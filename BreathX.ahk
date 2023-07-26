#SingleInstance Force

; Breathing Configs (in Millisecond)
inhaleDuration := 4000
pauseAfterInhale := 7000
exhaleDuration := 8000
pauseAfterExhale := 100

width := 0
if (inhaleDuration > exhaleDuration)
    width := inhaleDuration / 20
else
    width := exhaleDuration / 20

Gui +AlwaysOnTop +LastFound +ToolWindow
Gui, Color, cFFFFFF
Gui, Margin, 0
gui, +Resize
Gui, Add, Progress, x0 y1 w%width% h99 c666666 backgroundFFFFFF vProgressBox hwndhProgress, 100

windowLeftPosition := A_ScreenWidth - (width + 10)
windowTopPosition := A_ScreenHeight - 171
Gui, Show, x%windowLeftPosition% y%windowTopPosition% w%width% h100, BreathX

WinID := WinExist("A")

inhaleStepTime := inhaleDuration / 100
exhaleStepTime := exhaleDuration / 100

SetTimer, ShowProgress, -500
Return

 ShowProgress:
    boxLeft := 0

    Loop
    {
        ; Inhale
        timeTaken := 0
        tick := A_TickCount
        WinSetTitle, ahk_id %WinID%, , BreathX - Inhale
        While timeTaken <= inhaleDuration
        {
            boxWidth := width - (boxLeft * 2)

            GuiControl, Move, ProgressBox, x%boxLeft% w%boxWidth%
            Sleep, %inhaleStepTime%

            boxLeft := boxLeft + 2
            timeTaken := A_TickCount - tick
        }

        boxLeft := boxLeft - 2

        ; Pause
        WinSetTitle, ahk_id %WinID%, , BreathX - Hold
        GuiControl, +c444444, ProgressBox
        Sleep pauseAfterInhale
        GuiControl, +c666666, ProgressBox
        WinSet, ExStyle, -0x00020000, ahk_id %hProgress%

        ; Exhale
        timeTaken := 0
        tick := A_TickCount
        WinSetTitle, ahk_id %WinID%, , BreathX - Exhale
        While timeTaken <= exhaleDuration
        {
            boxWidth := width - (boxLeft * 2)

            GuiControl, Move, ProgressBox, x%boxLeft% w%boxWidth%
            Sleep, %exhaleStepTime%

            boxLeft := boxLeft - 2
            timeTaken := A_TickCount - tick
        }

        boxLeft := 0

        ; Pause
        WinSetTitle, ahk_id %WinID%, , BreathX - Hold
        GuiControl, +c444444, ProgressBox
        Sleep pauseAfterExhale
        GuiControl, +c666666, ProgressBox
        WinSet, ExStyle, -0x00020000, ahk_id %hProgress%
     } 

GuiSize:
    WinSet, ExStyle, -0x00020000, ahk_id %hProgress%
    Return
