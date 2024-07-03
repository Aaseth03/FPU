onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mult_expadd_tb/Tall_a
add wave -noupdate /mult_expadd_tb/Tall_b
add wave -noupdate /mult_expadd_tb/svar
add wave -noupdate /mult_expadd_tb/CLK_s
add wave -noupdate /mult_expadd_tb/mult1/CLK
add wave -noupdate /mult_expadd_tb/mult1/RST
add wave -noupdate /mult_expadd_tb/mult1/Tall_a
add wave -noupdate /mult_expadd_tb/mult1/Tall_b
add wave -noupdate /mult_expadd_tb/mult1/Tall_s
add wave -noupdate /mult_expadd_tb/mult1/sign_a
add wave -noupdate /mult_expadd_tb/mult1/sign_b
add wave -noupdate /mult_expadd_tb/mult1/sign_s
add wave -noupdate /mult_expadd_tb/mult1/exp_a
add wave -noupdate /mult_expadd_tb/mult1/exp_b
add wave -noupdate /mult_expadd_tb/mult1/exp_s
add wave -noupdate /mult_expadd_tb/mult1/fract_a
add wave -noupdate /mult_expadd_tb/mult1/fract_b
add wave -noupdate /mult_expadd_tb/mult1/fract_s
add wave -noupdate /mult_expadd_tb/mult1/tall_s_sig
add wave -noupdate /mult_expadd_tb/mult1/fract_s_m
add wave -noupdate /mult_expadd_tb/mult1/Num_z
add wave -noupdate /mult_expadd_tb/mult1/Norm/CLK
add wave -noupdate /mult_expadd_tb/mult1/Norm/Enable
add wave -noupdate /mult_expadd_tb/mult1/Norm/RST
add wave -noupdate /mult_expadd_tb/mult1/Norm/X
add wave -noupdate /mult_expadd_tb/mult1/Norm/Num_Z
add wave -noupdate /mult_expadd_tb/mult1/Norm/k
add wave -noupdate /mult_expadd_tb/mult1/Norm/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5171 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 236
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {33736 ps}
