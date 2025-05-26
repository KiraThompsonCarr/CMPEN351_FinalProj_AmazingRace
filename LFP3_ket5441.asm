# # # # # # # # # # # # # SETUP NOTES # # # # # # # # # # # # # # #
# BIT MAP DISPLAY:
# Unit Width/Height in Pixels: 16
# Display Width/Height in Pixels: 256
# Base address: heap
#
# KEYBOARD AND DISPLAY MMIO SIMULATOR
# Set up as usual; here you enter keys to steer the player
#
# TO PLAY:
# Navigate maze with (lowercase) wasd keys (in console, for now)
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
.data

	Instructions:	.asciiz		"\n\nWELCOME TO THE A-MAZE-ING RACE!\n\nTo get started, make sure to set up the bitmap display:\n* Unit width/height of 16 \n* Display width/height of 256 \nSet up the keyboard simulator as usual. There you will use w-a-s-d keys to steer your player.\n\nYou have 15 seconds to complete each maze. Beat all three to win the game!\n"
	
	RoundNumber:	.word	1	# initialize at first round
	# to make it match maze numbers, color 0 is white, color 1 is black, color 2 is gold
	ColorTable:
		.word	0x00ffffff	# 0, white (path color)
		.word	0x00000000	# 1, black (wall color)
		.word	0x00efbf04	# 2, gold (center/goal)			
		.word	0x0000ffff	# 3, cyan (player color)
		.word	0x00ff0000	# 4, red (player color -- invalid move)
		.word	0x00ff9a00	# 5, orange (player color -- < 10 seconds left)			

#----------------------------------------------------------------------------------------------------------------------------------
# # # # # # # # # # # # # # # # # # # # MAZE COORDINATES # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#----------------------------------------------------------------------------------------------------------------------------------
		
	# all mazes start in the bottom left corner (1,13) and finish in the middle (7,7)
	# 0 = path; 1 = wall; 2 = finish
	# since using more than two colors in the map, I couldn't (as far as I could figure out) use hex values here
	maze1: .word
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    		1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,
    		1,0,1,1,0,1,0,0,0,0,0,0,0,0,1,
		1,0,0,0,0,1,0,1,1,1,0,1,1,0,1,
		1,0,1,1,1,1,0,1,1,1,0,1,1,0,1,
    		1,0,0,0,0,0,0,0,1,1,0,1,1,0,1,
    		1,0,1,0,1,1,1,0,1,0,0,0,0,0,1,
    		1,0,1,0,1,0,1,0,1,0,1,1,1,0,1,
    		1,0,1,0,1,0,1,2,1,0,1,1,1,0,1,
    		1,0,1,0,1,0,1,1,1,0,1,1,1,0,1,
    		1,0,1,0,1,0,1,0,0,0,1,1,1,0,1,
    		1,0,1,1,1,0,1,0,1,1,1,1,1,0,1,
    		1,0,0,0,0,0,1,0,1,1,1,1,1,0,1,
    		1,0,1,1,1,1,1,0,1,1,1,1,1,1,1,
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		
    	maze2: .word
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    		1,1,1,1,1,0,0,0,0,0,0,0,1,0,1,
    		1,0,0,0,1,0,1,1,1,1,1,0,1,0,1,
    		1,0,1,0,0,0,1,0,0,0,1,0,1,0,1,
    		1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,
    		1,0,1,0,1,0,1,0,1,1,1,0,1,0,1,
    		1,0,1,0,1,0,1,0,0,0,0,0,1,0,1,
    		1,0,1,0,1,0,1,1,1,1,1,1,1,0,1,
    		1,0,1,0,1,0,1,2,0,0,0,0,0,0,1,
    		1,0,1,0,1,1,1,1,1,1,1,1,0,1,1,
    		1,0,1,0,1,1,1,1,0,0,0,1,0,1,1,
    		1,0,1,0,0,0,0,1,0,1,0,1,0,1,1,
    		1,0,1,0,1,1,0,1,1,1,0,1,0,1,1,
    		1,0,1,0,0,1,0,0,0,0,0,0,0,1,1,
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		
    	maze3: .word
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
    		1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,
    		1,0,1,1,1,0,1,0,1,1,1,1,1,0,1,
   		1,0,1,0,0,0,1,0,1,1,1,1,1,0,1,
   		1,0,1,1,1,1,1,0,1,0,0,0,0,0,1,
    		1,0,1,1,1,1,1,0,1,0,1,1,1,1,1,
    		1,0,1,0,0,0,0,0,1,0,1,1,1,1,1,
   		1,0,1,0,1,1,1,1,1,0,0,0,0,0,1,
    		1,0,1,0,1,0,1,2,1,1,1,1,1,0,1,
   		1,0,0,0,1,0,1,0,1,0,0,0,0,0,1,
    		1,0,1,1,1,0,1,0,1,0,1,1,1,0,1,
    		1,0,1,0,1,0,0,0,1,0,0,0,0,0,1,
    		1,0,1,0,1,0,1,1,1,1,1,1,1,0,1,
    		1,0,1,0,0,0,0,0,0,0,0,0,0,0,1,
   		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

