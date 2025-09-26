' MASTER MIND per MS/PC-DOS
' PD 10.10.85 by Marco da Venezia
' Esperimento scritto in GWBASIC, adattato per QuickBASIC
' Richiede CGA (o superiore)

'--------------------------------------------------
' Verifica tipo di scheda video
'--------------------------------------------------
DEF SEG = &H40
IF PEEK(&H49) = &H7 THEN
    PRINT "Scheda video monochrome."
    PRINT "Master Mind richiede CGA o superiore."
    END
END IF

'--------------------------------------------------
' Dichiarazione variabili
'--------------------------------------------------
DIM vec(4), fin(4), record$(1 TO 10), Names$(15)

'--------------------------------------------------
' Lettura record del file di classifica
'--------------------------------------------------
OPEN "A", #1, "MMIND.DAT": CLOSE
OPEN "I", #1, "MMIND.DAT"
WHILE NOT EOF(1)
    i = i + 1
    LINE INPUT #1, record$(i)
WEND
CLOSE

'--------------------------------------------------
' Generazione casuale del codice da indovinare
'--------------------------------------------------
RANDOMIZE TIMER
FOR i = 1 TO 4
    DO
        acaso = INT(6 * RND) + 1
        esiste = 0
        FOR j = 1 TO 4
            IF vec(j) = acaso THEN esiste = 1: EXIT FOR
        NEXT j
    LOOP WHILE esiste
    vec(i) = acaso
NEXT i

' Salvataggio codice in variabili separate
a = vec(1)
b = vec(2)
c = vec(3)
d = vec(4)
ERASE vec

'--------------------------------------------------
' Preparazione grafica dello schermo e interfaccia
'--------------------------------------------------
SCREEN , , 0
COLOR 7, 1
CLS

' Cornice principale e spazi gioco
COLOR 0, 7
LOCATE 2, 10, 0: PRINT CHR$(201); STRING$(17, 205); CHR$(187)
FOR i = 3 TO 23 STEP 2
    LOCATE i, 10: PRINT CHR$(186); "  o   o   o   o  "; CHR$(186)
    LOCATE , 10: PRINT CHR$(186); SPACE$(17); CHR$(186);
NEXT
LOCATE 24, 10: PRINT CHR$(200); STRING$(17, 205); CHR$(188);
LOCATE 4, 10: PRINT CHR$(204); STRING$(17, 205); CHR$(185)

' Funzioni laterali e legenda colori
COLOR 7, 0
LOCATE 11, 38: PRINT CHR$(201); STRING$(32, 205); CHR$(187);
LOCATE , 40: PRINT " FUNCTION "
FOR i = 12 TO 21
    LOCATE i, 38: PRINT CHR$(186); SPACE$(32); CHR$(186)
NEXT
LOCATE , 38: PRINT CHR$(200); STRING$(32, 205); CHR$(188)

LOCATE 13, 46: PRINT "Blue"; TAB(60); "TIMER"
LOCATE , 46: PRINT "Green"; TAB(60); "Mind"
LOCATE , 46: PRINT "Cyan"; TAB(60); "Row"
LOCATE , 46: PRINT "Red"
LOCATE , 46: PRINT "Pink"
LOCATE , 46: PRINT "Yellow"
LOCATE 20, 41: PRINT "[ TAB ]  Top 10"
LOCATE , 41: PRINT "[ ESC ]  End Game"
FOR i = 1 TO 6
    LOCATE 12 + i, 41: COLOR 0, i: PRINT i
NEXT

'--------------------------------------------------
' Animazione iniziale "Press any key"
'--------------------------------------------------
COLOR 31, 1
LOCATE 24, 44: PRINT "Press any key to start";

WHILE INKEY$ = ""
    FOR i = 1 TO 4 'STEP .25 'regola eventuale effetto strobo'
        'SOUND 0, 3 'fissa ritardo a prescindere da Hz CPU
        c1 = INT(3 * RND + 9)
        COLOR c1: LOCATE 2, 35:    PRINT "‹   ‹  ‹‹‹   ‹‹‹  ‹‹‹‹‹ ‹‹‹‹ ‹‹‹ "
        COLOR c1 + 1: LOCATE , 35: PRINT "€‹ ‹€ €   € €   ﬂ   €   €    €  €"
        COLOR c1 + 2: LOCATE , 35: PRINT "€ ﬂ € €ﬂﬂﬂ€  ﬂﬂﬂ‹   €   €ﬂﬂ  €ﬂﬂ‹"
        COLOR c1 + 3: LOCATE , 35: PRINT "€   € €   € ﬂ‹‹‹ﬂ   €   €‹‹‹ €  €"
        COLOR c1 + 3: LOCATE , 51: PRINT "‹   ‹  ‹‹‹  ‹   ‹  ‹‹‹  "
        COLOR c1 + 2: LOCATE , 51: PRINT "€‹ ‹€   €   €‹  €  €  € "
        COLOR c1 + 1: LOCATE , 51: PRINT "€ ﬂ €   €   € ﬂ‹€  €  € "
        COLOR c1: LOCATE , 51:     PRINT "€   €  ‹€‹  €   €  €‹‹ﬂ "
    NEXT
