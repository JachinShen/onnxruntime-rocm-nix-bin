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

## Testing

### Preparation

Download model and data:
```bash
wget https://s3.amazonaws.com/onnx-model-zoo/resnet/resnet50v2/resnet50v2.tar.gz
tar -xzf resnet50v2.tar.gz
```
### Run

```bash
python3 test.py
```