#----------------------------------------------------------------------------------------------------------------------------------
# # # # # # # # # # # # # # # # # # # # LEVEL SCREENS # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#----------------------------------------------------------------------------------------------------------------------------------
	# For consistency with the maze screens, I didn't use hex values here, either.
	level1: .word
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
   		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,0,1,1,1,0,0,1,1,1,1,1
   		1,1,1,1,0,1,1,1,1,0,1,1,1,1,1
    		1,1,1,1,0,1,1,1,1,0,1,1,1,1,1
    		1,1,1,1,0,1,1,1,1,0,1,1,1,1,1
    		1,1,1,1,0,1,1,1,1,0,1,1,1,1,1
    		1,1,1,1,0,1,1,1,1,0,1,1,1,1,1
    		1,1,1,1,0,0,0,1,0,0,0,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

	level2: .word
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
   		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,0,1,1,1,0,0,0,1,1,1,1
    		1,1,1,1,0,1,1,1,1,1,0,1,1,1,1
    		1,1,1,1,0,1,1,1,1,1,0,1,1,1,1
    		1,1,1,1,0,1,1,1,0,0,0,1,1,1,1
    		1,1,1,1,0,1,1,1,0,1,1,1,1,1,1
    		1,1,1,1,0,1,1,1,0,1,1,1,1,1,1
    		1,1,1,1,0,0,0,1,0,0,0,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

	level3:.word
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
   		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,0,1,1,1,0,0,0,1,1,1,1
    		1,1,1,1,0,1,1,1,1,1,0,1,1,1,1
    		1,1,1,1,0,1,1,1,1,1,0,1,1,1,1
    		1,1,1,1,0,1,1,1,0,0,0,1,1,1,1
    		1,1,1,1,0,1,1,1,1,1,0,1,1,1,1
    		1,1,1,1,0,1,1,1,1,1,0,1,1,1,1
    		1,1,1,1,0,0,0,1,0,0,0,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    		
    	win: .word
    		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  
		1,1,0,1,0,1,0,0,0,1,0,1,0,1,1  
		1,1,0,1,0,1,0,1,0,1,0,1,0,1,1  
		1,1,0,0,0,1,0,1,0,1,0,1,0,1,1  
		1,1,1,0,1,1,0,1,0,1,0,1,0,1,1  
		1,1,1,0,1,1,0,0,0,1,0,0,0,1,1  
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  
		1,0,1,0,1,0,1,0,1,0,1,1,1,0,1  
		1,0,1,0,1,0,1,0,1,0,0,1,1,0,1  
		1,0,1,0,1,0,1,0,1,0,0,0,1,0,1  
		1,0,1,0,1,0,1,0,1,0,1,0,0,0,1  
		1,0,1,0,1,0,1,0,1,0,1,1,0,0,1  
		1,0,0,0,0,0,1,0,1,0,1,1,1,0,1  
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  

	lose: .word
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  
		1,1,0,1,0,1,0,0,0,1,0,1,0,1,1  
		1,1,0,1,0,1,0,1,0,1,0,1,0,1,1  
		1,1,0,0,0,1,0,1,0,1,0,1,0,1,1  
		1,1,1,0,1,1,0,1,0,1,0,1,0,1,1  
		1,1,1,0,1,1,0,0,0,1,0,0,0,1,1  
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  
		1,0,1,1,0,0,0,1,0,0,0,1,0,0,0  
		1,0,1,1,0,1,0,1,0,1,1,1,0,1,1  
		1,0,1,1,0,1,0,1,0,0,0,1,0,0,0  
		1,0,1,1,0,1,0,1,1,1,0,1,0,1,1  
		1,0,1,1,0,1,0,1,1,1,0,1,0,1,1  
		1,0,0,1,0,0,0,1,0,0,0,1,0,0,0  
		1,1,1,1,1,1,1,1,1,1,1,1,1,1,1  

.text

# Main: 
# Center calling point for the A-Maze-ing Race
# Test area to test/debug drawing things; comment out before submission
# Inputs: N/A
# Outputs: N/A
# Stack: $ra
#---------------------------------------------------------------------------------
MainGame:
	addi $sp, $sp, -8      	# Make room on the stack for 2 registers ($ra and $s0)
	sw $ra, 0($sp)          # Save $ra (return address) to stack
	sw $s7, 4($sp)		# save $s7 so we can use it
	
	#load heap address -- li $s7, 0x10040000
	lui $s7, 0x1004      # Load upper 16 bits
	ori $s7, $s7, 0x0000 # Load lower 16 bits (can be skipped if lower bits are all 0)
	
	
