' Didattica Mistermind 6 colori con ripetizioni - QB64
' Tutte le combinazioni: 6^4 = 1296
' Layout grafico 1600x900, messaggio passo-passo, cursore lampeggiante
' Pallini colorati con numero bianco nei tentativi (sinistra)
' Pioli neri e bianchi con riquadro blu
' Cifre colorate nelle combinazioni compatibili (destra)
' PD 2025 by Marco da Venezia

DECLARE SUB Feedback (Secret%(), idx%, g1%, g2%, g3%, g4%, blacks%, whites%)
DECLARE SUB CerchioPieno (x AS INTEGER, y AS INTEGER, r AS INTEGER, colore AS _UNSIGNED LONG)
DECLARE SUB DisegnaPallino (x AS INTEGER, y AS INTEGER, num AS INTEGER, colore AS _UNSIGNED LONG)
DECLARE SUB DisegnaFeedback (x AS INTEGER, y AS INTEGER, colore AS _UNSIGNED LONG)

DefInt A-Z

Const MAXCODES = 1296
Dim Secret(1 To MAXCODES, 1 To 4)
Dim Alive(1 To MAXCODES)
Dim Guess(1 To 4)
Dim FeedbackMatrix(1 To MAXCODES, 1 To MAXCODES, 2)

Dim Shared Colori(1 To 6) As _Unsigned Long

' Finestra grafica
Screen _NewImage(1600, 900, 32)
_Title "* Fulmine Logico *"
'_CURSORSHOW
_Font 16
Cls

' Inizializza palette colori
Colori(1) = _RGB32(255, 64, 64) ' Rosso
Colori(2) = _RGB32(64, 220, 64) ' Verde
Colori(3) = _RGB32(64, 128, 255) ' Blu
Colori(4) = _RGB32(255, 220, 64) ' Giallo
Colori(5) = _RGB32(255, 96, 255) ' Magenta
Colori(6) = _RGB32(64, 220, 220) ' Ciano

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

'Color _RGB32(255, 255, 255)
'_PrintString (xTent + 200, 20), "Segreto: " + Str$(Secret(idxSegreta, 1)) + " " + Str$(Secret(idxSegreta, 2)) + " " + Str$(Secret(idxSegreta, 3)) + " " + Str$(Secret(idxSegreta, 4))

For j = 1 To 4
    cx = xTent + 250 + (j - 1) * 45
    cy = 20 + 10
    DisegnaPallino cx, cy, Secret(idxSegreta, j), Colori(Secret(idxSegreta, j))
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

    ' === MOSTRA TENTATIVO (SINISTRA) con PALLINI + NUMERO BIANCO ===
    _PrintString (xTent, yTent), "Tentativo " + LTrim$(Str$(level)) + ":"
    baseX = xTent + 200
    stepX = 45
    For j = 1 To 4
        cx = baseX + (j - 1) * stepX
        cy = yTent + 10
        DisegnaPallino cx, cy, Guess(j), Colori(Guess(j))
    Next

    ' Pioli feedback (neri e bianchi) con riquadro blu
    feedStartX = baseX + 4 * stepX + 30
    feedY = yTent + 10
    For k = 1 To nb
        DisegnaFeedback feedStartX + (k - 1) * 22, feedY, _RGB32(0, 0, 0)
    Next
    For k = 1 To nw
        DisegnaFeedback feedStartX + (nb + k - 1) * 22, feedY, _RGB32(255, 255, 255)
    Next

    ' (facoltativo) testo riassuntivo
    Color _RGB32(255, 255, 255)
    _PrintString (feedStartX + (nb + nw) * 22 + 15, yTent), "Neri=" + Str$(nb) + "  Bianchi=" + Str$(nw)

    yTent = yTent + 32

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

    ' === AREA DESTRA (COMPATIBILI) CON CIFRE COLORATE ===
    Color _RGB32(200, 200, 255)
    Line (800, 80)-(1590, 880), _RGB32(50, 50, 50), BF
    _PrintString (810, 90), "Restano " + LTrim$(Str$(remain)) + " codici compatibili:"
    riga = 120: colonna = 810: count = 0
    For i = 1 To idx
        If Alive(i) Then
            xx = colonna
            For j = 1 To 4
                Color Colori(Secret(i, j))
                _PrintString (xx, riga), LTrim$(Str$(Secret(i, j)))
                xx = xx + 12
            Next
            Color _RGB32(200, 200, 255)
            _PrintString (xx, riga), ""
            colonna = colonna + 55 '45
            count = count + 1
            If count Mod 14 = 0 Then
                riga = riga + 20
                colonna = 810
            End If
        End If
    Next
    Color _RGB32(255, 255, 255)

    ' Verifica se trovato
    If nb = 4 Then
        Color _RGB32(0, 255, 0)
        _PrintString (600, 450), "SEGRETO DETERMINATO!"
        _PrintString (620, 480), Str$(Secret(idxSegreta, 1)) + " " + Str$(Secret(idxSegreta, 2)) + " " + Str$(Secret(idxSegreta, 3)) + " " + Str$(Secret(idxSegreta, 4))
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

'k$ = Input$(1)
End

'---------------------------------------
Sub CerchioPieno (x As Integer, y As Integer, r As Integer, colore As _Unsigned Long)
    Circle (x, y), r, colore
    Paint (x, y), colore, colore
End Sub

'---------------------------------------
Sub DisegnaPallino (x As Integer, y As Integer, num As Integer, colore As _Unsigned Long)
    ' Disco base
    CerchioPieno x, y, 12, colore
    ' Numero in bianco acceso (centratura semplice)
    Color _RGB32(255, 255, 255)
    _PrintString (x - 5, y - 6), LTrim$(Str$(num))
End Sub

'---------------------------------------
Sub DisegnaFeedback (x As Integer, y As Integer, colore As _Unsigned Long)
    ' Riquadro blu di sfondo per visibilità
    Line (x - 10, y - 10)-(x + 10, y + 10), _RGB32(64, 128, 255), BF
    ' Cerchio pieno dentro
    CerchioPieno x, y, 8, colore
End Sub

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


