' Didattica Mastermind
' PD 1985-89 by Marco da Venezia
'
' Questo programma è stato creato per dimostrare la logica di risoluzione
' del gioco Mastermind, generando tutte le combinazioni possibili e
' restringendole passo dopo passo in base alle risposte dell'utente.
'
' L'algoritmo si basa sulla forza bruta, ma la sua efficienza è
' didatticamente utile per mostrare come la logica può essere usata
' per risolvere un problema complesso.
'
' Le combinazioni sono di 4 colori (numeri da 1 a 6) senza ripetizioni.
' Numero totale di combinazioni: 6 * 5 * 4 * 3 = 360.
'
' Nota: L'implementazione originale risale al 1985, e sfrutta le
' caratteristiche di QuickBASIC 4.5 e l'hardware CGA/VGA dell'epoca.
' Le "SUB" e le "FUNCTION" sono state usate per la modularità.
'
DEFINT A-Z
' Le seguenti righe dichiarano le subroutine usate nel programma principale.
' QuickBASIC richiede queste dichiarazioni per le subroutine definite dopo
' il corpo del programma.
DECLARE SUB ConfrontaComb (t1(), t2(), neri, bianchi)
DECLARE SUB MostraPossibilita (comb(), numComb)
DECLARE SUB DrawBarVertical (Rimaste)
DECLARE SUB EditLine (edit$)
DECLARE SUB Restart ())

' Dichiarazione degli array per memorizzare le combinazioni
' 'possibili': array che contiene tutte le 360 combinazioni iniziali.
' 'valido': array booleano (0/1) per marcare le combinazioni valide.
' 'tentativo': array per memorizzare la mossa corrente dell'utente.
' 'segreta': array che contiene la combinazione casuale da indovinare.
DIM possibili(1 TO 360, 1 TO 4)
DIM valido(1 TO 360)
DIM tentativo(1 TO 4)
DIM segreta(1 TO 4)

' Imposta lo schermo e disegna l'interfaccia di gioco.
CLS
LOCATE 25, 1: PRINT "Digita 4 numeri fra 1 e 6"; TAB(40); "Impara a giocare a Mastermind";
' Disegna il riquadro di gioco usando i caratteri pseudografici ASCII.
FOR i = 1 TO 21
    LOCATE i, 1
    IF i = 1 THEN i$ = "BN" ELSE i$ = "00"
    COLOR 7, 1: PRINT i$;
    COLOR 0, 7: PRINT CHR$(179); "...."; CHR$(179)
NEXT

' Genera tutte le 360 combinazioni possibili di 4 colori unici.
' Questo algoritmo a cicli annidati genera ogni possibile sequenza
' di numeri unici da 1 a 6.
COLOR 7, 0: PRINT "Calcolo ";
count = 0
FOR a = 1 TO 6
    FOR b = 1 TO 6
        IF b <> a THEN
            FOR c = 1 TO 6
                IF c <> a AND c <> b THEN
                    FOR d = 1 TO 6
                        IF d <> a AND d <> b AND d <> c THEN
                            count = count + 1
                            possibili(count, 1) = a
                            possibili(count, 2) = b
                            possibili(count, 3) = c
                            possibili(count, 4) = d
                            valido(count) = 1
                        END IF
                    NEXT
                END IF
            NEXT
        END IF
    NEXT
NEXT

' Genera una combinazione segreta casuale e la visualizza
' in un formato visibile all'utente.
RANDOMIZE TIMER
DIM usati(1 TO 6)
FOR i = 1 TO 4
    DO
        colore = INT(RND * 6) + 1
        IF usati(colore) = 0 THEN
            segreta(i) = colore
            usati(colore) = 1
            COLOR segreta(i), 7
            LOCATE 1, 3 + i: PRINT LTRIM$(STR$(segreta(i)));
            COLOR 7, 0
            EXIT DO
        END IF
    LOOP
NEXT

' Ciclo di gioco principale.
tentativi = 0
DO
    tentativi = tentativi + 1
    IF tentativi > 20 THEN Restart ' Limita il numero di tentativi.
    LOCATE 22, 1: PRINT "Riga"; tentativi
    LOCATE 22 - tentativi, 4, 1

    ' Chiama la subroutine per l'inserimento dell'input dell'utente.
    row = CSRLIN: col = POS(0)
    LOCATE row, col
    CALL EditLine(edit$)

    ' Converte la stringa di input in un array di numeri.
    FOR i = 1 TO 4
        tentativo(i) = VAL(MID$(edit$, i, 1))
        IF tentativo(i) = 0 THEN Restart
    NEXT

    ' Confronta il tentativo dell'utente con la combinazione segreta.
    CALL ConfrontaComb(tentativo(), segreta(), neri, bianchi)
   
    ' Stampa i risultati (pioli bianchi e neri).
    COLOR 0, 7: LOCATE row, 1: PRINT LTRIM$(STR$(bianchi));
    COLOR 7, 0: LOCATE row, 2: PRINT LTRIM$(STR$(neri));

    ' Filtra le combinazioni rimanenti. Questo è il cuore dell'algoritmo.
    ' Vengono scartate tutte le combinazioni che non darebbero lo stesso
    ' risultato (neri/bianchi) del tentativo appena fatto dall'utente.
    LOCATE 22, 1: PRINT "Calcolo ";
    FOR n = 1 TO 360
        IF valido(n) = 1 THEN
            FOR i = 1 TO 4
                comb(i) = possibili(n, i)
            NEXT
            CALL ConfrontaComb(tentativo(), comb(), simNeri, simBianchi)
            IF simNeri <> neri OR simBianchi <> bianchi THEN
                valido(n) = 0
            END IF
        END IF
    NEXT

    ' Aggiorna il conteggio delle combinazioni rimanenti.
    Rimaste = 0
    FOR n = 1 TO 360
        IF valido(n) = 1 THEN Rimaste = Rimaste + 1
    NEXT
    LOCATE 25, 1: PRINT USING "Combinazioni possibili: ### "; Rimaste;

    ' Disegna la barra di stato verticale in base al numero di combinazioni rimanenti.
    CALL DrawBarVertical(Rimaste)
   
    ' Crea un nuovo array temporaneo con solo le combinazioni valide.
    DIM combValide(1 TO 360, 1 TO 4)
    indice = 0
    FOR n = 1 TO 360
        IF valido(n) = 1 THEN
            indice = indice + 1
            FOR i = 1 TO 4
                combValide(indice, i) = possibili(n, i)
            NEXT
        END IF
    NEXT

    ' Mostra le combinazioni ancora possibili.
    CALL MostraPossibilita(combValide(), indice)

