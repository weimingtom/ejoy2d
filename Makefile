.PHONY : mingw ej2d linux undefined

CFLAGS = -g -Wall -Ilib -D EJOY2D_OS=$(OS)
LDFLAGS :=

SRC := \
lib/shader.c \
lib/lshader.c \
lib/ejoy2dgame.c \
lib/fault.c \
lib/screen.c \
lib/texture.c \
lib/ppm.c \
lib/spritepack.c \
lib/sprite.c \
lib/lsprite.c \
lib/matrix.c \
lib/lmatrix.c \
lib/dfont.c \
lib/label.c \
lib/particle.c \
lib/lparticle.c \
lib/scissor.c

UNAME=$(shell uname)
SYS=$(if $(filter Linux%,$(UNAME)),linux,\
	    $(if $(filter MINGW%,$(UNAME)),mingw,\
	    $(if $(filter Darwin%,$(UNAME)),macosx,\
	        undefined\
)))

all: $(SYS)

undefined:
	@echo "I can't guess your platform, please do 'make PLATFORM' where PLATFORM is one of these:"
	@echo "      linux mingw macosx"


mingw : OS := WINDOWS
mingw : TARGET := ej2d.exe
mingw : CFLAGS += -DGLEW_STATIC -Iextlibs/include
mingw : LDFLAGS +=  -DGLEW_STATIC -Lextlibs/lib -lgdi32 -lglew -lopengl32 -llua
mingw : SRC += mingw/window.c mingw/winfw.c mingw/winfont.c

mingw : $(SRC) ej2d

linux : OS := LINUX
linux : TARGET := ej2d
linux : CFLAGS += -I/usr/include -I/usr/local/include $(shell freetype-config --cflags)
linux : LDFLAGS +=  -lGLEW -lGL -lX11 -lfreetype -llua -lm -Wl,-E
linux : SRC += posix/window.c posix/winfw.c posix/winfont.c

linux : $(SRC) ej2d

macosx : OS := MACOSX
macosx : TARGET := ej2d
macosx : CFLAGS += -I/usr/X11R6/include -I/usr/include -I/usr/local/include $(shell freetype-config --cflags) -D __MACOSX
macosx : LDFLAGS += -L/usr/X11R6/lib  -lGLEW -lGL -lX11 -lfreetype -llua -lm -Wl,-E -ldl
macosx : SRC += posix/window.c posix/winfw.c posix/winfont.c

macosx : $(SRC) ej2d

ej2d :
	gcc $(CFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean :
	-rm -f ej2d.exe
	-rm -f ej2d

test:
	ej2d examples/ex01.lua
	ej2d examples/ex02.lua
	ej2d examples/ex03.lua
	ej2d examples/ex04.lua
