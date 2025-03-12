-- Simulation Init
quit -sim
vcom register_file.vhd
vsim work.register_file(rtl)

-- Add inputs
add wave -divider " INPUTS: "
add wave -divider " GENERAL SIGNALS: "
add wave -label synch_rst -color green synch_rst
add wave -label clk -color green clk

add wave -divider " ENABLE SIGNALS: "
add wave -label wr_en -color yellow wr_en
add wave -label rd_en -color yellow rd_en
add wave -label mode -color yellow mode

add wave -divider " ENABLE SIGNALS: "
add wave -label w_data_0 -color yellow -hexadecimal w_data_0
add wave -label w_data_1 -color yellow -hexadecimal w_data_1


--Add outputs
add wave -divider " OUTPUTS: "
add wave -label r_data -color red -hexadecimal r_data
add wave -label "K_{N} - K_{N+3}" -color red -hexadecimal r_data_low
add wave -label "K_{N+4} - K_{N+7}" -color red -hexadecimal r_data_high

add wave -divider " REGISTER DATA: "
add wave -label "Register Data" -color pink -expand -hexadecimal reg_file
add wave -label w_addr -color red -unsigned w_addr
add wave -label r_addr -color red -unsigned r_addr

add wave -label column -color red -unsigned column


--Generate Clock:
force clk 0 0, 1 50ps -repeat 100ps
--Start with reset 0:
force synch_rst 0
--Enable write to Registers
force wr_en 1
force rd_en 0
force mode 1

--0,1
force w_data_0 16#7519
force w_data_1 16#71F9
run 100ps


--2,3
force w_data_0 16#84E9
force w_data_1 16#4886
run 100ps


--4,5
force w_data_0 16#88E5
force w_data_1 16#523B
run 100ps

--6,7
force w_data_0 16#4EA4
force w_data_1 16#7ADE
run 100ps

--8,9
force w_data_0 16#FE40
force w_data_1 16#5E76
run 100ps

--10,11
force w_data_0 16#9819
force w_data_1 16#EEAC
run 100ps

--12,13
force w_data_0 16#1BD4
force w_data_1 16#2455
run 100ps

--14,15
force w_data_0 16#DCA0
force w_data_1 16#653B
run 100ps

--16,17
force w_data_0 16#3E32
force w_data_1 16#4652
run 100ps

--18,19
force w_data_0 16#1CC1
force w_data_1 16#34DF
run 100ps

--20,21
force w_data_0 16#778B
force w_data_1 16#771D
run 100ps

--22,23
force w_data_0 16#D324
force w_data_1 16#8410
run 100ps

--24,25
force w_data_0 16#1CA8
force w_data_1 16#BC64
run 100ps

--26,27
force w_data_0 16#A0DB
force w_data_1 16#BDD2
run 100ps

--28,29
force w_data_0 16#1F5F
force w_data_1 16#8F1C
run 100ps

--30,31
force w_data_0 16#6B81
force w_data_1 16#B560
run 100ps

--32,33
force w_data_0 16#196A
force w_data_1 16#9AB1
run 100ps

--34,35
force w_data_0 16#E015
force w_data_1 16#8190
run 100ps

--36,37
force w_data_0 16#9F72
force w_data_1 16#6643
run 100ps

--38,39
force w_data_0 16#AD32
force w_data_1 16#683A
run 100ps

--Setup Crypto:
force wr_en 1
force rd_en 1
run 100ps

force wr_en 0
force rd_en 1

run 3120
