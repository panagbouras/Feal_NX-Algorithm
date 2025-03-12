quit -sim
vsim -gui work.functionFK(pipeline)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label A -color blue A
add wave -label B -color blue B

add wave -divider -height 25 OUTPUTS:
add wave -label FK -color yellow FK

add wave -divider -height 25 INNER_SIGNALS:
add wave -label xor_out -color green xor_out 
add wave -label out_S01 -color green out_S01
add wave -label out_S02 -color green out_S02
add wave -label out_S11 -color green out_S11
add wave -label out_S12 -color green out_S12

--first test
force -freeze sim:/functionFK/A 00000000000000000000000000000000 0
force -freeze sim:/functionFK/B 00000000000000000000000000000000 0
run 200ps
--second test
force -freeze sim:/functionFK/A 00000000111111110000000011111111 0
force -freeze sim:/functionFK/B 11111111000000001111111100000000 0
run 200ps
--third test
force -freeze sim:/functionFK/A 11111110000000000000000011111111 0
force -freeze sim:/functionFK/B 11111111111111111111111111111110 0
run 200ps