;----------------------------------------------------------------------------
; Author:  BurgerKing
;----------------------------------------------------------------------------
GLOBAL $TITLE = "The Lazy Craftsman 2.5";
GLOBAL $sFont = "Courier New"

#include <Color.au3>
;---------------------------------------------------------------------------------------------------
;          D3 Inventory Box Constants
;---------------------------------------------------------------------------------------------------
GLOBAL $InvX=1428.5, $InvY=583      ;Center of top left item on backpack
GLOBAL $DivInvX=50.5        ;inventory square X size
GLOBAL $DivInvY=50        ;inventory square Y size
GLOBAL $TransmuteX=264, $TransmuteY=827    ;transmute button
GLOBAL $CraftedX=280, $CraftedY=420    ;top center item on kanai cube (cell10)
GLOBAL $ForgeX=165, $ForgeY=288
GLOBAL $FillX=718, $FillY=841      ;Kanai Recipe Fill

;----------------------------------------------------------------------------
;      Timing Routines
;----------------------------------------------------------------------------
GLOBAL $ABORT = false
GLOBAL $CLOCK = TimerInit()
GLOBAL $PAUSE = 0
func SetTimeOut($t)
  return( TimerDiff($CLOCK)-$PAUSE+$t )
endfunc

func IsTimeOut($t)
  return( ($t - TimerDiff($CLOCK) + $PAUSE) <= 0 )
endfunc

func GetTimeOut($t)
  return( $t - TimerDiff($CLOCK) + $PAUSE )
endfunc
;---------------------------------------------------------------------------------------------------
;          Screen Functions
;---------------------------------------------------------------------------------------------------
func ClickMouse($button,$x,$y,$c,$s)
  MouseMove($x,$y,1)
  if $s>0 then sleep($s)
  MouseClick($button,$x,$y,$c,0)
endfunc

Func MouseClock()
  local $t = (@SEC+@MSEC/1000) * 2 * 3.141592653589793 / 5    ;5 seconds to make a circle
  MouseMove(960+240*sin($t),100,0)
endfunc

local $PrintTimeOut = SetTimeOut(60000)
func Print($text)
  ToolTip( $text, 265, 190, "", 0, 2)
  $PrintTimeOut = SetTimeOut(5000)
endfunc

func SearchPixel($x1,$y1,$x2,$y2,$color,$tolerance)
  PixelSearch ($x1,$y1,$x2,$y2,$color,$tolerance)
  if @error = 1 then
    return(0)
  else
    return(1)
  endif
endfunc

;----------------------------------------------------------------------------
;      Hotkey Routines
;----------------------------------------------------------------------------
func Terminate()
  exit(-1)
endfunc
func Stop()
  $ABORT = true
endfunc

HotKeySet( "^!u",  "UpgradeRares" )
HotKeySet( "^!c",  "ConvertMaterial" )
HotKeySet( "^!s",  "SalvageLegendary" )
HotKeySet( "^!m",  "Myriam" )
HotKeySet( "^!a",  "Stop" )
HotKeySet( "^!x",  "Terminate" )

;------------------------------------------------------------------------------- 
;  GUI Routines
;------------------------------------------------------------------------------- 
#include <GuiListBox.au3>
#include <GUIConstantsEx.au3>
#include <guiconstants.au3>
#include <ColorConstants.au3>
GLOBAL $DimX = 350
GLOBAL $DimY = 272
GLOBAL $MW = GUICreate($TITLE, $DimX, $DimY)

local $iY=10
local $hGroupA = GUICtrlCreateGroup("",                                5,    $iY, $DimX-10,$DimY-19)
local $hLabelA = GUICtrlCreateLabel($TITLE,                           20,  $iY-5, $DimX-99, 25)
local $hLabelB = GUICtrlCreateLabel("Ctrl-Alt-U: Kanai Upgrade Rare", 20, 25+$iY, $DimX-99, 15)
local $hLabelC = GUICtrlCreateLabel("Ctrl-Alt-C: Kanai Convert Mats", 20, 45+$iY, $DimX-40, 15)
local $hLabelD = GUICtrlCreateLabel("Ctrl-Alt-S: BlackSmith Salvage", 20, 65+$iY, $DimX-40, 15)

