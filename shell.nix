{ pkgs ? import (fetchTarball "http://nixos.org/channels/nixos-22.11/nixexprs.tar.xz") {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.gnumake
    pkgs.ruby_3_1
    pkgs.docker
    pkgs.nodejs
    pkgs.nodePackages.pnpm
  ];
}
