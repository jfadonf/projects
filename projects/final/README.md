# CUBE IN HOME -- a game using Lua with LÖVE2D
#### Video Demo: <https://youtu.be/udHF7yFpjMM>
#### Description

##### 1. A home made game
When I was a kid, I'am enthusiastic about video game. Now I have two 10 year old children, so I want to make a my own game for them. As a game for children, it must be:
	Intuitive
	Easy to control
	Some things they are familiar with
	Funny
These remind me my favorite FC game Contra. I decided to make a similar platform game, which
	The main characters will be the figures they made. 
	The levels will be the photos of our home. 
	The enemies will be the ordinary home objects.
	The character can move around, jump, shoot the enemies down.
As I enrolled CS50game course from EDX, the project Mario inspired me a lot. I use Mario's structure and some utility functions of it to build this game.
The main feature of Cube in home is that you can draw you own level very easily. 
1st, choose any photo or picture, open it with any drawing software, then draw the level you want.
the pure white lines or pixels will be indentified as platform. pure white means that rgb color is 255,255,255.
the pure green spot will become the goal spot. once you reach there, you go to next level.
the half green spot will become your initial position of the level.
and the pure red lines will become the forts that send out enemies.
With all these 4 colors, you can build up your levels.
pure green and red means in rgb color only green and red is 255, the other 2 are 0.
half green means the green is 128, the other 2 are 0.
at last, you save you level in jpg format and rename it as the 3 levels in the graphics folder. now, you can play it.

##### 2. what's in my code
###### 2.1 basic classes of game elements
In player class file, I have some variables to store player's states; a function updates player's position and trigger player to shoot bullets.
In cake class file, there are attribute variables and particle system, function to update cake position and to draw cakes.
In bullets class file, there are some attribute variables; calculate the x-axis and y-axis speed; a function can detect collision; a update function to update bullet's position within a range. Because I think that too much bullets might slow down the game. A function draw bullets at last.
In gameLevel class file, there are some attribute variables of the level; some tables which store the level contents. Then, a function to remove contents not in play, such as bullets, cakes(enemy). A update function will update all contents of level. A render function will draw all contents of level.
A levelmaker class is mainly a function that generates the level from the level image. As the background of level is some home room photo, I need to define all the platforms for the game. To simplify and to enable my children to draw their own level, I make this level generation process to transfer certain color pixels into platforms, some pixels into forts from where the cakes(enemies) go out, a spot where the player begins, a spot where the player go to next level.
###### 2.2 game state machines classes
1. Start state: the cover page of the game, there are background and game title. if you press enter it will switch to Statistic state.
2. Statistic state: in this state, lives, scores, level number will be displayed for 3 seconds. Then it will switch to Play state.
3. Play state: the main state of the game. 
	1. The first part is enter function that initiate the level. In this function: drop the player; set random seconds timers for each fort(coordinate). 
	2. The update function updates timers and positions of sprites, removes dead sprites, makes all forts spit out cakes(enemies) on their timers and updates each timer. Then it detects collision between player and cakes(enemies). If the collision occurs, switch player state to die. At last, it checks if the player reach the goal spot.
	3. Render function draw background, cakes(enemies), player, particles. As the level image is much larger than screen, a translation of cam is introduced. The cam will follow the player and restrain the player in the screen center zone. the lives are drew at the top left, the score and the highest score are drew at the top right. If you complete a level, a 'you win!' notice will be displayed in the center. If you caught by cakes, 'you die!' displayed.
	4. A function spawn cakes from forts.
