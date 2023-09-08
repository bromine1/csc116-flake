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

      nativeBuildInputs = with pkgs; [
        jdk17
      ];
      buildPhase = "
          javac ${name}.java
          ";
      installPhase = ''
        mkdir -p $out/bin $out/share/java
        mv project1/bin/${name}.class $out/share/java
        makeWrapper ${pkgs.temurin-jre-bin-17}/bin/java $out/bin/${name} \
        --add-flags "-cp $out/share/java/ ${name}"
      '';
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          jdk17
          checkstyle
          firefox
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
                #vscode-extensions.vscodevim.vim
                vscode-extensions.oderwat.indent-rainbow
                extensions.vscode-marketplace.shengchen.vscode-checkstyle
                extensions.vscode-marketplace.thang-nm.catppuccin-perfect-icons
                extensions.vscode-marketplace.asvetliakov.vscode-neovim
              ];
          })
        ];
        inherit nativeBuildInputs buildPhase installPhase;
      };

      # Package
      packages.default = with pkgs;
        stdenv.mkDerivation {
          inherit name version src pname nativeBuildInputs buildPhase installPhase;
        };

      # App to run package
    });
}
