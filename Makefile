CXX ?= c++

PROGRAM := tinyrenderer
SOURCES := main.cpp tgaimage.cpp

BUILD_TYPE ?= release
BUILD_DIR := build/$(BUILD_TYPE)
TARGET := $(BUILD_DIR)/$(PROGRAM)
OBJECTS := $(SOURCES:%.cpp=$(BUILD_DIR)/%.o)
DEPENDENCIES := $(OBJECTS:.o=.d)

CPPFLAGS ?=
CXXFLAGS ?= -std=c++20 -Wall -Wextra -pedantic
LDFLAGS ?=
LDLIBS ?=

ifeq ($(BUILD_TYPE),debug)
  CXXFLAGS += -O0 -g
else
  CXXFLAGS += -O2 -DNDEBUG
endif

.DEFAULT_GOAL := all

.PHONY: all run debug clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD -MP -c $< -o $@

run: $(TARGET)
	./$(TARGET)

debug:
	$(MAKE) BUILD_TYPE=debug all

clean:
	rm -rf build framebuffer.tga

-include $(DEPENDENCIES)
