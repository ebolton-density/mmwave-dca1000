TARGET_CC = $(CROSS_COMPILE)g++
CFLAGS_DLL  = -std=c++11 -w -shared 
CFLAGS_EXE 	= -std=c++11 -Wall -DENABLE_DEBUG -static-libgcc -static-libstdc++
INCFLAGS 	= -I Common/DCA1000_API/. -I Common/Json_Utils/dist/json/. -I Common/. -I Common/Validate_Utils/. -I Common/Osal_Utils/.

ARCH ?= $(shell uname -m)
DIRECTORY 	= release-$(ARCH)

SOURCES_DLL = RF_API/*.cpp Common/Validate_Utils/validate_params.cpp
SOURCES_CTRL= CLI_Control/cli_control_main.cpp Common/Json_Utils/dist/jsoncpp.cpp Common/Validate_Utils/validate_params.cpp
SOURCES_REC	= CLI_Record/cli_record_main.cpp Common/Json_Utils/dist/jsoncpp.cpp Common/Validate_Utils/validate_params.cpp

RM = rm -f
SOURCES_OSAL= Common/Osal_Utils/osal_linux.cpp
LDFLAGS_DLL = 
LDFLAGS_EXE = -L ./$(DIRECTORY) -lRF_API
LDFLAGS_PTHREAD = -pthread
TARGET_DLL = ./$(DIRECTORY)/libRF_API.so
TARGET_CTRL = ./$(DIRECTORY)/DCA1000EVM_CLI_Control
TARGET_REC = ./$(DIRECTORY)/DCA1000EVM_CLI_Record
TARGET_DIR = mkdir -p $@

all: $(DIRECTORY) $(TARGET_DLL) $(TARGET_CTRL) $(TARGET_REC) 

$(DIRECTORY):
		@echo "Folder $(DIRECTORY) not exists"
		$(TARGET_DIR)

$(TARGET_DLL): $(SOURCES_DLL)
		$(TARGET_CC) $(CFLAGS_DLL) -o $(TARGET_DLL) -fPIC $(LDFLAGS_PTHREAD) $(SOURCES_DLL) $(SOURCES_OSAL) $(LDFLAGS_DLL)
$(TARGET_CTRL): $(SOURCES_CTRL)
		$(TARGET_CC) $(CFLAGS_EXE) -o $(TARGET_CTRL) $(SOURCES_CTRL) $(SOURCES_OSAL) $(INCFLAGS) $(LDFLAGS_EXE)
$(TARGET_REC): $(SOURCES_REC)
		$(TARGET_CC) $(CFLAGS_EXE) -o $(TARGET_REC) $(SOURCES_REC) $(SOURCES_OSAL) $(LDFLAGS_PTHREAD) $(INCFLAGS) $(LDFLAGS_EXE)

clean:
	$(RM) $(TARGET_DLL) $(TARGET_CTRL) $(TARGET_REC)
