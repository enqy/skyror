{
  description = "skyror: a instruction set.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in rec {
        packages.skyror32 = pkgs.stdenv.mkDerivation {
          pname = "skyror32";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = with pkgs; [asciidoctor-with-extensions];

          installPhase = ''
            mkdir -p $out
            asciidoctor-pdf -n ./spec32.adoc -o $out/skyror32.pdf
          '';
        };
        packages.default = packages.skyror32;

        devShells.default = pkgs.mkShell {
          name = "skyror";
          nativeBuildInputs = with pkgs; [
            asciidoctor-with-extensions
            entr
          ];
        };
      }
    );
}
