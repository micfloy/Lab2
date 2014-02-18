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
           button : in  STD_LOGIC;
           button_pulse : out  STD_LOGIC);
end button_module;

architecture moore of button_module is

	constant game_speed : integer := 500;

	type button_state is
	(idle, button_pushed, button_held);
	
	signal button_reg, button_next : button_state;
	
	signal count : unsigned(10 downto 0);
	
	signal pulse_reg, pulse_next, button_old, button_new, button_debounced : std_logic;

begin
	-- count register
--	process(reset, clk)
--	begin
--		if (reset = '1') then
--			count_reg <= (others => '0');
--		elsif (rising_edge(clk)) then
--			count_reg <= count_next;
--		end if;
--	end process;
--	
--	count_next <= 	(others => '0') when count_reg >= to_unsigned(game_speed,11) else
--						count_reg + 1;



	-- shift register
	process(clk,reset,button)
	begin
		if( reset = '1') then
			button_old <= '0';
		elsif(rising_edge(clk)) then
			button_old <= button;
		end if;
	end process;
	
	process(clk,reset,button_old)
	begin
		
		if( reset = '1') then
			button_debounced <= '0';
			count <= (others => '0');
			button_new <= '0';			
		elsif( rising_edge(clk)) then
			if(button_new = button_old) then
				count <= count + 1;
			else
				button_new <= button_old;
				count <= (others => '0');
				button_debounced <= '0';
			end if;
			
			if( count >= 1000 ) then
				button_debounced <= '1';
				count <= '0';
			end if;
		end if;
		
	end process;




	-- button state register
	process(clk,reset)
	begin
		if( reset = '1') then
			button_reg <= idle;
		elsif (rising_edge(clk)) then
			button_reg <= button_next;
		end if;
	end process;
	
	process (button_reg, button)
	begin
		button_next <= button_reg;
		
		case button_reg is
			when  idle =>
				if(button = '1') then
					button_next <= button_pushed;
				end if;
			when button_pushed =>
				button_next <= button_held;
			when button_held =>
				if(button = '0') then
					button_next <= idle;
				end if;
		end case;
					
	end process;
	
	process (clk, reset)
	begin
		if(reset = '1') then
			pulse_reg <= '0';
		elsif(rising_edge(clk)) then
			pulse_reg <= pulse_next;
		end if;
	end process;	
	
	pulse_next <= 	'1' when button_next = button_pushed else
						'0';

	button_pulse <= pulse_reg;

end moore;

