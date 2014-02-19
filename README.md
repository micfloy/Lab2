Lab2
====

This lab implements a basic version of the game pong.  The pong paddle is controlled using two push buttons.
The current functionality also allows the player to switch the speed of the ball between two settings.  A final addition was to make the ball bounce off of the paddle differently based on which half of the paddle it hit.  The majority of
the elements needed for this lab were taken from Lab 1.  The primary addition was the `pong_control` module.  This module contains all of the game logic.  A `button_module` was also created for this lab to allow the push buttons to be used without bouncing.

#Implementation

##Block Diagram

![alt text](https://raw.github.com/micfloy/Lab2/master/block_diagram.png)

`pong_control` had to be instantiated in the `atlys_lab_video` file from Lab1 and then the `button_module` was instatntiated inside of `pong_control`.  Until the addition of the control switch for the game speed, the architecture was purely moore.  Now it is a meally machine because the outputs rely directly on the game speed switch.

##State Diagram

![Wow! Such state](https://raw.github.com/micfloy/Lab2/master/state_diagram_lab2.png)

This is the state machine for the ball position.  The paddle's position was set using an output buffer and a somewhat complicated combinational logic statement. 

##`pong_control`

```VHDL
entity pong_control is
  port (
          clk         : in std_logic;
          reset       : in std_logic;
          up          : in std_logic;
          down        : in std_logic;
			 switch		 : in std_logic;
          v_completed : in std_logic;
          ball_x      : out unsigned(10 downto 0);
          ball_y      : out unsigned(10 downto 0);
          paddle_y    : out unsigned(10 downto 0)
  );
end pong_control;
```

This module was originally implemented as a pure moore machine.  The ball position is updated using a finite state machine. It has a total of 8 states.

```VHDL
type game_state is
	(idle, update, hit_top, hit_bot, hit_left, hit_right, hit_paddle_top, hit_paddle_bot);
```

Update is where all of the changes are made to the ball position based on the signals `x_dir` and `y_dir`.  Idle is simply used as the reset state.  All of the other states are self-explanatory.  As part of A functionality, the paddle_hit state was broken into the two shown above.  Now when the ball hits the top half of the paddle it will always travel up and to the right.  The bottom half of the paddle always makes the ball travel down and to the right.

The paddle movement itself was implemented using a state register and a combinational logic statement to assign the next state value.  To make the paddle respond to button presses, `button_module` was created, both to allow multiple buttons to be instantiated as easily as possible, as well as to debounce the button inputs.

Finally, a switch was also used to allow the speed of the ball to be changed between two settings at any time.  This addition makes `pong_control` a meally machine because the outputs are directly dependent on the inputs from the switch.

##`button_module`

```VHDL
entity button_module is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           button : in  STD_LOGIC;
           button_pulse : out  STD_LOGIC);
end button_module;
```

This module is very straight forward.  
	
It uses a three-state state machine to determine what state the button is and a shift register to debounce the button upon release.  As soon as the debounced signal is low, the button is considered to be released and button_pulse goes high momentarily.

##`pixel_gen`

Only minor changes were made to the basic architecture of `pixel_gen` from Lab 1.  Rather than displaying a test pattern it draws a pong paddle and a ball based on position inputs provided by the `pong_control`.  It also draws an Air Force logo on the background.  One of the lab requirements was that the ball needed to pass behind the logo.  This was acheived easily by putting all of the drawing in a process and drawing the logo last.  This way `pixel_gen` overrites the ball as it passes through the logo.

#Testing

There were multiple challenges in testing.  First of all, very little debugging was done with testbenches in this lab.  Because the lab was designed to be all visual, it was relatively easy to assess the effect of changes and bugs by observing the monitor output.

The biggest challenge for me was understanding what I would need for my ball state machine.  I started out by trying to implement it with only 4 states.  This did not work and I eventually incresed my states to 8 in order to simplify my code.  Throughout the lab as I would discuss problems with Captain Branchflower he would always make suggestions to modularize the code as much as possible in order to make it more easily understodd.  The more I was able to do this the better my design worked.

I also had a very difficult time implementing my paddle movement with the buttons.  It was incredibly difficult to pinpoint the source of my problem when my buttons would not move the paddle, because I had written all of the code for each button inside of `pong_control`.  When Captain Branchflower suggested I create the separate entity, `button_module` it greatly simplified my code.  After I had `button_module` working the rest of the bugs were mostly minor syntax problems.

A problem that plagued everyone throughout this lab, especially myself, was figuring out which signals to place in process sensitivity lists.  I believe I have a much better grasp of the concept now, but starting the lab I did not clearly understand what needed to be there.

#Conclusion

This lab was incredibly challenging.  I had several late nights and an all-nighter in the process of finishing it.  However, now that it is finished I do feel that I have a much better grasp of things I need to improve in terms of code discipline and a better idea of how to approach VHDL problems in the future.  I intend to work on better applying combination logic where it suits the problem and modularizing my code where I can.  I am definitely figuring out that VHDL is not about using the fewest number of lines possible.

I am pleased to say that I did succesfully complete the lab and this is a fully functioning, specification meeting, implementation of a game somewhat similar to the 1972 Pong by Atari Incorporated.  Hours(or minutes) of fun for one memeber of the family at a time.




