{
  description = "cavallo — GCP infrastructure for LLM inference";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { pkgs, ... }: {
        devShells.default = pkgs.mkShell {
          name = "cavallo";

          packages = with pkgs; [
            opentofu
            google-cloud-sdk
            jq
            curl
            git
          ];

          shellHook = ''
            echo ""
            echo "cavallo dev shell"
            echo "  tofu   $(tofu version | head -1)"
            echo "  gcloud $(gcloud version 2>/dev/null | head -1)"
            echo ""
            echo "Remember: run 'gcloud auth application-default login' before tofu apply."
            echo ""
          '';
        };
      };
    };
}
