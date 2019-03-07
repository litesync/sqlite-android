LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := libuv
LOCAL_SRC_FILES := ../libuv/$(TARGET_ARCH_ABI)/libuv.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/libuv/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := libbinn
LOCAL_SRC_FILES := ../binn/$(TARGET_ARCH_ABI)/libbinn.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/binn/include
include $(PREBUILT_SHARED_LIBRARY)

include $(CLEAR_VARS)

# Debug mode:
#sqlite_flags += -g -DSQLITE_DEBUG=1 -DDEBUGPRINT -rdynamic -funwind-tables
sqlite_flags += -DNDEBUG=1

# For testing:
sqlite_flags += -DLITESYNC_FOR_TESTING

# NOTE the following flags,
#   SQLITE_TEMP_STORE=3 causes all TEMP files to go into RAM. and thats the behavior we want
#   SQLITE_ENABLE_FTS3   enables usage of FTS3 - NOT FTS1 or 2.
sqlite_flags += \
	-DHAVE_USLEEP=1 \
	-DSQLITE_USE_URI=1 \
	-DSQLITE_HAS_CODEC \
	-DSQLITE_HAVE_ISNAN \
	-DSQLITE_DEFAULT_PAGE_SIZE=1024 \
	-DSQLITE_THREADSAFE=1 \
	-DSQLITE_TEMP_STORE=3 \
	-DSQLITE_POWERSAFE_OVERWRITE=1 \
	-DSQLITE_ENABLE_MEMORY_MANAGEMENT=1 \
	-DSQLITE_ENABLE_BATCH_ATOMIC_WRITE \
	-DSQLITE_ENABLE_FTS3 \
	-DSQLITE_ENABLE_FTS3_PARENTHESIS \
	-DSQLITE_ENABLE_FTS4 \
	-DSQLITE_ENABLE_FTS4_PARENTHESIS \
	-DSQLITE_ENABLE_FTS5 \
	-DSQLITE_ENABLE_RTREE \
	-DSQLITE_ENABLE_JSON1 \
	-DSQLITE_ENABLE_COLUMN_METADATA \
	-DSQLITE_OMIT_BUILTIN_TEST \
	-DSQLITE_OMIT_COMPILEOPTION_DIAGS \
	-DSQLITE_DEFAULT_FILE_PERMISSIONS=0600

#	-DSQLITE_OMIT_LOAD_EXTENSION \

LOCAL_CFLAGS += $(sqlite_flags)
LOCAL_CFLAGS += -Wno-unused-parameter -Wno-int-to-pointer-cast
LOCAL_CFLAGS += -Wno-uninitialized -Wno-parentheses
LOCAL_CPPFLAGS += -Wno-conversion-null


ifeq ($(TARGET_ARCH), arm)
	LOCAL_CFLAGS += -DPACKED="__attribute__ ((packed))"
else
	LOCAL_CFLAGS += -DPACKED=""
endif

LOCAL_SRC_FILES:= \
	android_database_SQLiteCommon.cpp \
	android_database_SQLiteConnection.cpp \
	android_database_SQLiteFunction.cpp \
	android_database_SQLiteGlobal.cpp \
	android_database_SQLiteDebug.cpp \
	android_database_CursorWindow.cpp \
	CursorWindow.cpp \
	JNIHelp.cpp \
	JNIString.cpp

LOCAL_SRC_FILES += sqlite3.c

LOCAL_C_INCLUDES += $(LOCAL_PATH)
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../binn/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/../libuv/include

LOCAL_MODULE:= libsqlite3x
LOCAL_LDLIBS += -ldl -llog

LOCAL_SHARED_LIBRARIES := libbinn libuv

include $(BUILD_SHARED_LIBRARY)
