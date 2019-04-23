# nix-pinning master target/lorri
# committed on "2019-04-10T12:59:50Z" - retrieved on 2019-04-23
#import removed the 'import' call
(builtins.fetchTarball {
  name   = "lorri-master-2019-04-10";
  url    = "https://github.com/target/lorri/archive/a1818308db1ed0d2de7d3cf95db3a669c40612b6.tar.gz";
  sha256 = "0kh3hz0c38d5zhkp41b87q5sngsbkdpk9awx8lihgmas95n07rwm";
})
