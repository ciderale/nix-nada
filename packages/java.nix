{
  custom = self: super: rec {

    # DEPRECATED does not make much sense anymore.. jdk11 exists
    jdk11 = super.jdk10.overrideAttrs (oldAttrs: rec {
      version = "11.2.3";
      openjdk = "11.0.1";
      name = "zulu-${version}";

      platform = "macosx";
      extension = "zip";

      src = super.fetchurl {
        url = "https://cdn.azul.com/zulu/bin/zulu${version}-jdk${openjdk}-${platform}_x64.${extension}";
        sha256 = "0zc311smgz6zsy41qiimrywlbfn8451j13g32dlms67k4j5slyqv";
      };
    });

  };

  select = jdkversion: self: super: { jdk = self."${jdkversion}"; };
}
