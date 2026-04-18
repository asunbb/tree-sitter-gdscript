ifeq ($(OS),Windows_NT)
$(error Windows is not supported)
endif

LANGUAGE_NAME := gdscript
SRC_DIR := src
TS ?= tree-sitter

# source files
PARSER_SRC := $(SRC_DIR)/parser.c
SCANNER_SRC := $(SRC_DIR)/scanner.c

# output
PARSER_OUT := parser/$(LANGUAGE_NAME).so

# compiler
CC ?= cc
CFLAGS ?= -O2
override CFLAGS += -I$(SRC_DIR) -std=c11 -fPIC

# OS-specific linker flags
ifeq ($(shell uname),Darwin)
  LDFLAGS := -bundle -undefined dynamic_lookup
else
  LDFLAGS := -shared
endif

.PHONY: all clean test generate

all: $(PARSER_OUT)

$(PARSER_OUT): $(PARSER_SRC) $(SCANNER_SRC)
	@mkdir -p parser
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	rm -f $(PARSER_OUT)
	rm -f $(SRC_DIR)/*.o

test:
	$(TS) test

generate:
	$(TS) generate
