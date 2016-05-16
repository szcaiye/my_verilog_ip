# TCL File Generated by Component Editor 12.1sp1
# Tue Mar 29 00:15:28 CST 2016
# DO NOT MODIFY


# 
# wb_slave_to_avalon_master "WishBone Slave to Avalon Master" v1.0
# Yogurt 2016.03.29.00:15:28
# Convert WishBone Slave Interface to Avalon Master Interface
# 

source "../../lib/aup_ip_generator.tcl"

# 
# module wb_slave_to_avalon_master
# 
set_module_property DESCRIPTION "Convert WishBone Slave Interface to Avalon Master Interface"
set_module_property NAME wb_slave_to_avalon_master
set_module_property VERSION 1.0
set_module_property GROUP my_ip/interface
set_module_property AUTHOR Yogurt
set_module_property DISPLAY_NAME "WishBone Slave to Avalon Master"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property GENERATION_CALLBACK generate


# 
# parameters
# 
add_parameter ADDR_WIDTH INTEGER 32
set_parameter_property ADDR_WIDTH DISPLAY_NAME "Address Bus Width"
set_parameter_property ADDR_WIDTH UNITS None
set_parameter_property ADDR_WIDTH AFFECTS_ELABORATION true
set_parameter_property ADDR_WIDTH AFFECTS_GENERATION true
set_parameter_property ADDR_WIDTH VISIBLE true
set_parameter_property ADDR_WIDTH ENABLED true

add_parameter DATA_WIDTH INTEGER 32
set_parameter_property DATA_WIDTH DISPLAY_NAME "Data Bus Width"
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES {8 16 32}
set_parameter_property DATA_WIDTH AFFECTS_ELABORATION true
set_parameter_property DATA_WIDTH AFFECTS_GENERATION true
set_parameter_property DATA_WIDTH VISIBLE true
set_parameter_property DATA_WIDTH ENABLED true

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
set_interface_property reset ENABLED true
set_interface_property reset synchronousEdges DEASSERT

add_interface_port reset rst_n reset_n Input 1

proc elaborate {} {
	set addr_width [ get_parameter_value "ADDR_WIDTH" ]
	set data_width [ get_parameter_value "DATA_WIDTH" ]
	set data_bytes [ expr ($data_width/8)]

	# 
	# connection point avalon_master
	# 
	add_interface avalon_master avalon start
	set_interface_property avalon_master addressUnits WORDS
	set_interface_property avalon_master associatedClock clock
	set_interface_property avalon_master associatedReset reset
	set_interface_property avalon_master bitsPerSymbol 8
	set_interface_property avalon_master burstOnBurstBoundariesOnly false
	set_interface_property avalon_master burstcountUnits WORDS
	set_interface_property avalon_master doStreamReads false
	set_interface_property avalon_master doStreamWrites false
	set_interface_property avalon_master holdTime 0
	set_interface_property avalon_master linewrapBursts false
	set_interface_property avalon_master maximumPendingReadTransactions 0
	set_interface_property avalon_master readLatency 0
	set_interface_property avalon_master readWaitTime 0
	set_interface_property avalon_master setupTime 0
	set_interface_property avalon_master timingUnits Cycles
	set_interface_property avalon_master writeWaitTime 0
	set_interface_property avalon_master ENABLED true

	add_interface_port avalon_master av_chipselect chipselect Output 1
	add_interface_port avalon_master av_byteenable byteenable Output $data_bytes
	add_interface_port avalon_master av_address address Output $addr_width
	add_interface_port avalon_master av_read read Output 1
	add_interface_port avalon_master av_write write Output 1
	add_interface_port avalon_master av_readdata readdata Input $data_width
	add_interface_port avalon_master av_readdatavalid readdatavalid Input 1
	add_interface_port avalon_master av_writedata writedata Output $data_width
	add_interface_port avalon_master av_waitrequest waitrequest Input 1

	# 
	# connection point wishbone_slave
	# 
	add_interface wishbone_slave conduit end
	set_interface_property wishbone_slave associatedClock clock
	set_interface_property wishbone_slave associatedReset reset
	set_interface_property wishbone_slave ENABLED true

	add_interface_port wishbone_slave wb_cyc_i export Input 1
	add_interface_port wishbone_slave wb_stb_i export Input 1
	add_interface_port wishbone_slave wb_we_i export Input 1
	add_interface_port wishbone_slave wb_adr_i export Input $addr_width
	add_interface_port wishbone_slave wb_dat_i export Input $data_width
	add_interface_port wishbone_slave wb_dat_o export Output $data_width
	add_interface_port wishbone_slave wb_sel_i export Input $data_bytes
	add_interface_port wishbone_slave wb_ack_o export Output 1
}

proc generate {} {
	set addr_width [ get_parameter_value "ADDR_WIDTH" ]
	set data_width [ get_parameter_value "DATA_WIDTH" ]
	set data_bytes [ expr ($data_width/8)]

	set params "ADDR_WIDTH:$addr_width;DATA_WIDTH:$data_width;DATA_BYTES:$data_bytes"
	set sections ""

	set dest_dir 		[ get_generation_property OUTPUT_DIRECTORY ]
	set dest_name		[ get_generation_property OUTPUT_NAME ]
	
	add_file "$dest_dir$dest_name.v" {SYNTHESIS SIMULATION}
	alt_up_generate "$dest_dir$dest_name.v" "hdl/wb_slave_to_avalon_master.v" "wb_slave_to_avalon_master" $dest_name $params $sections
}
