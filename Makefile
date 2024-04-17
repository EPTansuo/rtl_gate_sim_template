TOP_NAME = demo
TB_NAME = demo_tb

VSRC_DIR = ./vsrc
TB_DIR = ./tb

RTL_SIM_DIR = ./rtl_sim
GATE_SIM_DIR = ./gate_sim

GATE_SIM_LIB_V = /SM01/foundry/csmc/bcd18/std_libs/CSMC018G3HD5VSBCD1P6Mlib_FB_V20F07/verilog/csmc018G3.v
TB_FILE_V=$(abspath tb/$(TB_NAME).v)


PLATFORM=LINUX64
INC_FLAGS = +incdir+$(VSRC_DIR)
VCS_FLAGS = -full64 -notice -kdb -lca -debug_acc+all \
                +dmptf +warn=all +libext+.v+v2k+acc
#-R +fsdb+autoflush


############################################################
#                                                          #
# IF NOT NECESSARY, DO NOT CHANGE THE FOLLOWING VARIABLE!  #
#                                                          #
############################################################
VCS_LOG=$(RTL_SIM_DIR)/vcs.log
SIM_LOG=$(RTL_SIM_DIR)/sim.log
RTL_SIM_FILE_LIST_F= $(RTL_SIM_DIR)/file.list.f
GATE_SIM_FILE_LIST_F = $(GATE_SIM_DIR)/file.list.f
RTL_SIM_CSRC_OBJ_DIR=$(RTL_SIM_DIR)/csrc
GATE_SIM_CSRC_OBJ_DIR=$(GATE_SIM_DIR)/csrc
RTL_SIM_BIN=$(RTL_SIM_DIR)/simv
GATE_SIM_BIN=$(GATE_SIM_DIR)/simv
NETLIST_V=$(GATE_SIM_DIR)/$(TOP_NAME).netlist.v



VSRCS = $(shell find $(abspath $(VSRC_DIR)) -name "*.v")
VSRCS += $(shell find $(abspath $(TB_DIR)) -name "*.v")



-include ./scripts/rtl_sim.mk
-include ./scripts/gate_sim.mk

default: build
build: rtl_build
sim: rtl_sim


clean:
	-rm -rf $(RTL_SIM_DIR) $(GATE_SIM_DIR)

