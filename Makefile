THIS_MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
BUILD_TOP_DIR := $(abspath $(dir ${THIS_MAKEFILE_PATH}))
INSTALL_PREFIX := ${BUILD_TOP_DIR}/install
VERSION_STRING := 12.0.0
SRC_DIR := llvm-project-${VERSION_STRING}.src
LLVM_DIR := ${SRC_DIR}/llvm
BUILD_DIR := ${LLVM_DIR}/build

all:
	make source
	make rpm

source:
	#wget https://github.com/llvm/llvm-project/releases/download/llvmorg-${VERSION_STRING}/${SRC_DIR}.tar.xz
	tar -xf ${SRC_DIR}.tar.xz

rpm:
	rpmbuild -bb --define "_topdir ${BUILD_TOP_DIR}" --define "version ${VERSION_STRING}" --define "buildroot ${INSTALL_PREFIX}" ${BUILD_TOP_DIR}/llvm-clang.spec

build-llvm:
	mkdir -p ${BUILD_DIR}
	cd ${BUILD_DIR} && cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra" ${LLVM_DIR}
	ninja -j 4

install-llvm:
	cd ${BUILD_DIR} && make install

clean:
	rm -rf ${BUILD_DIR}
	rm -rf ${INSTALL_PREFIX}

.PHONY: all source rpm build-llvm install-llvm clean