LOOP UNTIL neri = 4

' La partita è finita. L'utente ha vinto.
Restart

' --- Definizione delle SUBROUTINE ---
' Qui inizia la definizione delle subroutine dichiarate all'inizio del programma.

SUB ConfrontaComb (t1(), t2(), neri, bianchi)
    ' Confronta due combinazioni di 4 numeri per determinare neri e bianchi.
    DIM usato1(1 TO 4), usato2(1 TO 4)
    neri = 0: bianchi = 0

    ' Primo ciclo: calcola i pioli neri (colore e posizione corretti).
    ' Usa gli array 'usato1' e 'usato2' per evitare di contare due volte
    ' lo stesso piolo.
    FOR i = 1 TO 4
        IF t1(i) = t2(i) THEN
            neri = neri + 1
            usato1(i) = 1
            usato2(i) = 1
        END IF
    NEXT

    ' Secondo ciclo: calcola i pioli bianchi (colore corretto, posizione sbagliata).
    FOR i = 1 TO 4
        IF usato1(i) = 0 THEN
            FOR j = 1 TO 4
                IF usato2(j) = 0 AND t1(i) = t2(j) THEN
                    bianchi = bianchi + 1
                    usato2(j) = 1
                    EXIT FOR
                END IF
            NEXT
        END IF
    NEXT
END SUB

SUB DrawBarVertical (Rimaste)
    ' Disegna una barra di stato verticale che si riduce man mano che
    ' il numero di combinazioni possibili diminuisce.
    filled = INT((Rimaste / 240) * 24)
    ' Il valore 240 è un valore di normalizzazione empirico.
    ' In un gioco con ripetizioni, questo valore cambierebbe a 1296.

    ' Cancella la colonna prima di disegnare per aggiornare la barra.
    FOR r = 1 TO 24
        LOCATE r, 80: PRINT CHR$(176);
    NEXT

    ' Disegna la barra dal basso verso l'alto.
    IF filled < 10 THEN filled = 1
    FOR r = 24 TO 25 - filled STEP -1
        LOCATE r, 80
        PRINT CHR$(219);
    NEXT
END SUB

SUB EditLine (edit$)
    ' Gestisce l'input dell'utente in modo interattivo.
    edit$ = ""
    DO
        k$ = INKEY$
        IF k$ = CHR$(13) THEN EXIT DO ' Invio
        IF k$ = CHR$(8) THEN ' Backspace
            IF LEN(edit$) THEN
                edit$ = LEFT$(edit$, LEN(edit$) - 1)
                LOCATE , POS(0) - 1: PRINT ".";
                LOCATE , POS(0) - 1
            END IF
        END IF
        IF k$ >= "1" AND k$ <= "6" AND LEN(edit$) < 4 THEN
            edit$ = edit$ + k$
            COLOR VAL(k$), 7: PRINT k$; : COLOR 0, 7
        END IF
    LOOP
END SUB

SUB MostraPossibilita (comb(), numComb)
    ' Mostra su schermo le combinazioni che sono ancora possibili.
    ' Il codice è ottimizzato per disporle in colonne.
   
    ' Cancella l'area di visualizzazione precedente.
    FOR r = 1 TO 24
        FOR c = 9 TO 74 STEP 5
            LOCATE r, c, 0: PRINT "|....";
        NEXT
    NEXT

    ' Stampa le combinazioni rimanenti.
    row = 1: col = 10
    FOR i = 1 TO numComb
        LOCATE row, col
        COLOR comb(i, 1): PRINT LTRIM$(STR$(comb(i, 1)));
        LOCATE row, col + 1
        COLOR comb(i, 2): PRINT LTRIM$(STR$(comb(i, 2)));
        LOCATE row, col + 2
        COLOR comb(i, 3): PRINT LTRIM$(STR$(comb(i, 3)));
        LOCATE row, col + 3
        COLOR comb(i, 4): PRINT LTRIM$(STR$(comb(i, 4)));
        row = row + 1
        IF row > 24 THEN row = 1: col = col + 5
    NEXT

    COLOR 7
END SUB

SUB Restart
    ' Chiede all'utente se vuole ricominciare il gioco.
    LOCATE 22, 1, 1
    PRINT "Restart?"
    PRINT "S/N";
    DO
        a$ = INPUT$(1)
        IF UCASE$(a$) = "S" THEN RUN
        IF UCASE$(a$) = "N" THEN EXIT DO
    LOOP
    CLS
    END
END SUB