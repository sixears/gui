{
  description = "nix configuration for gui things; shared X / Wayland";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/354184a; # master 2023-12-13
    flake-utils.url = github:numtide/flake-utils/c0e246b9;
    myPkgs          = {
      url    = github:sixears/nix-pkgs/r0.0.9.1;
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = { self, nixpkgs, flake-utils, myPkgs }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system:
      let
        pkgs    = nixpkgs.legacyPackages.${system};
        my-pkgs = myPkgs.packages.${system};

        swap-summary-fifo = "/run/user/$uid/swap-summary";
        i3status-rc =
          import ./src/i3status-rc.nix { inherit pkgs; };
      in
        rec {
          settings = { inherit swap-summary-fifo; };

          packages = flake-utils.lib.flattenTree (with pkgs; {
            # https://fontawesome.com/icons
            inherit font-awesome;
            i3stat = import ./src/i3stat.nix
                            { inherit pkgs i3status-rc swap-summary-fifo;
                              inherit (my-pkgs) replace; };
          });
        }
    );
}