$iY += 85
     GUICtrlCreateGroup("",                               11,    $iY, $DimX-22,105)
local $hLabelE = GUICtrlCreateLabel("Ctrl-Alt-M: Myriam Enchantment", 20,    $iY, $DimX-99, 20)
local $hLabel1 = GUICtrlCreateLabel("Property:",          30, 25+$iY,       80, 20)
local $hInput1 = GUICtrlCreateInput("Critical Hit Damage",       115, 22+$iY,$DimX-135, 22)
local $hLabel2 = GUICtrlCreateLabel("Value:   ",          30, 50+$iY,       80, 20)
local $hInput2 = GUICtrlCreateInput("50",           115, 47+$iY,$DimX-135, 22)
local $hLabel3 = GUICtrlCreateLabel("Retry:   ",          30, 75+$iY,       80, 20)
local $hInput3 = GUICtrlCreateInput("100"      ,         115, 72+$iY,$DimX-135, 22)

$iY += 105
     GUICtrlCreateGroup("",                               11,    $iY, $DimX-22, 53)
local $hLabelF = GUICtrlCreateLabel("Ctrl-Alt-A: Abort Current Task", 20, 10+$iY, $DimX-99, 20)
local $hLabelG = GUICtrlCreateLabel("Ctrl-Alt-X: EXIT APPLICATION",   20, 30+$iY, $DimX-99, 20)


;Set Fonts
GUICtrlSetFont($hLabelA,  14, 900, 0, $sFont, 5)
GUICtrlSetFont($hLabelB,  11, 800, 0, $sFont, 5)

GUICtrlSetFont($hLabelC,  11, 800, 0, $sFont, 5)
GUICtrlSetFont($hLabelD,  11, 800, 0, $sFont, 5)
GUICtrlSetFont($hLabelE,  11, 800, 0, $sFont, 5)

GUICtrlSetFont($hLabel1,  11, 800, 0, $sFont, 5)
GUICtrlSetFont($hInput1,  11, 800, 0, $sFont, 5)

GUICtrlSetFont($hLabel2,  11, 800, 0, $sFont, 5)
GUICtrlSetFont($hInput2,  11, 800, 0, $sFont, 5)

GUICtrlSetFont($hLabel3,  11, 800, 0, $sFont, 5)
GUICtrlSetFont($hInput3,  11, 800, 0, $sFont, 5)

GUICtrlSetFont($hLabelF,  11, 800, 0, $sFont, 5)
GUICtrlSetFont($hLabelG,  11, 800, 0, $sFont, 5)

GUICtrlSetColor($hLabelA,0xFF0000)
GUICtrlSetColor($hLabelB,0x0000FF)
GUICtrlSetColor($hLabelC,0x0000FF)
GUICtrlSetColor($hLabelD,0x0000FF)
GUICtrlSetColor($hLabelE,0x0000FF)
GUICtrlSetColor($hLabelF,0x0000FF)
GUICtrlSetColor($hLabelG,0x0000FF)

;------------------------------------------------------------------------------- 
;------------------------------------------------------------------------------- 
func GetNumber($temp)
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
endfunc