WEND

LOCATE 24, 44: PRINT SPACE$(23);

t1 = TIMER
LOCATE 23, 13, 1, 1, 7

'--------------------------------------------------
' Ciclo principale del gioco
'--------------------------------------------------
DO
    row = CSRLIN: col = POS(1)
    k$ = INKEY$

    ' Aggiornamento timer e tentativi
    IF k$ <> "" THEN
        LOCATE 13, 65, 0: COLOR 23, 0: PRINT INT(TIMER - t1)
        LOCATE , 65: COLOR 15, 0: PRINT mind
        LOCATE , 65: PRINT 1 + Lev
        LOCATE row, col, 1
    END IF

    ' Gestione tasti singoli
    IF LEN(k$) = 1 THEN
        IF k$ = CHR$(27) THEN EXIT DO ' ESC per uscire
        IF k$ = CHR$(9) THEN GOSUB classification ' TAB per classifica
        IF k$ = CHR$(13) THEN ' INVIO = controllo riga
            NoCR = 0
            FOR i = 1 TO 4
                IF vec(i) = 0 THEN NoCR = 1
            NEXT
            IF NoCR = 0 THEN
                Lev = Lev + 1
                fin(1) = a
                fin(2) = b
                fin(3) = c
                fin(4) = d

                ' Calcolo neri e bianchi
                nero = 0: bianco = 0
                FOR i = 1 TO 4
                    IF fin(i) = vec(i) THEN
                        fin(i) = 0
                        nero = nero + 1
                    END IF
                NEXT
                FOR i = 1 TO 4
                   IF fin(i) = vec(1) OR fin(i) = vec(2) OR fin(i) = vec(3) OR fin(i) = vec(4) THEN bianco = bianco + 1
                NEXT
                LOCATE row, 2: COLOR 7, 0: PRINT ; nero;
                LOCATE row, 5: COLOR 0, 7: PRINT ; bianco;

                IF nero = 4 OR row - 2 = 3 THEN EXIT DO ' Vittoria o ultimo tentativo
                LOCATE row - 2, 13
                ERASE vec
            END IF
        END IF

        ' Inserimento numeri giocatore
        IF ASC(k$) > 48 AND ASC(k$) < 55 THEN
            mind = mind + 1
            IF col = 13 THEN n = 1
            IF col = 17 THEN n = 2
            IF col = 21 THEN n = 3
            IF col = 25 THEN n = 4
            vec(n) = VAL(k$)
            COLOR 15, VAL(k$)
            LOCATE row, col - 1: PRINT "   ";
            LOCATE row, col: PRINT k$: LOCATE row, col
        END IF
    END IF

    ' Gestione tasti freccia
    IF LEN(k$) = 2 THEN
        k1$ = MID$(k$, 1, 1): k2$ = MID$(k$, 2, 1)
        k3$ = HEX$(ASC(k1$)) + HEX$(ASC(k2$))
        IF k3$ = "04B" THEN col = col - 4
        IF k3$ = "04D" THEN col = col + 4
        IF col < 13 THEN col = 25
        IF col > 25 THEN col = 13
        LOCATE row, col, 1
    END IF

LOOP

'--------------------------------------------------
' Calcolo punteggio finale
'--------------------------------------------------
t2 = TIMER
IF nero = 4 THEN
    IF Lev = 1 OR Lev = 10 THEN ScoreLev = 1
    IF Lev = 2 OR Lev = 9 THEN ScoreLev = 2
    IF Lev = 3 OR Lev = 8 THEN ScoreLev = 3
    IF Lev = 4 OR Lev = 7 THEN ScoreLev = 4
    IF Lev = 5 OR Lev = 6 THEN ScoreLev = 5
    Punti = INT(((10000 * ScoreLev) - (100 * (t2 - t1)) - (10 * mind)))
ELSE
    Punti = 0
END IF

