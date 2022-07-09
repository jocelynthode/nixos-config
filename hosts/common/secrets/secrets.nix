let
  jocelyn = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNw5wtM2BvjEcatJfnW28HwLK617om8YM8Ca/RIeuEK1eULcZxGdQ++QzfUdRrX57RLfVjzYawKWAmhh3g/OFC2vcfD+PUYiBoNAY0crBkf3e94RtvXPp6Cma13aEOJA6haatt3u7G7aehJCEFqdfR62coULoHHUPIykoC1Tnbdu0a5ZVkUdj3OPVTbRIlkfokbRueRTQ9cbPrFbfDq6ZlftvPm3UuTHObOrKPCjdtmHLHH5/jMZG254QpZ5hmMMYlHutC2lxBx3Rhqs6nv4RinixmrIZ7Z5Xpu0CLXQeGtnfTT/kdSDvrTFfZln26KX4KXHv/93EN4sHysxwsrBKF";
  users = [ jocelyn ];

  desktek = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqjsqOkgdM/rWztAzFEhVb8MSnvZBuViU2z4a80p1Ku";
  frametek = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICW8na5GrvJpuuJzdhBPnv4FVSvKzUkAbKXZvAd405kT";
  systems = [ desktek frametek ];
in
{
  "jocelyn-password.age".publicKeys = [ jocelyn ] ++ systems;
}