4. End state: when player lost all 3 lives, the end page will be loaded. It displays the scores, the last level. If you break the highest score, a notice will flash.
###### 2.3 player state machines classes
1. Idle state: the player stands still, wait for commands.
2. Right state: the player goes to the right, check the pixels on the right side of the player, if there is a platform pixel, block the player from moving. But, if the 5 lowest pixels at the bottom of the line have platform, enable player to go right and lift the player a little. The animation of go right consists of 3 images, display in a loop of 1, 2, 1, 3. 
3. Left state: same process for the left side.
4. Jump state: give a upwards speed to jump, check the pixels above the player, if there is platform then stop rising, when the vertical speed is less than 0, switch player to falling state.
5. Falling state: check the pixels under the player, if there is a pixel of platform, stop falling, make the player idle. If the player fall out of the screen, the player dies.
6. Win state: if player reaches the goal, it will spin up to the sky. After 3 seconds, it turns to the statistic page then goes to next level.
7. die state: if player is caught by cakes(enemies) or falls out of screen, the player spins, goes up first then goes down. After 3 seconds, it goes to the statistic page then goes in the same level again, if no more lives, it goes to the end page.
###### 2.4 cake(enemy) state machines classes
1. Emerging state: the cake come appear from a dot to full size for 3 seconds, then switches to chasing state.
2. Chasing state: I set the cake chases player for 2 seconds then pauses for 2 seconds then repeat. if cakes are hit by bullets, then lose 1 point of HP, if HP is below 0, cakes die. They will be switched to dying state. When cakes are hit, there will be particles sprout. Only in chasing state, the collisions between player and cake are counted.
3. Dying state: the dying cake will flash several times then disappear.
###### 2.5 other codes
1. Animation class: make player sprite animation.
2. statemachine class: basic setting of state machine.
3. Util: a generate quad function; a function can calculate angle of a direction from A to B.
4. constants: basic game setting, control keys, etc.
5. Dependencies: general loader of libs, utility, state machines, classes, sounds, textures, frames, fonts.
6. main: starter of the game. set up title, screen, game state machine, change game to start state, record keyboard input.
###### 2.6 resource files
1. fonts
2. graphics
3. lib
4. sounds

##### 3. considerations
###### 3.1 tile system or pixel system
Tiles have many advantages like: make the game neat, consume less system resources, easy to check the collision and to make the sprite walking on the tiles. But the level making in tiles system will be heavily time consuming. A few levels won't interest my children for long time. To make more levels and to include them in building their own levels, I decided to set up a procedure to make a level.
	1. take a picture of home room
	2. ask my children to draw on it
	3. load the picture with drawing
	4. in statistic state, register the pixels in certain colors:
		1. pure white pixels identify as platform
		2. pure red pixels identify as forts of cake(enemy)
		3. pure green pixels identify as the goal spot
		4. half green pixels identify as the initial position of player
With this mechanism, kids can invent their own levels, test them and adjust them to have more fun.
###### 3.2 download sprite image sets or DIY it
There are many free resources online, you have many choices. You can find complete set of same style and WYSIWYG. DIY is complicated. But my children insisted on using their handmade figures as sprite. I couldn't say no. So I take several pictures around the little figure, remove the background, adjust the size, align 8 pictures in 1 file. After all, the result is good.
###### 3.3 make cakes rotate towards player
The cakes chase player in all direction. If they don't rotate, that looks dull. I tried atan function to calculate the angle. But a direction in 2 different phases can get a same tan. I had to set up a series of conditions to determine the angle. To be simple, I made a function in util, which take parameters of 2 coordinates, then return an angle. This function compacts the code and can be use else where.

#### Transcript
Your video should somehow include your project’s title, your name, your city and country, and any other details that you’d like to convey to viewers. 

Hello every body! This is Jiong FAN from Beijing, China. 
This game is Cube in home, a game I made it and hope my children and other kids will enjoy it.
It is a platform game. You can walk around, jump and shoot. Of cause, there are enemies will chase you, just like Contra in Nintendo FC console.
The main feature of Cube in home is that you can draw you own level very easily. 
1st, choose any photo or picture, open it with any drawing software, then draw the level you want.
the pure white lines or pixels will be indentified as platform. pure white means that rgb color is 255,255,255.
the pure green spot will become the goal spot. once you reach there, you go to next level.
the half green spot will become your initial position of the level.
and the pure red lines will become the forts that send out enemies.
With all these 4 colors, you can build up your levels.
pure green and red means in rgb color only green and red is 255, the other 2 are 0.
half green means the green is 128, the other 2 are 0.
at last, you save you level in jpg format and rename it as the 3 levels in the graphics folder. now, you can play it.
