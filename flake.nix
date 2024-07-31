{
  description = "nix configuration for gui things; shared X / Wayland";

  inputs = {
    nixpkgs.url     = github:NixOS/nixpkgs/938aa157; # nixos-24.05 2024-06-20
    flake-utils.url = github:numtide/flake-utils/c0e246b9;
    myPkgs          = {
      url    = github:sixears/nix-pkgs/r0.0.10.2;
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = { self, nixpkgs, flake-utils, myPkgs }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system:
      let
        pkgs        = nixpkgs.legacyPackages.${system};
        my-pkgs     = myPkgs.packages.${system};
        my-settings = myPkgs.settings.${system};

        i3status-rc =
          import ./src/i3status-rc.nix { inherit pkgs; };
      in
        rec {
          settings = { inherit (my-settings) swap-summary-fifo cpu-temp-fifo; };

          packages = flake-utils.lib.flattenTree (with pkgs; {
            # https://fontawesome.com/icons https://nixos.wiki/wiki/Fonts
            inherit font-awesome fira-code fira-code-symbols nerdfonts;

            i3stat = import ./src/i3stat.nix {
              inherit pkgs i3status-rc;
              inherit (my-settings) swap-summary-fifo cpu-temp-fifo;
              inherit (my-pkgs) replace;
            };

            xcompose =
              pkgs.writeTextDir "share/xcompose"
                (nixpkgs.lib.strings.fileContents ./src/xcompose);

            xkeysyms =
              let src = import ./src/xkeysyms.nix { inherit pkgs; };
              in  pkgs.writers.writePerlBin "xkeysyms" { libraries = [ ]; } src;
          });
        }
    );
}
