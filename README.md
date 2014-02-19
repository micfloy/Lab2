Lab2
====

This lab implements a basic version of the game pong.  The pong paddle is controlled using two push buttons.
The current functionality also allows the player to switch the speed of the ball between two settings.  The majority of
the elements needed for this lab were taken from Lab 1.  The primary addition was the `pong_control` module.  This module
contains all of the game logic.  A `button_module` was also created for this lab to allow the push buttons to be used
without bouncing.

#Implementation

##Block Diagram

![alt text](https://raw.github.com/micfloy/Lab2/master/block_diagram.png)

`pong_control` had to be instantiated in the `atlys_lab_video` file from Lab1 and then the `button_module` was instatntiated inside of `pong_control`.  Until the addition of the control switch for the game speed, the architecture was purely moore.  Now it is a meally machine because the outputs rely directly on the game speed switch.

##State Diagram

![Wow! Such state](https://raw.github.com/micfloy/Lab2/master/state_diagram_lab2.png)

This is the state machine for the ball position.  The paddle's position was set using an output buffer and a somewhat complicated combinational logic statement. 

```VHD
	paddle_y_next <=  paddle_y_reg when game_over_reg = '1' else
			  	to_unsigned(0,11) when (paddle_y_reg < paddle_inc) and (up_pulse = '1') else
			  	(screen_h - to_unsigned(paddle_h,11)) when (paddle_y_reg > (screen_h - to_unsigned(paddle_h,11)
			  		- to_unsigned(paddle_inc,11))) and (down_pulse = '1') else
				 paddle_y_reg - paddle_inc when up_pulse = '1' else
			  	paddle_y_reg + paddle_inc when down_pulse = '1' else
			  	paddle_y_reg;
```