'--------------------------------------------------
' Stampa codice e punteggio
'--------------------------------------------------
COLOR 16
LOCATE 3, 12: COLOR , a: PRINT ; a;
LOCATE , 16: COLOR , b: PRINT ; b;
LOCATE , 20: COLOR , c: PRINT ; c;
LOCATE , 24: COLOR , d: PRINT ; d;
COLOR 15, 4
LOCATE 20, 38: PRINT CHR$(201); STRING$(32, 205); CHR$(187)
LOCATE , 40: PRINT " RESULT "
FOR i = 21 TO 23
    LOCATE i, 38: PRINT CHR$(186); SPC(32); CHR$(186)
NEXT
LOCATE 24, 38: PRINT CHR$(200); STRING$(32, 205); CHR$(188);
LOCATE 21, 40: PRINT "Your score is"; Punti

'--------------------------------------------------
' Gestione nuovo record
'--------------------------------------------------
IF Punti > VAL(record$(10)) THEN
    COLOR 31, 4
    LOCATE 22, 47: PRINT "NEW HIGHT SCORE !"
    COLOR 14
    LOCATE 23, 40, 1, 6, 7: PRINT "Enter your name: ";
    COLOR 10
    GOSUB InsName
END IF

'--------------------------------------------------
' Chiede se giocare ancora
'--------------------------------------------------
PullOff = 1
LOCATE 22, 40: PRINT "Mind"; mind; "- Row"; Lev; "- Sec"; INT(t2 - t1)
COLOR 31, 4
LOCATE 23, 40, 1, 6, 7: PRINT "Play again (Y/N)?              ";
GOSUB classification
LOCATE 23, 58, 1
a$ = INPUT$(1)
IF UCASE$(a$) = "N" THEN
    COLOR 0, 1
    LOCATE 25, 26, 0: PRINT "PD 10.10.1985 by Marco da Venezia";
    SLEEP (1)
    SCREEN , , 0
    COLOR 7, 0
    CLS
    END
ELSE
    RUN
END IF

'--------------------------------------------------
' Sottomenu classifica
'--------------------------------------------------
classification:
r1 = CSRLIN: c1 = POS(1)
PCOPY 0, 1
SCREEN , , 1
COLOR 0, 3
LOCATE 7, 26: PRINT CHR$(201); STRING$(32, 205); CHR$(187);
LOCATE , 28: PRINT " CLASSIFICATION "
FOR i = 8 TO 18
    LOCATE i, 26: PRINT CHR$(186); SPACE$(32); CHR$(186)
NEXT
LOCATE 19, 26: PRINT CHR$(200); STRING$(32, 205); CHR$(188)
FOR i = 1 TO 10
    IF i = 1 THEN COLOR 4 ELSE COLOR 1
    LOCATE 8 + i, 28: PRINT i; record$(i)
NEXT

IF PullOff = 1 THEN
    PullOff = 0
    RETURN
END IF
WHILE INKEY$ = "": WEND
SCREEN , , 0
LOCATE r1, c1, 1
RETURN

'--------------------------------------------------
' Inserimento nome record
'--------------------------------------------------
InsName:
DO
    a$ = INPUT$(1)
    col = POS(1): n = col - 55
    IF a$ = CHR$(13) THEN EXIT DO
    IF a$ = CHR$(8) THEN
        IF col = 57 THEN col = 58
        LOCATE 23, col - 1: PRINT CHR$(32); : LOCATE 23, col - 1
        Names$(n - 1) = ""
    END IF
    IF UCASE$(a$) >= "A" AND UCASE$(a$) <= "Z" THEN
        IF col = 71 THEN col = 70: n = 15
        Names$(n) = a$
        LOCATE 23, col: PRINT a$;
    END IF
LOOP

'--------------------------------------------------
' Aggiornamento record e ordinamento
'--------------------------------------------------
FOR i = 1 TO 15: Names$ = Names$ + Names$(i): NEXT
IF Names$ = "" THEN Names$ = "Master Mind"
record$(10) = STR$(Punti) + "  " + Names$ + " " + STR$(Lev)
FOR i = 1 TO 9
    FOR j = 1 TO 10 - i
        IF VAL(record$(j)) < VAL(record$(j + 1)) THEN SWAP record$(j), record$(j + 1)
    NEXT j
NEXT i

'--------------------------------------------------
' Salvataggio record su file
'--------------------------------------------------
OPEN "O", #1, "MMIND.DAT"
FOR i = 1 TO 10
    PRINT #1, record$(i)
NEXT
CLOSE
RETURN