#----------------------------------------------------------------------------------------------------------------------------------
# # # # # # # # # # # # # # # # # # # # MAIN GAME CODE # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#----------------------------------------------------------------------------------------------------------------------------------

# Procedure: ShowInstructions
# Temporarily shows instructions to player before game commences
# Inputs: N/A
# Outputs: N/A
# Stack: N/A
#----------------------------------------------------
ShowInstructions:
	la $a0, Instructions	# get starting instructions to print in console
	li $v0, 4		# read string 
	syscall
	
# Procedure: StartGame
# Calls procedures to begin gameplay
# Inputs: N/A
# Outputs: N/A
# Stack: $ra
#----------------------------------------------------
StartGame:
	addiu $sp, $sp, -4	# room for 1 word on stack
	sw $ra, 0($sp) 		# store $ra
	
	jal InitRound 		# Takes care of initilizing new round
	li $a0, 1		# set initial x for position (1,13)
	li $a1, 13		# set initial y
	j GetInput		# takes care of input handling, cycling through gameplay
	
	lw $ra, 0($sp)		# restore $ra
	addiu $sp, $sp, 4	# clear stack
	jr $ra
	
# Procedure: InitRound
# Initializes round by resetting timer, clears screen, draws maze, and initializes player
# Inputs: N/A
# Outputs: N/A
# Stack: $ra
#-----------------------------------------------------
InitRound:
	addiu $sp, $sp, -4	# room for 1 word on stack
	sw $ra, 0($sp) 		# store $ra
	
	jal ClearScreen		# reset screen before drawing
	la $t0, RoundNumber	# get correct maze number
	lw $a3, 0($t0)		# store maze number in a3 input for drawmaze
	jal DrawLevelScreen	# shows "LX" to indicate level
	jal DrawMaze		
	jal InitTimer		# gets round start time and saves to $s6
	jal InitPlayer		# draw player in initial position
	
	lw $ra, 0($sp)		# restore $ra
	addiu $sp, $sp, 4	# clear stack
	j GetInput

# Procedure: InitTimer
# Resets timer at the beginnning of a round
# Inputs: N/A
# Outputs: N/A
# Stack: N/A
#-----------------------------------------------------
InitTimer:
	li  $v0, 30         # Syscall 30: get current system time in milliseconds
   	syscall
    	move $s6, $a0       # Save the current time into $s6 as the round start time
	jr $ra
	
# Procedure: GetInput
# Reads char input from user and forwards it to the correct next state
# Inputs: $a0 - x val
#	$a1 - y val
# Outputs: N/A
# Stack: $ra, $v0, $a0
#-----------------------------------------------------
GetInput:
	addiu $sp, $sp, -12	# room for 2 word on stack
	sw $ra, 0($sp) 		# store $ra
	sw $v0, 4($sp)		# store $v0
	sw $a0, 8($sp)		# store $a0 (might get modified)
	
_checkIfCenter:	# if they're at the center (where maze[x][y] == 2), they win the maze; move on
	# $a0 already has x val, $a1 already has y val
	la $t0, RoundNumber		# get address of round number
	lw $a3, 0($t0)			#$a3 - roundNumber/maze number
	jal GetMazeVal			# gives $v0 - value at index in current 
	bne $v0, 2, _checkTime		# if current value !=2, not at the center
	j IncRoundNumber		# if at the center, continue to next round
	
_checkTime:
	jal CheckTime			# returns how many seconds left
	bltz $v0, ShowExitMessage	# if lost round; show loser message
	
_waitForKey:		# else wait for user's input
	# polling with keyboard simulator
	lw $t0, 0xffff0000($0)	# polling ffff0000 until ready
	andi $t0, $t0, 0x1	# mask to check ready bit
	beqz $t0, _waitForKey	# keep waiting until key is ready
	lb $v0, 0xffff0004($0)	# load ascii code from data reg
	
	#doing char syscall for now
	#li $v0, 12	# get char from console
	#syscall		#stores result in $v0
	
_processKey:
	lw $a0 8($sp)		# restore $a0
	#$a1 should already be set by being passed into this function
	move $a2, $v0		#store as "direction" for validation	
	jal ValidateMove

	lw $v0, 4($sp)		# restore $v0
	lw $ra, 0($sp)		# restore $ra
	addiu $sp, $sp, 12	# clear stack
	jr $ra			# return

