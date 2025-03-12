quit -sim
vsim -gui work.functionS(behavioral)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label in1 -color blue in1
add wave -label in2 -color blue in2
add wave -label mode -color blue mode

add wave -divider -height 25 OUTPUTS:
add wave -label output -color yellow output

add wave -divider -height 25 INNER_SIGNALS:
add wave -label result -color green result 

--first test
force -freeze sim:/functionS/in1 00010011 0
force -freeze sim:/functionS/in2 11110010 0
force -freeze sim:/functionS/mode 1 0
run 100ps
--second test
force -freeze sim:/functionS/in1 11001100 0
force -freeze sim:/functionS/in2 00000000 0
force -freeze sim:/functionS/mode 0 0
run 100ps
--third test
force -freeze sim:/functionS/in1 10101010 0
force -freeze sim:/functionS/in2 01010101 0
force -freeze sim:/functionS/mode 1 0
run 100ps
--fourth test
force -freeze sim:/functionS/in1 00111100 0
force -freeze sim:/functionS/in2 00010001 0
force -freeze sim:/functionS/mode 0 0
run 100ps
--fifth test
force -freeze sim:/functionS/in1 01110001 0
force -freeze sim:/functionS/in2 10001011 0
force -freeze sim:/functionS/mode 1 0
run 100ps