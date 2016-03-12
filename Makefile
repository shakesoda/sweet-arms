OUT    := bin/demo
SRCS   := \
	src/main.s \
	src/math.s
FILES  := $(foreach file, $(SRCS), $(basename $(file)))
OBJS   := $(foreach file, $(FILES), obj/$(file).o))
OUTDIR := obj
LINKS  := -lSDL

all: .mkbin
	gcc -o $(OUT) $(SRCS) $(LINKS)

clean:
	if [ -f $(OUT) ]; then rm $(OUT); fi
	if [ -d bin ]; then rm -rf bin; fi

tests: .mkbin
	gcc -o bin/test_math tests/test_math.s

.mkbin:
	if [ ! -d bin ]; then mkdir bin; fi


.PHONY: all clean tests

