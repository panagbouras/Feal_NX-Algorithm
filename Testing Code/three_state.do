quit -sim
vsim -gui work.three_state(behavioral)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label clk -color blue clk
add wave -label synch_rst -color blue synch_rst

add wave -divider -height 25 OUTPUTS:
add wave -label output -color yellow output

add wave -divider -height 25 INNER_SIGNALS:
add wave -label inner -color green inner

--test
force -freeze sim:/three_state/synch_rst 0 0
force -freeze sim:/three_state/clk 0 0, 1 {100 ps} -r 200 ps
run 400ps
force -freeze sim:/three_state/synch_rst 1 0
run 400ps
force -freeze sim:/three_state/synch_rst 0 0
run 200ps