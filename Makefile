RTL_BUILD_DIR = ./rtl_sim
GATE_BUILD_DIR = ./gate_sim
DC_TCL = demo_dc.tcl

GATE_LIB_V = /SM01/foundry/csmc/bcd18/std_libs/CSMC018G3HD5VSBCD1P6Mlib_FB_V20F07/verilog/csmc018G3.v

VSRC_DIR = ./vsrc
TB_DIR = ./tb
INC_FLAGS = +incdir+$(VSRC_DIR)
TOP_NAME = demo
TB_NAME = demo_tb
PLATFORM=LINUX64

VCS_LOG=$(RTL_BUILD_DIR)/vcs.log
SIM_LOG=$(RTL_BUILD_DIR)/sim.log
FILE_LIST_F= $(RTL_BUILD_DIR)/file.list.f
GATE_FILE_LIST_F = $(GATE_BUILD_DIR)/file.list.f
CSRC_DIR=$(RTL_BUILD_DIR)/csrc
GATE_CSRC_DIR=$(GATE_BUILD_DIR)/csrc
BIN=$(RTL_BUILD_DIR)/simv
GATE_BIN=$(GATE_BUILD_DIR)/simv
NETLIST_V=$(GATE_BUILD_DIR)/$(TOP_NAME).netlist.v
TB_FILE=$(abspath tb/$(TB_NAME).v)

VCS_FLAGS = -full64 -notice -kdb -lca -debug_acc+all \
		+dmptf +warn=all +libext+.v+v2k+acc
#-R +fsdb+autoflush


VSRCS = $(shell find $(abspath $(VSRC_DIR)) -name "*.v")
VSRCS += $(shell find $(abspath $(TB_DIR)) -name "*.v")


default: $(BIN)


$(FILE_LIST_F): $(VSRCS)
	$(shell mkdir -p $(RTL_BUILD_DIR))
	$(shell printf '%s\n' $(VSRCS) > $(FILE_LIST_F))


$(BIN): $(FILE_LIST_F)
	vcs	$(INC_FLAGS) -l $(VCS_LOG) $(VCS_FLAGS)\
		-P $(VERDI_HOME)/share/PLI/VCS/$(PLATFORM)/novas.tab\
		$(VERDI_HOME)/share/PLI/VCS/$(PLATFORM)/pli.a\
		 -f $(FILE_LIST_F) -top $(TB_NAME)\
		-Mdir=$(CSRC_DIR) -o $(BIN)

sim: $(BIN)
	cd $(RTL_BUILD_DIR) && ./$(shell basename $^)\
		 -l $(abspath $(SIM_LOG))
rtl_sim: sim

gate_sim: $(GATE_BIN)
	cd $(GATE_BUILD_DIR) && ./$(shell basename $^)

$(GATE_BIN):$(NETLIST_V)
	vcs     $(INC_FLAGS) $(VCS_FLAGS) -f $(GATE_FILE_LIST_F)\
		-kdb -sdf typ:$(TOP_NAME):$(GATE_BUILD_DIR)/design.sdf\
		-Mdir=$(GATE_CSRC_DIR) -o $(GATE_BIN) -top $(TB_NAME)


$(GATE_FILE_LIST_F): $(VSRCS)
	$(shell mkdir -p $(GATE_BUILD_DIR))
	$(shell mkdir -p $(GATE_BUILD_DIR)/report)
	$(shell printf '%s\n' $(GATE_LIB_V) > $(GATE_FILE_LIST_F))
	echo $(GATE_LIB_V)
	echo $(GATE_FILE_LIST_F)
	echo $(TB_FILE)
	$(shell printf '%s\n' $(NETLIST_V) >> $(GATE_FILE_LIST_F))

	$(shell printf '%s\n' $(TB_FILE) >> $(GATE_FILE_LIST_F))

$(NETLIST_V): $(GATE_FILE_LIST_F)
	cd $(GATE_BUILD_DIR) && dc_shell -f $(abspath $(DC_TCL))
	

all: default


clean:
	-rm -rf $(RTL_BUILD_DIR) $(GATE_BUILD_DIR)





