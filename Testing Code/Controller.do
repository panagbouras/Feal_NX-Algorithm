quit -sim
vsim -gui work.Controller(behavioral)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label new_in -color blue new_in
add wave -label in32 -color blue in32
add wave -label N -color blue N
add wave -label clk -color blue clk
add wave -label synch_rst -color blue synch_rst

add wave -divider -height 25 OUTPUTS:
add wave -label ack -color yellow ack
add wave -label sel -color yellow sel
add wave -label control_KS -color yellow control_KS
add wave -label control_crypto -color yellow control_crypto
add wave -label wr_en -color yellow wr_en
add wave -label rd_en -color yellow rd_en
add wave -label key_out -color yellow key_out
add wave -label act_out -color yellow act_out
add wave -label plain0_out -color yellow plain0_out
add wave -label plain1_out -color yellow plain1_out
add wave -label plain2_out -color yellow plain2_out
add wave -label plain3_out -color yellow plain3_out
add wave -label plain4_out -color yellow plain4_out
add wave -label plain5_out -color yellow plain5_out
add wave -label plain6_out -color yellow plain6_out
add wave -label plain7_out -color yellow plain7_out

add wave -divider -height 25 INNER_SIGNALS:
add wave -label pr_state -color green pr_state
add wave -label nx_state -color green nx_state
add wave -label plain_reg -color green plain_reg
add wave -label key_reg -color green key_reg
add wave -label count -color green count
add wave -label count_max -color green count_max
add wave -label N_reg -color green N_reg
add wave -label loaded_reg -color green loaded_reg
add wave -label valid_out -color green valid_out

--test
force -freeze sim:/Controller/synch_rst 0 0
force -freeze sim:/Controller/clk 0 0, 1 {100 ps} -r 200 ps
force -freeze sim:/Controller/new_in 0 0
force -freeze sim:/Controller/in32 00000001001000110100010101100111 0
force -freeze sim:/Controller/N 0000 0
run 200ps
force -freeze sim:/Controller/in32 10001001101010111100110111101111 0
run 200ps
force -freeze sim:/Controller/in32 00000001001000110100010101100111 0
run 200ps
force -freeze sim:/Controller/in32 10001001101010111100110111101111 0
run 200ps
force -freeze sim:/Controller/in32 11110000100010100000000000000000 0
run 200ps