quit -sim
vsim -gui work.cp_adder_8bits(circuit)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label in1 -color blue in1
add wave -label in2 -color blue in2
add wave -label Cin -color blue Cin

add wave -divider -height 25 OUTPUTS:
add wave -label Sum -color yellow Sum

add wave -divider -height 25 INNER_SIGNALS:
add wave -label Carry -color green Carry 

--first test
force -freeze sim:/cp_adder_8bits/in1 00010011 0
force -freeze sim:/cp_adder_8bits/in2 11110010 0
force -freeze sim:/cp_adder_8bits/Cin 1 0
run 100ps 
--second test
force -freeze sim:/cp_adder_8bits/in1 11111111 0
force -freeze sim:/cp_adder_8bits/in2 11111111 0
force -freeze sim:/cp_adder_8bits/Cin 1 0
run 100ps 
--third test
force -freeze sim:/cp_adder_8bits/in1 10101010 0
force -freeze sim:/cp_adder_8bits/in2 00010001 0
force -freeze sim:/cp_adder_8bits/Cin 0 0
run 100ps 
--fourth test
force -freeze sim:/cp_adder_8bits/in1 11000011 0
force -freeze sim:/cp_adder_8bits/in2 00000011 0
force -freeze sim:/cp_adder_8bits/Cin 1 0
run 100ps 
--fifth test
force -freeze sim:/cp_adder_8bits/in1 11111111 0
force -freeze sim:/cp_adder_8bits/in2 11110010 0
force -freeze sim:/cp_adder_8bits/Cin 0 0
run 100ps 
