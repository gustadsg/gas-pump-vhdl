-- Test bench file for gas-pump

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_gas_pump is 
end tb_gas_pump;


architecture test_bench of tb_gas_pump is
component gas_pump is
	port(
		clock: in std_logic;
		btn_continue: in std_logic;
		fuel_type: in std_logic_vector(1 downto 0);
		credit_input: in std_logic_vector(7 downto 0);
		change: out std_logic_vector(7 downto 0) := x"00";
		pump: out std_logic := '0';
		credit_output: out std_logic_vector(7 downto 0)
	);
end component;



signal clock: std_logic;
signal btn_continue:  std_logic;
signal fuel_type:  std_logic_vector(1 downto 0);
signal credit_input:  std_logic_vector(7 downto 0);
signal change:  std_logic_vector(7 downto 0) := x"00";
signal pump:  std_logic := '0';
signal credit_output:  std_logic_vector(7 downto 0);


begin 
	instance_gas_pump : gas_pump port map (
		clock => clock,
		btn_continue => btn_continue,
		fuel_type => fuel_type ,
		credit_input => credit_input,
		change => change,
		pump => pump,
		credit_output => credit_output
	);
	
	clock <= not clock after 25 ns;
	btn_continue <= '1' after 30 ns,'0' after 35 ns,'1' after 1000 ns, '0' after 1005 ns,'1' after 2000 ns, '0' after 2005 ns,'1' after 3000 ns, '0' after 3005 ns,'1' after 4000 ns, '0' after 4005 ns,'1' after 5000 ns, '0' after 5005 ns;
	fuel_type <= "01" after 30 ns;
	credit_input <= "00100010" after 30 ns;
end test_bench;