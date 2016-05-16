# TCL File Generated by Component Editor 12.1sp1
# Thu Aug 20 16:47:37 CST 2015
# DO NOT MODIFY


# 
# i2c_avalon "i2c_avalon" v1.1
# Yogurt 2015.08.20.16:47:37
# Yogurt 2015.08.27.16:14:00
# 

source "../../lib/aup_ip_generator.tcl"

# 
# module i2c_avalon
# 
set_module_property DESCRIPTION "I2C Module With Avalon Interface"
set_module_property NAME i2c_avalon
set_module_property VERSION 1.1
set_module_property GROUP my_ip/Interface
set_module_property AUTHOR Yogurt
set_module_property DISPLAY_NAME i2c_avalon
set_module_property DATASHEET_URL "[pwd]/doc/I2C Core.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property VALIDATION_CALLBACK validate
set_module_property ELABORATION_CALLBACK elaborate
set_module_property GENERATION_CALLBACK generate

# 
# file sets
# 
add_file "hdl/i2c_clk_div.v" SYNTHESIS
add_file "hdl/i2c_interface.v" SYNTHESIS


# 
# parameters
# 
add_parameter in_clk INTEGER 20000000
set_parameter_property in_clk DISPLAY_NAME "Input Clock Frequency"
set_parameter_property in_clk UNITS None
set_parameter_property in_clk DISPLAY_UNITS Hz
set_parameter_property in_clk AFFECTS_ELABORATION false
set_parameter_property in_clk AFFECTS_GENERATION true
set_parameter_property in_clk VISIBLE true
set_parameter_property in_clk ENABLED true

add_parameter i2c_clk INTEGER 100000
set_parameter_property i2c_clk DISPLAY_NAME "I2C Clock Frequency"
set_parameter_property i2c_clk UNITS None
set_parameter_property i2c_clk DISPLAY_UNITS Hz
set_parameter_property i2c_clk AFFECTS_ELABORATION false
set_parameter_property i2c_clk AFFECTS_GENERATION true
set_parameter_property i2c_clk VISIBLE true
set_parameter_property i2c_clk ENABLED true

# +-----------------------------------
# | Validation function
# | 
proc validate {} {
	set in_clk			[ get_parameter_value "in_clk"]
	set i2c_clk			[ get_parameter_value "i2c_clk"]
	
	set i2c_clk_max		[ expr ($in_clk / 4)]
	set i2c_clk_min		[ expr ($in_clk / 4 / 65535)]

	if { $i2c_clk < $i2c_clk_min } {
		send_message error "The I2C clock frequency is at least $i2c_clk_min Hz"
	}
	if { $i2c_clk > $i2c_clk_max } {
		send_message error "The I2C clock frequency is at most $i2c_clk_max Hz"
	}
}
# | 
# +-----------------------------------

# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock ENABLED true

add_interface_port clock clk clk Input 1

# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true

add_interface_port reset rst_n reset_n Input 1

# +-----------------------------------
# | Elaboration function
# | 
proc elaborate {} {

	set in_clk [ get_interface_property clock clockRate ]
	if { $in_clk <= 0 } {
		set_parameter_property in_clk ENABLED true
	} else {
		set_parameter_property in_clk ENABLED false
		set_parameter_value "in_clk" $in_clk
	}

	# 
	# connection point s1
	# 
	add_interface s1 avalon end
	set_interface_property s1 addressUnits WORDS
	set_interface_property s1 associatedClock clock
	set_interface_property s1 associatedReset reset
	set_interface_property s1 bitsPerSymbol 8
	set_interface_property s1 burstOnBurstBoundariesOnly false
	set_interface_property s1 burstcountUnits WORDS
	set_interface_property s1 explicitAddressSpan 0
	set_interface_property s1 holdTime 0
	set_interface_property s1 linewrapBursts false
	set_interface_property s1 maximumPendingReadTransactions 1
	set_interface_property s1 readLatency 0
	set_interface_property s1 readWaitTime 1
	set_interface_property s1 setupTime 0
	set_interface_property s1 timingUnits Cycles
	set_interface_property s1 writeWaitTime 0
	set_interface_property s1 ENABLED true

	add_interface_port s1 av_address address Input 2
	add_interface_port s1 av_write write Input 1
	add_interface_port s1 av_read read Input 1
	add_interface_port s1 av_writedata writedata Input 32
	add_interface_port s1 av_readdata readdata Output 32
	add_interface_port s1 av_readdatavalid readdatavalid Output 1
	add_interface_port s1 av_waitrequest waitrequest Output 1
	set_interface_assignment s1 embeddedsw.configuration.isFlash 0
	set_interface_assignment s1 embeddedsw.configuration.isMemoryDevice 0
	set_interface_assignment s1 embeddedsw.configuration.isNonVolatileStorage 0
	set_interface_assignment s1 embeddedsw.configuration.isPrintableDevice 0

	# 
	# connection point i2c_wire
	# 
	add_interface i2c_wire conduit end
	set_interface_property i2c_wire associatedClock clock
	set_interface_property i2c_wire associatedReset reset
	set_interface_property i2c_wire ENABLED true

	add_interface_port i2c_wire i2c_scl export Output 1
	add_interface_port i2c_wire i2c_sda export Bidir 1
}
# | 
# +-----------------------------------

# +-----------------------------------
# | Generation function
# | 
proc generate {} {
	set in_clk			[ get_parameter_value "in_clk"]
	set i2c_clk			[ get_parameter_value "i2c_clk"]

	set div_cnt			[ expr ($in_clk / $i2c_clk / 4) ]
	set div_cnt_p		"DIV_CNT:$div_cnt"

	set params 			"$div_cnt_p"
	set sections 		""

	set dest_dir 		[ get_generation_property OUTPUT_DIRECTORY ]
	set dest_name		[ get_generation_property OUTPUT_NAME ]

	add_file "$dest_dir$dest_name.v" SYNTHESIS
	alt_up_generate "$dest_dir$dest_name.v" "hdl/i2c_top.v" "i2c_top" $dest_name $params $sections
}
# | 
# +-----------------------------------