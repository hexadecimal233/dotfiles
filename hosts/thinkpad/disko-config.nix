{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "2G"; # lessons learned: never set esp too small (512M); should've set higher 🥺
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes = {
                "@root" = {
                  mountpoint = "/";
                  mountOptions = [];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd"];
                };
                "@swap" = {
                  mountpoint = "/.swapvol";
                  swap.swapfile.size = "16G";
                };
              };
            };
          };
        };
      };
    };
  };
}
