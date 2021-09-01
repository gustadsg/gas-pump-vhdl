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
signal data_input_payment: std_logic_vector(7 downto 0);
signal data_input_fuel: std_logic_vector(1 downto 0);
signal data_output : std_logic_vector(7 downto 0);

signal read_data_in : std_logic := '0';
signal flag_write : std_logic := '0';


file input_credit_input : text open read_mode is "credit_input.txt";
file input_payment_amount : text open read_mode is "payment_amount.txt";
file input_fuel_selection : text open read_mode is "fuel_selection.txt";

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
-----------------Process to read data from payment_amount.txt file
------------------------------------------------------------------------------------
read_input_payment_amount : process
						variable linha: line;
						variable input : std_logic_vector(7 downto 0);
						
					begin
						while not endfile(input_payment_amount) loop
							if read_data_in = '1' then
								readline(input_payment_amount,linha);
									read(linha,input);
									data_input_payment <= input;
							end if;
							wait for period;
						end loop;
						wait;
					end process read_input_payment_amount;



------------------------------------------------------------------------------------
-----------------Process to read data from fuel_selection.txt file
------------------------------------------------------------------------------------
read_input_fuel_selection : process
						variable linha: line;
						variable input : std_logic_vector(1 downto 0);
						
					begin
						while not endfile(input_fuel_selection) loop
							if read_data_in = '1' then
								readline(input_fuel_selection,linha);
									read(linha,input);
									data_input_fuel <= input;
							end if;
							wait for period;
						end loop;
						wait;
					end process read_input_fuel_selection;
					
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
		constant inserted_value_text : string := " Voce inseriu R$ " ;
		constant payment_amount_text : string := ". Voce tentou gastar R$ ";
		constant change_value_text : string := "! Seu troco é de R$";
		constant fuel_type_text : string := ". O combustível selecionado foi: ";
		constant consumption_text : string := ". O total abastecido, em litros, foi de: ";
		variable fuel_type_value : string(1 to 9) := "undefined";
		variable linha	: line;
		variable output	:	std_logic_vector(7 downto 0);
		variable change_value: integer;
		variable inserted_value: integer;
		variable payment_value: integer;
		
	begin
		while true loop
			if(flag_write = '1') then 
					output := data_output;
					change_value := to_integer(unsigned(output));
					inserted_value := to_integer(unsigned(credit_input));
					payment_value := to_integer(unsigned(payment_amount));
					
					write(linha,thank_you_text,right,0);
					
					write(linha,inserted_value_text,right,0);
					write(linha,inserted_value,right,0);
					
					write(linha,payment_amount_text,right,0);
					write(linha,payment_value,right,0);
					
					write(linha,change_value_text,right,0);
					write(linha,change_value,right,0);
					
					if(fuel_type = "00") then
						report("GASOLINA");
						fuel_type_value := " gasolina";
					elsif (fuel_type = "01") then
						report("ALCOOL");
						fuel_type_value := "   alcool";
					elsif (fuel_type = "10") then
						report("DIESEL");
						fuel_type_value := "   diesel";
					else 
						fuel_type_value := "undefined";
					end if;
					
					
					write(linha,fuel_type_text,right,0);
					write(linha,fuel_type_value,right,0);
					
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
	credit_input <= data_input;
	data_output <= change;
	payment_amount <= data_input_payment;
	fuel_type <= data_input_fuel;
end test_bench;