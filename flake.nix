{
  description = "A soothing pastel theme for SDDM";

  # Nixpkgs / NixOS version to use.
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      # Generate a user-friendly version number.
      version = builtins.substring 0 8 self.lastModifiedDate;

      # System types to support.
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      # Provide some binary packages for selected system types.
      packages = forAllSystems (system: {
        sddm-dz = nixpkgsFor.${system}.stdenvNoCC.mkDerivation {
          pname = "sddm-dz";
          inherit version;

          src = nixpkgs.lib.cleanSourceWith {
            filter = name: type: type != "regular" || !nixpkgs.lib.hasSuffix ".nix" name;
            src = nixpkgs.lib.cleanSource ./.;
          };

          propagatedBuildInputs = [ nixpkgsFor.${system}.qtgraphicaleffects ];

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            mkdir -p "$out/share/sddm/themes/"
            cp -r catppuccin/ "$out/share/sddm/themes/sddm-dz"

            runHook postInstall
          '';

          meta = {
            description = "Soothing pastel theme for SDDM";
            homepage = "https://github.com/mitchdzugan/sddm-dz";
            license = nixpkgs.lib.licenses.mit;
            maintainers = with nixpkgs.lib.maintainers; [ mitchdzugan ];
            platforms = nixpkgs.lib.platforms.linux;
          };
        };
      });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.sddm-dz);

      devShell = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor.${system};
        in
        pkgs.mkShell { buildInputs = with pkgs; [ ]; }
      );
    };
}
