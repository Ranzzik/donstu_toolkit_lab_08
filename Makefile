.DEFAULT_GOAL := all
.PHONY: all clean rebuild run info test check lint debug release

include mk/config.mk
include mk/rules.mk
include $(BUILD)/version.mk
-include mk/help.mk
-include $(DEPS)

# Конфигурации сборки
debug:   CFLAGS += -g -O0 -DDEBUG
release: CFLAGS += -O3 -DNDEBUG
$(BUILD)/%.o: CFLAGS += -fno-omit-frame-pointer

debug release: all

all: $(TARGET)

run: all
	./$(TARGET) $(ARGS)

clean:
	rm -rf $(BUILD) $(TARGET)

rebuild: clean all

info:                ## показать значения переменных
	@echo "CC        = $(CC)        [$(origin CC)]"
	@echo "CFLAGS    = $(CFLAGS)"
	@echo "TARGET    = $(TARGET)"
	@echo "OBJS      = $(OBJS)"
	@echo "DEPS      = $(DEPS)"
	@echo "MAKEFLAGS = $(MAKEFLAGS)"

define run-test
	@echo "== running $(1) =="
	./$(BUILD)/$(1)$(EXE)
endef

test: all $(TEST_BIN)  ## запустить тесты
	$(call run-test,test_calc)

CHECK_DIRS    := src include
CHECK_TARGETS := $(foreach d,$(CHECK_DIRS),check-$(d))

check: $(CHECK_TARGETS)  ## проверить стиль исходников
$(CHECK_TARGETS): check-%:
	@echo "== checking $* =="
	@grep -rnE '[[:space:]]+$$' $* && echo "FOUND trailing spaces" || echo "OK"

# Цель lint-<файл> для каждого исходника
define lint-rule
.PHONY: lint-$(notdir $(1))
lint-$(notdir $(1)): $(1)
	@echo "checking $(1)"
endef

$(foreach f,$(SRCS),$(eval $(call lint-rule,$(f))))

lint: $(addprefix lint-,$(notdir $(SRCS)))  ## проверить все исходники
