
# Set variables for top name and build dir
set TOP_NAME "demo"
set BUILD_DIR gate_sim;                       


# set variable for PRJ_DIR
set currentPath [info script]
set normalizedPath [file normalize $currentPath]
set currentDir [file dirname $normalizedPath]
set PRJ_DIR [file dirname $currentDir]

   
# get all verilog files 
set FILE_LIST_F [file join ${PRJ_DIR} ${BUILD_DIR} "dc_file.list.f" ]

set V_FILES []

set fp [open $FILE_LIST_F r] 

while {[gets $fp line] >= 0} {
    lappend V_FILES $line
}

puts $V_FILES


# Constraint
set MAX_AREA 1000
set MAX_FINOUT 8
set MAX_TRANSITION 5


# Foundary Libraries 
set STD_LIBS_PATH /SM01/foundry/csmc/bcd18/std_libs/CSMC018G3HD5VSBCD1P6Mlib_FB_V20F07
set LINK_LIBRARY [ list "${STD_LIBS_PATH}/synopsys/csmc018g3_typ.db"]
set TARGET_LIBRARY [ list  "${STD_LIBS_PATH}/synopsys/csmc018g3_typ.db" "${STD_LIBS_PATH}/synopsys/csmc018g3_max.db" ]


# Standard cell library definition
set link_library $LINK_LIBRARY
set target_library $TARGET_LIBRARY
set symbol_library ""


######################
#                    #
#       START!       #
#                    #
######################


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


