set TOP_NAME "demo"
set TOP_V_FILE "$env(PWD)/vsrc/${TOP_NAME}.v"
set PRJ_DIR /SM01/home/bs2021/bs202164050062/PROJECT/Verilog/rtl_gate_sim_template
set BUILD_DIR gate_sim
set V_FILES [list "${PRJ_DIR}/vsrc/demo.v" "${PRJ_DIR}/vsrc/series.v"]
set MAX_AREA 1000
set MAX_FINOUT 8
set MAX_TRANSITION 5
set LINK_LIBRARY {/SM01/foundry/csmc/bcd18/std_libs/CSMC018G3HD5VSBCD1P6Mlib_FB_V20F07/synopsys/csmc018g3_typ.db}
set TARGET_LIBRARY { /SM01/foundry/csmc/bcd18/std_libs/CSMC018G3HD5VSBCD1P6Mlib_FB_V20F07/synopsys/csmc018g3_typ.db /SM01/foundry/csmc/bcd18/std_libs/CSMC018G3HD5VSBCD1P6Mlib_FB_V20F07/synopsys/csmc018g3_max.db }


# Standard cell library definition
set link_library $LINK_LIBRARY
set target_library $TARGET_LIBRARY
set symbol_library ""

# Read RTL, analyse and elborate 
read_file -format verilog $V_FILES
analyze -library WORK -format verilog $V_FILES
elaborate TOP_NAME -architecture verilog -library WORK
analyze -format verilog $V_FILES

# set constraints
create_clock -name "clk" -period 10 -waveform { 5 10 } [get_ports clk_port]
set_max_area $MAX_AREA
set_max_fanout $MAX_FINOUT $TOP_NAME
set_max_transition $MAX_TRANSITION $TOP_NAME
#set_min_delay 0.01 rise -to {demo} set_min_delay 0.01 -fall -to {demo}
#set input_delay [ expr $clock_period / 4 ] set ouput_delay [ expr $clock_period / 4 ]

# check design 
check_design

# compile
compile -exact_map

# save gate-level netlist
file mkdir report
write -hierarchy -format verilog -output [file join $PRJ_DIR $BUILD_DIR "${TOP_NAME}.netlist.v"]
write_sdc -nosplit -version 2.0 [file join $PRJ_DIR $BUILD_DIR design.sdc]
write_sdf [file join $PRJ_DIR $BUILD_DIR design.sdf]

# Report file generations
report_area -hierarchy > [file join $PRJ_DIR $BUILD_DIR report design.area]
report_timing > [file join $PRJ_DIR $BUILD_DIR report design.timing]
report_power > [file join $PRJ_DIR $BUILD_DIR report design.power]

#start_gui
#
exit


