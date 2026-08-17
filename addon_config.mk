meta:
	ADDON_NAME = ofxOnnxRuntime
	ADDON_DESCRIPTION = "ONNX Runtime addon for OpenFrameworks"
	ADDON_AUTHOR = Yuya Hanai
	ADDON_TAGS = "ONNX"
	ADDON_URL = https://github.com/hanasaan/ofxOnnxRuntime

common:
	ADDON_INCLUDES = libs/onnxruntime/include
	ADDON_INCLUDES += src
osx:
	# Single token: openFrameworks runs addon LDFLAGS through $(call uniq,...),
	# which collapses the repeated -Xlinker in "-Xlinker -rpath -Xlinker @executable_path"
	# and leaves @executable_path as a stray argument to the linker.
	# Xcode copies the dylib next to the executable inside the .app bundle;
	# the makefile build copies it to bin/ instead, three levels up from
	# bin/<app>.app/Contents/MacOS/. Cover both.
	ADDON_LDFLAGS = -Wl,-rpath,@executable_path
	ADDON_LDFLAGS += -Wl,-rpath,@executable_path/../../..
vs:

