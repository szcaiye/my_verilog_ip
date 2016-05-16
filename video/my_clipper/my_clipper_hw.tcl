# TCL File Generated by Component Editor 12.1sp1
# Thu Jul 09 20:34:40 CST 2015
# DO NOT MODIFY


# 
# my_clipper "my_clipper" v1.2
# Yogurt 2015.07.09.20:34:40
# Yogurt 2015.09.10.19:55:00
# Yogurt 2015.09.16.19.41:00

source "../../lib/aup_ip_generator.tcl"

# 
# module my_clipper
# 
set_module_property DESCRIPTION "Clip Video Streams"
set_module_property NAME my_clipper
set_module_property VERSION 1.2
set_module_property GROUP my_ip/video
set_module_property AUTHOR Yogurt
set_module_property DISPLAY_NAME my_clipper
set_module_property DATASHEET_URL "[pwd]/doc/Video Clipping IP Core.pdf"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property GENERATION_CALLBACK generate

# 
# file sets
# 
add_file "hdl/my_clipper_decode.v" SYNTHESIS
add_file "hdl/my_clipper_fifo.v" SYNTHESIS
add_file "hdl/my_clipper_read_fifo.v" SYNTHESIS
add_file "hdl/my_clipper_encode.v" SYNTHESIS

# 
# parameters
# 
add_parameter color_bits INTEGER 8
set_parameter_property color_bits DISPLAY_NAME "Color Bits"
set_parameter_property color_bits GROUP "Image Data Format"
set_parameter_property color_bits UNITS NONE
set_parameter_property color_bits DISPLAY_UNITS Bits
set_parameter_property color_bits AFFECTS_ELABORATION true
set_parameter_property color_bits AFFECTS_GENERATION true
set_parameter_property color_bits ALLOWED_RANGES 4:32
set_parameter_property color_bits VISIBLE true
set_parameter_property color_bits ENABLED true

add_parameter color_planes INTEGER 3
set_parameter_property color_planes DISPLAY_NAME "Color Planes"
set_parameter_property color_planes GROUP "Image Data Format"
set_parameter_property color_planes UNITS None
set_parameter_property color_planes DISPLAY_UNITS Planes
set_parameter_property color_planes AFFECTS_ELABORATION true
set_parameter_property color_planes AFFECTS_GENERATION true
set_parameter_property color_planes ALLOWED_RANGES {1 2 3}
set_parameter_property color_planes VISIBLE true
set_parameter_property color_planes ENABLED true

add_parameter fifo_depth INTEGER 1024
set_parameter_property fifo_depth DISPLAY_NAME "FIFO Depth"
set_parameter_property fifo_depth GROUP "FIFO Setting"
set_parameter_property fifo_depth UNITS None
set_parameter_property fifo_depth AFFECTS_ELABORATION true
set_parameter_property fifo_depth AFFECTS_GENERATION true
set_parameter_property fifo_depth ALLOWED_RANGES {128 256 512 1024 2048 4096 8192 16384 32768 65536}
set_parameter_property fifo_depth VISIBLE true
set_parameter_property fifo_depth ENABLED true

add_parameter RUNTIME_CONTROL boolean false
set_parameter_property RUNTIME_CONTROL DiSPLAY_NAME "Runtime Control"
set_parameter_property RUNTIME_CONTROL GROUP "Clipping Options"
set_parameter_property RUNTIME_CONTROL UNITS None
set_parameter_property RUNTIME_CONTROL AFFECTS_ELABORATION true
set_parameter_property RUNTIME_CONTROL AFFECTS_GENERATION true
set_parameter_property RUNTIME_CONTROL VISIBLE true
set_parameter_property RUNTIME_CONTROL ENABLED true

add_parameter left_offset INTEGER 24
set_parameter_property left_offset DISPLAY_NAME "Left Offset"
set_parameter_property left_offset GROUP "Clipping Options"
set_parameter_property left_offset UNITS None
set_parameter_property left_offset DISPLAY_UNITS Pixels
set_parameter_property left_offset AFFECTS_ELABORATION false
set_parameter_property left_offset AFFECTS_GENERATION true
set_parameter_property left_offset VISIBLE true
set_parameter_property left_offset ENABLED true

