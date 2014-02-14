----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:27:06 02/14/2014 
-- Design Name: 
-- Module Name:    button_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity button_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  v_completed : in STD_LOGIC;
           button : in  STD_LOGIC;
           button_pulse : out  STD_LOGIC);
end button_module;

architecture moore of button_module is

constant game_speed : integer := 500;

type button_state is
	(idle, button_pushed, button_released);
	
	signal button_reg, button_next : button_state;
	
	signal count_reg, count_next : unsigned(10 downto 0);
	
	signal pulse_reg, pulse_next : std_logic;


begin

	-- button state register
	process(clk,reset)
	begin
		if( reset = '1') then
			button_reg <= idle;
		elsif (rising_edge(clk)) then
			button_reg <= button_next;
		end if;
	end process;
	
		-- count register
	process(reset, clk)
	begin
		if (reset = '1') then
			count_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			count_reg <= count_next;
		end if;
	end process;
	
		count_next <= count_reg + 1 when (v_completed = '1') and (count_reg < to_unsigned(game_speed,11)) else
						(others => '0') when count_reg >= to_unsigned(game_speed,11) else
						count_reg;

	
	process (clk, reset)
	begin
		if(reset = '1') then
			pulse_reg <= '0';
		elsif(rising_edge(clk)) then
			pulse_reg <= pulse_next;
		end if;
	end process;	

	-- look-ahead button logic
	process(button_reg, button_next)
	begin
	
		pulse_next <= '0';
	
			case button_next is 
			
				when idle =>			
				when button_pushed =>
				when button_released =>
					pulse_next <= '1';
			end case;
		end process;

button_pulse <= pulse_reg;

end moore;

