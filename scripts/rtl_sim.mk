
$(RTL_SIM_FILE_LIST_F): $(VSRCS)
        $(shell mkdir -p $(RTL_SIM_DIR))
        $(shell printf '%s\n' $(VSRCS) > $(RTL_SIM_FILE_LIST_F))


$(RTL_SIM_BIN): $(RTL_SIM_FILE_LIST_F)
	vcs     $(INC_FLAGS) -l $(VCS_LOG) $(VCS_FLAGS)\
                -P $(VERDI_HOME)/share/PLI/VCS/$(PLATFORM)/novas.tab\
                $(VERDI_HOME)/share/PLI/VCS/$(PLATFORM)/pli.a\
                 -f $(RTL_SIM_FILE_LIST_F) -top $(TB_NAME)\
                -Mdir=$(RTL_SIM_CSRC_OBJ_DIR) -o $(RTL_SIM_BIN)

rtl_sim: rtl_build
	cd $(RTL_SIM_DIR) && ./$(shell basename $(RTL_SIM_BIN))\
                 -l $(abspath $(SIM_LOG))

rtl_build: $(RTL_SIM_BIN)

