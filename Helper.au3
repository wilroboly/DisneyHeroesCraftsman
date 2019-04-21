;-------------------------------------------------------------------------------
; Helper Routines
;-------------------------------------------------------------------------------
Func WaitForScreenText($GUIText)
  $ABORT = false
  ;  MouseMove(0,0,1)
  ;  Print(StringFormat("Waiting for %s User Interface", $GUIText))
  ;  while NOT WinActive("Diablo III")
  ;    WinActivate("Diablo III")
  ;    sleep(100)
  ;  wend

  Print("Waiting for " & $GUIText)
  DO
    ; Position of the Window Label "ENCHANT"
    local $text = OpticalRead($windowLabelLeft,$windowLabelTop,$windowLabelRight,$windowLabelBottom)
    Print(StringFormat("Waiting for %s - Response: %s " & @CRLF & "at (%d,%d) x (%d,%d) ", $GUIText, $text, $windowLabelLeft,$windowLabelTop,$windowLabelRight,$windowLabelBottom))
    sleep(500)
  UNTIL StringInStr($text,$GUIText)>0
  Print($GUIText & " Ready!")
  return(1)
EndFunc

Func WaitDiablo3($GUIText)
  $ABORT = false
  ;  MouseMove(0,0,1)
  ;  Print(StringFormat("Waiting for %s User Interface", $GUIText))
  ;  while NOT WinActive("Diablo III")
  ;    WinActivate("Diablo III")
  ;    sleep(100)
  ;  wend

  Print("Waiting for " & $GUIText)
  DO
    ; Position of the Window Label "ENCHANT"
    local $text = OpticalRead($windowLabelLeft,$windowLabelTop,$windowLabelRight,$windowLabelBottom)
    Print(StringFormat("Waiting for %s - Response: %s " & @CRLF & "at (%d,%d) x (%d,%d) ", $GUIText, $text, $windowLabelLeft,$windowLabelTop,$windowLabelRight,$windowLabelBottom))
    sleep(500)
  UNTIL StringInStr($text,$GUIText)>0
  Print($GUIText & " Ready!")
  return(1)
EndFunc

Func GetNumber($temp)
  $temp = StringRegExpReplace($temp, "(?<=\d)O", "0")
  $temp = StringReplace($temp,",","")
  $temp = StringReplace($temp,"%","")
  local $result = StringRegExp($temp, "(?<=[\( +-])([0-9\.]+)",3)
  If @error then
    return(0)
  elseif UBound($result) = 1 then
    return(Number($result[0]))
  elseif UBound($result) = 2 then
    if ($result[1] > 0) then
      return((Number($result[0]) + Number($result[1]))/2)
    else
      return(Number($result[0]))
    endif
  endif
EndFunc

Func OpticalRead($x1,$y1,$x2,$y2)
  ;Print( stringformat("%02d:%02d:%02d OCR",@HOUR,@MIN,@SEC) )
  ClipPut("")
  $cli_cmd = stringformat("%s %d %d %d %d %s ", 'C:\Capture2Text\Capture2Text_CLI.exe -s "' , $x1, $y1, $x2, $y2, '" --clipboard')
  RunWait(@ComSpec & " /c" & $cli_cmd, 'C:\Capture2Text\', @SW_HIDE)
  sleep(100)
  return( ClipGet() )
EndFunc

Func OptionPosition(ByRef $position, $leading, $iY)
  $value = (20 * ($position-1)) + $leading + $iY
  $position = $position + 1
  Return $value
EndFunc

