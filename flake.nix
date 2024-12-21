{
  description = "A Nix-flake-based Python development environment";

  inputs.nixpkgs.url = "github:jachinshen/nixpkgs/rocm-6.2.2";
  nixConfig.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
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
        default = pkgs.mkShell {
          venvDir = "./.venv";
          packages = with pkgs.python310Packages; [
            python
            venvShellHook
            numpy
          ] ++ (with pkgs; [
            patchelf
            wget
          ]);

          env = {
            PATCH_PATH="${pkgs.rocmPackages.clr}/lib:${pkgs.rocmPackages.hipfft}/lib:${pkgs.rocmPackages.roctracer}/lib:${pkgs.rocmPackages.rocblas}/lib:${pkgs.rocmPackages.miopen}/lib:${pkgs.rocmPackages.migraphx}/lib:${pkgs.protobuf}/lib:${pkgs.sqlite.out}/lib:${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.rocmPackages.llvm.runtimes}/lib:${pkgs.zlib}/lib";
          };
        };
      });
    };
}