# Procedure: ValidateMove
# Confirms whether or not the users input is valid and calls appropriate
# Inputs: $a0 - x coordinate
#	$a1 - y coordinate
#	$a2 - direction char (W = up; A = left; S = down; D = right)
# Outputs: N/A
# Stack: $ra, $a0, $a1, $s0, $s1, $s2, $s3
#-----------------------------------------------------
ValidateMove:
	addiu $sp, $sp, -28	# room for lots of word on stack
	sw $ra, 0($sp) 		# store $ra
	sw $a0, 4($sp) 		# store $a0 (will be modified during execution)
	sw $a1, 8($sp) 		# store $a1 (will be modified during execution)
	sw $s0, 12($sp) 	# store $s0 
	sw $s1, 16($sp) 	# store $s1 
	sw $s2, 20($sp) 	# store $s2 
	sw $s3, 24($sp) 	# store $s3
	
	move $s0, $a0		# temp copy x
	move $s1, $a1		# temp copy y
	beq $a2, 'w', _caseW	# go to correct calc based on input
	beq $a2, 'a', _caseA
	beq $a2, 's', _caseS
	beq $a2, 'd', _caseD
	j _default		# if not WASD key, ignore
	
_caseW: # case W = up: find and check (x, y-1)
	addi $s1, $a1, -1	# dec temp y
	j _checkCoordinate
_caseA: # case A = left: find and check (x-1, y)
	addi $s0, $a0, -1	# dec temp x
	j _checkCoordinate
_caseS: # case S = down: find and check (x, y+1)
	addi $s1, $a1, 1	# inc temp y
	j _checkCoordinate
_caseD: # case D = right: find and check (x+1, y)
	addi $s0, $a0, 1	# inc temp x
	j _checkCoordinate

_checkCoordinate:
	move $s2, $a0			# save "old x" so we can input "new x"
	move $a0, $s0			# $a0 - (possibly modified) x val
	move $s3, $a1			# save "old y" so we can input "new y"
	move $a1, $s1			# $a1 - (possibly modified)  y val
	la $t5, RoundNumber		# get address of maze id/round number
	lw $a3, 0($t5)			# $a3 - maze id/round number
	jal GetMazeVal			# returns value at coordinate in $v0
	
	# prep values to pass into UpdatePlayerPos or FlashInvalidMove
	move $a2, $a0		# $a2 - new x
	move $a3, $a1		# $a3 - new y
	move $a0, $s2		# $a0 - old x (restore from earlier copy)
	move $a1, $s3		# $a1 - old y (restore from earlier copy)
	
	#reset stack before branching
	lw $ra, 0($sp)		# restore $ra
	lw $a0, 4($sp) 		# restore $a0 
	lw $a1, 8($sp) 		# restore $a1
	lw $s0, 12($sp) 	# store $s0 
	lw $s1, 16($sp) 	# store $s1 
	lw $s2, 20($sp) 	# store $s2 
	lw $s3, 24($sp) 	# store $s3 
	addiu $sp, $sp, 28	# clear stack
	
	beq $v0, 1, FlashInvalidMove	# if value is 1, move is invalid 
	j UpdatePlayerPos		# else value is 0 or 2, valid
	
_default:
	lw $ra, 0($sp)		# restore $ra
	lw $a0, 4($sp) 		# restore $a0 
	lw $a1, 8($sp) 		# restore $a1
	lw $s0, 12($sp) 	# store $s0 
	lw $s1, 16($sp) 	# store $s1 
	lw $s2, 20($sp) 	# store $s2 
	lw $s3, 24($sp) 	# store $s3 
	addiu $sp, $sp, 28	# clear stack
	j GetInput		# loop through getting next thing
	

# Procedure: GetLevelAddr
# Returns address of given maze
# Inputs: $a3 - roundNumber/maze number
# Outputs: $v0 - maze address
# Stack: N/A
#-----------------------------------------------------
GetLevelAddr:
	beq $a3, 1, _l1Addr	# if round 1
	beq $a3, 2, _l2Addr 	# if round 2
	beq $a3, 3, _l3Addr	# if round 3
_l1Addr:
	la $v0, level1	# then level 1
	j _retLevelAddr
_l2Addr:
	la $v0, level2	# then level 2
	j _retLevelAddr
_l3Addr:
	la $v0, level3	# then level 3
	j _retLevelAddr
_retLevelAddr:
    	jr $ra			# return

# Procedure: GetMazeAddr
# Returns address of given maze
# Inputs: $a3 - roundNumber/maze number
# Outputs: $v0 - maze address
# Stack: N/A
#-----------------------------------------------------
GetMazeAddr:
	beq $a3, 1, _m1Addr	# if round 1
	beq $a3, 2, _m2Addr 	# if round 2
	beq $a3, 3, _m3Addr	# if round 3
_m1Addr:
	la $v0, maze1	# then maze 1
	j _retAddr
_m2Addr:
	la $v0, maze2	# then maze 2
	j _retAddr
_m3Addr:
	la $v0, maze3	# then maze 3
	j _retAddr
_retAddr:
    	jr $ra			# return
			
