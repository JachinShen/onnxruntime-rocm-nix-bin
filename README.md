# ONNXRuntime-ROCm-Nix-bin

This repository runs [pre-built ONNXRuntime binaries for ROCm](https://repo.radeon.com/rocm/manylinux/rocm-rel-6.2/) on NixOS.

## Building

The shared library in onnxruntime-rocm finds dependencies in the system path, which is unavailable in NixOS. To work around this, we need to patch the library to use the Nix store instead.

```bash
nix develop .
pip install -r requirements.txt
./patch.sh
```

You can check the patched library with `ldd`: `ldd .venv/lib/python3.10/site-packages/onnxruntime/capi/libonnxruntime_providers_rocm.so` should show the Nix store paths.

Note: I use `onnxruntime-rocm` of `rocm-6.2.x` here because official pre-built wheels of newer versions do not include old architectures like `gfx1030`.

## Testing

### Preparation

Download model and data:
```bash
wget https://s3.amazonaws.com/onnx-model-zoo/resnet/resnet50v2/resnet50v2.tar.gz
tar -xzf resnet50v2.tar.gz
```
### Run

Depend on your GPU, you may need to set `HSA_OVERRIDE_GFX_VERSION` to the correct version. For example, for AMD RX 6750XT, it is `10.3.0`.

```bash
HSA_OVERRIDE_GFX_VERSION=10.3.0 python3 test.py
```

### Debugging

Refer to [Logging HIP activity](https://rocmdocs.amd.com/projects/HIP/en/latest/how-to/logging.html).

```bash
HSA_OVERRIDE_GFX_VERSION=10.3.0 AMD_LOG_LEVEL=5 python3 test.py
```