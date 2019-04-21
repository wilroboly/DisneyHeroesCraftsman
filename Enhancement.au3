;-------------------------------------------------------------------------------
; Ctrl-Alt Routines
;-------------------------------------------------------------------------------
HotKeySet( "^!e",  "EnhanceSkills" )
Func EnhanceSkills($Param)
  WaitForScreenText("ENHANCEMENT")

  local $AddMultiple  = GUICtrlRead($hInput1)
  local $RemoveMultiple  = GUICtrlRead($hInput2)

  local $OCR,$number
  local $text="Waiting for Item"

  local $mouseClickPosX = Floor(400*$sRatio)

  local $titleBarLeft = Floor(125*$sRatio)
  local $titleBarTop = Floor(349*$sRatio)
  local $titleBarRight = Floor(400*$sRatio)
  local $titleBarBottom = Floor(367*$sRatio)

  ; Screen Locations of title bar
  local $x1=Floor(77*$sRatio), $x2=Floor(440*$sRatio)
  local $y0=Floor(395*$sRatio), $dy=Floor(44*$sRatio)

  if ($AddMultiple > 1) Then
    $Attempts = $AddMultiple
  EndIf

  If ($RemoveMultiple > 1) Then
    $Attempts = $RemoveMultiple
  EndIf

  ; Position of the material button
  MouseGetPos EnchantX, EnchantY

  ;move mouse out of the way all the time to prevent interference
  ;~ MouseMove($EnchantX,$EnchantY,1)

  WHILE (($Attempts>0) AND ($ABORT=false))
    if ($CheckSumReplace=0) then
      ; Position of the "Replace a Previously Enchanted Property" or "Select a Property to Replace"or "Select Replacement Property" header
      ;Print("read title bar")
      $text = OpticalRead($titleBarLeft,$titleBarTop,$titleBarRight,$titleBarBottom)    ;read title bar
	    Print("Current Text: " & $text)
      ;~ if StringInStr($text, "Replace a Previously Enchanted Property")>0 then
      ;~   $CheckSumReplace = PixelCheckSum($checkSumLeft,$checkSumTop,$checkSumRight,$checkSumBottom)
      ;~   $text = "Item is Ready for Enchantment"
      ;~ endif
    ;~ elseif $CheckSumReplace = PixelCheckSum($checkSumLeft,$checkSumTop,$checkSumRight,$checkSumBottom) then
    ;~   ;      Print("click reroll bar")
    ;~   ClickMouse("left", $EnchantX, $EnchantY, 1, 10)      ;click REROLL bar until actual enchanting
    ;~   sleep(250)
    ;~ elseif SearchPixel($x1, $y0+$dy*2, $x2, $y0+$dy*2, 0x6969FF, 4) then
    ;~   ;      Print("here they come")
    ;~   $text = ""
    ;~   if ($ThisChoice=-1) then
    ;~     $OCR = OpticalRead($x1,$y0+$dy*0-$fontHeight,$x2,$y0+$dy*0+$fontHeight)
    ;~     if StringInStr($OCR, $DesiredProperty) then
    ;~       $number = GetNumber($OCR)
    ;~       if ($number >= $ThisNumber) then
    ;~         $ThisChoice = 0
    ;~         $ThisNumber = $number
    ;~       endif
    ;~     endif
    ;~   endif

    ;~   ;1st Random Choice
    ;~   $OCR = OpticalRead($x1,$y0+$dy*1-$fontHeight,$x2,$y0+$dy*1+$fontHeight)
    ;~   $number = GetNumber($OCR)
    ;~   $text &= "(" & $number & ") " & $OCR & @CRLF
    ;~   if StringInStr($OCR, $DesiredProperty) then
    ;~     if ($number >= $ThisNumber) then
    ;~       $ThisChoice = 1
    ;~       $ThisNumber = $number
    ;~     endif
    ;~   endif

    ;~   ;2nd Random Choice
    ;~   $OCR = OpticalRead($x1,$y0+$dy*2-$fontHeight,$x2,$y0+$dy*2+$fontHeight)
    ;~   $number = GetNumber($OCR)
    ;~   $text &= "(" & $number & ") " & $OCR & @CRLF
    ;~   if StringInStr($OCR, $DesiredProperty) then
    ;~     if ($number >= $ThisNumber) then
    ;~       $ThisChoice = 2
    ;~       $ThisNumber = $number
    ;~     endif
    ;~   endif

    ;~   Print("Counter: " & $Attempts & @CRLF & "Current Value: " & $ThisNumber & "/" & $DesiredNumber & "/" & $number & " " & $DesiredProperty & @CRLF & $text)
    ;~   while SearchPixel($searchPixelLeft, $searchPixelTop, $searchPixelRight, $searchPixelBottom, 0x6969FF, 4)
    ;~     ;while there are still 2 rerolls to choose
    ;~     if ($ThisChoice=-1) then
    ;~       ClickMouse("left", $mouseClickPosX, $y0+$dy*0, 1, 10)
    ;~     else
    ;~       ClickMouse("left", $mouseClickPosX, $y0+$dy*$ThisChoice, 1, 10)
    ;~     endif
    ;~     ClickMouse("left", $EnchantX, $EnchantY, 1, 10)
    ;~     sleep(500)
    ;~   wend
    ;~   $Attempts -= 1
    ;~   if $ThisChoice>0 then
    ;~     $ThisChoice = 0
    ;~   endif
    ;~   if ($ThisNumber>=$DesiredNumber) then
    ;~     exitloop
    ;~   endif
    endif
    ;Print("Counter: " & $Attempts & @CRLF & "Current Value: " & $ThisNumber & @CRLF & $text)
    Sleep(100)
  WEND
  Print("Done")
  $ABORT = true

  Return True
EndFunc