# Procedure: GetMazeVal
# Finds and returns value at index x,y in a given maze
# Code here is repetitive. still trying to find better way to do it.
# Inputs: $a0 - x val
# 	$a1 - y val
#	$a3 - roundNumber/maze number
# Outputs: $v0 - value at index in current maze
# Stack: N/A
#-----------------------------------------------------
GetMazeVal:
	li $t1, 15	# load maze width
	
	beq $a3, 1, _m1Val	# if round 1
	beq $a3, 2, _m2Val	# if round 2
	beq $a3, 3, _m3Val	# if round 3
_m1Val:
	la $t0, maze1	# then maze 1
	j _findVal
_m2Val:
	la $t0, maze2	# then maze 2
	j _findVal
_m3Val:
	la $t0, maze3	# then maze 3
	j _findVal
	
_findVal:
	mul $t2, $a1, $t1	# temp = y * 15 = y * maze width
    	add $t2, $t2, $a0	# temp += x
    	sll $t2, $t2, 2		# temp *= 4 (because bytes)
    	add $t2, $t0, $t2	# maze base + temp
    	lw $v0, 0($t2)		# load value stored there
    	jr $ra			# return
    	
# Procedure: IncRoundNumber
# Increments round number to keep track of maze, etc.
# Inputs: N/A
# Outputs: N/A
# Stack: N/A
#-----------------------------------------------------
IncRoundNumber:
	lw $t0, RoundNumber		# load current round number
	addi $t0, $t0, 1		# increment it
	move $a3, $t0			# to pass into ShowExitMessage
	bgt $t0, 3, ShowExitMessage	# if round number >3, they won the game!
	sw $t0, RoundNumber		# else store it
	j InitRound			# and continue to next round		

# Procedure: UpdatePlayerPos
# Updates the player position if the move was valid
#Inputs: $a0 - x coordinate
#	$a1 - y coordinate
#	$a2 - new x coordinate
#	$a3 - new y coordinarte
# Outputs: N/A
# Stack: $ra, $s0, $s1
#-----------------------------------------------------
UpdatePlayerPos:
	addiu $sp, $sp, -12	# room for 3 word on stack
	sw $ra, 0($sp) 		# store $ra
	sw $s0, 4($sp) 		# store $s0
	sw $s1, 8($sp) 		# store $s1
	
	move $s0, $a2	# temp new x (avoid overwriting)
	move $s1, $a3	# temp new y
	
_eraseOld:	# erase (draw white square) "old" position, a0=x and a1=y values already set
	li $a2, 0	# a2 - color (white)
	jal DrawDot
_drawNew:	# draw player at new position
	move $a0, $s0	# a0 - new x coord
	move $a1, $s1	# a1 - new y coord
	# decide color
	jal CheckTime			# see how much time is left
	bgt $v0, 5000, _stillTime 	# if more than 5 seconds remaining, stay same color
	li $a2, 5			# else color = orange
	j _updatePos
_stillTime:
	li $a2, 3	# a2 - color (cyan)
_updatePos:
	jal DrawDot
	
	lw $ra, 0($sp) 		# restore $ra
	lw $s0, 4($sp)		# restore $s0
	lw $s1, 8($sp)		# restore $s1
	addiu $sp, $sp, 12	# clear stack
	j GetInput		# get next key

# Procedure: FlashInvalidMove
# Turns player red momentarily if attempted move is invalid
# Inputs: $a0 - x coordinate
#	$a1 - y coordinate
# Outputs: N/A 
# Stack: $ra, $a0, $a1
#-----------------------------------------------------
FlashInvalidMove:
	addiu $sp, $sp, -12	# room for lots of word on stack
	sw $ra, 0($sp) 		# store $ra
	sw $a0, 4($sp) 		# store $a0 (will be modified during execution)
	sw $a1, 8($sp)		# store $a1, may get modified
	
	#draw current position in red
	# $a0 alerady holds x, $a1 already holds y
	li $a2, 4	# a2 - color (red)	
	jal DrawDot
	
	#pause's $a0 requires wait time in ms
	li $a0, 200	# 200 ms flash
	jal Pause
	
	#redraw current position in cyan 
	lw $a0, 4($sp)	# restore $a0 after modification; $a0 = x
	lw $a1, 8($sp)	# restore $a1 after modification; $a1 = y
	
# decide color
	jal CheckTime			# see how much time is left
	bgt $v0, 5000, _stillTime2 	# if more than 5 seconds remaining, stay same color
	li $a2, 5			# else color = orange
	j _endFlash
_stillTime2:
	li $a2, 3	# a2 - color (cyan)
_endFlash:
	jal DrawDot
	
	lw $ra, 0($sp)		# restore $ra
	addiu $sp, $sp, 12	# clear stack
	j GetInput		# get next key

