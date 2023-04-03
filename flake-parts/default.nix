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
    self',
    ...
  }: let
    devTools = [
      # node tooling
      self'.packages.nodejs
      self'.packages.yarn
    ];
  in rec {
    devShells.default = pkgs.mkShell rec {
      packages = devTools;
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath packages;
    };
  };
}
