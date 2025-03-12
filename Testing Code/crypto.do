quit -sim
vsim -gui work.crypto(structural)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label first_keys -color blue first_keys
add wave -label last_keys -color blue last_keys
add wave -label key -color blue key
add wave -label input -color blue input
add wave -label clk -color blue clk
add wave -label synch_rst -color blue synch_rst
add wave -label control -color blue control

add wave -divider -height 25 OUTPUTS:
add wave -label output -color yellow -hexadecimal output

add wave -divider -height 25 INNER_SIGNALS:
add wave -label reg_out -color green -hexadecimal reg_out
add wave -label xor_out1 -color green -hexadecimal xor_out1
add wave -label xor_out -color green -hexadecimal xor_out
add wave -label xor_out5 -color green -hexadecimal xor_out5
add wave -label mux_out1 -color green -hexadecimal mux_out1
add wave -label mux_out2 -color green -hexadecimal mux_out2
add wave -label out_f -color green -hexadecimal out_f

--test
--initialize
force -freeze sim:/crypto/first_keys 16#196A9AB1E0158190
force -freeze sim:/crypto/last_keys 16#9F726643AD32683A
force -freeze sim:/crypto/key 16#7519
force -freeze sim:/crypto/input 0000000000000000000000000000000000000000000000000000000000000000  0
force -freeze sim:/crypto/clk 0 0, 1 {100 ps} -r 200 ps
force -freeze sim:/crypto/synch_rst 0 0
force -freeze sim:/crypto/control 1 0
--1st run
run 200ps
--2nd run
force -freeze sim:/crypto/control 0 0
force -freeze sim:/crypto/key 16#71F9
run 100ps
force -freeze sim:/crypto/key 16#84E9
run 200ps
force -freeze sim:/crypto/key 16#4886
run 200ps
force -freeze sim:/crypto/key 16#88E5