add_parameter right_offset INTEGER 24
set_parameter_property right_offset DISPLAY_NAME "Right Offset"
set_parameter_property right_offset GROUP "Clipping Options"
set_parameter_property right_offset UNITS None
set_parameter_property right_offset DISPLAY_UNITS Pixels
set_parameter_property right_offset AFFECTS_ELABORATION false
set_parameter_property right_offset AFFECTS_GENERATION true
set_parameter_property right_offset VISIBLE true
set_parameter_property right_offset ENABLED true

add_parameter top_offset INTEGER 0
set_parameter_property top_offset DISPLAY_NAME "Top Offset"
set_parameter_property top_offset GROUP "Clipping Options"
set_parameter_property top_offset UNITS None
set_parameter_property top_offset DISPLAY_UNITS Pixels
set_parameter_property top_offset AFFECTS_ELABORATION false
set_parameter_property top_offset AFFECTS_GENERATION true
set_parameter_property top_offset VISIBLE true
set_parameter_property top_offset ENABLED true

add_parameter bottom_offset INTEGER 0
set_parameter_property bottom_offset DISPLAY_NAME "Bottom Offset"
set_parameter_property bottom_offset GROUP "Clipping Options"
set_parameter_property bottom_offset UNITS None
set_parameter_property bottom_offset DISPLAY_UNITS Pixels
set_parameter_property bottom_offset AFFECTS_ELABORATION false
set_parameter_property bottom_offset AFFECTS_GENERATION true
set_parameter_property bottom_offset VISIBLE true
set_parameter_property bottom_offset ENABLED true

proc elaborate {} {
	set color_bits				[get_parameter_value "color_bits"]
	set color_planes			[get_parameter_value "color_planes"]
	set run_control				[get_parameter_value "RUNTIME_CONTROL"]
	set data_width				[ expr ($color_bits * $color_planes) ]

	# 
	# connection point vst_clk
	# 
	add_interface vst_clk clock end
	set_interface_property vst_clk ENABLED true

	add_interface_port vst_clk vst_clk clk Input 1

	# 
	# connection point vst_rst_n
	# 
	add_interface vst_rst_n reset end
	set_interface_property vst_rst_n associatedClock vst_clk
	set_interface_property vst_rst_n synchronousEdges DEASSERT
	set_interface_property vst_rst_n ENABLED true

	add_interface_port vst_rst_n vst_rst_n reset_n Input 1

	# 
	# connection point vst_din
	# 
	add_interface vst_din avalon_streaming end
	set_interface_property vst_din associatedClock vst_clk
	set_interface_property vst_din associatedReset vst_rst_n
	set_interface_property vst_din dataBitsPerSymbol $color_bits
	set_interface_property vst_din errorDescriptor ""
	set_interface_property vst_din maxChannel 0
	set_interface_property vst_din readyLatency 1
	set_interface_property vst_din symbolsPerBeat $color_planes

	add_interface_port vst_din din_ready ready Output 1
	add_interface_port vst_din din_valid valid Input 1
	add_interface_port vst_din din_data data Input $data_width
	add_interface_port vst_din din_startofpacket startofpacket Input 1
	add_interface_port vst_din din_endofpacket endofpacket Input 1

	# 
	# connection point vst_dout
	# 
	add_interface vst_dout avalon_streaming start
	set_interface_property vst_dout associatedClock vst_clk
	set_interface_property vst_dout associatedReset vst_rst_n
	set_interface_property vst_dout dataBitsPerSymbol $color_bits
	set_interface_property vst_dout errorDescriptor ""
	set_interface_property vst_dout maxChannel 0
	set_interface_property vst_dout readyLatency 1
	set_interface_property vst_dout symbolsPerBeat $color_planes

	add_interface_port vst_dout dout_ready ready Input 1
	add_interface_port vst_dout dout_valid valid Output 1
	add_interface_port vst_dout dout_data data Output $data_width
	add_interface_port vst_dout dout_startofpacket startofpacket Output 1
	add_interface_port vst_dout dout_endofpacket endofpacket Output 1

	if { $run_control } {
		# 
		# connection point av_clk
		# 
		add_interface av_clk clock end
		set_interface_property av_clk ENABLED true
		add_interface_port av_clk av_clk clk Input 1

		# 
		# connection point av_rst_n
		# 
		add_interface av_rst_n reset end
		set_interface_property av_rst_n associatedClock av_clk
		set_interface_property av_rst_n synchronousEdges DEASSERT
		set_interface_property av_rst_n ENABLED true

		add_interface_port av_rst_n av_rst_n reset_n Input 1

		# 
		# connection point av_control
		# 
		add_interface av_control avalon end
		set_interface_property av_control addressUnits WORDS
		set_interface_property av_control associatedClock av_clk
		set_interface_property av_control associatedReset av_rst_n
		set_interface_property av_control bitsPerSymbol 8
		set_interface_property av_control burstOnBurstBoundariesOnly false
		set_interface_property av_control burstcountUnits WORDS
		set_interface_property av_control explicitAddressSpan 0
		set_interface_property av_control holdTime 0
		set_interface_property av_control linewrapBursts false
		set_interface_property av_control maximumPendingReadTransactions 8
		set_interface_property av_control readLatency 0
		set_interface_property av_control readWaitTime 0
		set_interface_property av_control setupTime 0
		set_interface_property av_control timingUnits Cycles
		set_interface_property av_control writeWaitTime 0
		set_interface_property av_control ENABLED true

		add_interface_port av_control av_address address Input 3
		add_interface_port av_control av_write write Input 1
		add_interface_port av_control av_writedata writedata Input 32
		add_interface_port av_control av_read read Input 1
		add_interface_port av_control av_readdata readdata Output 32
		add_interface_port av_control av_readdatavalid readdatavalid Output 1
		add_interface_port av_control av_waitrequest waitrequest Output 1
		
		set_interface_assignment av_control embeddedsw.configuration.isFlash 0
		set_interface_assignment av_control embeddedsw.configuration.isMemoryDevice 0
		set_interface_assignment av_control embeddedsw.configuration.isNonVolatileStorage 0
		set_interface_assignment av_control embeddedsw.configuration.isPrintableDevice 0
	}
}

