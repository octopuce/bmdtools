#** -LICENSE-START-
#** Copyright (c) 2009 Blackmagic Design
#**
#** Permission is hereby granted, free of charge, to any person or organization
#** obtaining a copy of the software and accompanying documentation covered by
#** this license (the "Software") to use, reproduce, display, distribute,
#** execute, and transmit the Software, and to prepare derivative works of the
#** Software, and to permit third-parties to whom the Software is furnished to
#** do so, all subject to the following:
#**
#** The copyright notices in the Software and this entire statement, including
#** the above license grant, this restriction and the following disclaimer,
#** must be included in all copies of the Software, in whole or in part, and
#** all derivative works of the Software, unless such copies or derivative
#** works are solely in the form of machine-executable object code generated by
#** a source language processor.
#**
#** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#** FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
#** SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
#** FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
#** ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#** DEALINGS IN THE SOFTWARE.
#** -LICENSE-END-

prefix ?= /usr
bindir ?= $(prefix)/bin

CXX = g++
SDK_PATH = ../include

SYS=$(shell uname)

PKG_DEPS = libavcodec libavformat libswscale libavutil

CXXFLAGS = `pkg-config --cflags $(PKG_DEPS)` -D__STDC_CONSTANT_MACROS
LDFLAGS  = `pkg-config --libs $(PKG_DEPS)`

CXXFLAGS+= -Wno-multichar -I $(SDK_PATH) -fno-rtti -g
LDFLAGS += -lm -ldl -lpthread -lrt

ifeq ($(SYS), Darwin)
CXXFLAGS+= -framework CoreFoundation -DHAVE_CFSTRING
LDFLAGS += -framework CoreFoundation
endif

PROGRAMS = bmdcapture bmdplay bmdgenlock

COMMON_FILES = modes.cpp $(SDK_PATH)/DeckLinkAPIDispatch.cpp

all: $(PROGRAMS)

bmdcapture: bmdcapture.cpp $(COMMON_FILES)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

bmdplay: bmdplay.cpp $(COMMON_FILES)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

bmdgenlock: genlock.cpp $(SDK_PATH)/DeckLinkAPIDispatch.cpp
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

clean:
	-rm -f $(PROGRAMS)

install: all
	mkdir -p $(DESTDIR)/$(bindir)
	cp $(PROGRAMS) $(DESTDIR)/$(bindir)
