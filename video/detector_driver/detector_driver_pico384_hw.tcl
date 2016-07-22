# TCL File Generated by Component Editor 13.1
# Thu Jun 16 16:41:10 CST 2016
# DO NOT MODIFY


# 
# detector_driver_pico384 "detector_driver_pico384" v1.0
# Yogurt 2016.06.16.16:41:10
# Detector Driver for PICO384
# 


# 
# module detector_driver_pico384
# 
set_module_property DESCRIPTION "Detector Driver for PICO384"
set_module_property NAME detector_driver_pico384
set_module_property VERSION 1.0
set_module_property GROUP my_ip/video
set_module_property AUTHOR Yogurt
set_module_property DISPLAY_NAME detector_driver_pico384
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ELABORATION_CALLBACK elaborate
set_module_property GENERATION_CALLBACK generate


# 
# file sets
# 
add_file "hdl/detector_avalon_slave.v" SYNTHESIS
add_file "hdl/detector_ddio_in.v" SYNTHESIS
add_file "hdl/detector_driver.v" SYNTHESIS


# 
# parameters
# 
add_parameter clk_fre positive 6000000
set_parameter_property clk_fre DISPLAY_NAME "Pixel Clock Frequency"
set_parameter_property clk_fre UNITS NONE
set_parameter_property clk_fre DISPLAY_UNITS "Hz"
set_parameter_property clk_fre AFFECTS_ELABORATION false
set_parameter_property clk_fre AFFECTS_GENERATION true
set_parameter_property clk_fre VISIBLE true
set_parameter_property clk_fre ENABLED true

add_parameter seq_tri_width positive 8
set_parameter_property seq_tri_width DISPLAY_NAME "Seq Trigger Pulse Width"
set_parameter_property seq_tri_width UNITS NONE
set_parameter_property seq_tri_width DISPLAY_UNITS "cycles"
set_parameter_property seq_tri_width AFFECTS_ELABORATION false
set_parameter_property seq_tri_width AFFECTS_GENERATION true
set_parameter_property seq_tri_width VISIBLE true
set_parameter_property seq_tri_width ENABLED true


# 
# connection point clock_reg
# 
add_interface clock_reg clock end
set_interface_property clock_reg ENABLED true

add_interface_port clock_reg clk clk Input 1


# 
# connection point clock_pixel
# 
add_interface clock_pixel clock end
set_interface_property clock_pixel ENABLED true

add_interface_port clock_pixel dd_psync clk Input 1


# 
# connection point reset_reg
# 
add_interface reset_reg reset end
set_interface_property reset_reg associatedClock clock_reg
set_interface_property reset_reg synchronousEdges DEASSERT
set_interface_property reset_reg ENABLED true

add_interface_port reset_reg rst_n reset_n Input 1

# 
# connection point control
# 
add_interface control avalon end
set_interface_property control addressUnits WORDS
set_interface_property control associatedClock clock_reg
set_interface_property control associatedReset reset_reg
set_interface_property control bitsPerSymbol 8
set_interface_property control burstOnBurstBoundariesOnly false
set_interface_property control burstcountUnits WORDS
set_interface_property control explicitAddressSpan 0
set_interface_property control holdTime 0
set_interface_property control linewrapBursts false
set_interface_property control maximumPendingReadTransactions 0
set_interface_property control readLatency 1
set_interface_property control readWaitStates 0
set_interface_property control readWaitTime 0
set_interface_property control setupTime 0
set_interface_property control timingUnits Cycles
set_interface_property control writeWaitTime 0
set_interface_property control ENABLED true

add_interface_port control av_address address Input 3
add_interface_port control av_read read Input 1
add_interface_port control av_readdata readdata Output 32
add_interface_port control av_write write Input 1
add_interface_port control av_writedata writedata Input 32
set_interface_assignment control embeddedsw.configuration.isFlash 0
set_interface_assignment control embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment control embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment control embeddedsw.configuration.isPrintableDevice 0


# 
# connection point dout
# 
add_interface dout avalon_streaming start
set_interface_property dout associatedClock clock_pixel
set_interface_property dout associatedReset reset_reg
set_interface_property dout dataBitsPerSymbol 14
set_interface_property dout errorDescriptor ""
set_interface_property dout firstSymbolInHighOrderBits true
set_interface_property dout maxChannel 0
set_interface_property dout readyLatency 1
set_interface_property dout ENABLED true

add_interface_port dout dout_startofpacket startofpacket Output 1
add_interface_port dout dout_endofpacket endofpacket Output 1
add_interface_port dout dout_valid valid Output 1
add_interface_port dout dout_data data Output 14


# 
# connection point detector
# 
add_interface detector conduit end
set_interface_property detector associatedClock clock_pixel
set_interface_property detector associatedReset reset_reg
set_interface_property detector ENABLED true

add_interface_port detector dd_nrst export Output 1
add_interface_port detector dd_i2cad export Output 1
add_interface_port detector dd_seq_trigger export Output 1
add_interface_port detector dd_hsync export Input 1
add_interface_port detector dd_vsync export Input 1
add_interface_port detector dd_video export Input 14



proc elaborate {} {
	set clk_fre [ get_interface_property clock_pixel clockRate ]
	if { $clk_fre <= 0 } {
		set_parameter_property clk_fre ENABLED true
	} else {
		set_parameter_property clk_fre ENABLED false
		set_parameter_value "clk_fre" $clk_fre
	}
}

proc generate {} {
	set clk_fre					[ get_parameter_value "clk_fre"]
	set seq_tri_width			[ get_parameter_value "seq_tri_width"]
	set frame_cnt				[ format "%.0f" [ expr round ($clk_fre / 50) ]]

	set frame_cnt_p				"FRAME_FRE_CNT:32'd$frame_cnt"
	set seq_tri_width_p			"SEQ_TRT_WIDTH:8'd$seq_tri_width"

	set params 					"$frame_cnt_p;$seq_tri_width_p"
	set sections				""

	set dest_dir 				[ get_generation_property OUTPUT_DIRECTORY ]
	set dest_name				[ get_generation_property OUTPUT_NAME ]

	add_file "$dest_dir$dest_name.v" SYNTHESIS
	alt_up_generate "$dest_dir$dest_name.v" "hdl/detector_driver_top.v" "detector_driver_top" $dest_name $params $sections
}