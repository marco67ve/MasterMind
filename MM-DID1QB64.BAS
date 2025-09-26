' Didattica Mistermind 6 colori con ripetizioni - QB64
' Tutte le combinazioni: 6^4 = 1296
' Layout grafico 1600x900, messaggio passo-passo, cursore lampeggiante
' PD 2008 by Marco da Venezia

DECLARE SUB Feedback (Secret%(), idx%, g1%, g2%, g3%, g4%, blacks%, whites%)
DefInt A-Z

Const MAXCODES = 1296
Dim Secret(1 To MAXCODES, 1 To 4)
Dim Alive(1 To MAXCODES)
Dim Guess(1 To 4)
Dim FeedbackMatrix(1 To MAXCODES, 1 To MAXCODES, 2)

' Finestra grafica
Screen _NewImage(1600, 900, 32)
_Title "? Fulmine Logico ?"
_Font 16
Cls

' Genera tutte le 1296 combinazioni (con ripetizioni)
idx = 0
For a = 1 To 6
    For b = 1 To 6
        For c = 1 To 6
            For d = 1 To 6
                idx = idx + 1
                Secret(idx, 1) = a
                Secret(idx, 2) = b
                Secret(idx, 3) = c
                Secret(idx, 4) = d
            Next d
        Next c
    Next b
Next a

For i = 1 To idx
    Alive(i) = -1
Next

' Precalcolo dei feedback tra tutte le coppie
For i = 1 To idx
    For j = 1 To idx
        Call Feedback(Secret(), i, Secret(j, 1), Secret(j, 2), Secret(j, 3), Secret(j, 4), b, w)
        FeedbackMatrix(i, j, 1) = b
        FeedbackMatrix(i, j, 2) = w
    Next
Next

' Titolo a video
_PrintString (600, 20), "ASSISTENTE MASTERMIND (6 colori, con ripetizioni)"
Line (0, 60)-(1600, 60), _RGB32(255, 255, 255)

Randomize Timer
idxSegreta = Int(Rnd * idx) + 1
Color _RGB32(255, 255, 255)
_PrintString (50, 20), "Segreto: "
For i = 1 To 4
    _PrintString (240 + col, 20), Str$(Secret(idxSegreta, i))
    col = col + 50
Next

