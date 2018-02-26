CC=cc
CFLAGS+=-std=c11 -Wall -ggdb

# Put here path to qbe-root
QBEROOT=qbe

BUILD_DIR?=.

BIN_DIR=$(BUILD_DIR)/bin
OBJ_DIR=$(BUILD_DIR)/obj
INCLUDE_DIR=$(BUILD_DIR)/include

CFLAGS+=-I$(INCLUDE_DIR)
CFLAGS+=-I$(INCLUDE_DIR)/amd64
CFLAGS+=-I$(INCLUDE_DIR)/arm64

SOURCES=$(wildcard *.c)
OBJFILES=$(addprefix $(OBJ_DIR)/, $(SOURCES:.c=.o))
TARGET=$(addprefix $(BIN_DIR)/, $(basename $(notdir $(OBJFILES))))

QBEOBJFILES=$(addprefix $(QBEROOT)/obj/, util.o parse.o cfg.o)

all: directories qbe $(TARGET)

$(TARGET): $(OBJFILES)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(wildcard $(OBJ_DIR)/$(notdir $@).o) $(QBEOBJFILES)

directories:
	@mkdir -p $(OBJ_DIR) $(BIN_DIR) $(INCLUDE_DIR)
	@echo $(abspath $(OBJ_DIR) $(BIN_DIR) $(INCLUDE_DIR)) > directories

qbe: directories
	@make -C $(QBEROOT) -j4
	@test -e $(abspath $(INCLUDE_DIR)/qbe) || ln -s $(abspath $(QBEROOT)) $(abspath $(INCLUDE_DIR)/qbe)

$(OBJ_DIR)/%.o: %.c
	$(CC) $(CFLAGS) -c $^ -o $@

clean:
	@rm -rvf $(BIN_DIR) $(OBJ_DIR) $(INCLUDE_DIR)
	rm directories

ifeq (check,$(firstword $(MAKECMDGOALS)))
  # use the rest as arguments for "run"
  CHECK_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  # ...and turn them into do-nothing targets
  $(eval $(CHECK_ARGS):;@:)
endif

check: $(TARGET)
	cd tests && ./tester $(CHECK_ARGS) $(abspath $^);

realclean: clean
	@rm -rv tests/*.{output,diff}
	make -C $(QBEROOT) clean

.PHONY: clean all realclean
