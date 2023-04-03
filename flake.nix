{
  description = "bumps versions in files";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      dream2nix.config.projectRoot = ./.;

      imports = [
        inputs.dream2nix.flakeModuleBeta

        ./flake-parts/node.nix
        ./flake-parts/default.nix
      ];
    };
}
