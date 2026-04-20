PACKAGE=bgnet0
WEB_IMAGES=$(wildcard src/*.svg src/*.png)

BGBSPD_BUILD_DIR?=../bgbspd

include $(BGBSPD_BUILD_DIR)/main.make