func OpticalRead ($x1,$y1,$x2,$y2)
;  Print( stringformat("%02d:%02d:%02d OCR",@HOUR,@MIN,@SEC) )
  ClipPut("")
  $cli_cmd = stringformat("%s %d %d %d %d %s ", 'C:\Capture2Text\Capture2Text_CLI.exe -s "' , $x1, $y1, $x2, $y2, '" --clipboard')
  RunWait(@ComSpec & " /c" & $cli_cmd, 'C:\Capture2Text\', @SW_HIDE)
  sleep(100)
  return( ClipGet() )
endfunc

;------------------------------------------------------------------------------- 
;------------------------------------------------------------------------------- 
GUISetState(@SW_SHOW)
WHILE 1
  switch GUIGetMsg()
    case $GUI_EVENT_CLOSE
      exitloop
  endswitch
  if IsTimeOut($PrintTimeOut) then
    Print("")
    $PrintTimeOut = SetTimeOut(60000)
  endif
WEND
GUIDelete()
;------------------------------------------------------------------------------- 
;------------------------------------------------------------------------------- 
func IsKanaiEmpty($x,$y)
  $x = 209+56*$x
  $y = 404+56*$y
  local $r=0,$g=0,$b=0,$c=0
  for $i = $x-20 to $x+20 step 20
    for $j = $y-20 to $y+20 step 20
      $c = PixelGetColor($i,$j)
      $r = _ColorGetRed  ($c)
      $g = _ColorGetGreen($c)
      $b = _ColorGetBlue ($c)
      if $r>24 or $g>24 or $b>16 then    ;"empty color" is R<24 G<24 B<16
        return(False)      ;if one pixel is not an empty color, then it is not empty
      endif
    next
  next
  return(True)            ;if all pixels are background color, then it is empty
endfunc

func IsRareItem($x,$y)
  $x = $InvX+$x*$DivInvX
  $y = $InvY+$y*$DivInvY
  MouseMove($x,$y,0)
  local $timeout = SetTimeOut(500)    ;500ms timeout
  while NOT IsTimeOut($timeout)
    sleep(50)
    if SearchPixel($x-349.5,400,$x-349.5,600,0xFFFF00,2) then  ;Yellow?
      return(1)      ;then it is a Rare Item
;    elseif SearchPixel($x-351,450,$x-349,525,0xFF0000,4) then  ;Red?
;      return(1)      ;then it is an unsupported Rare item
    endif
  wend
  return(0)
endfunc

func IsInventoryEmpty ($x,$y)
  $x = $InvX+$x*$DivInvX
  $y = $InvY+$y*$DivInvY
  local $r=0,$g=0,$b=0,$c=0

  MouseMove($x,$y,0)      ;move mouse to spot of interest
  for $i = $x-20 to $x+20 step 20
    for $j = $y-20 to $y+20 step 20
      $c = PixelGetColor($i,$j)
      $r = _ColorGetRed  ($c)
      $g = _ColorGetGreen($c)
      $b = _ColorGetBlue ($c)
      if $r>24 or $g>24 or $b>16 then    ;background color is R<24 G<24 B<16
        return(0)      ;if one pixel is not a background color, then it is not empty
      endif
    next
  next
  return(1)            ;if all pixels are background color, then it is empty
endfunc

func WaitDiablo3($GUIText)
  $ABORT = false
;  MouseMove(0,0,1)
  Print("Waiting for " & $GUIText & " User Interface")
;  while NOT WinActive("Diablo III")
;    WinActivate("Diablo III")
;    sleep(100)
;  wend

  Print("Waiting for " & $GUIText)
  DO
    ; Position of the Window Label "ENCHANT" 
    local $text = OpticalRead(265-80,135-10,265+80,135+10)
    Print("Waiting for " & $GUIText & " / " & $text)
    sleep(500)
  UNTIL StringInStr($text,$GUIText)>0
  Print($GUIText & " Ready!")
  return(1)
endfunc

func KanaiCubeRecipe($pattern)
  $ABORT = false
  Print("Waiting for " & $pattern)
  DO
;    local $text = OpticalRead(610,155,822,210)
    local $text = OpticalRead(665,785,775,800)
    Print("Waiting for " & $pattern & " / " & $text)
    sleep(500)
  UNTIL StringRegExp($text,'(?i)' & $pattern)>0
  Print($pattern & " Ready!")
  return(1)
endfunc

func UpgradeRares()
  WaitDiablo3("CUBE")
  ;Kanai Coordinates
  ;+----+----+----+
  ;| 00 | 10 | 20 |
  ;+----+----+----+
  ;| 01 | 11 | 21 |
  ;+----+----+----+
  ;| 02 | 12 | 22 |
  ;+----+----+----+
  KanaiCubeRecipe("PAGE 3")
  for $y = 0 to 5
    for $x = 0 to 9
      if $ABORT then exitloop
      if (IsInventoryEmpty($x,$y)=0 and IsRareItem($x,$y)) then
        Print(stringformat("Upgrading Rare (%d,%d)", $x,$y))
        DO
          if $ABORT then exitloop
          ;put materials
          ClickMouse("Left",$FillX,$FillY,1,10)  ;Click "FILL" to put raw materials
          ;put rate item
          ClickMouse("Right", $InvX+$DivInvX*$x, $InvY+$DivInvY*$y,1,10)
        UNTIL NOT IsKanaiEmpty(1,1)
        ;Transmute
        DO
          if $ABORT then exitloop
          ClickMouse ("Left", $TransmuteX, $TransmuteY, 1, 10)
          sleep(100)
        UNTIL IsKanaiEmpty(0,0)      ;until C00 is empty
        ;move item back to backpack
        DO
          if $ABORT then exitloop
          ClickMouse ("Right", $CraftedX, $CraftedY, 1, 50)
        UNTIL IsKanaiEmpty(1,0)      ;until C10 is empty
      endif
    next
  next
  Print("Done Upgrading Rares.")
  $ABORT = true
endfunc

func ConvertMaterial()
  WaitDiablo3("CUBE")
  ;Kanai Coordinates
  ;+----+----+----+
  ;| 00 | 10 | 20 |
  ;+----+----+----+
  ;| 01 | 11 | 21 |
  ;+----+----+----+
  ;| 02 | 12 | 22 |
  ;+----+----+----+
  KanaiCubeRecipe("PAGE [789]")
  for $y = 0 to 5
    for $x = 0 to 9
      if $ABORT then exitloop
      if IsInventoryEmpty($x,$y)=0 then
        Print(stringformat("Converting Material (%d,%d)", $x,$y))
        DO        
          if $ABORT then exitloop
          ;put materials
          ClickMouse("Left",$FillX,$FillY,1,10)  ;Click "FILL" to put raw materials
              UNTIL (NOT IsKanaiEmpty(0,1))
        DO
          if $ABORT then exitloop
          ;put item
          ClickMouse("Right", $InvX+$DivInvX*$x, $InvY+$DivInvY*$y,1,10)
              UNTIL (NOT IsKanaiEmpty(0,2)) OR (NOT IsKanaiEmpty(1,0))
        ;Transmute
        DO
          if $ABORT then exitloop
          ClickMouse ("Left", $TransmuteX, $TransmuteY, 1, 10)
          sleep(100)
        UNTIL IsKanaiEmpty(0,0)  AND IsKanaiEmpty(1,1)  ;until C00 is empty
      endif
    next
  next
  Print("Done Converting Materials.")
  $ABORT = true
endfunc

func SalvageLegendary()
  WaitDiablo3("SALVAGE")
  ClickMouse("Left", 510, 479, 3, 100)
  ClickMouse("Left", $ForgeX, $ForgeY, 1, 100)
  for $y = 0 to 5
    if ($y=5) then
      $x=1
    else
      $x = 0
    endif
    while ($x<10)
      if $ABORT then exitloop
      local $try = 2
      Print(stringformat("Salvage Item (%d,%d)", $x,$y))
      while ($try>0) AND (IsInventoryEmpty($x,$y)=0)
        ClickMouse("Left", $InvX+$DivInvX*$x, $InvY+$DivInvY*$y, 1, 50)
        sleep(100)
        if SearchPixel(843-2, 373-2, 843+2, 373+2, 0xF3AA55, 8) then
;          send("{ENTER}")
          ClickMouse("Left", 843, 373, 1, 50)
        endif
        $try -= 1
      wend
      $x += 1
    wend
  next
;  ClickMouse("Right", $InvX+$DivInvX*9, $InvY+$DivInvY*5, 3, 10)
  Print("Done Salvaging.")
  $ABORT = true
endfunc

;------------------------------------------------------------------------------- 
;        Myriam Functions
;------------------------------------------------------------------------------- 
func Myriam()
  WaitDiablo3("ENCHANT")

  local $DesiredProperty  = GUICtrlRead($hInput1)
  local $DesiredNumber  = GUICtrlRead($hInput2)
  local $Attempts    = GUICtrlRead($hInput3)

  local $ThisChoice  = -1  ;-1 No choice made
  local $ThisNumber  = 0

  local $CheckSumReplace = 0


  local $OCR,$number
  local $text="Waiting for Item"
  
  local $x1=77, $x2=440
  local $y0=395, $dy=44
  ; Position of the "...Property to Replace" button
  local $EnchantX=265, $EnchantY=780

  ;move mouse out of the way all the time to prevent interference
  MouseMove($EnchantX,$EnchantY,1)

  WHILE (($Attempts>0) AND ($ABORT=false))
    if ($CheckSumReplace=0) then
      ; Position of the "Replace a Previously Enchanted Property" or "Select a Property to Replace"or "Select Replacement Property" header
      ; Print("read title bar")
      $text = OpticalRead(125,354-9,400,354+9)    ;read title bar
      if StringInStr($text, "Replace a Previously Enchanted Property")>0 then
        $CheckSumReplace = PixelCheckSum(125,361,400,361)
        $text = "Replace Property"
      endif
    elseif $CheckSumReplace = PixelCheckSum(125,361,400,361) then
;      Print("click reroll bar")
      ClickMouse("left", $EnchantX, $EnchantY, 1, 10)      ;click REROLL bar until actual enchanting
      sleep(250)
    elseif SearchPixel($x1, $y0+$dy*2, $x2, $y0+$dy*2, 0x6969FF, 4) then
;      Print("here they come")
      $text = ""
      if ($ThisChoice=-1) then
        $OCR = OpticalRead($x1,$y0+$dy*0-10,$x2,$y0+$dy*0+10)
        if StringInStr($OCR, $DesiredProperty) then
          $number = GetNumber($OCR)
          if ($number >= $ThisNumber) then
            $ThisChoice = 0
            $ThisNumber = $number
          endif
        endif
      endif

      ;1st Random Choice
      $OCR = OpticalRead($x1,$y0+$dy*1-10,$x2,$y0+$dy*1+10)
      $number = GetNumber($OCR)
      $text &= "(" & $number & ") " & $OCR & @CRLF
      if StringInStr($OCR, $DesiredProperty) then
        if ($number >= $ThisNumber) then
          $ThisChoice = 1
          $ThisNumber = $number
        endif
      endif

      ;2nd Random Choice
      $OCR = OpticalRead($x1,$y0+$dy*2-10,$x2,$y0+$dy*2+10)
      $number = GetNumber($OCR)
      $text &= "(" & $number & ") " & $OCR & @CRLF
      if StringInStr($OCR, $DesiredProperty) then
        if ($number >= $ThisNumber) then
          $ThisChoice = 2
          $ThisNumber = $number
        endif
      endif

      Print("Counter: " & $Attempts & @CRLF & "Current Value: " & $ThisNumber & "/" & $DesiredNumber & " " & $DesiredProperty & @CRLF & $text)
      while SearchPixel(84-2, 429, 84+2, 490, 0x6969FF, 4)  ;while there are still 2 rerolls to choose
        if ($ThisChoice=-1) then
          ClickMouse("left", 400, $y0+$dy*0, 1, 10)
        else
          ClickMouse("left", 400, $y0+$dy*$ThisChoice, 1, 10)
        endif
        ClickMouse("left", $EnchantX, $EnchantY, 1, 10)
        sleep(500)
      wend
      $Attempts -= 1
      if $ThisChoice>0 then
        $ThisChoice = 0
      endif
      if ($ThisNumber>=$DesiredNumber) then
        exitloop
      endif
    endif
;    Print("Counter: " & $Attempts & @CRLF & "Current Value: " & $ThisNumber & @CRLF & $text)
    Sleep(100)
  WEND
  Print("Done")
  $ABORT = true
endfunc
