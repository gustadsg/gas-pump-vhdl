-- Test bench file for gas-pump

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity tb_gas_pump is 
end tb_gas_pump;


architecture test_bench of tb_gas_pump is
component gas_pump is
	port(
		clock: in std_logic;
		btn_continue: in std_logic;
		fuel_type: in std_logic_vector(1 downto 0);
		payment_amount: in std_logic_vector(7 downto 0);
		credit_input: in std_logic_vector(7 downto 0);
		change: out std_logic_vector(7 downto 0) := x"00";
		pump: out std_logic := '0';
		total_consumption: out integer
	
	);
end component;


------------------------------------------------------------------------------------
----------------- Declaration of Input and Output variables
------------------------------------------------------------------------------------
signal clock: std_logic := '1';
signal btn_continue:  std_logic;
signal fuel_type:  std_logic_vector(1 downto 0);
signal credit_input:  std_logic_vector(7 downto 0);
signal change:  std_logic_vector(7 downto 0) := x"00";
signal aux_pump:  std_logic := '0';
signal payment_amount: std_logic_vector(7 downto 0);
signal total_consumption: integer;

constant max_value : natural := 3;
constant min_value : natural := 1;
constant period: time := 50 ns;
constant offset: time := 5 ns;

signal data_input : std_logic_vector(7 downto 0);
signal data_output : std_logic_vector(7 downto 0);

signal read_data_in : std_logic := '0';
signal flag_write : std_logic := '0';


file input_credit_input : text open read_mode is "credit_input.txt";
file input_payment_amount : text open read_mode is "payment_amount.txt";

file output_change: text open write_mode is "output_change.txt";

begin 
	instance_gas_pump : gas_pump port map (
		clock => clock,
		btn_continue => btn_continue,
		fuel_type => fuel_type ,
		credit_input => credit_input,
		change => change,
		pump => aux_pump,
		payment_amount => payment_amount,
		total_consumption => total_consumption
	
	);
	
------------------------------------------------------------------------------------
-----------------Process to read data from input_credit_input.txt file
------------------------------------------------------------------------------------
read_input_credit_input : process
						variable linha: line;
						variable input : std_logic_vector(7 downto 0);
						
					begin
						while not endfile(input_credit_input) loop
							if read_data_in = '1' then
								readline(input_credit_input,linha);
									read(linha,input);
									data_input <= input;
							end if;
							wait for period;
						end loop;
						wait;
					end process read_input_credit_input;


					
					
------------------------------------------------------------------------------------
----------------- Stimulus to read data from files 
------------------------------------------------------------------------------------
tb_stimulus: process
	begin
	wait for (period);
		read_data_in <='1';
					
					wait for period;
				
		read_data_in <= '0';
			wait;
		end process tb_stimulus;


		
------------------------------------------------------------------------------------
------ Stimulus to write data in files
----------------------------------------------------------------------------------

write_output: process(aux_pump, clock)
	begin
	for i in min_value to max_value loop
		if(falling_edge(aux_pump)) then 
		flag_write<= '1';
		end if;
		if(rising_edge(clock)) then 
		flag_write <= '0';
		end if;
		
				
			end loop;
		
		
	end process write_output;



-- ------------------------------------------------------------------------------------
-- ------ Process to write data in output_change.txt file
-- ------------------------------------------------------------------------------------  

write_output_change: process

		constant thank_you_text : string := "Muito obrigado por escolher o Posto do Gustavinho!";
		constant inserted_value_text : string := " Voce inseriu R$" ;
		constant change_value_text : string := "! Seu troco é de R$";
		constant consumption_text : string := ". O total abastecido, em litros, foi de: ";
		variable linha	: line;
		variable output	:	std_logic_vector(7 downto 0);
		variable change_value: integer;
		variable inserted_value: integer;
		
	begin
		while true loop
			if(flag_write = '1') then 
					output := data_output;
					change_value := to_integer(unsigned(output));
					inserted_value := to_integer(unsigned(credit_input));
					
					write(linha,thank_you_text,right,0);
					
					write(linha,inserted_value_text,right,0);
					write(linha,inserted_value,right,0);
					
					write(linha,change_value_text,right,0);
					write(linha,change_value,right,0);
					
					write(linha,consumption_text,right,0);
					write(linha,total_consumption,right,0);
					
					writeline(output_change,linha);
			end if;
			wait for period;
		end loop;
		wait;
	end process write_output_change;	
	
	
	
	
	
	
	clock <= NOT clock after 25 ns;
	btn_continue <= '1' after 30 ns,'0' after 35 ns,'1' after 1000 ns, '0' after 1005 ns,'1' after 2000 ns, '0' after 2005 ns,'1' after 3000 ns, '0' after 3005 ns,'1' after 4000 ns, '0' after 4005 ns;
	fuel_type <= "01" after 30 ns;
	credit_input <= data_input;
	payment_amount <= "00011110";
	data_output <= change;
end test_bench;