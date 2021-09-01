-- Automated Gas Pump Made by UFMG Students
-- 		-Daniel Benicá & Gustavo Gomes & Paulo Santos

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




entity gas_pump is 
	port(
		clock: in std_logic;
		btn_continue: in std_logic;
		payment_amount: in std_logic_vector(7 downto 0);
		fuel_type: in std_logic_vector(1 downto 0);
		credit_input: in std_logic_vector(7 downto 0);
		change: out std_logic_vector(7 downto 0) := x"00";
		pump: out std_logic := '0';
		total_consumption: out integer := 0
	);
end gas_pump;


architecture behaviour of gas_pump is
	
type states is (idle, payment, payment_selection, fuel_selection, fueling, give_change);
type fuel is array (0 to 2) of std_logic_vector(7 downto 0);
signal current_state : states := idle;	
	
	begin
		
		main : process (clock, btn_continue, fuel_type, credit_input, current_state)
		
				variable user_credit : std_logic_vector(7 downto 0) := payment_amount; 	
				variable aux_current_credit : std_logic_vector(23 downto 0);
				variable fuel_price : fuel;
				variable selected_fuel : std_logic_vector(7 downto 0);
				variable flow_rate : integer := 100; -- 1l /ns for easier simulation
				variable verification_period : std_logic_vector(7 downto 0) := "11111010";
				variable fuel_amount : integer ;
				variable fuel_time: time ;
				variable tempo: time;
				begin	
				
					if(rising_edge(clock)) then 
						case current_state is 
							
							
							when idle => 
								fuel_price(0) := "00001010";
								fuel_price(1) := "00000101";
								fuel_price(2) := "00000100";
								selected_fuel := x"00";
								pump <= '0';
								if (btn_continue = '1') then 
									current_state <= payment;
								end if;
								
								
							
							when payment =>
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
									current_state <= payment_selection;
								else
									selected_fuel := fuel_price(0);
								end if;
								
							
							when payment_selection =>
								user_credit := payment_amount;
								-- user cant have more credit than the money he inserted
								if(user_credit > credit_input) then
									user_credit := credit_input;
								end if;
							
							
							
							
								fuel_amount := to_integer(unsigned(user_credit)/unsigned(selected_fuel));
								total_consumption <= fuel_amount; 
								fuel_amount := fuel_amount * 100000;
								report "O tanto de combusta meu fi: "& integer'image(fuel_amount);
								report "SALVE SALVE FAMILIA: "& integer'image(flow_rate);
								fuel_time := (fuel_amount/flow_rate)*1 ns;
								
								report "TEMPOOOOOOOO: "& time'image(fuel_time);
								
								if(btn_continue = '1') then	
									current_state <= fueling;
								end if;
								
							when fueling =>
								pump <= '1';
								current_state <= give_change after fuel_time;
								
								
								
							when give_change =>
								change <= std_logic_vector(unsigned(credit_input) - unsigned(user_credit));
								current_state <= idle after 75 ns ;
						end case;
					end if;
					

		end process main;
			
	end behaviour;
