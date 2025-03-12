quit -sim
vsim -gui work.Key_Schedule(structural)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label key -color blue key
add wave -label clk -color blue clk
add wave -label synch_rst -color blue synch_rst
add wave -label control -color blue control

add wave -divider -height 25 OUTPUTS:
add wave -label Klow -color yellow Klow
add wave -label Khigh -color yellow Khigh

add wave -divider -height 25 INNER_SIGNALS:
add wave -label mux_out -color green mux_out
add wave -label reg_out -color green reg_out
add wave -label A0 -color green A0
add wave -label B0 -color green B0
add wave -label D0 -color green D0
add wave -label Q1 -color green Q1
add wave -label Q2 -color green Q2
add wave -label Q3 -color green Q3
add wave -label xor_out1 -color green xor_out1
add wave -label xor_out2 -color green xor_out2
add wave -label out_f -color green out_f
add wave -label or_out -color green or_out
add wave -label state -color green state

--test
force -freeze sim:/Key_Schedule/key 00000001001000110100010101100111100010011010101111001101111011110000000100100011010001010110011110001001101010111100110111101111  0
force -freeze sim:/Key_Schedule/synch_rst 0 0
force -freeze sim:/Key_Schedule/control 1 0
force -freeze sim:/Key_Schedule/clk 0 0, 1 {100 ps} -r 200 ps
run 200ps
force -freeze sim:/Key_Schedule/control 0 0
run 200ps