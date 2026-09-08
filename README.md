# ofxOnnxRuntime
[ONNX Runtime](https://github.com/microsoft/onnxruntime) tiny wrapper for openFrameworks

!['test'](screenshot.png)

## Installation

The prebuilt runtimes ship with the addon under `libs/onnxruntime/lib/<platform>/`,
so a clone is ready to build. openFrameworks copies the shared library next to the
executable (`bin/`) as part of the build, and nothing in `bin/` needs to be committed.

- macOS (Apple Silicon)
    - `libs/onnxruntime/lib/osx/libonnxruntime.1.dylib` is bundled; the Xcode project
      links against it directly and the `@executable_path` rpaths in `addon_config.mk`
      let the app find it at runtime.
    - Generate a project using ProjectGenerator.
- Linux (aarch64 / Raspberry Pi)
    - `libs/onnxruntime/lib/linuxaarch64/libonnxruntime.so*` is bundled.
    - Build with the makefile: `cd example-onnx_mnist && make`, then `make RunRelease`.
- Windows
    - There are two ways to install ONNX Runtime on your project.
    1. Install using NuGet
        - I recommend this way in general.
        - Generate a project using ProjectGenerator.
        - Open `sln` file.
        - Right click your project on `Solution Explorer` pane, and then select `Manage NuGet Packages...`.
        - From `Browse` tab, search `Microsoft.ML.OnnxRuntime` (CPU) or `Microsoft.ML.OnnxRuntime.Gpu` (GPU) and install it.
    2. DLL direct download
        - You can download prebuilt DLLs from [here](https://github.com/microsoft/onnxruntime/releases).
        - Unzip downloaded `onnxruntime-win-x64-(gpu-)1.10.0.zip` and locate files on `libs\onnxruntime\lib\vs\x64\` .
        - Generate a project using ProjectGenerator, then all libs are linked correctly and all dlls are copied to `bin`.

## Tested environment
- oF 0.11.2 + MacBookPro 2018 Intel + macOS Catalina
- oF 0.11.2 + VS2017 + Windows 10 + RTX2080Ti + CUDA 11.4
- oF 0.12.1 + Raspberry Pi 4 (Cortex-A72) + Raspberry Pi OS Bookworm aarch64 + onnxruntime 1.29.0 (CPU)

## ToDo
- check Linux GPU

## Reference Implementation
- I heavily referred [Lite.AI.ToolKit](https://github.com/DefTruth/lite.ai.toolkit) implementation.
