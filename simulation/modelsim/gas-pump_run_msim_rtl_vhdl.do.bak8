transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/danie/OneDrive/Área de Trabalho/Lab de SD/gas-pump-vhdl/gas_pump.vhd}

vcom -93 -work work {C:/Users/danie/OneDrive/Área de Trabalho/Lab de SD/gas-pump-vhdl/tb_gas_pump.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneii -L rtl_work -L work -voptargs="+acc"  tb_gas_pump

add wave *
view structure
view signals
run 6000 ns
