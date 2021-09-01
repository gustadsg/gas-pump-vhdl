if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -93 "gas_pump.vhd"
vcom -explicit  -93 "tb_gas_pump.vhd"
vsim -t 1ns   -lib work tb_gas_pump
add wave sim:/tb_gas_pump/*
#do {wave.do}
view wave
view structure
view signals
run 20000ns
#quit -force