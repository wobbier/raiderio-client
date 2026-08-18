{
    description = "Flake for the RaiderIO client";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    outputs = { self, nixpkgs }:
    let
        eachSystem = systems: f:
        nixpkgs.lib.genAttrs systems (system:
        f {
            inherit system;
            pkgs = import nixpkgs {
                inherit system;
                config.allowUnfree = true;
            };
        });
        supportedSystems = [ "x86_64-linux" ];
    in
    {
        packages = eachSystem supportedSystems ({ pkgs, system }: {
            default = pkgs.callPackage ./pkgs/raiderio-client/default.nix {};
            raiderio-client = pkgs.callPackage ./pkgs/raiderio-client/default.nix {};
        });
    };
}