# Procedure: Pause
# Pauses long enough for player to see red flash for invalid move
# Inputs: $a0 - timeout (minimum pause time) in milliseconds
# Outputs: N/A
# Stack: N/A
#-----------------------------------------------------
Pause:
	move $t0, $a0	# $t0 holds timeout value
	li $v0, 30	# syscall 30 to get systime in $a0
	syscall
	move $t1, $a0	# $t1 holds saved initial time
_pauseLoop:	
	syscall				# still syscall 30 to get current time in $a0
	subu $t2, $a0, $t1		# #t2 = timeElapsed = newTime - initialTime
	bltu $t2, $t0, _pauseLoop	# loop again if timeElapsed < timeout
	jr $ra				#return

# Procedure: CheckTime
# checks current vs start time; see if round should be over
# Inputs: N/A
# Outputs: $v0 - amount of time that has passed
# Stack: $a0, $a1
#-----------------------------------------------------
CheckTime:
	addiu $sp, $sp, -8	# make room for one item on stack
	sw $a0, 0($sp)		# store $a0
	sw $a1, 4($sp)		# store $a1
	
	li $v0, 30		# gets current time
	syscall
	move $t6, $a0		# t6 = current time
	subu $t6, $t6, $s6   	# t6 = elapsed time= current time - start time
	li $t7, 15000		# 15 second limit
	sub $v0, $t7, $t6	# v0 = 15 sec - time ellapsed = remaining time
	
	lw $a0, 0($sp)		# restore $a0
	lw $a1, 4($sp)		# restore $a1
	addiu $sp, $sp, 8	# clear stack
	
	jr $ra				# else return
	
# Procedure: ShowExitMessage
# Displays exit message (i.e. win or lose message)
# Inputs: $a3 - roundNumber
# Outputs: N/A
# Stack: $ra, $s0, $s1, $s2
#-----------------------------------------------------
ShowExitMessage:
	addiu $sp, $sp, -16
	sw $ra, 0($sp)	# store $ra
	sw $s0, 4($sp)	# store $s0
	sw $s1, 8($sp)	# store $s1
	sw $s2, 12($sp)	# store $s2

	bgt $a3, 3, _winMsg # if $a3 > 3, win
   	la $s0, lose	#load lose address
   	j _drawMessage
_winMsg:
  	la $s0, win	# load win address
   	
_drawMessage:
   	#iterate through screen to draw it
   	li $s1, 0		# row index
_messageRowLoop:
   	li $s2, 0		# col index
	_messageColLoop:
		move $a0, $s2 			# x=col
		move $a1, $s1			# y=row
		lw $a2, 0($s0)			# color id
		jal DrawDot			# place pixel
		addiu $s0, $s0, 4		# inc screen pointer by 1 word
		addi $s2, $s2, 1		# inc col index
		blt $s2, 15, _messageColLoop	# loop through each column
	addi $s1, $s1, 1		# inc row index	
	blt $s1, 15, _messageRowLoop	#loop through each row
	
	lw $ra, 0($sp)	# restore $ra
	lw $s0, 4($sp)	# restore $s0
	lw $s1, 8($sp)	# restore $s1
	lw $s2, 12($sp)	# restore $s2
	addiu $sp, $sp, 16	# clear stack
	j EndGame

# Procedure: EndGame
# Ends game. Terminates program
# Inputs: N/A
# Outputs: N/A
# Stack: N/A
#-----------------------------------------------------
EndGame:
	li $v0, 10	# syscall 10 to exit
	syscall	
	
	
#----------------------------------------------------------------------------------------------------------------------------------
# # # # # # # # # # # # # # # # # # # # GRAPHICS CODE # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#----------------------------------------------------------------------------------------------------------------------------------
# Procedure: CalcAddress
# Converts x, y coordinates for screen into memory address
# Inputs: $a0 = x coordinate (0-255)
#	$a1 = y coordinate (0-255)
# Outputs: $v0 = memory address
# Stack: $s7,$a0,$a1
#-----------------------------------------------------
CalcAddress:
	addiu $sp, $sp, -12	# room for 3 word on stack
	sw $s7, 0($sp)		# store $s7 (preserve across call)
	sw $a0, 4($sp)		# store $a0 (preserve across call)
	sw $a1, 8($sp)		# store $a1 (preserve across call)
	
	move $t0, $s7		# $t0 = $s0 = base address = heap
	sll $t1, $a0, 2		# $t1 = x-coord * 4
	addu $t0, $t0, $t1	# t0 += $t1 (NEED to add unsigned or else address explosions)
	sll $t1, $a1, 6		# t1 = $a1*32*4 = $a1 * 128 = $a1 * 2^7
	add $t0, $t0, $t1	# t0 += $t1
	move $v0, $t0		# $v0 = baseAddr + ($a0*4) + ($a1*32*4)
	
	lw $s7, 0($sp)		# restore $s7
	lw $a0, 4($sp)		# restore $a0
	lw $a1, 8($sp)		# restore $a1
	addiu $sp, $sp, 12	# clear stack
	jr $ra			# return
	
