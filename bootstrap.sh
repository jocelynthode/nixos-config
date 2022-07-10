#! /usr/bin/env bash
#! nix-shell -i bash -p parted btrfs-progs gptfdisk cryptsetup
set -euo pipefail

die() {
	echo "$*" >&2
	exit 2
} # complain to STDERR and exit with error

needs_arg() { if [ -z "$OPTARG" ]; then die "No arg for --$OPT option"; fi; }

create_efi=""
encrypt=""
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
	encrypt-root) encrypt=true ;;
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
		echo "   --encrypt-root       to encrypt root disk"
		echo "   --hostname HOSTNAME  to specify the hostname to build"
		echo "   --disk DISK_PATH     to specify the disk to use"
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

if [ -n "${create_efi}" ]; then
	wipefs -af "${drive}"
	parted "${drive}" -- mklabel gpt
	parted "${drive}" -a optimal -- mkpart ESP fat32 1MiB 512MiB name 1 EFI
	parted "${drive}" -a optimal -- mkpart primary 512MiB 100% name 2 "${hostname}"
	parted "${drive}" -- set 1 esp on
else
	parted "${drive}" -a optimal -- mkpart primary 1MiB 100% name 1 "${hostname}"
fi

partprobe "${drive}"
sleep 2

device="/dev/disk/by-partlabel/${hostname}"

if [ -n "${encrypt}" ]; then
	echo "Creating LUKS partition"
	cryptsetup luksFormat --verbose --verify-passphrase /dev/disk/by-partlabel/"${hostname}"
	cryptsetup config /dev/disk/by-partlabel/"${hostname}" --label "${hostname}_crypt"
	cryptsetup open /dev/disk/by-partlabel/"${hostname}" "${hostname}"
	device="/dev/mapper/${hostname}"
fi

partprobe
sleep 2

mkfs.btrfs -fL "${hostname}" "${device}"

if [ -n "${create_efi}" ]; then
	echo "Creating EFI partition"
	mkfs.vfat -n EFI /dev/disk/by-partlabel/EFI
fi

exit 0

echo "Creating BTRFS subovlumes"
mkdir -p /mnt
mount -t btrfs "${device}" /mnt
cd /mnt/
btrfs subvolume create @
btrfs subvolume create @blank
mkdir -p @blank/boot/efi
mkdir -p @blank/mnt
mkdir -p @blank/etc
cp /etc/machine-id @blank/etc/
btrfs property set -ts @blank ro true
btrfs subvolume create @nix
btrfs subvolume create @persist
btrfs subvolume create @snapshots
btrfs subvolume create @log
btrfs subvolume create @swap
chattr +C /mnt/@swap
cd -
umount /mnt

echo "Mounting BTRFS subvolumes"
mount -t btrfs -o subvol=@ "${device}" /mnt
mkdir -p /mnt/nix
mkdir -p /mnt/persist
mkdir -p /mnt/var/log
mkdir -p /mnt/.snapshots
mkdir -p /mnt/swap
mkdir -p /mnt/boot/efi
mount -t btrfs -o subvol=@nix "${device}" /mnt/nix
mount -t btrfs -o subvol=@persist "${device}" /mnt/persist
mount -t btrfs -o subvol=@log "${device}" /mnt/var/log
mount -t btrfs -o subvol=@snapshots "${device}" /mnt/.snapshots
mount -t btrfs -o subvol=@swap "${device}" /mnt/swap
mount /dev/disk/by-partlabel/EFI /mnt/boot/efi

echo "Creating SWAP"
dd if=/dev/zero of=/mnt/swap/swapfile bs=1M count="${swap_size}" status="progress"
chmod 0600 /mnt/swap/swapfile
mkswap -L swap /mnt/swap/swapfile

echo "Creating basic persist folders"
mkdir -p /mnt/persist/home
mkdir -p /mnt/persist/etc/ssh

echo "Generating ssh host keys"
ssh-keygen -q -t rsa -b 4096 -C "${hostname}" -N "" -f /mnt/persist/etc/ssh/ssh_host_rsa_key
ssh-keygen -t ed25519 -f /mnt/persist/etc/ssh/ssh_host_ed25519_key -N ''

echo "Printing public host key"
cat /mnt/persist/etc/ssh/ssh_host_ed25519_key.pub

echo ""
echo "IFF you did not see any errors, setup copy the public key to the correct file, rekey your secrets and install"