proc generate {} {
	set color_bits				[get_parameter_value "color_bits"]
	set color_planes			[get_parameter_value "color_planes"]
	set fifo_depth				[get_parameter_value "fifo_depth"]
	set run_control				[get_parameter_value "RUNTIME_CONTROL"]
	set left_offset				[get_parameter_value "left_offset"]
	set right_offset			[get_parameter_value "right_offset"]
	set top_offset				[get_parameter_value "top_offset"]
	set bottom_offset			[get_parameter_value "bottom_offset"]

	set data_width				[ expr ($color_bits * $color_planes) ]
	set fifo_use_width 			[ format "%.0f" [ expr ceil (log($fifo_depth) / (log (2))) ]]

	set data_width_p			"DATA_WIDTH:$data_width"
	set color_bits_p			"COLOR_BITS:$color_bits"
	set color_planes_p			"COLOR_PLANES:$color_planes"
	set fifo_use_width_p		"USED_WIDTH:$fifo_use_width"
	set left_offset_p			"LEFT_OFFSET:16'd$left_offset"
	set right_offset_p			"RIGHT_OFFSET:16'd$right_offset"
	set top_offset_p			"TOP_OFFSET:16'd$top_offset"
	set bottom_offset_p			"BOTTOM_OFFSET:16'd$bottom_offset"

	if { $run_control } {
		set run_control_if "RUNTIME_CONTROL:1"
	} else {
		set run_control_if "RUNTIME_CONTROL:0"
	}

	set params "$data_width_p;$color_bits_p;$color_planes_p;$fifo_use_width_p;$left_offset_p;$right_offset_p;$top_offset_p;$bottom_offset_p"
	set sections "$run_control_if"

	set dest_dir 		[ get_generation_property OUTPUT_DIRECTORY ]
	set dest_name		[ get_generation_property OUTPUT_NAME ]

	add_file "$dest_dir$dest_name.v" SYNTHESIS
	alt_up_generate "$dest_dir$dest_name.v" "hdl/my_clipper_top.v" "my_clipper_top" $dest_name $params $sections
}