CC        := gcc
CSTD      := -std=c11
WARN      := -Wall -Wextra -Werror -Wpedantic
OPT       ?= -O2
CFLAGS    := $(CSTD) $(WARN) $(OPT) -Iinclude -MMD -MP
LDFLAGS   :=
LDLIBS    := -lm
# В Windows gcc добавляет к имени программы суффикс .exe
ifeq ($(OS),Windows_NT)
    EXE := .exe
endif
TARGET    := app$(EXE)
BUILD     := build
PREFIX    ?= /usr/local
ARGS      ?= 1 50
PROJECT_VERSION := 1.0.0
GIT_REV   := $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
BUILD_DATE := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
OBJS      := $(BUILD)/main.o $(BUILD)/calc.o $(BUILD)/util.o
DEPS      := $(OBJS:.o=.d)
