{ pkgs ? import (fetchTarball "http://nixos.org/channels/nixos-22.11/nixexprs.tar.xz") {} }:

pkgs.mkShell {
  packages = [
    pkgs.gnumake
    pkgs.docker
    pkgs.ruby_3_1
    pkgs.nodejs
    pkgs.nodePackages.pnpm
  ];
}