# Procedure: GetColor
# Converts color ID to RBG value
# Inputs: $a2 = color id (0-7)
# Outputs: $v1 = RGB value to write to display
# Stack: $ra, $a2
#-----------------------------------------------------
GetColor:
	addiu $sp, $sp, -8	# room for 2 word on stack
	sw $ra, 0($sp)		# store $ra
	sw $a2, 4($sp)		# store $a2
		
	la $t0, ColorTable	# load color table base address
	sll $a2, $a2, 2		# colortable index = colorID * 4
	add $a2, $a2, $t0	# address = base + offset
	lw $v1, 0($a2)		# get RGB value at this address
	
	lw $a2, 4($sp)		# store $a2
	lw $ra, 0($sp)		# store $ra
	addiu $sp, $sp, 8	# pop from stack
	jr $ra			# return
	
# Procedure: DrawDot
# Takes coordinates and color, and draws dot on bitmap display
# Inputs: $a0 = x coordinate (0-255)
#	$a1 = y coordinate (0-255)
#	$a2 = color id (0-7)
# Outputs: N/A
# Stack: $ra, $a2, $v0
#-----------------------------------------------------	
DrawDot:
	addiu $sp, $sp, -12	# room for 3 words on stack
	sw $ra, 0($sp)		# store $ra
	sw $a2, 4($sp)		# store $a2 (preserve across call)

	jal CalcAddress		# returns pixel address in $v0
	sw $v0, 8($sp)		# store $v0 (preserve across call)
	
	jal GetColor		# returns color in $v1
	lw $v0, 8($sp)		# restore $v0 (pixel address)
	sw $v1, 0($v0)		# store $v1 (color) in $v0 (address) to make dot 
	
	lw $ra, 0($sp)		#restore $ra
	lw $a2, 4($sp)		# restore $a2
	addiu $sp, $sp, 12	# adjust $sp
	jr $ra			#return
	

# Procedure: HorzLine
# Draws a horizontal line to the display
# Inputs: $a0 = x coordinate (0-255)
#	$a1 = y coordinate (0-255)
#	$a2 = color id (0-7)
#	$a3 = length of line drawn (1-256)
# Outputs: N/A
# Stack: $ra, $a0, $a1, $a2
#-----------------------------------------------------	
HorzLine:
	# to be safe, store $a1-2 so not accidentally modifies in DrawDot
	addiu $sp, $sp, -16	# room for 4 words on stack
	sw $ra, 0($sp)		# store $ra
	sw $a1, 8($sp)		# store $a1 (preserve across call)
	sw $a2, 12($sp)		# store $a2 (preserve across call)
_horzLoop:
	#need to store $a0 (xcoord) inside the loop
	sw $a0, 4($sp)		# store $a0 (preserve across call)
	jal DrawDot
	# restore all $a regs
	lw $a0, 4($sp)		# restore $a0
	lw $a1, 8($sp)		# restore $a1
	lw $a2, 12($sp)		# restore $a2
	addi $a0, $a0, 1	# inc x-coord ($a0 +=1)
	subi $a3, $a3, 1	#dec length left to draw ($a3 -=1)
	bne $a3, $0, _horzLoop	# continue until full length drawn
	
	lw $ra, 0($sp)		# restore $ra
	addiu $sp, $sp, 16	# clear stack
	jr $ra			# return
		
# Procedure: DrawBox
# Draws a box to the display
# Inputs: $a0 = x coordinate (0-255)
#	$a1 = y coordinate (0-255)
#	$a2 = color id (0-7)
#	$a3 = size of box (1-256)
# Outputs: N/A
# Stack: $ra, $a0, $a1, $a2, $s0
#-----------------------------------------------------	
DrawBox:
	addiu $sp, $sp, -24	# room for 5 words on stack
	sw $ra, 0($sp)		# store $ra
	sw $a3, 16($sp)		# store $a3 (preserve across call)
	sw $s1, 20($sp)		# store $s1 (preserve across call)
	
	move $s1, $a3		# copy $a3 (box size) to counter reg, $s1
_boxLoop:
	sw $a0, 4($sp)		# store $a0 (preserve across call)
	sw $a1, 8($sp)		# store $a1 (preserve across call)
	sw $a2, 12($sp)		# store $a2 (preserve across call)
	
	jal HorzLine		# draw a line
	
	lw $a0, 4($sp)		# restore $a0
	lw $a1, 8($sp)		# restore $a1
	lw $a2, 12($sp)		# restore $a2
	lw $a3, 16($sp)		# retore $a3 (size) to pass into HorzLine
		
	addi $a1, $a1, 1	# inc y coord: $a1 +=1
	subi $s1, $s1, 1	# dec counter: $s1 -=1
	bne $s1, $0, _boxLoop	# repeat until correct size
	
	lw $ra, 0($sp)		# restore $ra
	lw $s1, 20($sp)		# restore $s1
	addiu $sp, $sp, 24	# clear stack
	jr $ra			# return


