----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:31:07 02/13/2014 
-- Design Name: 
-- Module Name:    pong_control - Behavioral 
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

entity pong_control is
  port (
          clk         : in std_logic;
          reset       : in std_logic;
          up          : in std_logic;
          down        : in std_logic;
          v_completed : in std_logic;
          ball_x      : out unsigned(10 downto 0);
          ball_y      : out unsigned(10 downto 0);
          paddle_y    : out unsigned(10 downto 0)
  );
end pong_control;

architecture moore of pong_control is

-- Constants
constant speed_x    : integer := 3;
constant speed_y    : integer := 3;
constant	ball_r     : integer := 5;
constant	screen_h   : integer := 480;
constant	screen_w   : integer := 640;
constant	paddle_w	  : integer := 10;
constant	paddle_h   : integer := 60;
	
type game_state is
	(idle, update, hit_top, hit_bot, hit_left, hit_right, hit_paddle);
	
	signal state_reg, state_next : game_state;
	
	signal ball_x_reg, ball_y_reg, paddle_y_reg, ball_x_next, ball_y_next, paddle_y_next : unsigned(10 downto 0);
	
	signal x_dir_reg, y_dir_reg, x_dir_next, y_dir_next : std_logic;

	signal count_reg, count_next : unsigned(10 downto 0);
	
begin
	
	-- state register
	process(clk,reset)
	begin
 		if (reset='1') then
			state_reg <= idle;
		elsif (rising_edge(clk)) then
			state_reg <= state_next;
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
		
	count_next <= (others => '0') when (v_completed = '1') and (count_reg > 1000) else
						count_reg + 1 when (v_completed = '1') else
						count_reg;
	
--	ball_x_next <= ball_x_reg + 2 when (count_reg = 1000) and (x_dir_reg = '1') else
--					   ball_x_reg - 2 when (count_reg = 1000) and (x_dir_reg = '0') else
--					   ball_x_reg;
--
--	ball_y_next <= ball_y_reg + 2 when (count_reg = 1000) and (y_dir_reg = '1') else
--					   ball_y_reg - 2 when (count_reg = 1000) and (y_dir_reg = '0') else
--					   ball_y_reg;
						
	paddle_y_next <= paddle_y_reg;
						
	-- next state logic						
	process(reset, clk, state_reg, count_reg, ball_x_reg, ball_y_reg, paddle_y_reg)
	begin	
			
		case state_reg is
			when idle =>

					state_next <= update;

			when update =>
							
					if (ball_y_reg >= screen_h) then
						state_next <= hit_top;
					elsif (ball_y_reg <= 0) then
						state_next <= hit_bot;
					elsif (ball_x_reg <= 0) then
						state_next <= hit_left;
					elsif (ball_x_reg >= screen_w) then
						state_next <= hit_right;
					elsif ((ball_x_reg <= paddle_w + 5) and ((ball_y_reg <= paddle_y_reg + paddle_h) or (ball_y_reg >= paddle_y_reg))) then
						state_next <= hit_paddle;
					else 
						state_next <= idle;
					end if;
			when hit_top =>
				state_next <= update;
			when hit_bot =>
				state_next <= update;
			when hit_left =>
				state_next <= update;
			when hit_right =>
				state_next <= update;
			when hit_paddle =>
				state_next <= update;
				
		end case;			
	
	end process;
	
	process(reset, clk)
	begin
		if(reset = '1') then
			ball_x_reg <= to_unsigned(400,11);
			ball_y_reg <= to_unsigned(200,11);
			paddle_y_reg <= to_unsigned(200,11);
			x_dir_reg <= '1';
			y_dir_reg <= '1';
		elsif (rising_edge(clk)) then
			ball_x_reg <= ball_x_next;
			ball_y_reg <= ball_y_next;
			paddle_y_reg <= paddle_y_next;
			x_dir_reg <= x_dir_next;
			y_dir_reg <= y_dir_next;
		end if;
	end process;
	
	-- look-ahead output logic
	process(state_next, count_reg, ball_x_reg, ball_y_reg, x_dir_reg, y_dir_reg)
	begin
		ball_x_next <= ball_x_reg;
		ball_y_next <= ball_y_reg;
		x_dir_next <= x_dir_reg;
		y_dir_next <= y_dir_reg;
		
		if (count_reg >= 1000) then
		
			case state_next is
				
				when idle =>
				
				when update =>					
					if (x_dir_reg = '1') then
						ball_x_next <= ball_x_reg + speed_x;
					elsif (x_dir_reg = '0') then
						ball_x_next <= ball_x_reg - to_unsigned(speed_x,11);
					end if;
					
					if (y_dir_reg = '1') then
						ball_y_next <= ball_y_reg + speed_y;
					elsif (y_dir_reg = '0') then
						ball_y_next <= ball_y_reg - to_unsigned(speed_y, 11);
					end if;
				when hit_top =>
					y_dir_next <= '0';
				when hit_bot =>
					y_dir_next <= '1';
				when hit_left =>
					x_dir_next <= '1';
				when hit_right =>
					x_dir_next <= '0';
				when hit_paddle =>
					x_dir_next <= '1';
					
			end case;
		end if;
	end process;
		
	
	
	ball_x <= ball_x_reg;
	ball_y <= ball_y_reg;
	paddle_y <= paddle_y_reg;


end moore;

