.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.PHONY: all clean rebuild run info test check lint debug release install uninstall dist

include mk/config.mk
include mk/rules.mk
include $(BUILD)/version.mk
CFLAGS += -DGIT_HASH=\"$(GIT_HASH)\" -DBUILD_DATE=\"$(BUILD_DATE)\"
-include mk/help.mk
-include $(DEPS)

# Конфигурации сборки
debug:   CFLAGS += -g -O0 -DDEBUG
release: CFLAGS += -O3 -DNDEBUG
$(BUILD)/%.o: CFLAGS += -fno-omit-frame-pointer

debug release: all

all: $(TARGET)       ## собрать проект

run: all             ## собрать и запустить
	./$(TARGET) $(ARGS)

clean:               ## удалить артефакты
	rm -rf $(BUILD) $(TARGET) $(TARGET)-*.tar.gz

rebuild: clean all   ## чистая пересборка

# Установка и дистрибутив
install: all         ## установить в DESTDIR+PREFIX
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 0755 $(TARGET) $(DESTDIR)$(PREFIX)/bin/$(TARGET)

uninstall:           ## удалить установленную программу
	rm -f $(DESTDIR)$(PREFIX)/bin/$(TARGET)

DIST_FILES := Makefile README.md mk src include
dist: clean          ## собрать архив с исходниками
	tar czf $(TARGET)-$(VERSION).tar.gz $(DIST_FILES)

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
