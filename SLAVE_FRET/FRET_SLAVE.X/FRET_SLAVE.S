;***************************************************************************
;
;	    Filename: FRET_SLAVE.S
;	    Date: 12/04/2025
;	    File Version: 1
;	    Author: Jason Permann
;	    Co-Author: Payden Hoskins
;	    Company: Idaho State University
;	    Description: A Program for a slave I2C device that can set one of
;				12 frets on a bass guitar
			    
;**************************************************************************
	
;*************************************************************************
; 
;	    Revision History:
;   
;	    Modified as listed
;	    Started 12/10/2025
;
;*************************************************************************
    
; PIC16F1788 Configuration Bit Settings

; Assembly source line config statements
	#include <xc.inc>
	#include "pic16f1788.inc"
	#include "88SetUp.inc"
	;#include "I2C_READ.inc"
	
; CONFIG1
  CONFIG  FOSC = INTOSC         ; Oscillator Selection (INTOSC oscillator: I/O function on CLKIN pin)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable (PWRT disabled)
  CONFIG  MCLRE = ON            ; MCLR Pin Function Select (MCLR/VPP pin function is MCLR)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Memory Code Protection (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown-out Reset Enable (Brown-out Reset disabled)
  CONFIG  CLKOUTEN = ON         ; Clock Out Enable (CLKOUT function is enabled on the CLKOUT pin)
  CONFIG  IESO = OFF            ; Internal/External Switchover (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable (Fail-Safe Clock Monitor is disabled)

; CONFIG2
  CONFIG  WRT = OFF             ; Flash Memory Self-Write Protection (Write protection off)
  CONFIG  VCAPEN = OFF          ; Voltage Regulator Capacitor Enable bit (Vcap functionality is disabled on RA6.)
  CONFIG  PLLEN = OFF           ; PLL Enable (4x PLL enabled)
  CONFIG  STVREN = OFF          ; Stack Overflow/Underflow Reset Enable (Stack Overflow or Underflow will not cause a Reset)
  CONFIG  BORV = HI             ; Brown-out Reset Voltage Selection (Brown-out Reset Voltage (Vbor), high trip point selected.)
  CONFIG  LPBOR = OFF           ; Low Power Brown-Out Reset Enable Bit (Low power brown-out is disabled)
  CONFIG  DEBUG = OFF           ; In-Circuit Debugger Mode (In-Circuit Debugger disabled, ICSPCLK and ICSPDAT are general purpose I/O pins)
  CONFIG  LVP = OFF             ; Low-Voltage Programming Enable (High-voltage on MCLR/VPP must be used for programming)

;Properties
;-Wl,-presetVect=0h,-pisrVect=04,-pnotes=08h,-pcode=F0h
  ;pnotes must be notes rather than note, as note created a compiling error
  ;pcode must be equal to 89h or higher, so the notes table has enough room in PCL
  
; Code Section
;-------------------------------------------------------------------------------
    
;Register/Variable Setup
BANK_SAVE EQU 0x020
W_SAVE EQU 0x021
DATA_BYTE EQU 0x070
DATA_RX_1 EQU 0x071
DATA_RX_2 EQU 0x072
DATA_RX_3 EQU 0x073
DATA_RX_4 EQU 0x074
DATA_RX_5 EQU 0x075
DATA_RX_6 EQU 0x076
EVIL_TEMP EQU 0x07D
;Start Of Program
    PSECT resetVect,class=CODE,delta=2	;Reset Vector Adress
    GOTO    SETUP
    
    PSECT isrVect,class=CODE,delta=2
    GOTO    INTERUPT_HANDLER
;Setup Code That Runs Once At Power Up/Reset
    PSECT notes,class=CODE,delta=2 
;<editor-fold defaultstate="collapsed" desc="Look Up Table">
NOTE_TABLE:
    ADDWF   PCL,1   ;ADD working register (NOTE) to program counter  
    GOTO    OFR	;0
    GOTO    OFR	;1
    GOTO    OFR	;2
    GOTO    OFR	;3
    GOTO    OFR	;4
    GOTO    OFR	;5
    GOTO    OFR	;6
    GOTO    OFR	;7
    GOTO    OFR	;8
    GOTO    OFR	;9
    GOTO    OFR	;10
    GOTO    OFR	;11
    GOTO    OFR	;12
    GOTO    OFR	;13
    GOTO    OFR	;14
    GOTO    OFR	;15
    GOTO    OFR	;16
    GOTO    OFR ;17
    GOTO    OFR	;18
    GOTO    OFR	;19
    GOTO    OFR	;20
    GOTO    OFR	;21
    GOTO    OFR	;22
    GOTO    OFR	;23
    GOTO    OFR	;24
    GOTO    OFR	;25
    GOTO    OFR	;26
    GOTO    OFR	;27
    GOTO    F0	;28
    GOTO    F1	;29
    GOTO    F2	;30
    GOTO    F3	;31
    GOTO    F4	;32
    GOTO    F5	;33
    GOTO    F6	;34
    GOTO    F7	;35
    GOTO    F8	;36
    GOTO    F9	;37
    GOTO    F10	;38
    GOTO    F11	;39
    GOTO    F12	;40
    GOTO    OFR	;41
    GOTO    OFR	;42
    GOTO    OFR	;43
    GOTO    F11	;44
    GOTO    F12	;45
    GOTO    OFR	;46
    GOTO    OFR	;47
    GOTO    OFR	;48
    GOTO    F11	;49
    GOTO    F12	;50   
    GOTO    OFR	;51
    GOTO    OFR	;52
    GOTO    OFR	;53
    GOTO    F11	;54
    GOTO    F12	;55
    GOTO    OFR	;56
    GOTO    OFR	;57
    GOTO    OFR	;58
    GOTO    OFR	;59
    GOTO    OFR	;60
    GOTO    OFR	;61
    GOTO    OFR	;62
    GOTO    OFR	;63
    GOTO    OFR	;64
    GOTO    OFR	;65
    GOTO    OFR	;66
    GOTO    OFR	;67
    GOTO    OFR ;68
    GOTO    OFR	;69
    GOTO    OFR	;70
    GOTO    OFR	;71
    GOTO    OFR	;72
    GOTO    OFR	;73
    GOTO    OFR	;74
    GOTO    OFR	;75
    GOTO    OFR	;76
    GOTO    OFR	;77
    GOTO    OFR	;78
    GOTO    OFR	;79
    GOTO    OFR	;80
    GOTO    OFR	;81
    GOTO    OFR	;82
    GOTO    OFR	;83
    GOTO    OFR	;84
    GOTO    OFR	;85
    GOTO    OFR	;86
    GOTO    OFR	;87
    GOTO    OFR	;88
    GOTO    OFR	;89
    GOTO    OFR	;90
    GOTO    OFR	;91
    GOTO    OFR	;92
    GOTO    OFR	;93
    GOTO    OFR	;94
    GOTO    OFR	;95
    GOTO    OFR	;96
    GOTO    OFR	;97
    GOTO    OFR	;98
    GOTO    OFR	;99
    GOTO    OFR	;100    
    GOTO    OFR	;101
    GOTO    OFR	;102
    GOTO    OFR	;103
    GOTO    OFR	;104
    GOTO    OFR	;105
    GOTO    OFR	;106
    GOTO    OFR	;107
    GOTO    OFR	;108
    GOTO    OFR	;109
    GOTO    OFR	;110
    GOTO    OFR	;111
    GOTO    OFR	;112
    GOTO    OFR	;113
    GOTO    OFR	;114
    GOTO    OFR	;115
    GOTO    OFR	;116
    GOTO    OFR ;117
    GOTO    OFR	;118
    GOTO    OFR	;119
    GOTO    OFR	;120
    GOTO    OFR	;121
    GOTO    OFR	;122
    GOTO    OFR	;123
    GOTO    OFR	;124
    GOTO    OFR	;125
    GOTO    OFR	;126
    GOTO    OFR	;127;</editor-fold>
; Setup Code That Runs Once At Power Up/Reset
    PSECT code,class=CODE,delta=2
;-------------------------------------------------------------------------------
;<editor-fold defaultstate="collapsed" desc="MAIN">
MAIN:
    BANKSEL	PORTC
    BTFSC	PORTC,2
    GOTO	RX_HANDLER  ;Subroutine for handling a I2C RX
    GOTO	MAIN;</editor-fold>
    
;<editor-fold defaultstate="collapsed" desc="INTERUPT HANDLER">
INTERUPT_HANDLER:
    CALL	I2C_READ
    RETFIE;</editor-fold>

    
;<editor-fold defaultstate="collapsed" desc="RX_HANDLER">
RX_HANDLER:    
    BANKSEL	PORTC
    BCF		PORTC,2
    
    BTFSC	DATA_RX_1,4 ;Check if upper nibble of command byte is a note on or off (8 or 9) 
    GOTO	GRAB_NOTE	;Subroutine for when command byte is note on
   
    GOTO	MAIN;</editor-fold>
    
;<editor-fold defaultstate="collapsed" desc="Use Note Data">
GRAB_NOTE:
    MOVF	DATA_RX_3,0	;Move Note value to W
    GOTO	NOTE_TABLE	;Look up table that for all available notes (0-127)
    ;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="Fret Handler">
F0:;no fret pressed
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F1:  
    BANKSEL	PORTB
    BCF		PORTB,0		    ;set Fret 1
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F2:
    BANKSEL	PORTC
    BCF		PORTC,7		    ;set Fret 2
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F3:
    BANKSEL	PORTC
    BCF		PORTC,6		    ;set Fret 3
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F4:
    BANKSEL	PORTC
    BCF		PORTC,5		    ;set Fret 4
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F5:
    BANKSEL	PORTB
    BCF		PORTB,4		    ;set Fret 5
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F6:
    BANKSEL	PORTB
    BCF		PORTB,3		    ;set Fret 6
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F7:
    BANKSEL	PORTB
    BCF		PORTB,2		    ;set Fret 7
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F8:
    BANKSEL	PORTB
    BCF		PORTB,1		    ;set Fret 8 
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F9:
    BANKSEL	PORTA
    BCF		PORTA,3		    ;set Fret 9
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F10:
    BANKSEL	PORTA
    BCF		PORTA,2		    ;set Fret 10
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F11:
    BANKSEL	PORTA
    BCF		PORTA,1		    ;set Fret 11
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
F12:
    BANKSEL	PORTA
    BCF		PORTA,0		    ;set Fret 12 	
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
OFR:;OUT OF RANGE (no fret pressed)
    CALL	WAIT_FOR_NOTE_OFF   ;Subroutine that waits for a note off command
    GOTO	MAIN		    ;All functions complete go back to main
    ;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="Wait for Note off command">
WAIT_FOR_NOTE_OFF:
    BANKSEL	PORTC
    BTFSC	PORTC,2
    GOTO	CHECK_NOTE_COMMAND  ;Subroutine for handling the 2nd I2C RX
    GOTO	WAIT_FOR_NOTE_OFF   ;loop continously until SSP1IF flag is set
    
CHECK_NOTE_COMMAND:
    BANKSEL	PORTC
    BCF		PORTC,2
    
    BTFSC	DATA_RX_1,4	    ;Check if upper nibble of command byte is a note on or off (8 or 9) 
    GOTO	CHECK_NOTE_COMMAND  ;loop continously until note off command recived
    GOTO	PORT_RESET;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="PORT RESET">
PORT_RESET:	;Set all Ports HIGH to reset any Fret that was energized
    BANKSEL	PORTA
    MOVLW	0xFF
    MOVWF	PORTA
 
    BANKSEL	PORTB
    MOVLW	0xFF
    MOVWF	PORTB
 
    BANKSEL	PORTC
    MOVLW	0xFB	;LEAVE OUT STATUS LED
    MOVWF	PORTC
 
    RETURN;</editor-fold>

;Subroutines Section
;-------------------------------------------------------------------------------
;<editor-fold defaultstate="collapsed" desc="Sub for all Setup routines">
SETUP:
    CALL    SETUP88		    ;Call is needed as the setup88 include file has a return at the end
    CALL    SET_INT		    ;Call is needed as the I2C interupt include file has a return at the end of the peripheral setup
    CALL    POWER_ON		    ;Set POWER ON LED
    GOTO    MAIN;</editor-fold>
    
;<editor-fold defaultstate="collapsed" desc="Power On">
POWER_ON:
    BANKSEL	PORTC
    BSF		PORTC,1	    ;Turn on Power LED
    RETURN;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="Set Status LED">
STATUS_LED:
    BANKSEL PORTC
    BSF	    PORTC,2	;Turn on STATUS LED
    RETURN;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="INTERUPT SETUP">
SET_INT:
    MOVLB 0x07		;Bank 7
    CLRF INLVLC		;Configures voltage level to trigger IOC, Port C
    
    ;----------------------------------------------------------
    MOVLB 0x06		;Bank 6
    CLRF SLRCONC	;Configures Slew Rate Limit, Port C
    
    ;----------------------------------------------------------
    MOVLB 0x05		;Bank 5
    MOVLW 0x18
    MOVWF ODCONC	;Configures Sink Source Current, Port C
    
    ;----------------------------------------------------------
    MOVLB 0x04		;Bank 4
    CLRF WPUC		;Configures Internal Pull-ups, Port C
    MOVLW 0x20
    MOVWF SSP1ADD	;Configures I2C address
    MOVLW 0X36
    MOVWF SSP1CON1	;Enable SDA SCL Pins, Clock, & Set as 7 bit address Slave
    MOVLW 0X81
    MOVWF SSP1CON2	;Enable General Call & Clock Strechting
    MOVLW 0X0B
    MOVWF SSP1CON3	;Disable Slave Interrupts, SDA Hold Time of 300nS, Auto Enable Address & Data Clock Stretching
    MOVLW 0X80
    MOVWF SSP1STAT	;Disable Slew Rate Control & flags
    MOVLW 0XFE
    MOVWF SSP1MSK	;Enable address matching
    CLRF APFCON1
    
    ;----------------------------------------------------------
    MOVLB 0x03		;Bank 3
    CLRF ANSELC		;Configures Analog Inputs, Port C
    
    ;----------------------------------------------------------
    MOVLB 0x02		;Bank 2
    
    ;----------------------------------------------------------
    MOVLB 0x01		;Bank 1
    MOVLW 0x18
    MOVWF TRISC		;Configures I 0, Port C
    MOVLW 0x80
    MOVWF OPTION_REG	;Settings for TMR0, INT edge, and Pullup control, All Ports
    BTFSC OSCSTAT, 6	;Is PLL ready?
    GOTO $-1		;No
    MOVLW 0X78		;Configures Oscillator, Internal, 16MHz
    MOVWF OSCCON
    BTFSC OSCSTAT, 5	;Is Osc ready?
    GOTO $-1		;No
    MOVLW 0x08
    MOVWF PIE1		;Enable I2C Interrupts
    
    ;----------------------------------------------------------
    MOVLB 0x00		;Bank 0
    MOVLW 0xF9
    MOVWF PORTC		;Clears port to ensure known state, Port C
    CLRF BANK_SAVE
    CLRF W_SAVE
    CLRF DATA_BYTE
    CLRF DATA_RX_1
    CLRF DATA_RX_2
    CLRF DATA_RX_3
    CLRF DATA_RX_4
    CLRF DATA_RX_5
    CLRF DATA_RX_6   
    RETURN;</editor-fold>

    
;<editor-fold defaultstate="collapsed" desc="Recive Code">
I2C_READ:
    MOVWF W_SAVE		
    MOVF BSR, 0		;Save Bank & W
    MOVWF BANK_SAVE
    BTFSC PIR1, 3	;Is I2C flag set?
    GOTO Recieve 	;Yes
Restore:
    MOVLB 0x00		;Bank 0
    BCF PIR1, 3		;Clear I2C flag
    MOVLB 0x04		;Bank 4
    BSF SSP1CON1, 4	;Hold clock Low
    MOVF BANK_SAVE, 0	
    MOVWF BSR		;Restore Bank & W
    MOVF W_SAVE, 0	
    RETURN		;Return to main code

Recieve:
    BSF PORTC, 2	;Status: Revieving
    MOVLB 0x04		;Bank 4
    MOVF SSP1BUF, 0	;Recieve I2C
    BTFSC SSP1STAT, 0	;Is it done?
    GOTO $-1		;No, wait
    BTFSS SSP1STAT, 5	;Is it address or data?
    GOTO Restore	;Address, Disregard
    MOVLB 0x00		;Bank 0
    MOVWF EVIL_TEMP	;Data, Save
    MOVLW 0x05		
    XORWF DATA_BYTE, 0	
    BTFSC STATUS, 2	;Is it byte 6?
    GOTO Byte6		;Yes
    MOVLW 0x04		
    XORWF DATA_BYTE, 0	
    BTFSC STATUS, 2	;Is it byte 5?
    GOTO Byte5		;Yes
    MOVLW 0x03		
    XORWF DATA_BYTE, 0	
    BTFSC STATUS, 2	;Is it byte 4?
    GOTO Byte4		;Yes
    MOVLW 0x02		
    XORWF DATA_BYTE, 0	
    BTFSC STATUS, 2	;Is it byte 3?
    GOTO Byte3		;Yes
    MOVLW 0x01		
    XORWF DATA_BYTE, 0	
    BTFSC STATUS, 2	;Is it byte 2?
    GOTO Byte2		;Yes
    MOVLW 0x00		
    XORWF DATA_BYTE	
    BTFSC STATUS, 2	;Is it byte 1?
    GOTO Byte1		;Yes
    GOTO Restore
    
Byte1:
    MOVF EVIL_TEMP, 0	;Move data to W
    MOVWF DATA_RX_1	;Save first Byte
    INCF DATA_BYTE, 1	;Increament for next byte
    GOTO Restore	;Return
    
Byte2:
    MOVF EVIL_TEMP, 0	;Move data to W
    MOVWF DATA_RX_2	;Save second Byte
    INCF DATA_BYTE, 1	;Increament for next byte
    GOTO Restore	;Return
    
Byte3:
    MOVF EVIL_TEMP, 0	;Move data to W
    MOVWF DATA_RX_3	;Save third Byte
    INCF DATA_BYTE, 1	;Reset
    GOTO Restore	;Return
    
Byte4:
    MOVF EVIL_TEMP, 0	;Move data to W
    MOVWF DATA_RX_4	;Save fourth Byte
    INCF DATA_BYTE, 1	;Reset
    GOTO Restore	;Return
    
Byte5:
    MOVF EVIL_TEMP, 0	;Move data to W
    MOVWF DATA_RX_5	;Save fith Byte
    INCF DATA_BYTE, 1	;Reset
    GOTO Restore	;Return
    
Byte6:
    MOVF EVIL_TEMP, 0	;Move data to W
    MOVWF DATA_RX_6	;Save sixth Byte
    CLRF DATA_BYTE	;Reset
    BANKSEL PORTC
    BSF	    PORTC,2	;Indicate full recive complete
    GOTO Restore	;Return;</editor-fold>

      
 END 