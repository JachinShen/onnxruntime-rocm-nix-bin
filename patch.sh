echo "Patchelf libonnxruntime..."
patchelf --set-rpath $PATCH_PATH ./.venv/lib/python3.10/site-packages/onnxruntime/capi/libonnxruntime_providers_rocm.so
patchelf --set-rpath $PATCH_PATH ./.venv/lib/python3.10/site-packages/onnxruntime/capi/libonnxruntime_providers_migraphx.so
patchelf --set-rpath $PATCH_PATH ./.venv/lib/python3.10/site-packages/onnxruntime/capi/libonnxruntime_providers_shared.so
patchelf --set-rpath $PATCH_PATH ./.venv/lib/python3.10/site-packages/onnxruntime/capi/onnxruntime_pybind11_state.so
echo "Done"