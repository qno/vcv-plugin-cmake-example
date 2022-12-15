# If RACK_DIR is not defined when calling the Makefile, default to two directories above
RACK_DIR ?= ../..

include $(RACK_DIR)/arch.mk

CMAKE_BUILD=dep/cmake-build
libmy_plugin := $(CMAKE_BUILD)/libMyPlugin.a

OBJECTS += $(libmy_plugin)

# trigger CMake build when running `make dep`
DEPS += $(libmy_plugin)

EXTRA_CMAKE :=
ifdef ARCH_MAC
ifdef ARCH_ARM64
    EXTRA_CMAKE += -DCMAKE_OSX_ARCHITECTURES="arm64"
else
    EXTRA_CMAKE += -DCMAKE_OSX_ARCHITECTURES="x86_64"
endif
endif

$(libmy_plugin): CMakeLists.txt
	$(CMAKE) -B$(CMAKE_BUILD) -DRACK_SDK_DIR=$(RACK_DIR) -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(CMAKE_BUILD)/dist $(EXTRA_CMAKE)
	cmake --build $(CMAKE_BUILD) -- -j $(shell getconf _NPROCESSORS_ONLN)
	cmake --install $(CMAKE_BUILD)

# FLAGS will be passed to both the C and C++ compiler
FLAGS +=
CFLAGS +=
CXXFLAGS +=

# Careful about linking to shared libraries, since you can't assume much about the user's environment and library search path.
# Static libraries are fine, but they should be added to this plugin's build system.
LDFLAGS +=

# Add .cpp files to the build
SOURCES += $(wildcard src/plugin.cpp)

# Add files to the ZIP package when running `make dist`
# The compiled plugin and "plugin.json" are automatically added.
DISTRIBUTABLES += res
DISTRIBUTABLES += $(wildcard LICENSE*)

# Include the Rack plugin Makefile framework
include $(RACK_DIR)/plugin.mk
