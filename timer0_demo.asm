;/********************************************************************************
;* timer0_demo.asm: Demonstration av användning av Timer 0 i assembler för
;*                  toggling av en lysdiod ansluten till pin 8 (PORTB0) var
;*                  100:e ms. Timern ställs in så att timergenererat avbrott
;*                  sker var 16.384:e ms, därmed togglas lysdioden ungefär var
;*                  sjätte avbrott.
;********************************************************************************/

; Makrodefinitioner:
.EQU LED1 = PORTB0          ; Lysdiod 1 ansluten till pin 8 (PORTB0).
.EQU TIMER0_MAX_COUNT = 6   ; Motsvarar ca 100 ms (avbrott var 16.384:e ms).

.EQU RESET_vect = 0x00      ; Reset-vektor, programmets startpunkt.
.EQU TIMER0_OVF_vect = 0x20 ; Avbrottsvektor för OVF-avbrott på Timer 0.

;/********************************************************************************
;* .DSEG: Dataminnet, här lagras statiska variabler.
;********************************************************************************/
.DSEG
.ORG SRAM_START
   timer0_counter: .byte 1 ; Räknar antalet timergenererade avbrott på Timer 0.

;/********************************************************************************
;* .CSEG: Programminnet, här lagras programkoden.
;********************************************************************************/
.CSEG

;/********************************************************************************
;* RESET_vect: Programmet startpunkt. Vid start anropas subrutinen main för
;*             att starta programmet.
;********************************************************************************/
.ORG RESET_vect
   RJMP main

;/********************************************************************************
;* TIMER0_OVF_vect: Avbrottsvektor för overflow-avbrott på Timer 0, vilket sker
;*                  var 16.384:e ms. Programhopp sker till motsvarande 
;*                  avbrottsrutin för att hantera avbrottet.
;********************************************************************************/
.ORG TIMER0_OVF_vect
   RJMP ISR_TIMER0_OVF

;/********************************************************************************
;* ISR_TIMER0_OVF: Avbrottrutin för overflow-avbrott på Timer 0, vilket sker
;*                 var 16.384:e ms. Varje avbrott räknas upp via den statiska
;*                 variabeln counter. Var sjätte avbrott (ungefär var 100:e ms)
;*                 togglas lysdiod 1.
;********************************************************************************/
ISR_TIMER0_OVF:
   LDS R24, timer0_counter
   INC R24
   CPI R24, TIMER0_MAX_COUNT
   BRLO ISR_TIMER0_OVF_end
   OUT PINB, R16
   CLR R24
ISR_TIMER0_OVF_end:
   STS timer0_counter, R24
   RETI

/********************************************************************************
;* main: Initierar systemet vid start. Programmet hålls sedan igång så länge 
;*       matningsspänning tillförs.
;********************************************************************************/
main:

;/********************************************************************************
;* setup: Sätter lysdioden till utport samt aktiverar timerkrets Timer 0 
;*        så att avbrott sker via overflow var 16.384:e ms.
;********************************************************************************/
setup:
   LDI R16, (1 << LED1)
   OUT DDRB, R16
   LDI R24, (1 << CS00) | (1 << CS22)
   OUT TCCR0B, R24
   STS TIMSK0, R16
   SEI

;/********************************************************************************
;* main_loop: Håller igång programmet så länge matningsspänning tillförs.
;********************************************************************************/
main_loop:
   RJMP main_loop