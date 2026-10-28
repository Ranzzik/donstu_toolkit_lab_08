$(TARGET): $(OBJS) | $(BUILD)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(BUILD)/%.o: src/%.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST_BIN): $(TEST_OBJS) $(filter-out $(BUILD)/main.o,$(OBJS)) | $(BUILD)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(BUILD):
	mkdir -p $@

$(BUILD)/version.mk: mk/version.mk.in | $(BUILD)
	sed -e 's/@VERSION@/$(PROJECT_VERSION)/' 	    -e 's/@GIT_HASH@/$(GIT_REV)/' $< > $@
