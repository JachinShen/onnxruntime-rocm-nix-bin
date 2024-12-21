{
  description = "A Nix-flake-based Python development environment";

  # inputs.nixpkgs.url = "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/nixos-24.05/nixexprs.tar.xz";
  inputs.nixpkgs.url = "/home/jachinshen/Documents/nixpkgs";
  nixConfig.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    # "https://cache.nixos.org"
  ];

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell rec {
          venvDir = "./.venv";
          packages = with pkgs.python310Packages; [
            python
            venvShellHook
            numpy
          ] ++ (with pkgs; [
          # packages = (with pkgs;[
            patchelf
            zlib
          ]);

          # buildInputs = with pkgs; [
          #   patchelf
          #   zlib
          # ];

          env = {
            PATCH_PATH="${pkgs.rocmPackages.clr}/lib:${pkgs.rocmPackages.hipfft}/lib:${pkgs.rocmPackages.roctracer}/lib:${pkgs.rocmPackages.rocblas}/lib:${pkgs.rocmPackages.miopen}/lib:${pkgs.rocmPackages.migraphx}/lib:${pkgs.protobuf}/lib:${pkgs.sqlite.out}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.rocmPackages.llvm.runtimes}/lib:${pkgs.zlib}/lib";
            # HSA_OVERRIDE_GFX_VERSION="10.3.0";
            https_proxy="http://127.0.0.1:1081";
          };

        };
      });
    };
}