# Procedure: DrawLevelScreen
# Draws level number to the screen
# Inputs: $a3 - round number
# Outputs: N/A
# Stack: $ra, $s0, $s1, $s2
#-----------------------------------------------------
DrawLevelScreen:
	addiu $sp, $sp, -16
	sw $ra, 0($sp)	# store $ra
	sw $s0, 4($sp)	# store $s0
	sw $s1, 8($sp)	# store $s1
	sw $s2, 12($sp)	# store $s2

	#a3 should already hold the round number to pass into GetLevelAddr
	jal GetLevelAddr	# returns level address in $v0			
   	move $s0, $v0           # copy to $s0 for safety
   	
   	#iterate through screen to draw it
   	li $s1, 0		# row index
_levelRowLoop:
   	li $s2, 0		# col index
	_levelColLoop:
		move $a0, $s2 			# x=col
		move $a1, $s1			# y=row
		lw $a2, 0($s0)			# color id
		jal DrawDot			# place pixel
		addiu $s0, $s0, 4		# inc level screen pointer by 1 word
		addi $s2, $s2, 1		# inc col index
		blt $s2, 15, _levelColLoop	# loop through each column
	addi $s1, $s1, 1		# inc row index	
	blt $s1, 15, _levelRowLoop	#loop through each row
	
	# pause long enough to see it
	li $a0, 500	# 500 ms screen
	jal Pause
	
	lw $ra, 0($sp)	# restore $ra
	lw $s0, 4($sp)	# restore $s0
	lw $s1, 8($sp)	# restore $s1
	lw $s2, 12($sp)	# restore $s2
	addiu $sp, $sp, 16	# clear stack
	
# Procedure: DrawMaze
# Draws maze to the screen
# Inputs: $a3 - mazeID
# Outputs: N/A
# Stack: $ra, $s0, $s1, $s2
#-----------------------------------------------------
DrawMaze:
	addiu $sp, $sp, -16
	sw $ra, 0($sp)	# store $ra
	sw $s0, 4($sp)	# store $s0
	sw $s1, 8($sp)	# store $s1
	sw $s2, 12($sp)	# store $s2

	#a3 should already hold the round number to pass into GetMazeAddr
	jal GetMazeAddr		# returns maze address in $v0			
   	move $s0, $v0           # copy to $s0 for safety
   	
   	#iterate through maze to draw it
   	li $s1, 0		# row index
_mazeRowLoop:
   	li $s2, 0		# col index
	_mazeColLoop:
		move $a0, $s2 			# x=col
		move $a1, $s1			# y=row
		lw $a2, 0($s0)			# color id
		jal DrawDot			# place pixel
		addiu $s0, $s0, 4		# inc maze pointer by 1 word
		addi $s2, $s2, 1		# inc col index
		blt $s2, 15, _mazeColLoop	# loop through each column
	addi $s1, $s1, 1		# inc row index	
	blt $s1, 15, _mazeRowLoop	#loop through each row
	
	lw $ra, 0($sp)	# restore $ra
	lw $s0, 4($sp)	# restore $s0
	lw $s1, 8($sp)	# restore $s1
	lw $s2, 12($sp)	# restore $s2
	addiu $sp, $sp, 16	# clear stack
    	jr $ra


# Procedure: InitPlayer
# Draws player in initial position (1,13)
# Inputs: N/A
# Outputs: N/A
# Stack: $ra
#-----------------------------------------------------
InitPlayer:
	addiu $sp, $sp, -4	# make room for 1 word on stack
	sw $ra, 0($sp)		# store $ra
	
	li $a0, 1	# x-init = 1
	li $a1, 13	# y-init = 13
	li $a2, 3	# color = cyan
	jal DrawDot	# draw the player
	
	lw $ra, 0($sp)		# restore $ra
	addiu $sp, $sp, 4 	# clear stack
	jr $ra
	
# Procedure: ClearScreen
# Fills in screen in black
# Inputs: N/A
# Outputs: N/A
# Stack: $ra
#-----------------------------------------------------
ClearScreen:
	addiu $sp, $sp, -4	# make room for 1 word on stack
	sw $ra, 0($sp)		# store $ra
	
	li $a0, 0	# top left corner
	li $a1, 0
	li $a2, 1	# black
	li $a3, 16	# full screen
	jal DrawBox
	
		lw $ra, 0($sp)		# restore $ra
	addiu $sp, $sp, 4 	# clear stack
	jr $ra
