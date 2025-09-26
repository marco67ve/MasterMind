10 ' MASTER MIND per MS/PC-DOS
20 ' 10.10.85 by Marco da Venezia
30 ' Esperimento scritto in GWBASIC
40 ' Richiede CGA (o superiore)
41 ' ------------------------------
45 KEY OFF ' abilita la riga 25 in GWBASIC
46 ' ------------------------------
50 ' controlla CGA
60 DEF SEG = &H40
70 IF PEEK(&H49) = &H7 THEN PRINT "Scheda video monochrome.": PRINT "Master Mind richiede CGA o superiore.": END
71 ' ------------------------------
80 DIM VEC(4), FIN(4), RECORD$(10), NAMES$(16)
81 ' ------------------------------
90 ' genera 4 colori unici casuali
100 RANDOMIZE TIMER
110 a = INT(6 * RND + 1)
120 b = INT(6 * RND + 1): IF b = a GOTO 120
130 c = INT(6 * RND + 1): IF c = b OR c = a GOTO 130
140 d = INT(6 * RND + 1): IF d = c OR d = b OR d = a GOTO 140
141 ' ------------------------------
150 ' crea e/o carica punteggi
160 OPEN "A", #1, "MMIND.DAT": CLOSE
170 OPEN "I", #1, "MMIND.DAT"
180 WHILE NOT EOF(1)
190     I = I + 1
200     LINE INPUT #1, RECORD$(I)
210 WEND
220 CLOSE
221 ' ------------------------------
230 ' cancella schermo in blu
240 SCREEN , , 0: COLOR 7, 1: CLS
250 ' disegna tavola
260 COLOR 0, 7
270 LOCATE 2, 10, 0: PRINT "…"; STRING$(17, 205); "ª";
280 LOCATE 4, 10: PRINT "Ã"; STRING$(17, 205); "π";
290     FOR I = 3 TO 23 STEP 2
300         LOCATE I, 10:     PRINT "∫  o   o   o   o  ∫";
310         LOCATE I + 1, 10: PRINT "∫"; SPACE$(17); "∫";
320     NEXT
330 LOCATE 4, 10: PRINT "Ã"; STRING$(17, 205); "π";
340 LOCATE 24, 10: PRINT "»"; STRING$(17, 205); "º";
350 ' disegna panello funzioni
360 COLOR 7, 0
370 LOCATE 11, 38: PRINT "…Õ FUNCTION "; STRING$(21, 205); "ª"
380     FOR I = 12 TO 21
390         LOCATE I, 38: PRINT "∫"; SPACE$(32); "∫"
400     NEXT
410 LOCATE 22, 38: PRINT "»"; STRING$(32, 205); "º"
420 ' stampa descrizioni panello
430 LOCATE 13, 46: PRINT "Blue"; TAB(60); "TIMER"
440 LOCATE , 46: PRINT "Green"; TAB(60); "Mind"
450 LOCATE , 46: PRINT "Cyan"; TAB(60); "Row"
460 LOCATE , 46: PRINT "Red"
470 LOCATE , 46: PRINT "Pink"
480 LOCATE , 46: PRINT "Yellow"
490 LOCATE 20, 41: PRINT "[ TAB ]  Top 10"
500 LOCATE , 41: PRINT "[ ESC ]  End Game"
510 FOR I = 1 TO 6
520     LOCATE 12 + I, 41: COLOR 0, I: PRINT I
530 NEXT
540 ' messaggio lampeggiante
550 COLOR 31, 1
560 LOCATE 24, 44: PRINT "Press any key to start";
570 ' genera la scritta MASTER MIND in ASCII art
580 WHILE INKEY$ = ""
590     FOR I = 1 TO 4 'STEP .25 'regola eventuale effetto strobo'
600         'SOUND 0, 3 'fissa ritardo a prescindere da Hz CPU
610         C1 = INT(3 * RND + 9)
620         COLOR C1: LOCATE 2, 35:    PRINT "‹   ‹  ‹‹‹   ‹‹‹  ‹‹‹‹‹ ‹‹‹‹ ‹‹‹ "
630         COLOR C1 + 1: LOCATE , 35: PRINT "€‹ ‹€ €   € €   ﬂ   €   €    €  €"
640         COLOR C1 + 2: LOCATE , 35: PRINT "€ ﬂ € €ﬂﬂﬂ€  ﬂﬂﬂ‹   €   €ﬂﬂ  €ﬂﬂ‹"
650         COLOR C1 + 3: LOCATE , 35: PRINT "€   € €   € ﬂ‹‹‹ﬂ   €   €‹‹‹ €  €"
660         COLOR C1 + 3: LOCATE , 51: PRINT "‹   ‹  ‹‹‹  ‹   ‹  ‹‹‹  "
670         COLOR C1 + 2: LOCATE , 51: PRINT "€‹ ‹€   €   €‹  €  €  € "
680         COLOR C1 + 1: LOCATE , 51: PRINT "€ ﬂ €   €   € ﬂ‹€  €  € "
690         COLOR C1: LOCATE , 51:     PRINT "€   €  ‹€‹  €   €  €‹‹ﬂ "
700     NEXT
710 WEND
711 ' ------------------------------
720 ' inizia gioco
730 LOCATE 24, 44: PRINT SPACE$(23); ' cancella messaggio lampeggiante
740 T1 = TIMER ' memorizza valore timer
750 LOCATE 23, 13, 1, 1, 7 ' posiziona cursore pieno su primo livello
760 ' intercetta tasti
770 ROW = CSRLIN: COL = POS(1)
780 IF K$ <> "" GOTO 790 ELSE 830
790     LOCATE 13, 65, 0: COLOR 23, 0: PRINT INT(TIMER - T1)
800     LOCATE , 65: COLOR 15, 0: PRINT MIND
810     LOCATE , 65: PRINT 1 + LEV
820     LOCATE ROW, COL, 1
830 K$ = INKEY$
840 IF LEN(K$) = 1 GOTO 850 ELSE 1200
850     ' Esc salta in Terminando
860     IF K$ = CHR$(27) GOTO 1300
870     ' Tab salta in Classification e ritorna
880     IF K$ = CHR$(9) THEN GOSUB 1770
890     IF K$ = CHR$(13) THEN GOTO 900 ELSE 1090
900         ' se VEC non contiene 4 pioli, torna in attesa
910         FOR I = 1 TO 4
920             IF VEC(I) = 0 GOTO 770
930         NEXT
940         LEV = LEV + 1
950         FIN(1) = a: FIN(2) = b: FIN(3) = c: FIN(4) = d
960         NERO = 0: BIANCO = 0
970         FOR I = 1 TO 4
980             IF FIN(I) = VEC(I) THEN FIN(I) = 0: NERO = NERO + 1
990         NEXT
1000        FOR I = 1 TO 4
1010            IF FIN(I) = VEC(1) OR FIN(I) = VEC(2) OR FIN(I) = VEC(3) OR FIN(I) = VEC(4) THEN BIANCO = BIANCO + 1
1020        NEXT
1030        LOCATE ROW, 2: COLOR 7, 0: PRINT ; NERO;
1040        LOCATE ROW, 5: COLOR 0, 7: PRINT ; BIANCO;
1050        IF NERO = 4 OR ROW - 2 = 3 GOTO 1300
1060        LOCATE ROW - 2, 13
1070        ERASE VEC
1080    ' premuto un numero da 1 a 6
1090    IF ASC(K$) > 48 AND ASC(K$) < 55 GOTO 1100 ELSE 1200
1100        MIND = MIND + 1
1110        IF COL = 13 THEN N = 1
1120        IF COL = 17 THEN N = 2
1130        IF COL = 21 THEN N = 3
1140        IF COL = 25 THEN N = 4
1150        VEC(N) = VAL(K$)
1160        COLOR 15, VAL(K$)
1170        LOCATE ROW, COL - 1: PRINT "   ";
1180        LOCATE ROW, COL: PRINT K$: LOCATE ROW, COL
1190 ' tasti direzionali sx e dx
1200 IF LEN(K$) = 2 GOTO 1210 ELSE 1280
1210    K1$ = MID$(K$, 1, 1): K2$ = MID$(K$, 2, 1)
1220    K3$ = HEX$(ASC(K1$)) + HEX$(ASC(K2$))
1230    IF K3$ = "04B" THEN COL = COL - 4
1240    IF K3$ = "04D" THEN COL = COL + 4
1250    IF COL < 13 THEN COL = 25
1260    IF COL > 25 THEN COL = 13
1270    LOCATE ROW, COL, 1
1280 GOTO 770
1281 ' ------------------------------
1290 ' Terminando
1300 T2 = TIMER
1310 IF NERO = 4 GOTO 1320 ELSE 1400  ' se hai risolto calcola punteggio
1320    IF LEV = 1 OR LEV = 10 THEN SCOLEV = 1
1340    IF LEV = 2 OR LEV = 9 THEN SCOLEV = 2
1350    IF LEV = 3 OR LEV = 8 THEN SCOLEV = 3
1360    IF LEV = 4 OR LEV = 7 THEN SCOLEV = 4
1370    IF LEV = 5 OR LEV = 6 THEN SCOLEV = 5
1380    PUNTI = INT(((10000 * SCOLEV) - (100 * (T2 - T1)) - (10 * MIND)))
1390    GOTO 1410
1400 PUNTI = 0 ' se non hai risolto
1405 ' visualizza il codice segreto
1410 COLOR 16
1420 LOCATE 3, 12: COLOR , a: PRINT ; a;
1430 LOCATE , 16: COLOR , b: PRINT ; b;
1440 LOCATE , 20: COLOR , c: PRINT ; c;
1450 LOCATE , 24: COLOR , d: PRINT ; d;
1455 ' panello risultati
1460 COLOR 15, 4
1470 LOCATE 20, 38: PRINT "…Õ RESULT "; STRING$(23, 205); "ª"
1480 FOR I = 21 TO 23
1490    LOCATE I, 38: PRINT "∫"; SPC(32); "∫"
1500 NEXT
1510 LOCATE 24, 38: PRINT "»"; STRING$(32, 205); "º";
1520 LOCATE 21, 40: PRINT "Your score is"; PUNTI
1530 ' punteggio valido (maggiore del pió basso)
1540 IF PUNTI > VAL(R1$) GOTO 1550 ELSE 1600
1550    LOCATE 22, 47: COLOR 31, 4: PRINT "NEW HIGHT SCORE !"
1560    COLOR 14: LOCATE 23, 41, 1, 6, 7: PRINT "Enter your name ";
1570    COLOR 10
1580    GOSUB 1990 ' va all'inserimento del nome
1590 ' terminato
1600 PULLOFF = 1
1610 LOCATE 22, 40: PRINT "Mind"; MIND; "- Row"; LEV; "- Sec"; INT(T2 - T1)
1620 COLOR 31, 4
1630 LOCATE 23, 40, 1, 6, 7: PRINT "Play again (Y/N)?              ";
1640 LOCATE 23, 58, 1
1650 GOSUB 1770 ' va alla classifica
1660 a$ = INPUT$(1)
1670 IF NOT (a$ = "n" OR a$ = "N") THEN RUN
1680 ' esce al DOS
1690 COLOR 0, 1
1700 LOCATE 25, 26, 0: PRINT "PD 10.10.1985 by Marco da Venezia";
1710 WHILE INKEY$ = "": WEND
1720 SCREEN , , 0
1730 COLOR 7, 0
1740 CLS
1750 END
1751 ' ------------------------------
1760 ' classifica
1770 R1 = CSRLIN: C1 = POS(1)
1780 PCOPY 0, 1   ' copia pagina 0 su 1 per popup
1790 SCREEN , , 1 ' passa in pagina 1
1800 ' disegna pannello classifica
1810 COLOR 0, 3
1820 LOCATE 7, 26: PRINT CHR$(201); STRING$(32, 205); CHR$(187);
1830 LOCATE , 28: PRINT " CLASSIFICATION "
1840 FOR I = 8 TO 18
1850    LOCATE I, 26: PRINT CHR$(186); SPACE$(32); CHR$(186)
1860 NEXT
1870 LOCATE 19, 26: PRINT CHR$(200); STRING$(32, 205); CHR$(188)
1875 ' stampa punteggi e nomi
1880 FOR I = 1 TO 10
1890    IF I = 1 THEN COLOR 4 ELSE COLOR 1
1900    LOCATE 8 + I, 28: PRINT I; RECORD$(I)
1910 NEXT
1920 IF PULLOFF = 1 THEN PULLOFF = 0: RETURN ' se terminato ritorna per uscire o riavviare
1930 ' attende un tasto per ritornare in pagina 0
1940 WHILE INKEY$ = "": WEND
1950 SCREEN , , 0
1960 LOCATE R1, C1, 1
1970 RETURN
1971 ' ------------------------------
1980 ' inserimento del proprio nome (15 caratteri)
1990 a$ = INPUT$(1)
2000 COL = POS(1): N = COL - 55
2010 IF a$ = CHR$(13) GOTO 2120 ' va al confronto
2020 IF a$ = CHR$(8) GOTO 2030 ELSE 2060
2030    IF COL = 57 THEN COL = 58
2040    LOCATE 23, COL - 1: PRINT CHR$(32); : LOCATE 23, COL - 1
2050    NAMES$(N - 1) = ""
2060 IF (a$ >= "A" OR a$ > "Z") OR (a$ >= "a" AND a$ <= "z") GOTO 2070 ELSE 1990
2070 IF COL = 71 THEN COL = 70: N = 15
2080 NAMES$(N) = a$
2090 LOCATE 23, COL: PRINT a$;
2100 GOTO 1990
2101 ' ------------------------------
2110 ' confronto
2120 FOR I = 1 TO 15: NAMES$ = NAMES$ + NAMES$(I): NEXT ' compone il nome
2130 IF NAMES$ = "" THEN NAMES$ = "Master Mind" ' se vuoto sarÖ Master Mind
2140 RECORD$(10) = STR$(PUNTI) + "  " + NAMES$ + " " + STR$(LEV) ' costruisce la stringa sul decimo posto
2150 'bubble sort
2160 FOR I = 1 TO 9
2170    FOR J = 1 TO 10 - I
2180        IF VAL(RECORD$(J)) < VAL(RECORD$(J + 1)) THEN SWAP RECORD$(J), RECORD$(J + 1)
2190    NEXT J
2200 NEXT I
2210 ' scrive la classifica su file
2220 OPEN "O", #1, "MMIND.DAT"
2230 FOR I = 1 TO 10
2240    PRINT #1, RECORD$(I)
2250 NEXT
2260 CLOSE
2270 RETURN
3000 ' NOTA: finire di riordinare al meglio i numeri di riga
                          

