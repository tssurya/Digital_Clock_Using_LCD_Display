List p=16f877A
#include p16f877A.inc

;;;;;;;;;;;;;;;;;;;
;INITIAL CONFIGURATION
BSF STATUS,5
movlw 0x01
movwf TRISC ;0th bit is input sensor
movlw 0x00
movwf TRISB;to pass the number

;;;;;;;;;;;;;;;;;;;
BCF STATUS,5
movlw 0x00
movwf PORTB

movlw 0x00
movwf 0x60;one's place of the seconds
movwf 0x61;ten's place of the seconds
movwf 0x62;one's place of the minutes
movwf 0x63;ten's place of the minutes
movwf 0x64;one's place of the hours
movwf 0x65;ten's place of the hours
movwf 0x66;temporary register if needed anywhere
movwf 0x67;number check
BEGIN: BTFSC PORTC,0
       CALL ENTERING
       CALL delay
       ;call delay
       GOTO BEGIN

ENTERING:  CALL INCREMENT
           ;tens_place_hours
           movf 0x65,0
           movwf 0x67
           CALL LCDSTART
           MOVLW 0XA3
           CALL LCDDELAY
           call NUMBERCHECK
           MOVWF PORTB
           NOP
           CALL LCDENABL

           ;ones_place_hours
           movf 0x64,0
           movwf 0x67
           MOVLW 0XA3
           CALL LCDDELAY
           call NUMBERCHECK
           MOVWF PORTB
           NOP
           CALL LCDENABL

		   ;colon
           movlw 0x3A
           movwf 0x67
           MOVLW 0XA3
           CALL LCDDELAY
           call NUMBERCHECK
           MOVWF PORTB
           NOP
           CALL LCDENABL

           ;tens_place_minutes
           movf 0x63,0
           movwf 0x67
           MOVLW 0XA3
           CALL LCDDELAY
           call NUMBERCHECK
           MOVWF PORTB
           NOP
           CALL LCDENABL

           ;ones_place_minutes
            movf 0x62,0
			movwf 0x67
			MOVLW 0XA3
			CALL LCDDELAY
			call NUMBERCHECK
			MOVWF PORTB
			NOP
			CALL LCDENABL


		   ;colon
           movlw 0x3A
           movwf 0x67
           MOVLW 0XA3
           CALL LCDDELAY
           call NUMBERCHECK
           MOVWF PORTB
           NOP
           CALL LCDENABL

            ;tens_place_seconds
            movf 0x61,0
            movwf 0x67
			MOVLW 0XA3
			CALL LCDDELAY
			call NUMBERCHECK
			MOVWF PORTB
			NOP
			CALL LCDENABL

            ;ones_place_seconds
             movf 0x60,0
			 movwf 0x67
			 MOVLW 0XA3
			 CALL LCDDELAY
			 call NUMBERCHECK
			 MOVWF PORTB
			 NOP
			 CALL LCDENABL
             return



;;;;;;;;;;;;;;;;;;;;
INCREMENT: 
          ones_place_seconds: movlw 0x09
                              movwf 0x66
                              movf 0x60,0
                              subwf 0x66,1
                              BTFSC STATUS,Z
                              goto tens_place_seconds
                              INCF 0X60,1 
                              goto inc_finish
                              
          
          tens_place_seconds: movlw 0x00
                              movwf 0x60
                              movlw 0x05
                              movwf 0x66
                              movf 0x61,0
                              subwf 0x66,1
                              BTFSC STATUS,Z
                              goto ones_place_minutes
                              INCF 0X61,1
                             ; goto ones_place_seconds 
                              goto inc_finish

          
          ones_place_minutes: movlw 0x00
                              movwf 0x60
                              movwf 0x61
						      movlw 0x09
                              movwf 0x66
                              movf 0x62,0
                              subwf 0x66,1
                              BTFSC STATUS,Z
                              goto tens_place_minutes
                              INCF 0X62,1 
                              ;goto ones_place_seconds
                              goto inc_finish 
     
          tens_place_minutes: movlw 0x00
                              movwf 0x60
                              movwf 0x61
                              movwf 0x62
                              
                              movlw 0x05
                              movwf 0x66
                              movf 0x63,0
                              subwf 0x66,1
                              BTFSC STATUS,Z
                              goto ones_place_hours
                              INCF 0X63,1
                              ;goto ones_place_seconds 
                              goto inc_finish

           ones_place_hours:                  
                              movlw 0x00 
                              movwf 0x60
                              movwf 0x61
                              movwf 0x62
                              movwf 0x63
                              
                              movlw 0x09
                              movwf 0x66
                              movf 0x64,0
                              subwf 0x66,1
                              BTFSC STATUS,Z
                              goto tens_place_hours
                              INCF 0X64,1
                              ;goto ones_place_seconds 
                              goto inc_finish

            tens_place_hours: movlw 0x00
                              movwf 0x60
                              movwf 0x61
                              movwf 0x62
                              movwf 0x63
                              movwf 0x64
                              
                              movlw 0x02
                              movwf 0x66
                              movf 0x65,0
                              subwf 0x66,1
                              BTFSC STATUS,Z
                              goto overflow1
                              INCF 0X65,1
                              ;goto ones_place_seconds 
                              goto inc_finish

            overflow1: movlw 0x02
                       movwf 0x66
                       movf 0x64,0
                       subwf 0x66,1
                       BTFSC STATUS,Z
                       goto inc_finish
                       INCF 0X64,1
                       ;goto ones_place_seconds
                       goto inc_finish
