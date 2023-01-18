;/********************************************************************************
;* timer0_demo.asm: Demonstration av anv�ndning av Timer 0 i assembler f�r
;*                  toggling av en lysdiod ansluten till pin 8 (PORTB0) var
;*                  100:e ms. Timern st�lls in s� att timergenererat avbrott
;*                  sker var 16.384:e ms, d�rmed togglas lysdioden ungef�r var
;*                  sj�tte avbrott.
;********************************************************************************/

; Makrodefinitioner:
.EQU LED1 = PORTB0          ; Lysdiod 1 ansluten till pin 8 (PORTB0).
.EQU TIMER0_MAX_COUNT = 6   ; Motsvarar ca 100 ms (avbrott var 16.384:e ms).

.EQU RESET_vect = 0x00      ; Reset-vektor, programmets startpunkt.
.EQU TIMER0_OVF_vect = 0x20 ; Avbrottsvektor f�r OVF-avbrott p� Timer 0.

;/********************************************************************************
;* .DSEG: Dataminnet, h�r lagras statiska variabler.
;********************************************************************************/
.DSEG
.ORG SRAM_START
   timer0_counter: .byte 1 ; R�knar antalet timergenererade avbrott p� Timer 0.

;/********************************************************************************
;* .CSEG: Programminnet, h�r lagras programkoden.
;********************************************************************************/
.CSEG

;/********************************************************************************
;* RESET_vect: Programmet startpunkt. Vid start anropas subrutinen main f�r
;*             att starta programmet.
;********************************************************************************/
.ORG RESET_vect
   RJMP main

;/********************************************************************************
;* TIMER0_OVF_vect: Avbrottsvektor f�r overflow-avbrott p� Timer 0, vilket sker
;*                  var 16.384:e ms. Programhopp sker till motsvarande 
;*                  avbrottsrutin f�r att hantera avbrottet.
;********************************************************************************/
.ORG TIMER0_OVF_vect
   RJMP ISR_TIMER0_OVF

;/********************************************************************************
;* ISR_TIMER0_OVF: Avbrottrutin f�r overflow-avbrott p� Timer 0, vilket sker
;*                 var 16.384:e ms. Varje avbrott r�knas upp via den statiska
;*                 variabeln counter. Var sj�tte avbrott (ungef�r var 100:e ms)
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
;* main: Initierar systemet vid start. Programmet h�lls sedan ig�ng s� l�nge 
;*       matningssp�nning tillf�rs.
;********************************************************************************/
main:

;/********************************************************************************
;* setup: S�tter lysdioden till utport samt aktiverar timerkrets Timer 0 
;*        s� att avbrott sker via overflow var 16.384:e ms.
;********************************************************************************/
setup:
   LDI R16, (1 << LED1)
   OUT DDRB, R16
   LDI R24, (1 << CS00) | (1 << CS22)
   OUT TCCR0B, R24
   STS TIMSK0, R16
   SEI

;/********************************************************************************
;* main_loop: H�ller ig�ng programmet s� l�nge matningssp�nning tillf�rs.
;********************************************************************************/
main_loop:
   RJMP main_loop