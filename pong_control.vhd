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
constant game_speed : integer := 500;
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
	
	signal game_over, game_over_next, up_pulse, down_pulse : std_logic;
	
begin

	up_button : entity work.button_module(moore)
		port map(
			clk => clk,
			reset => reset,
			v_completed => v_completed,
			button => up,
			button_pulse => up_pulse
		);
		
		down_button : entity work.button_module(moore)
		port map(
			clk => clk,
			reset => reset,
			v_completed => v_completed,
			button => down,
			button_pulse => down_pulse
		);
	
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
		
	count_next <= count_reg + 1 when (v_completed = '1') and (count_reg < to_unsigned(game_speed,11)) else
						(others => '0') when count_reg >= to_unsigned(game_speed,11) else
						count_reg;
						
						
	-- next state logic						
	process(reset, clk, state_reg, count_reg, ball_x_reg, ball_y_reg, paddle_y_reg)
	begin	

			case state_reg is
			
				when idle =>
					state_next <= update;

				when update =>							
						if (ball_y_reg + ball_r) >= (screen_h - 1) then
							state_next <= hit_top;
						elsif (ball_y_reg <= 0) then
							state_next <= hit_bot;
						elsif (ball_x_reg <= 0) then
							state_next <= hit_left;
						elsif (ball_x_reg + ball_r) >= (screen_w - 1) then
							state_next <= hit_right;
						elsif ((ball_x_reg <= paddle_w + 5) and ((ball_y_reg <= paddle_y_reg + paddle_h) and (ball_y_reg >= paddle_y_reg))) then
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
			game_over <= '0';
			ball_x_reg <= to_unsigned(400,11);
			ball_y_reg <= to_unsigned(200,11);
			paddle_y_reg <= to_unsigned(200,11);
			x_dir_reg <= '1';
			y_dir_reg <= '1';
		elsif (rising_edge(clk)) then
			game_over <= game_over_next;
			ball_x_reg <= ball_x_next;
			ball_y_reg <= ball_y_next;
			paddle_y_reg <= paddle_y_next;
			x_dir_reg <= x_dir_next;
			y_dir_reg <= y_dir_next;
		end if;
	end process;		
					
		
	
	-- look-ahead output logic
	process(state_next, count_reg, ball_x_reg, ball_y_reg, x_dir_reg, y_dir_reg, paddle_y_reg, up_reg, down_reg, game_over)
	begin
		ball_x_next <= ball_x_reg;
		ball_y_next <= ball_y_reg;
		x_dir_next <= x_dir_reg;
		y_dir_next <= y_dir_reg;
		paddle_y_next <= paddle_y_reg;
		
		if (count_reg >= game_speed) then
		
			case state_next is
			
				when idle =>
				
				when update =>	

					--if (game_over = '0') then
					
						if (x_dir_reg = '1') then
							ball_x_next <= ball_x_reg + 1;
						elsif (x_dir_reg = '0') then
							ball_x_next <= ball_x_reg - to_unsigned(1,11);
						end if;
						
						if (y_dir_reg = '1') then
							ball_y_next <= ball_y_reg + 1;
						elsif (y_dir_reg = '0') then
							ball_y_next <= ball_y_reg - to_unsigned(1,11);
						end if;
						
						-- Bounds checking for paddle
						if paddle_y_reg < 5 then
							paddle_y_next <= to_unsigned(0,11);
						elsif paddle_y_reg > (screen_h - to_unsigned(paddle_h,11) - to_unsigned(5,11)) then
							paddle_y_next <= screen_h - to_unsigned(paddle_h,11);
						end if;
						
						if up_pulse = '1' and down_pulse = '0' and paddle_y_reg > 0 then
							paddle_y_next <= paddle_y_reg - to_unsigned(5,11);
						elsif down_pulse = '1' and up_pulse = '0' and (paddle_y_reg <= (screen_h - to_unsigned(paddle_h,11))) then
							paddle_y_next <= paddle_y_reg + to_unsigned(5,11);
						end if;	
						
			--	end if;
					
				when hit_top =>
					y_dir_next <= '0';
				when hit_bot =>
					y_dir_next <= '1';
				when hit_left =>
					game_over_next <= '1';
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

