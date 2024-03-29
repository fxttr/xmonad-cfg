{
  description = "xmonad configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";

    artwork = {
      url = "github:NixOS/nixos-artwork";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, artwork, ... }@inputs: inputs.utils.lib.eachSystem [
    "x86_64-linux"
    "i686-linux"
    "aarch64-linux"
  ]
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [ ];
        };
      in
      {
        devShells.default =
          with import nixpkgs { system = "x86_64-linux"; };
          haskellPackages.shellFor {
            buildInputs = with haskellPackages; [
              haskell-language-server
              hlint
              xmonad
              xmonad-contrib
            ];
            packages = haskellPackages: [ ];
            withHoogle = true;
          };

        defaultPackage = ./default.nix;
      });
}
