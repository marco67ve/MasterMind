# Marco da Venezia BASIC Anthology – COLLEZIONE MASTER MIND  

**Un viaggio algoritmico dal 1985 al 2025**

## Scopo

Questa raccolta documenta la scrittura del gioco Master Mind verso la fine degli anni '80 e l'evoluzione di un algoritmo didattico scritto e riscritto più volte nel corso degli anni per riflettere il contesto tecnico e creativo del suo tempo: dal GWBASIC su PC XT, al QuickBASIC su AT, al QB64 su PC a 64 bit.


## Mastermind anni '80 per PC/MS-DOS

### Introduzione
Questo è un progetto del famoso gioco da tavolo Mastermind, scritto originariamente in GW-BASIC nel 1985 e riscritto in QuickBASIC 4.5 nel 1989.
Gradisco documentare un pezzo di storia della programmazione per offrire una visione di come venivano sviluppati i giochi su PC con l'hardware e i linguaggi dell'epoca.

### Caratteristiche
- Interfaccia testuale che utilizza i caratteri estesi ASCII (Code Page 437) per disegnare la grafica
- Controllo di input da tastiera con frecce, backspace e conferma  
- Timer e contatore tentativi  
- Algoritmo di gioco: implementa una logica classica per la generazione del codice segreto e per la valutazione dei tentativi calcolando i pioli bianchi e neri.
- Classifica dei migliori punteggi con inserimento del proprio nome tramite editor di linea interno

### Compatibilità
Richiede una scheda video CGA (o superiore) che era lo standard per la grafica a colori su PC negli anni '80.

### Il Codice
Il progetto include due versioni principali:
- Versione GW-BASIC (MM-GWB.BAS): la prima scrittura del gioco, un esempio di come si programmava con la logica "linea per linea" e i comandi GOTO.
- Versione QuickBASIC (MM.BAS): la riscrittura successiva, che sfrutta le funzionalità di QuickBASIC 4.5 come i cicli DO...LOOP e i blocchi IF...THEN...ELSE, rendendo il codice strutturato e più leggibile; non integra SUB e FUNCTION, ommesse per ragioni di compatibilità con altri dialetti Basic tipici di quegli anni.

### Lo Script Didattico
Include uno script separato (MM-DID.BAS) che serve come strumento didattico. Questo script non è un gioco, ma un algoritmo di risoluzione di Mastermind che genera e filtra le possibilità: inizialmente genera tutte le 360 combinazioni possibili e, a ogni tentativo, filtra in tempo reale l'elenco delle combinazioni che non si conformano alla risposta (neri/bianchi) data, mostrando il numero delle combinazioni ancora possibili tramite un contatore e una barra verticale, offrendo una chiara rappresentazione visiva dei progressi dell'algoritmo.

### Ulteriori script didattici
Aggiunti due script: MM-DID1QB64.BAS del 2008 grazie all'uscita di QB64 e MM-DID2QB64.BAS del 2025


## Codici inclusi
```
| Versione        | Linguaggio     | Anno | Descrizione                        |
|-----------------+----------------+------+------------------------------------|
| MM-GWB.BAS      | GWBASIC        | 1985 | Prima versione del gioco, con      | 
|                 |                |      | numerazione e interfaccia CGA      |
| MM.BAS          | QuickBASIC 4.5 | 1989 | Restauro strutturato (senza GOTO,  |
|                 |                |      | output a video identico)           |
| MM-DID.BAS      | QuickBASIC 4.5 | 1989 | Didattico, con 360 combinazioni e  |
|                 |                |      | interfaccia testuale               |
| MM-DID1QB64.BAS | QB64           | 2008 | Espansione a 1296 combinazioni,    |
|                 |                |      | grafica RGB, algoritmo minimax     |
| MM-DID2QB64.BAS | QB64           | 2025 | Versione con grafica interattiva,  |
|                 |                |      | pallini e pioli visivi             |
|                 |                |      |                                    |
```

## Uso

