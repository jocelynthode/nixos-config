#! /usr/bin/env nix-shell
#! nix-shell -i bash -p parted btrfs-progs ssh-to-age sops yq-go
set -euo pipefail

needs_arg() { if [ -z "$OPTARG" ]; then die "No arg for --$OPT option"; fi; }

create_efi=""
drive=""
hostname=""
swap=32

if [ $# -eq 0 ]; then
	echo "Missing options!"
	echo "(run $0 -h for help)"
	echo ""
	exit 0
fi

while getopts h:-: OPT; do
	# support long options: https://stackoverflow.com/a/28466267/519360
	if [ "$OPT" = "-" ]; then # long option: reformulate OPT and OPTARG
		OPT="${OPTARG%%=*}"      # extract long option name
		OPTARG="${OPTARG#$OPT}"  # extract long option argument (may be empty)
		OPTARG="${OPTARG#=}"     # if long option argument, remove assigning `=`
	fi
	case "$OPT" in
	create-efi) create_efi=true ;;
	hostname)
		needs_arg
		hostname="$OPTARG"
		;;
	disk)
		needs_arg
		drive="$OPTARG"
		;;
	swap)
		needs_arg
		swap="$OPTARG"
		;;
	*)
		echo "Usage:"
		echo "bootstrap.sh -h "
		echo ""
		echo "   --create-efi         to create the EFI partition"
		echo "   --hostname HOSTNAME  to specify the hostname to build"
		echo "   --disk DISK_PATH          to specify the disk to use"
		echo "   --swap SIZE_IN_GB    to specify the swap size"
		exit 0
		;;
	esac
done
shift $((OPTIND - 1)) # remove parsed options and args from $@ list

if [ -z "${drive}" ]; then
	echo "the drive must be specified"
	exit 1
fi

if [ -z "${hostname}" ]; then
	echo "the hostname must be specified"
	exit 1
fi

swap_size=$((1024 * swap))

echo "preparing drive ${drive} for NixOS ${hostname} with ${swap}GB of SWAP"
echo ""
echo "WARNING!"
echo "this script will overwrite everything on ${drive}"
echo "the current partition table on ${drive} is:"
sgdisk --print "${drive}"
read -r -p "type ${drive} to confirm and overwrite partitions ~> " confirm
if [[ ! "${confirm}" == "${drive}" ]]; then exit 1; fi

wipefs -a "${drive}"
parted "${drive}" -- mklabel gpt

if [ -n "${create_efi}" ]; then
	parted "${drive}" -- mkpart ESP fat32 1MiB 512MiB name EFI
	parted "${drive}" -- mkpart primary 512MiB 100% name "${hostname}"
	parted "${drive}" -- set 1 esp on
	mkfs.vfat -n EFI /dev/disk/by-partlabel/EFI
else
	parted "${drive}" -- mkpart primary 1MiB 100% name "${hostname}"
fi

partprobe "${drive}"
sleep 2

mkfs.btrfs -L "${hostname}" /desk/disk/by-partlabel/"${hostname}"

if [ -n "${create_efi}" ]; then
	mkfs.vfat -n EFI /dev/disk/by-partlabel/EFI
fi

echo "Creating BTRFS subovlumes"
mkdir -p /mnt
mount -t btrfs /dev/disk/by-label/"${hostname}" /mnt
cd /mnt/
btrfs subvolume create @
btrfs subvolume create @blank
btrfs property set -ts @blank ro true
btrfs subvolume create @nix
btrfs subvolume create @persist
btrfs subvolume create @log
btrfs subvolume create @swap
chattr +C /mnt/@swap
cd -
umount /mnt

echo "Mounting BTRFS subvolumes"
mount -t btrfs -o subvol=@ /dev/disk/by-label/"${hostname}" /mnt
mkdir -p /mnt/nix
mkdir -p /mnt/persist
mkdir -p /mnt/var/log
mkdir -p /mnt/swap
mkdir -p /mnt/boot/efi
mount -t btrfs -o subvol=@nix /dev/disk/by-label/"${hostname}" /mnt/nix
mount -t btrfs -o subvol=@persist /dev/disk/by-label/"${hostname}" /mnt/persist
mount -t btrfs -o subvol=@log /dev/disk/by-label/"${hostname}" /mnt/var/log
mount -t btrfs -o subvol=@swap /dev/disk/by-label/"${hostname}" /mnt/swap
mount /dev/disk/by-label/EFI /mnt/boot/efi

echo "Creating SWAP"
dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count="${swap_size}" status=progress
chmod 0600 /mnt/swap/swapfile
mkswap -L swap /mnt/swap/swapfile

echo "Creating basic persist folders"
mkdir -p /mnt/persist/home
mkdir -p /mnt/persist/etc/ssh

echo "Generating ssh host keys"
ssh-keygen -q -t rsa -b 4096 -C "${hostname}" -N "" -f /mnt/persist/etc/ssh/ssh_host_rsa_key
ssh-keygen -yf /mnt/persist/etc/ssh/ssh_host_ed25519_key >/mnt/persist/etc/ssh/ssh_host_ed25519_key.pub
agekey=$(ssh-to-age -i /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub)

echo "Setting up sops key"
yq -i ".keys[1].hosts += '&${hostname} ${agekey}'" .sops.yaml
yq ".creation_rules[0].key_groups[0].age as \$age | length as \$length | \$age[\$length - 1] alias=\"${hostname}\"| .creation_rules[0].key_groups[0].age = \$age" .sops.yaml
sops updatekeys hosts/common/secrets/passwords.yaml -y

echo "Running nixos-install"
time nixos-install --no-root-password --no-channel-copy --flake ".#${hostname}"

umount -R /mnt

echo ""
echo "IFF you did not see any errors, Commit your new sops files and reboot!"
