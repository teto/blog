let
  pkgs = import <nixpkgs> { };
  drv = pkgs.haskellPackages.hakyll;
in
  if pkgs.lib.inNixShell then drv.env else drv
