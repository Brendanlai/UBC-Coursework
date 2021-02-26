$MODDE0CV

; To test the hours incrementing must set to 58 minutes. Doesn't work if you set to 59

org 0
zero equ 40H
one equ 79H

mov LEDRA, #0
mov LEDRB, #0

	ljmp mycode
	

DSEG at 30H
seconds: ds 1
minutes: ds 1
hours: ds 1
	
CSEG
	
lookUpTable:
	DB	0C0H, 0f9H, 0A4H, 0B0H, 099H	;0-4
	DB	092H, 082H, 0F8H, 080H, 090H	;5-9

	CLK EQU 33333333
	FREQ EQU 200
	TIMER0RELOAD EQU (65536-(CLK/(12*FREQ)))
		
	wait1s:
		;initilize timer
		mov a, TMOD
		anl a, #00001111B	;clear bits for timer 0, leave timer 1 unchanged
		orl a, #00010000B	;gate=0, C/T*=0, M1=0, M0=1: 16-bit timer
		mov TMOD, a
		clr TR1				;disable timer 0
		mov TH1, #high(TIMER0RELOAD)
		mov TL1, #low(TIMER0RELOAD)
		clr TF1				;clear timer flag
		setb TR1			;enable timer 0
	wait1s_L0:
		jnb TF1, wait1s_L0		;wait for overflow
		djnz R7, wait1s
		ret
	
mycode:
	mov SP, #7FH
;set initial time
	mov HEX0, #zero
	mov HEX1, #zero
	mov HEX2, #zero
	mov HEX3, #zero
	mov HEX4, #one
	mov HEX5, #zero
	
	mov seconds, #0	;seconds counter
	mov minutes, #0	;minutes counter
	mov hours, #1	;hours counter
	mov dptr, #lookUpTable
	

set_clock:
	mov a, #0				;check on switch
	mov a, SWA					;if on go to seconds(run clock)
	cjne a, #0, count_seconds
	jnb key.1, set_seconds		;check if any buttons pressed
	jnb key.2, set_minutes			;send to corresponding function
	jnb key.3, set_hours						
	sjmp set_clock

set_seconds:
	mov A, seconds
	anl A, #0FH
	movc A, @A+dptr
	mov HEX0, A
	mov A, seconds
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX1, A
	mov R7, #10
	lcall wait1s
	mov A, seconds
	add A, #1
	da A
	mov seconds, A
	cjne A, #060H, set_clock
	mov seconds, #0
	sjmp set_clock

set_minutes:
	mov A, minutes
	anl A, #0FH
	movc A, @A+dptr
	mov HEX2, A
	mov A, minutes
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX3, A
	mov R7, #10
	lcall wait1s
	mov A, minutes
	add A, #1
	da A
	mov minutes, A
	cjne A, #060H, set_clock
	mov minutes, #0
	sjmp set_clock
	
set_hours:
	mov A, hours
	anl A, #0FH
	movc A, @A+dptr
	mov HEX4, A
	mov A, hours
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX5, A
	mov R7, #10
	lcall wait1s
	mov A, hours
	add A, #1
	da A
	mov hours, A
	cjne A, #013H, set_clock
	mov hours, #1
	sjmp set_clock

count_seconds: 
	mov A, seconds
	anl A, #0FH
	movc A, @A+dptr
	mov HEX0, A
	mov A, seconds
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX1, A
	lcall wait1s
	mov A, seconds
	add A, #1
	da A
	mov seconds, A
	cjne A, #060H, reset_clock
	mov seconds, #0
	sjmp count_minutes
	
count_minutes:
	mov A, minutes
	cjne A, #060H, inc_minutes
	mov minutes, #0
	mov A, minutes
	anl A, #0FH
	movc A, @A+dptr
	mov HEX2, A
	mov A, minutes
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX3, A
	mov A, minutes
	add A, #1
	da A
	mov minutes, A
	sjmp count_hours

count_hours:
	mov A, hours
	anl A, #0FH
	movc A, @A+dptr
	mov HEX4, A
	mov A, hours
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX5, A
	mov A, hours
	add A, #1
	da A
	mov hours, A
	mov A, hours
	cjne A, #013H, reset_clock
	mov hours, #1
	sjmp reset_clock
	
inc_minutes:
	mov A, minutes
	anl A, #0FH
	movc A, @A+dptr
	mov HEX2, A
	mov A, minutes
	swap A
	anl A, #0FH
	movc A, @A+dptr
	mov HEX3, A
	mov A, minutes
	add A, #1
	da A
	mov minutes, A
	sjmp reset_clock
		
reset_clock:
	ljmp set_clock

end
