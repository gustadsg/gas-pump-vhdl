-- Automated Gas Pump Made by UFMG Students
-- 		-Daniel Benicá & Gustavo Gomes & Paulo Santos

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




entity gas_pump is 
	port(
		clock: in std_logic;
		btn_continue: in std_logic;
		fuel_type: in std_logic_vector(2 downto 0);
		credit_input: in std_logic_vector(7 downto 0);
		change: out std_logic_vector(7 downto 0) := x"00";
		pump: out std_logic := '0'
	);
end gas_pump;


architecture behaviour of gas_pump is
	
type states is (idle, payment, fuel_selection, fueling, comparator, give_change);
type fuel is array (0 to 2) of std_logic_vector(7 downto 0);
signal current_state : states := idle;	

	
	begin
		
		shrek : process(clock, btn_continue, fuel_type, credit_input, current_state)
		
				variable current_credit : std_logic_vector(7 downto 0); 	
				variable fuel_price : fuel;
				variable selected_fuel : std_logic_vector(7 downto 0);
				variable flow_rate : integer := 20;
				variable verification_period : time := 250 ms;
				
				begin	
				
					if(rising_edge(clock)) then 
						case current_state is 
							
							
							when idle => 
								fuel_price(0) := "00001010";
								fuel_price(1) := "00000101";
								fuel_price(2) := "00000100";
								change <= x"00";
								selected_fuel := x"00";
								pump <= '0';
								if (btn_continue = '1') then 
									current_state <= payment;
								end if;
								
								
							
							when payment =>
								current_credit := credit_input;
								if(btn_continue = '1') then	
									current_state <= fuel_selection;
								end if;
						
						
						
							when fuel_selection =>
								if(fuel_type = "00") then 
									selected_fuel := fuel_price(0);
									
								elsif(fuel_type = "01") then
									selected_fuel := fuel_price(1);
								
								elsif(fuel_type = "10") then 
									selected_fuel := fuel_price(2);
									
								end if;
								if(btn_continue = '1' and selected_fuel /= x"11") then 
									current_state <= fueling;
								end if;
								
								
								
							when fueling =>
								pump <= '1';
								wait for verification_period;
								current_state <= comparator;
							
							
							
							when comparator => 
								--current_credit := std_logic_vector(to_integer(unsigned(current_credit)) - ((flow_rate*to_integer(verification_period)*to_integer(unsigned(selected_fuel)))/1000);
								if(btn_continue = '1') then
									pump <= '0';
									current_state <= give_change;
									
								elsif(to_integer(unsigned(current_credit)) <= 0) then 
									pump <= '0';
									current_state <= idle;
									
								else
									current_state <= fueling;
									
								end if;
								
								
								
							when give_change =>
								change <= current_credit;
								current_state <= idle;
						end case;
					end if;
					

		end process shrek;
	end behaviour;
