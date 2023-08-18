{
  description = "A java flake with csc 116 dev tools";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.vscodeExtensions.url = "github:nix-community/nix-vscode-extensions";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = {
    self,
    nixpkgs,
    vscodeExtensions,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
      };
      extensions = vscodeExtensions.extensions.${system};

      # Package
      name = "java";
      version = "";
      src = ./.;
      pname = name;

      propagatedBuildInputs = with pkgs; [
        jdk17
      ];
      buildPhase = "
          javac ${name}.java
          ";
      installPhase = ''
        mkdir -p $out/bin/class
        mv *.class $out/bin/class
      '';
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          jdk17
          (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions;
            # CSC116 Extenstions
              [
                redhat.java
                catppuccin.catppuccin-vsc
                vscjava.vscode-java-debug
                vscjava.vscode-java-test
                ms-vsliveshare.vsliveshare
              ]
              ++
              # Personal extensions
              [
                vscode-extensions.vscodevim.vim
                vscode-extensions.oderwat.indent-rainbow
                extensions.vscode-marketplace.shengchen.vscode-checkstyle
                extensions.vscode-marketplace.thang-nm.catppuccin-perfect-icons
              ];
          })
        ];
        inherit propagatedBuildInputs buildPhase installPhase;
      };

      # Package
      packages.default = with pkgs;
        stdenv.mkDerivation {
          inherit name version src pname propagatedBuildInputs buildPhase installPhase;
        };

      # App to run package
    });
}
