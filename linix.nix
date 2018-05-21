with (import <nixpkgs> {});

let dockerfile = writeText "Dockerfile" ''
  From ubuntu:18.04

  # boot strapping environment
  RUN apt-get update
  RUN apt-get install -y bzip2 curl man netbase locales

  # setup locale
  RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
      && locale-gen
  ENV LANG en_US.UTF-8  
  ENV LANGUAGE en_US:en  
  ENV LC_ALL en_US.UTF-8     

  # setting up the user
  RUN useradd -ms /bin/bash nixi
  RUN mkdir /nix && chown -R nixi /nix
  USER nixi
  ENV USER nixi
  WORKDIR /home/nixi

  # install nix
  RUN curl https://nixos.org/nix/install | sh

  # nix environment
  RUN . /home/nixi/.nix-profile/etc/profile.d/nix.sh \
    && nix-env -i vim -i nox \
    && nix-env -iA nixpkgs.nixUnstable

  CMD ["bash", "-l"]
'';

in  # minimal docker image to get a nix-installed linux docker container running
    # mounts the current working directory as a data directory
    # install with: nix-env -f linix.nix -i  
  writeScriptBin "linix" ''
        cat ${dockerfile} | ${docker}/bin/docker build -t linix:latest -
        ${docker}/bin/docker run -ti --volume $PWD:/home/nixi/data linix
  ''