DC_FILES_V = $(shell find $(abspath $(VSRC_DIR)) -name "$(TOP_NAME).v")
DC_FILES_V += $(shell find $(abspath $(VSRC_DIR)) -name "*.v" ! -name "$(TOP_NAME).v")
DC_FILE_LIST_F = $(GATE_SIM_DIR)/dc_file.list.f

$(GATE_SIM_FILE_LIST_F): $(VSRCS)
	$(shell mkdir -p $(GATE_SIM_DIR))
	$(shell mkdir -p $(GATE_SIM_DIR)/report)
	$(shell printf '%s\n' $(GATE_SIM_LIB_V) > $(GATE_SIM_FILE_LIST_F))
	$(shell printf '%s\n' $(NETLIST_V) >> $(GATE_SIM_FILE_LIST_F))
	$(shell printf '%s\n' $(TB_FILE_V) >> $(GATE_SIM_FILE_LIST_F))


$(GATE_SIM_BIN):$(NETLIST_V)
	vcs     $(INC_FLAGS) $(VCS_FLAGS) -f $(GATE_SIM_FILE_LIST_F)\
                -kdb -sdf typ:$(TOP_NAME):$(GATE_SIM_DIR)/design.sdf\
                -Mdir=$(GATE_SIM_CSRC_OBJ_DIR) -o $(GATE_SIM_BIN) -top $(TB_NAME)




$(NETLIST_V): $(GATE_SIM_FILE_LIST_F)
	$(shell printf '%s\n' $(DC_FILES_V) > $(DC_FILE_LIST_F))
	cd $(GATE_SIM_DIR) && dc_shell -f $(abspath ./scripts/dc.tcl)


gate_sim: gate_build
	cd $(GATE_SIM_DIR) && ./$(shell basename ${GATE_SIM_BIN})

gate_build: $(GATE_SIM_BIN)
	
