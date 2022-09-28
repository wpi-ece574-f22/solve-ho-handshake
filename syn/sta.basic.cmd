read_liberty /mnt/volume_nyc1_01/skywater-pdk/libraries/sky130_fd_sc_hd/latest/timing/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog counter_gl.v
link_design counter

create_clock -name clk -period 5 {clk}
set_input_delay -clock clk 1 {reset}
set_output_delay -clock clk 1 {q}

report_checks

exit