level = 1
xTent = 50: yTent = 100
Do
    ' Primo tentativo casuale
    If level = 1 Then
        Dim Temp(1 To 6)
        For i = 1 To 6: Temp(i) = i: Next
        For i = 6 To 1 Step -1
            j = Int(i * Rnd) + 1
            Swap Temp(i), Temp(j)
        Next
        For i = 1 To 4: Guess(i) = Temp(i): Next
    End If

    ' Calcolo feedback automatico
    Call Feedback(Secret(), idxSegreta, Guess(1), Guess(2), Guess(3), Guess(4), nb, nw)

    ' Mostra tentativo
    _PrintString (xTent, yTent), "Tentativo " + LTrim$(Str$(level)) + ":"
    col = xTent + 200
    For i = 1 To 4
        Color _RGB32(255, 255, 0)
        _PrintString (col, yTent), LTrim$(Str$(Guess(i)))
        col = col + 50
    Next
    Color _RGB32(255, 255, 255)
    _PrintString (col + 50, yTent), "Neri=" + Str$(nb) + "  Bianchi=" + Str$(nw)

    yTent = yTent + 30

    ' Filtra i segreti compatibili
    remain = 0
    For i = 1 To idx
        If Alive(i) = -1 Then
            Call Feedback(Secret(), i, Guess(1), Guess(2), Guess(3), Guess(4), blacks, whites)
            If blacks = nb And whites = nw Then
                remain = remain + 1
            Else
                Alive(i) = 0
            End If
        End If
    Next

    ' Area destra per codici compatibili
    Color _RGB32(200, 200, 255)
    Line (900, 80)-(1590, 880), _RGB32(50, 50, 50), BF
    _PrintString (910, 90), "Restano " + LTrim$(Str$(remain)) + " codici compatibili:"

    riga = 120: colonna = 910: count = 0
    For i = 1 To idx
        If Alive(i) Then
            codice$ = ""
            For j = 1 To 4: codice$ = codice$ + LTrim$(Str$(Secret(i, j))): Next
            codice$ = codice$ + " "
            _PrintString (colonna, riga), codice$
            colonna = colonna + 45
            count = count + 1
            If count Mod 15 = 0 Then
                riga = riga + 20
                colonna = 910
            End If
        End If
    Next

    ' Verifica se trovato
    If nb = 4 Then
        Color _RGB32(0, 255, 0)
        _PrintString (600, 450), "SEGRETO DETERMINATO"
        '_PrintString (600, 480), Str$(Secret(idxSegreta, 1)) + " " + Str$(Secret(idxSegreta, 2)) + " " + Str$(Secret(idxSegreta, 3)) + " " + Str$(Secret(idxSegreta, 4))
        Exit Do
    End If

    ' Messaggio passo-passo con "lampeggio"
    Do
        Color _RGB32(180, 180, 180)
        _PrintString (400, 860), "Premi un tasto per continuare..."
        _Delay 0.5
        Line (400, 800)-(780, 880), _RGB32(0, 0, 0), BF
        _Delay 0.5
        If InKey$ <> "" Then Exit Do
    Loop

    Line (400, 860)-(780, 880), _RGB32(0, 0, 0), BF

    ' Calcolo mossa ottimale
    Dim FeedbackCount(0 To 4, 0 To 4)
    bestScore = MAXCODES + 1: bestIdx = 0

    For t = 1 To idx
        For b = 0 To 4: For w = 0 To 4: FeedbackCount(b, w) = 0: Next: Next
        For i = 1 To idx
            If Alive(i) Then
                b = FeedbackMatrix(i, t, 1)
                w = FeedbackMatrix(i, t, 2)
                FeedbackCount(b, w) = FeedbackCount(b, w) + 1
            End If
        Next
        worst = 0
        For b = 0 To 4: For w = 0 To 4
                If FeedbackCount(b, w) > worst Then worst = FeedbackCount(b, w)
        Next: Next
        If worst < bestScore Then
            bestScore = worst: bestIdx = t
        ElseIf worst = bestScore Then
            If Alive(t) = -1 Then bestIdx = t
        End If
    Next

    If bestIdx > 0 Then
        For j = 1 To 4: Guess(j) = Secret(bestIdx, j): Next
    End If

    level = level + 1
    If level > 10 Then
        Color _RGB32(255, 0, 0)
        _PrintString (600, 450), "LIMITE 10 MOSSE RAGGIUNTO"
        Exit Do
    End If
Loop

Sleep
End

'---------------------------------------
Sub Feedback (Secret(), idx, g1, g2, g3, g4, blacks, whites)
    Dim CountS(1 To 6), CountG(1 To 6)
    Dim k
    blacks = 0: whites = 0
    For k = 1 To 6: CountS(k) = 0: CountG(k) = 0: Next
    If Secret(idx, 1) = g1 Then blacks = blacks + 1
    If Secret(idx, 2) = g2 Then blacks = blacks + 1
    If Secret(idx, 3) = g3 Then blacks = blacks + 1
    If Secret(idx, 4) = g4 Then blacks = blacks + 1
    CountS(Secret(idx, 1)) = CountS(Secret(idx, 1)) + 1
    CountS(Secret(idx, 2)) = CountS(Secret(idx, 2)) + 1
    CountS(Secret(idx, 3)) = CountS(Secret(idx, 3)) + 1
    CountS(Secret(idx, 4)) = CountS(Secret(idx, 4)) + 1
    CountG(g1) = CountG(g1) + 1
    CountG(g2) = CountG(g2) + 1
    CountG(g3) = CountG(g3) + 1
    CountG(g4) = CountG(g4) + 1
    For k = 1 To 6
        If CountS(k) < CountG(k) Then
            whites = whites + CountS(k)
        Else
            whites = whites + CountG(k)
        End If
    Next
    whites = whites - blacks
End Sub

