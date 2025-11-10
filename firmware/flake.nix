{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    self.submodules = true;
    nrf-nix.url = "path:nrf-nix";
  };
  outputs = { self, nixpkgs, nrf-nix, ... }:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; overlays = [ nrf-nix.overlays.default ]; config = { allowUnfree = true; segger-jlink.acceptLicense = true; }; };
  in
  {
    packages.x86_64-linux.default = pkgs.mkZephyrProject rec {
      name = "PPG-Watch";
      app = name;
      board = "nrf52840";
      westWorkspace = pkgs.fetchWestWorkspace {
        url = "https://github.com/nrfconnect/sdk-nrf";
        rev = "v2.1.0";
        sha256 = "sha256-LoL0SzPiKfXxWnZdbx+3m0bzyPeHovWNlmkFQsmiR7g=";
      };
      src = self;
    };
  };
}
