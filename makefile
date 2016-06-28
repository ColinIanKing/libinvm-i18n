#
# Copyright (c) 2015, 2016 Intel Corporation
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   * Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#   * Neither the name of Intel Corporation nor the names of its contributors
#     may be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# makefile - Top level makefile for the Intel I18N library.
#

# ---- BUILD ENVIRONMENT ---------------------------------------------------------------------------
ROOT_DIR = .
# sets up standard build variables
include $(ROOT_DIR)/build.mk
SKIP_UNITTESTS ?= 1

FLAGS := SKIP_UNITTESTS=$(SKIP_UNITTESTS)

# ---- FILES ---------------------------------------------------------------------------------------
# Linux Install Files
LIB_DIR ?= /usr/lib64
# files that get installed into /usr/lib64
LIB_FILES = $(LIB_BASENAME).so* 
INCLUDE_DIR ?= /usr/include
# files that get installed into /usr/include/
I18N_INCLUDE_DIR = $(HEADER_DIRECTORY)

# ---- RECIPES -------------------------------------------------------------------------------------
# Build all
all :
	$(MAKE) -C src all $(FLAGS)

# Build only shippable products (no unittests)
targets :
	$(MAKE) -C src targets

clean :
	$(MAKE) -C src clean

clobber :
	$(MAKE) -C src clobber
	$(RM) $(BUILD_DIR)/crystalridge.pot
	$(RM) -r $(LOCALE_DIR)
	$(RM) $(GETTEXT_OUTPUTFILE)

install :
	# complete the paths for the files to be installed
	$(eval LIB_FILES := $(addprefix $(BUILD_DIR)/, $(LIB_FILES)))
	$(eval I18N_INCLUDE_DIR := $(addprefix $(BUILD_DIR)/include/, $(I18N_INCLUDE_DIR)))
	
	# install files into lib directory
	$(MKDIR) $(RPM_ROOT)$(LIB_DIR)
	$(COPY) $(LIB_FILES) $(RPM_ROOT)$(LIB_DIR)
	
	# install files into include directory
	$(MKDIR) $(RPM_ROOT)$(INCLUDE_DIR)
	$(COPY) $(I18N_INCLUDE_DIR) $(RPM_ROOT)$(INCLUDE_DIR)
uninstall : 

	$(eval LIB_FILES := $(addprefix $(RPM_ROOT)$(LIB_DIR)/, $(LIB_FILES)))
	$(eval I18N_INCLUDE_DIR := $(addprefix $(RPM_ROOT)$(INCLUDE_DIR)/, $(I18N_INCLUDE_DIR)))
	
	$(RM) $(LIB_FILES)
	$(RMDIR) $(I18N_INCLUDE_DIR)

rpm :
	#Make the Directories
	$(MKDIR) $(RPMBUILD_DIR) $(RPMBUILD_DIR)/BUILD $(RPMBUILD_DIR)/SOURCES $(RPMBUILD_DIR)/RPMS $(RPMBUILD_DIR)/SRPMS $(RPMBUILD_DIR)/SPECS $(RPMBUILD_DIR)/BUILDROOT $(RPMBUILD_DIR)/BUILD/$(HEADER_DIRECTORY)-$(BUILDNUM)
	$(RMDIR) $(RPMBUILD_DIR)/BUILD/$(HEADER_DIRECTORY)-$(BUILDNUM)

	#Copy Spec File
	$(COPY) install/linux/$(LINUX_DIST)-release/*.spec $(RPMBUILD_DIR)/SPECS/$(LIB_BASENAME).spec
	#Update the Spec file
	$(SED) -i 's/^%define build_version .*/%define build_version $(BUILDNUM)/g' $(RPMBUILD_DIR)/SPECS/$(LIB_BASENAME).spec

	#Archive the directory
	git archive --format=tar --prefix="$(LIB_BASENAME)-$(BUILDNUM)/" HEAD | gzip -c > $(RPMBUILD_DIR)/SOURCES/$(LIB_BASENAME)-$(BUILDNUM).tar.gz
	#rpmbuild
	$(RPMBUILD) -ba $(RPMBUILD_DIR)/SPECS/$(LIB_BASENAME).spec --define "_topdir $(RPMBUILD_DIR)" --define "cflag $(CFLAGS_EXTERNAL)"


.PHONY : all qb_standard src clean clobber uninstall install rpm
