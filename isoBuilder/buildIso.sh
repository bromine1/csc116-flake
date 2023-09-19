#!/usr/bin/env sh
nix build .#nixosConfigurations.Iso.config.system.build.isoImage
