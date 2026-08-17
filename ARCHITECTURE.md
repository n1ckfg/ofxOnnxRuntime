# ofxOnnxRuntime Architecture

`ofxOnnxRuntime` is a lightweight openFrameworks wrapper for the [ONNX Runtime](https://github.com/microsoft/onnxruntime) C++ API. It provides a simple, unified interface for loading ONNX models and performing inference using CPU, CUDA, or TensorRT.

## High-Level Structure

The addon is designed around a single core wrapper class, `BaseHandler`, which encapsulates the complexities of the ONNX Runtime session, memory allocation, and tensor management.

### Key Components

#### 1. `BaseSetting` (Configuration)
A minimal struct used to configure the execution provider and target device before session initialization.
- **`infer_type`**: Specifies the hardware backend (`INFER_CPU`, `INFER_CUDA`, `INFER_TENSORRT`).
- **`device_id`**: Identifies which GPU device to use when hardware acceleration is enabled.

#### 2. `BaseHandler` (Core Wrapper)
The main class that handles the lifecycle of an ONNX model inference session.

**Responsibilities:**
- **Initialization & Session Management:**
  - Manages `Ort::Env` and `Ort::Session`.
  - Configures execution providers (CPU, CUDA, TensorRT) based on `BaseSetting` during `setup()`.
  - Parses and caches model metadata (input/output node names, dimensions, and type info).
- **Memory Management:**
  - Pre-allocates a contiguous memory buffer (`input_values_handler`) for the input tensor.
  - Dynamically computes input tensor size based on model metadata. Dynamic axes (reported as -1) are defaulted to 1 to prevent memory overflow, though they can be resized by the caller if needed.
- **Inference Execution:**
  - Provides a pointer to the input buffer via `getInputTensorData()` where user applications can copy their preprocessed data.
  - The `run()` method binds the input tensor, executes the network, and returns the resulting output `Ort::Value`.

### Data Flow

1. **Setup Phase (`setup` / `setup2`)**: 
   - Application instantiates a `BaseHandler`.
   - Application calls `setup()` with the path to the `.onnx` model and a `BaseSetting`.
   - `BaseHandler` loads the model, extracts input and output node metadata, and pre-allocates the `input_values_handler` `std::vector<float>`.
2. **Data Preparation**: 
   - Application calls `getInputTensorData()` to get the raw float pointer to the input memory.
   - Application populates this memory buffer with the formatted image or data (e.g., resizing, normalizing, CHW format).
3. **Inference (`run`)**: 
   - Application calls `run()`.
   - `BaseHandler` constructs an `Ort::Value` tensor from the `input_values_handler` buffer.
   - The session processes the data and stores the result in `output_values`.
   - The function returns a reference to the output tensor.

## Dependencies

- **ONNX Runtime C++ API** (`onnxruntime_cxx_api.h`): The underlying engine for parsing and executing the models.
- **openFrameworks Core** (`ofMain.h`): Used for file path resolution (`ofToDataPath`) and string manipulation (`ofStringReplace`).

## Execution Providers

The wrapper currently supports three execution providers:
- **CPU**: Default fallback provider.
- **CUDA**: Appends `OrtCUDAProviderOptions` to accelerate inference on NVIDIA GPUs.
- **TensorRT**: Appends `OrtTensorRTProviderOptions` for optimized GPU inference. It automatically configures FP16 precision and enables engine caching (caching the optimized TRT engine alongside the `.onnx` model file with a `_trt_cache` suffix) to speed up subsequent loads.
