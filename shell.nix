{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = [
    pkgs.gnumake
    pkgs.docker
    pkgs.ruby_3_1
    pkgs.nodejs
    pkgs.nodePackages.pnpm
  ];
}