overflow:
movlw 0x00
movwf 0x60
movwf 0x61
movwf 0x62
movwf 0x63
movwf 0x64
movwf 0x65

inc_finish:
return

;;;;;;;;;;;;;;;;;;;;;;;;

NUMBERCHECK:
movlw 0x00
movwf 0x66;temp

;check for 0
movlw 0x00
addwf 0x67,1
btfss STATUS,Z
goto x1
movlw '0'
goto numcheckfinish

;check for 1
x1:
movlw 0x01
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x2
movlw '1'
goto numcheckfinish

;check for 2
x2:
movlw 0x02
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x3
movlw '2'
goto numcheckfinish

;check for 3
x3:
movlw 0x03
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x4
movlw '3'
goto numcheckfinish

;check for 4
x4:
movlw 0x04
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x5
movlw '4'
goto numcheckfinish

;check for 5
x5:
movlw 0x05
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x6
movlw '5'
goto numcheckfinish

;check for 6
x6:
movlw 0x06
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x7
movlw '6'
goto numcheckfinish

;check for 7
x7:
movlw 0x07
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x8
movlw '7'
goto numcheckfinish

;check for 8
x8:
movlw 0x08
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x9
movlw '8'
goto numcheckfinish

;check for 9
x9:
movlw 0x09
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto x10
movlw '9'
goto numcheckfinish

;check for :
x10:
movlw 0x3A
movwf 0x66
movf 0x67,0
subwf 0x66,1
btfss STATUS,Z
goto numcheckfinish
movlw ':'
goto numcheckfinish


numcheckfinish:
return
;;;;;;;;;;;;;;;;;;;;

LCDSTART
BSF STATUS,RP0
BCF STATUS,RP1
BSF PCON,0
BSF PCON,1
BCF STATUS,RP0
CLRF PORTB
CLRF PORTE
BSF STATUS, RP0
MOVLW 0X00
MOVWF TRISB
MOVWF TRISE
MOVLW 0X86
MOVWF ADCON1
NOP
BCF STATUS,RP0
MOVLW 0XFF
MOVWF PORTB
MOVLW 0XDC
CALL LCDDELAY
MOVLW 0X3F
MOVWF PORTB
NOP 
CALL LCDENABL
MOVLW 0XA3
CALL LCDDELAY
NOP
CALL LCDENABL
MOVLW 0XA3
CALL LCDDELAY
NOP
MOVLW 0X3B
MOVWF PORTB
NOP
CALL LCDENABL
MOVLW 0XA3
CALL LCDDELAY
MOVLW 0X0C
MOVWF PORTB
NOP
CALL LCDENABL

MOVLW 0XA3
CALL LCDDELAY
MOVLW 0X01
MOVWF PORTB
NOP
CALL LCDENABL

MOVLW 0XA3
CALL LCDDELAY
MOVLW 0X06
MOVWF PORTB
NOP
CALL LCDENABL
MOVLW 0XA3
CALL LCDDELAY
MOVLW 0X01
MOVWF PORTB
NOP
CALL LCDENABL
MOVLW 0XA3
CALL LCDDELAY
MOVLW 0X80
MOVWF PORTB
NOP
CALL LCDENABL
MOVLW 0XA3
CALL LCDDELAY
BSF PORTE,0
RETURN


LCDENABL
BSF PORTE,2
NOP
NOP
BCF PORTE,2
MOVLW 0X07
CALL LCDDELAY
RETURN

LCDDELAY
MOVWF 0X027
NEST1 
MOVLW 0XFF
MOVWF 0X027
NEST2
DECFSZ 0X027
GOTO NEST2
RETURN
;;;;;;;;;;;;;;;;;;;;;

; DELAY PROGRAM
delay:
Y: movlw 0x05
movwf 0x20
Y1:
movlw 0xff
movwf 0x21
Y2:
movlw 0xff
movwf 0x22
Y3:
decfsz 0x22
goto Y3
decfsz 0x21
goto Y2
decfsz 0x20
goto Y1
return

en:
end
