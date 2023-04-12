TARGET_CC = $(CROSS_COMPILE)g++
CFLAGS_DLL  = -std=c++11 -w -shared 
CFLAGS_EXE 	= -std=c++11 -Wall -DENABLE_DEBUG -static-libgcc -static-libstdc++
INCFLAGS 	= -I src/Common/DCA1000_API/. -I src/Common/Json_Utils/dist/json/. -I src/Common/. -I src/Common/Validate_Utils/. -I src/Common/Osal_Utils/.

ARCH ?= $(shell uname -m)
INSTALL = install
BUILD_DIR = release-$(ARCH)
SCRIPT_DIR = scripts
DESTDIR ?= /usr
bindir ?= /bin

SOURCES_DLL = src/RF_API/*.cpp src/Common/Validate_Utils/validate_params.cpp
SOURCES_CTRL = src/CLI_Control/cli_control_main.cpp src/Common/Json_Utils/dist/jsoncpp.cpp src/Common/Validate_Utils/validate_params.cpp
SOURCES_REC	= src/CLI_Record/cli_record_main.cpp src/Common/Json_Utils/dist/jsoncpp.cpp src/Common/Validate_Utils/validate_params.cpp

RM = rm -f
SOURCES_OSAL= src/Common/Osal_Utils/osal_linux.cpp
LDFLAGS_DLL =
LDFLAGS_EXE = -L ./$(BUILD_DIR) -lRF_API
LDFLAGS_PTHREAD = -pthread
TARGET_DLL = ./$(BUILD_DIR)/libRF_API.so
TARGET_CTRL = ./$(BUILD_DIR)/DCA1000EVM_CLI_Control
TARGET_REC = ./$(BUILD_DIR)/DCA1000EVM_CLI_Record
TARGET_DIR = mkdir -p $@

all: $(BUILD_DIR) $(TARGET_DLL) $(TARGET_CTRL) $(TARGET_REC) install

$(BUILD_DIR):
	@echo "Folder $(BUILD_DIR) does not exist"
	$(TARGET_DIR)

$(TARGET_DLL): $(SOURCES_DLL)
	$(TARGET_CC) $(CFLAGS_DLL) -o $(TARGET_DLL) -fPIC $(LDFLAGS_PTHREAD) $(SOURCES_DLL) $(SOURCES_OSAL) $(LDFLAGS_DLL)
$(TARGET_CTRL): $(SOURCES_CTRL)
	$(TARGET_CC) $(CFLAGS_EXE) -o $(TARGET_CTRL) $(SOURCES_CTRL) $(SOURCES_OSAL) $(INCFLAGS) $(LDFLAGS_EXE)
$(TARGET_REC): $(SOURCES_REC)
	$(TARGET_CC) $(CFLAGS_EXE) -o $(TARGET_REC) $(SOURCES_REC) $(SOURCES_OSAL) $(LDFLAGS_PTHREAD) $(INCFLAGS) $(LDFLAGS_EXE)

.PHONY: install
install:
	$(INSTALL) -d $(DESTDIR)$(bindir)
	$(INSTALL) $(BUILD_DIR)/* $(DESTDIR)$(bindir)
	$(INSTALL) $(SCRIPT_DIR)/* $(DESTDIR)$(bindir)

clean:
	$(RM) $(TARGET_DLL) $(TARGET_CTRL) $(TARGET_REC)
