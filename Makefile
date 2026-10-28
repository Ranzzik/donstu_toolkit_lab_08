.DEFAULT_GOAL := all
.PHONY: all clean rebuild run info

include mk/config.mk
include mk/rules.mk
include $(BUILD)/version.mk
-include mk/help.mk
-include $(DEPS)

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
