;***************************************************************************
;
;	    Filename: Eslave.ASM
;	    Date: 11/05/2024
;	    File Version: 2
;	    Author: Owen Fujii
;	    Co-Author: Justin Bell
;	    Company: Idaho State University
;	    Description: A Program for a slave I2C device that plays notes on the
;			    E string of a Bass guitar
;**************************************************************************
	
;*************************************************************************
; 
;	    Revision History:
;   
;	    Modified as listed
;	    Started 11/05/2024
;
;*************************************************************************
    
; PIC16F1788 Configuration Bit Settings

; Assembly source line config statements
	#include <xc.inc>
	#include "pic16f1788.inc"
	#include "88SetUp.inc"
	#include "I2C_READ.inc"
	
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
 W_SAVE	    EQU   0x74
 STAT_SAVE  EQU   0x75
;Start Of Program
    PSECT resetVect,class=CODE,delta=2	;Reset Vector Adress
    GOTO  SETUP
    PSECT isrVect,class=CODE,delta=2
    ;GOTO INTERUPT_HANDLER
;Setup Code That Runs Once At Power Up/Reset
    PSECT notes,class=CODE,delta=2 
;<editor-fold defaultstate="collapsed" desc="Look Up Table">
NOTE_TABLE:
    ADDWF   PCL,1   ;ADD working register to program counter  
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
;<editor-fold defaultstate="collapsed" desc="MAIN">
MAIN:
    BANKSEL	PORTC
    BCF		PORTC,2
    BANKSEL PIR1
    BTFSC   PIR1,3
    ;CALL    I2C_READ
    GOTO    RX_HANDLER
    GOTO	MAIN;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="Power On">
POWER_ON:
    BANKSEL	PORTC
    BSF		PORTC,1
    BANKSEL	DATA_BYTE
    CLRF	DATA_BYTE
    RETURN;</editor-fold>
    
    
;<editor-fold defaultstate="collapsed" desc="Note on/off decide">
RX_HANDLER:
    BANKSEL DATA_BYTE
    CLRF    DATA_BYTE
    
    CALL    I2C_READ
    
    BTFSC   DATA_RX_1,4 ;Check if upper nibble of command byte is a note on or off (8 or 9) 
    GOTO    GRAB_NOTE
   
    GOTO    MAIN;</editor-fold>
GRAB_NOTE:
    MOVF    DATA_RX_2,0	;Move note value to w
    GOTO    NOTE_TABLE
    
    STATUS_LED:
    BANKSEL	PORTC
    BSF		PORTC,2
    RETURN

;<editor-fold defaultstate="collapsed" desc="Fret Handler">
F0:	;no fret pressed

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F1:
    
    BANKSEL PORTB
    BCF	PORTB,0 ;set Fret 1

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F2:
    BANKSEL PORTC
    BCF	PORTC,7 ;set Fret 2

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F3:
    BANKSEL PORTC
    BCF	PORTC,6 ;set Fret 3

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F4:
    BANKSEL PORTC
    BCF	PORTC,5 ;set Fret 4

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F5:
    BANKSEL PORTB
    BCF	PORTB,4 ;set Fret 5

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F6:
    BANKSEL PORTB
    BCF	PORTB,3 ;set Fret 6

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F7:
    BANKSEL PORTB
    BCF	PORTB,2 ;set Fret 7

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F8:
    BANKSEL PORTB
    BCF	PORTB,1 ;set Fret 8 

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F9:
    BANKSEL PORTA
    BCF	PORTA,3 ;set Fret 9

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F10:
    BANKSEL PORTA
    BCF	PORTA,2 ;set Fret 10

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F11:
    BANKSEL PORTA
    BCF	PORTA,1 ;set Fret 11

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
F12:
    BANKSEL PORTA
    BCF	PORTA,0 ;set Fret 12 	

    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
OFR:	;OUT OF RANGE
    
    CALL	WAIT_FOR_NOTE_OFF
    GOTO	MAIN
    ;GOTO	INTERUPT_END;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="Wait for note off">
WAIT_FOR_NOTE_OFF:
    BANKSEL PIR1
    BTFSC   PIR1,3
    GOTO    CHECK_NOTE_COMMAND
    GOTO    WAIT_FOR_NOTE_OFF
    
    CHECK_NOTE_COMMAND:
    BANKSEL DATA_BYTE
    CLRF    DATA_BYTE
    
    CALL    I2C_READ
    
    BTFSC	DATA_RX_1,4 ;Check if upper nibble of command byte is a note on or off (8 or 9) 
    GOTO	CHECK_NOTE_COMMAND
    GOTO	PORT_RESET;</editor-fold>

;<editor-fold defaultstate="collapsed" desc="PORT RESET">
PORT_RESET:	;Set all Ports high to keep Frets from being pressed
    BANKSEL	PORTA
    MOVLW	0xFF
    MOVWF	PORTA
 
    BANKSEL	PORTB
    MOVLW	0xFF
    MOVWF	PORTB
 
    BANKSEL	PORTC
    MOVLW	0xFB ;LEAVE OUT STATUS LED
    MOVWF	PORTC
    
    CALL	STATUS_LED
 
    RETURN;</editor-fold>
    
    SETUP:
    CALL    SETUP88 ;Call is needed as the setup88 include file has a return at the end
    CALL    I2C_SETUP_PERIPHERAL ;Call is needed as the I2C interupt include file has a return at the end of the peripheral setup
    CALL    POWER_ON	;Set power on LED
    GOTO    MAIN

 END 