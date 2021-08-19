-- Automated Gas Pump Made by UFMG Students
-- 		-Daniel Benicá & Gustavo Gomes & Paulo Santos

library ieee;
use ieee.std_logic_1164.all;




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
variable current_credit : std_logic_vector(7 downto 0); 	
variable fuel_price : fuel;
variable selected_fuel : std_logic_vector(7 downto 0);

fuel_price(0) := x"06";
fuel_price(1) := x"05";
fuel_price(2) := x"04";
	begin
		
		shrek : process(clock, btn_continue, fuel_type, credit_input, change, pump, current_state)
					
					if(rising_edge(clock)) then 
						case current_state is 
							
							
							when idle => 
								change <= x"00";
								selected_fuel := "11";
								pump <= '0'
								if (btn_continue) then 
									current_state <= payment;
								end if;
								
								
							
							when payment =>
								current_credit := credit_input;
								if(btn_continue) then	
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
								if(btn_continue) then 
									current_state <= fueling;
								end if;
		
		
					end if;
					

		end process shrek;
	end behaviour;
