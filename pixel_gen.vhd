----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:29:56 01/29/2014 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
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

entity pixel_gen is
    port ( row      : in unsigned(10 downto 0);
           column   : in unsigned(10 downto 0);
           blank    : in std_logic;
			  switch_6  : in std_logic;
			  switch_7  : in std_logic;
           r        : out std_logic_vector(7 downto 0);
           g        : out std_logic_vector(7 downto 0);
           b        : out std_logic_vector(7 downto 0));
end pixel_gen;

architecture sel_arch of pixel_gen is

begin
	process(switch_6, switch_7, blank, column, row)
	begin
		r <= (others => '0');
		g <= (others => '0');
		b <= (others => '0');
		
		if (blank = '0') then
		
			if (switch_6 = '0') and (switch_7 = '0') then
			
				if ((column >= 195) and (column <= 265)) then
				
					if (row >= 120) and (row < 150) then
						b <= (others => '1');
					end if;
					
					if (row >= 210) and (row <= 240) then
						b <= (others => '1');
					end if;
					
				end if;
				
				if (((column >= 160) and (column < 195)) or ((column >= 265) and (column <= 300))) and ((row >= 120) and (row <= 360)) then
					b <= (others => '1');
				end if;
				
				if ((column >= 340) and (column <= 375)) and ((row >= 120) and (row <= 360)) then
					b <= (others => '1');
				end if;
				
				if ((row >= 120) and (row <= 150)) and ((column >= 340) and (column <= 480)) then
					b <= (others => '1');
				end if;
				
				if ((row >= 210) and (row <= 240)) and ((column >= 340) and (column <= 445)) then
					b <= (others => '1');
				end if;
				
							
			elsif(switch_6 = '1') and (switch_7 = '0') then
				if(column > 150) then
					r <= (others => '1');
				elsif(column >= 150) and (row < 200) then
					g <= (others => '1');
				elsif(column <= 150) and (row > 440) then
					b <= (others => '1');
				elsif(column >= 150) and (row >= 200) and (row <= 440) then
					g <= "10001000";
				end if;
					
			elsif(switch_6 = '0') and (switch_7 = '1') then
				if (column <=100) and (column >= 380) then
					r <= (others => '1');
				elsif(column >= 150) and (row < 200) then
					g <= (others => '1');
				elsif(column <= 150) and (row > 440) then
					b <= (others => '1');
				elsif(column >= 150) and (row >= 200) and (row <= 440) then
					g <= "11001100";
				end if;
			
			else
				if (column <=100) and (column >= 380) then
					g <= (others => '1');
				elsif(column >= 150) and (row < 200) then
					r <= (others => '1');
				elsif(column <= 150) and (row > 440) then
					b <= (others => '1');
				elsif(column >= 150) and (row >= 200) and (row <= 440) then
					g <= "00001000";
				end if;
				
			end if;
			
		end if;
		
	end process;

end sel_arch;