onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fpu_tb/Tall_a
add wave -noupdate /fpu_tb/Tall_b
add wave -noupdate /fpu_tb/Tall_s
add wave -noupdate /fpu_tb/CLK
add wave -noupdate /fpu_tb/Op_ctrl
add wave -noupdate /fpu_tb/FPU1/AddSub_s
add wave -noupdate /fpu_tb/FPU1/Mult_s
add wave -noupdate /fpu_tb/FPU1/Div_s
add wave -noupdate /fpu_tb/FPU1/AddSub_enable
add wave -noupdate /fpu_tb/FPU1/Mult_enable
add wave -noupdate /fpu_tb/FPU1/Div_enable
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7582 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {3828 ps} {29272 ps}
