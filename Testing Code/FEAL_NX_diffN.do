quit -sim
vsim -gui work.FEAL_NX(structural)

--add the signals to the wave
add wave -divider -height 25 INPUTS:
add wave -label new_in -color white new_in
add wave -label in32 -color white in32
add wave -label mode -color white mode
add wave -label N -color white N
add wave -label clk -color white clk
add wave -label synch_rst -color white synch_rst

add wave -divider -height 25 OUTPUTS:
add wave -label out64 -color yellow -hexadecimal out64
add wave -label act_out -color green -hexadecimal act_out
add wave -label ack -color green -hexadecimal ack

add wave -divider -height 25 INNER_SIGNALS:
add wave -label K_N_to_K_N3 -color green -hexadecimal keys_low
add wave -label K_N4_to_K_N7 -color green -hexadecimal keys_high
add wave -label mux21_first -color green -hexadecimal mux21_first
add wave -label mux21_last -color green -hexadecimal mux21_last
add wave -label plain_sig -color green -hexadecimal plain_sig
add wave -label out_sig -color green -hexadecimal out_sig
add wave -label out_reg -color green -hexadecimal out_reg
add wave -label out_mux21 -color green -hexadecimal out_mux21
add wave -label control_KS -color green -hexadecimal control_KS
add wave -label control_crypto -color green -hexadecimal control_crypto
add wave -label wr_en -color green -hexadecimal wr_en
add wave -label rd_en -color green -hexadecimal rd_en
add wave -label active_out -color green -hexadecimal active_out
add wave -label key -color green -hexadecimal key
add wave -label K_low -color green -hexadecimal K_low
add wave -label K_high -color green -hexadecimal K_high
add wave -label r_data -color green -hexadecimal r_data
add wave -label sel -color green -hexadecimal sel

--test
force -freeze sim:/FEAL_NX/synch_rst 0 0
force -freeze sim:/FEAL_NX/clk 0 0, 1 {100 ps} -r 200 ps
force -freeze sim:/FEAL_NX/mode 1 0
force -freeze sim:/FEAL_NX/new_in 0 0
force -freeze sim:/FEAL_NX/in32 00000001001000110100010101100111 0
force -freeze sim:/FEAL_NX/N 1001 0
run 200ps
force -freeze sim:/FEAL_NX/in32 10001001101010111100110111101111 0
run 200ps
force -freeze sim:/FEAL_NX/in32 00000001001000110100010101100111 0
run 200ps
force -freeze sim:/FEAL_NX/in32 10001001101010111100110111101111 0
run 200ps
force -freeze sim:/FEAL_NX/in32 00001010100011110101101100001010 0
run 200ps