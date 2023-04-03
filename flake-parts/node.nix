{
  inputs,
  self,
  ...
} @ part-inputs: {
  imports = [];

  perSystem = {
    config,
    pkgs,
    lib,
    system,
    inputs',
    ...
  }: let
    inherit (inputs.nix-filter.lib) filter inDirectory matchExt;
  in rec {
    packages = {
      # Pin the nodejs and yarn versions and provide them as flake packages.
      inherit (pkgs) nodejs yarn;

      # Copy the dream2nix package to the flake output.
      inherit (config.dream2nix.outputs.localForage.packages) localForage;
    };

    dream2nix.inputs.localForage = {
      source = filter {
        root = ../.;
        include = [
          "yarn.lock"
          (inDirectory "src")
          (inDirectory "typings")
          (inDirectory "typing-tests")
          (inDirectory "test")
          (matchExt "js")
          (matchExt "json")
          (matchExt "ts")
          (matchExt "cjs")
          (matchExt "mjs")
          ".babelrc"
          ".babelrc-umd"
          ".huskyrc"
        ];
      };

      projects.localForage = {
        name = "localForage";
        subsystem = "nodejs";
        translator = "yarn-lock";
      };

      packageOverrides.localForage = {
        copySite = {
          # We only need the files in the dist directory to be copied to the output.
          installPhase = ''
            mkdir -p $out
            cp -r ./dist/* $out
          '';
        };
      };
    };
  };
}
