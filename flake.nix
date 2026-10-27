{
  description = "Developer environment shell for ownyourday";

  inputs = {
    nixpkgs = {
      owner = "NixOS";
      repo = "nixpkgs";
      # 22.11
      rev = "e6d5772f3515b8518d50122471381feae7cbae36";
      type = "github";
    };
    # nixos-26.05, used for Ruby 3.4 (22.11 only ships up to Ruby 3.1)
    nixpkgs-ruby = {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "718f670e845328e9c2cecdd832835712b2cbd065";
      type = "github";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-ruby }:
    let
      # Helper to provide system-specific attributes
      forAllSupportedSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
        pkgs-ruby = import nixpkgs-ruby { inherit system; };
      });

      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in

    {
      devShells = forAllSupportedSystems ({ pkgs, pkgs-ruby }: {
        # mkShell comes from the same nixpkgs as Ruby so native gems compile against the matching glibc
        default = pkgs-ruby.mkShell {
          packages = [
            pkgs.docker
            pkgs.git
            pkgs.gnumake
            pkgs.terraform
            pkgs.nixpkgs-fmt
            pkgs.nodejs
            pkgs.nodePackages.pnpm
            pkgs.postgresql_11
            pkgs-ruby.ruby_3_4
            pkgs.imagemagick
          ];
        };
      });
    };
}