- Ogni file può essere eseguito in QB64; le rel. 1985-89 girano anche in Windows XP/NT (32 bit, sia sotto command.com che cmd.exe) oppure su sistemi a 64 bit sotto DOSBox e DOSBox-X 

## Licenza

Pubblicazione personale di Pubblico dominio a scopo didattico e storico, per giocare, imparare e contribuire.



# Mastermind Didattico – QB 4.5 (1989)
**Simulatore logico interattivo senza ripetizioni**

## Scopo

Questa demo non è un semplice gioco, ma un assistente didattico per comprendere la logica del Mastermind.  
Il giocatore inserisce tentativi e riceve feedback (neri e bianchi) osservando come l'algoritmo filtra le combinazioni ancora valide.

## Caratteristiche

- Generazione combinatoria completa: 360 combinazioni uniche senza ripetizioni.
- Algoritmo di deduzione: ogni tentativo filtra le combinazioni valide, simulando il ragionamento umano.
- Visualizzazione dinamica: la barra verticale e la griglia colorata mostrano l'evoluzione del pensiero.
- Interfaccia didattica: il giocatore impara a giocare mentre gioca, con feedback visivo e logico.
- Modularità: ogni funzione è autonoma e pensata per essere riusata o estesa.

## File inclusi

- `MM-DID.BAS` – versione didattica con output testuale a colori



# Mistermind Didattico – QB64 (2008)  
**Simulatore logico interattivo per Mastermind con ripetizioni**

## Scopo

Potenziare l'algoritmo del 1989 (scritto per PC XT/AT con SO a 16 bit) sfruttando la memoria e la potenza dei PC a 64 bit per espandere la didattica computazionale

## Caratteristiche

- Ripetizioni ammesse, da 360 a 1296 combinazioni.
- Precalcolo dei feedback tra tutte le coppie
- Algoritmo minimax per scelta ottimale del tentativo, ottimizzare il tempo di risposta e permettere strategie avanzate (intelligenza artificiale stile Knuth).
- Visualizzazione grafica del layout in 1600×900, colori RGB, messaggi lampeggianti.
- Filtro dinamico delle combinazioni compatibili

## Filosofia

> Un algoritmo che "pensa". Un'interfaccia che insegna.  
> Il gioco che diventa lezione.”  

## ?? File inclusi

- `MM-DID1QB64.BAS.bas` – versione didattica con grafica e algoritmo ottimizzato (motore elaborato "Bishop")



# Mistermind Didattico – QB64 (2025)  
**Simulatore logico interattivo per Mastermind con ripetizioni**

## Scopo

La versione del 2025 riprende il codice del 2008 per esplorare nuove strategie e interfacce.

## Caratteristiche

- Evoluzioni grafiche rispetto al 2008

    Pallini colorati con numero bianco: ogni tentativo è ora un elemento visivo chiaro e leggibile.

    Pioli neri e bianchi con riquadro blu: feedback visivo immediato.

    Cifre colorate nei codici compatibili: la griglia a destra diventa una mappa logica, non solo un elenco.

    Lampeggio e messaggi interattivi: il flusso è ritmato, il giocatore è guidato con più tatto.

    Palette RGB personalizzata: ogni colore ha una sua identità, e il codice la rispetta.

- Continuità algoritmica

    Precalcolo dei feedback: ottimizzazione conservata.

    Algoritmo minimax: raffinato, ma non stravolto, la logica resta leggibile e didattica.

    Struttura modulare: ogni SUB è autonoma e pronta per essere riusata o estesa.

Questa versione segna il mio ritorno alla programmazione non a oggetti, dopo la lunga esperienza con Visual Basic, per assaggiare la leggerezza e la potenza del QB64, in accordo con la *Marco da Venezia BASIC Anthology*, un archivio personale che celebra la bellezza del codice retrocomputazionale e la sua evoluzione nel tempo.

## File inclusi

- `MM-DID2QB64.BAS` – versione didattica con grafica migliorata (motore "Bishop")



