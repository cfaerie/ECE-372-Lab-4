;*****************************************************************
;* ParsingLoop.ASM
;* 
;*****************************************************************
; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point

; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 
		
;-------------------------------------------------- 
; Equates Section  
;----------------------------------------------------  
ROMStart    EQU  $2000  ; absolute address to place my code

;---------------------------------------------------- 
; Variable/Data Section
;----------------------------------------------------  
            ORG RAMStart   ; loc $1000  (RAMEnd = $3FFF)
; Insert here your data definitions here

COUNT       DS.B    1

SEED        DC.B    0

PROMPT      dc.b    $0A, $0D   ; CR LF
            dc.b    "Type a character:  Y N M  "
            dc.b    0    ; using zero terminated strings
            
YESSTRG     dc.b   "   YES  "
            dc.b    0

NOSTRG      dc.b   "   NO   "
            dc.b    0

MAYBESTRG    dc.b  "   MAYBE  "
             dc.b   0


       INCLUDE 'utilities.inc'
       INCLUDE 'LCD.inc'

;---------------------------------------------------- 
; Code Section
;---------------------------------------------------- 
            ORG   ROMStart  ; loc $2000
Entry:
_Startup:
            ; remap the RAM &amp; EEPROM here. See EB386.pdf
 ifdef _HCS12_SERIALMON
            ; set registers at $0000
            CLR   $11                  ; INITRG= $0
            ; set ram to end at $3FFF
            LDAB  #$39
            STAB  $10                  ; INITRM= $39

            ; set eeprom to end at $0FFF
            LDAA  #$9
            STAA  $12                  ; INITEE= $9
            JSR   PLL_init      ; initialize PLL  
  endif

;---------------------------------------------------- 
; Insert your code here
;---------------------------------------------------- 
         LDS   #ROMStart ; load stack pointer
         JSR   TermInit  ; needed for Simulator only
         JSR   led_enable   ; enable PORTB for LED's
         CLR   COUNT

CHCKPTH3 BRSET PTH,%00001000,CHCKPTH2
         JSR   DELAY
         JSR   PH3FCN
         STAA  PORTB
         
CHCKPTH2 BRSET PTH,%00000100,CHCKPTH1
         JSR   DELAY
         JSR   PH2FCN

CHCKPTH1 BRSET PTH,%00000010,CHCKPTH0
         JSR   DELAY
         JSR   PH1FCN

CHCKPTH0 BRSET PTH,%00000001,NEXT
         JSR   DELAY
         BCLR  PTP, $10 + $20 + $40
         JSR   PH0FCN


NEXT     JMP   CHCKPTH3



; Note: main program is an endless loop and subroutines follow
; (Must press reset to quit.)

;===================================================================
; FUNCTIONS CALLED BY MAIN LOOP


        
PH3FCN  LDAA   SEED
        LSLA
        ADCA   #20
        STAA   SEED   
        RTS

PH2FCN  PSHB  
			  LDAB   PORTB  ; toggle LED bits
		    LSLB
	      STAB   PORTB
	      JSR    DELAY
        PULB
        RTS
        
PH1FCN  PSHB  
			  LDAB   PORTB  ; toggle LED bits
		    ASRB
	      STAB   PORTB
	      JSR    DELAY
        PULB
        RTS
        
PH0FCN  PSHB
        LDAA   PTH
        ANDA   #%11111000
        CLR    COUNT
        LSLA
        BCC    ONE
        INC    COUNT
ONE     LSLA  
        BCC    TWO
        INC    COUNT
TWO     LSLA  
        BCC    THREE
        INC    COUNT   
THREE   LSLA  
        BCC    FOUR
        INC    COUNT
FOUR    LSLA  
        BCC    FIVE
        INC    COUNT
FIVE    LDAB   COUNT
        CMPB   #2
        BLS    REDE
        JSR    GREEN
REDE    JSR    RED
        PULB
        RTS
        
RED     BSET   PTP, $10
        RTS
GREEN   BSET   PTP, $40
        RTS
                           
       
; delay is approx. 100ms (ignoring overhead)         
DELAY   ldab    #100    ;  1 cycle
dly1:   ldy     #6000   ; 6000 x 4 = 24,000 cycles = 1ms
dly:    dey             ; 1 cycle
        bne     dly     ; 3 cycles
        decb            ; 1 cycle
        bne     dly1    ; max. 3 cycles (3/1)
        rts    
                    


ClearLeds
        CLR   PORTB      ; clear all LED's
        RTS                                  
                         
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   Vreset
            DC.W  Entry         ; Reset Vector
 