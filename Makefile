.DEFAULT_GOAL := all
.PHONY: all clean rebuild run

include mk/config.mk
include mk/rules.mk
-include mk/help.mk
-include $(DEPS)

all: $(TARGET)

run: all
	./$(TARGET) $(ARGS)

clean:
	rm -rf $(BUILD) $(TARGET)

rebuild: clean all
