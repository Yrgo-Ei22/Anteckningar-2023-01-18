# Anteckningar 2023-01-18
Demonstration av timerkrets Timer 0 i assembler, övning gällande avbrottsimplementering i assembler 
samt skapande av dataminne för emulerad CPU.

Filen "timer0_demo.asm" utgör en demonstration av Timer 0 i assembler för toggling av en lysdiod 
ansluten till pin 8 (PORTB0) var 100:e ms. Timern ställs in så att timergenererat avbrott sker 
var 16.384:e ms, därmed togglas lysdioden ungefär var sjätte avbrott.

Filen "exercise.asm" utgör en övningsuppgift innefattande PCI-avbrott i assembler.
Tre lysdioder anslutna till pin 8 - 10 (PORTB0 - PORTB2) togglas via nedtryckning av 
var sin tryckknapp ansluten till pin 11 - 13 (PORTB3 - PORTB5) enligt nedan:

   - Lysdiod 1 ansluten till pin 8 (PORTB0) togglas via nedtryckning av tryckknapp 1 ansluten till pin 11 (PORTB3).
   - Lysdiod 2 ansluten till pin 9 (PORTB1) togglas via nedtryckning av tryckknapp 2 ansluten till pin 12 (PORTB4).
   - Lysdiod 3 ansluten till pin 10 (PORTB2) togglas via nedtryckning av tryckknapp 3 ansluten till pin 13 (PORTB5).

Samtliga .c- och .h-filer utgör den emulerade CPU som konstrueras under kursens gång.



