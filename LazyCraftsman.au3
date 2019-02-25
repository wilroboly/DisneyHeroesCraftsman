;----------------------------------------------------------------------------
; Author:  BurgerKing
; Updates by: Wilco
;----------------------------------------------------------------------------
#include <GuiListBox.au3>
#include <GUIConstantsEx.au3>
#include <guiconstants.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
#include <Color.au3>
#include <Array.au3>

GLOBAL $TITLE = "The Lazy Craftsman 2.5";
GLOBAL $sFont = "Calibri"
GLOBAL $fontLeading = 18
GLOBAL $fontTitleHeight = 14
GLOBAL $fontOptionHeight = 11
GLOBAL $fontQuality = $CLEARTYPE_QUALITY

;---------------------------------------------------------------------------------------------------
; D3 Window Constants
;---------------------------------------------------------------------------------------------------
GLOBAL $sHeight = @DesktopHeight
GLOBAL $sWidth = @DesktopWidth

GLOBAL $bRatio=1.0 ; Base ration for 1920x1080
GLOBAL $widthRatio=($sWidth/1920)
GLOBAL $heightRatio=($sHeight/1080)

; This is a temporary fix as we use proper screen res and ratios
GLOBAL $sRatio=$widthRatio

;---------------------------------------------------------------------------------------------------
; Left Window Position Constants
;---------------------------------------------------------------------------------------------------
GLOBAL $titleBarLeft = Floor(125*$sRatio)
GLOBAL $titleBarTop = Floor(349*$sRatio)
GLOBAL $titleBarRight = Floor(400*$sRatio)
GLOBAL $titleBarBottom = Floor(367*$sRatio)

GLOBAL $windowLabelLeft = Floor(265*$sRatio)-Floor(80*$sRatio) ; 265-80
GLOBAL $windowLabelTop = Floor(135*$sRatio)-Floor(10*$sRatio) ; 135-10
GLOBAL $windowLabelRight = Floor(265*$sRatio)+Floor(80*$sRatio) ; 265+80
GLOBAL $windowLabelBottom = Floor(135*$sRatio)+Floor(10*$sRatio) ; 135+10

GLOBAL $windowPageLeft = Floor(665*$sRatio)
GLOBAL $windowPageTop = Floor(785*$sRatio)
GLOBAL $windowPageRight = Floor(775*$sRatio)
GLOBAL $windowPageBottom = Floor(800*$sRatio)

;---------------------------------------------------------------------------------------------------
; D3 Inventory Box Constants
;---------------------------------------------------------------------------------------------------
GLOBAL $InvX = Floor(1428.5*$sRatio), $InvY=Floor(609.5*$sRatio)                ;Center of top left item on backpack
GLOBAL $DivInvX = Floor(50.5*$sRatio)                                           ;inventory square X size
GLOBAL $DivInvY = Floor(50*$sRatio)                                             ;inventory square Y size
GLOBAL $TransmuteX = Floor(264*$sRatio), $TransmuteY=Floor(827*$sRatio)         ;transmute button
GLOBAL $KanaiRecipesX = Floor(432*$sRatio), $KanaiRecipesY=Floor(827*$sRatio)   ;Kanai Recipes page button
GLOBAL $KanaiPagesX = Floor(857*$sRatio), $KanaiPagesY=Floor(830*$sRatio)       ;Kanai Page right button
GLOBAL $CraftedX = Floor(280*$sRatio), $CraftedY=Floor(420*$sRatio)             ;top center item on kanai cube (cell10)
GLOBAL $ForgeX = Floor(165*$sRatio), $ForgeY=Floor(288*$sRatio)                 ;Salvage Forge button
GLOBAL $FillX = Floor(718*$sRatio), $FillY=Floor(841*$sRatio)                   ;Kanai Recipe Fill
GLOBAL $avoidColumns[] = [10]
GLOBAL $avoidCells[] = [1,2]

;----------------------------------------------------------------------------
; Timing Routines
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
  MouseMove(Floor(960*$sRatio)+240*sin($t),100,0)
endfunc

local $PrintTimeOut = SetTimeOut(60000)

func Print($text)
  ToolTip( $text, Floor(100*$sRatio), Floor(50*$sRatio), "Info")
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
GLOBAL $DimX = 350
GLOBAL $DimY = 350; 272
GLOBAL $MW = GUICreate($TITLE, $DimX, $DimY)

local $iY=8
local $hGroupA = GUICtrlCreateGroup("", 5, $iY, $DimX-10,$DimY-19)
local $hLabelA = GUICtrlCreateLabel("Options", 20,  $iY-5, $DimX-99, $fontLeading + 2)
local $hLabelB = GUICtrlCreateLabel("Ctrl-Alt-U: Kanai Upgrade Rare", 20, 25+$iY, $DimX-99, $fontLeading)
local $hLabelC = GUICtrlCreateLabel("Ctrl-Alt-C: Kanai Convert Mats", 20, 45+$iY, $DimX-40, $fontLeading)
local $hLabelD = GUICtrlCreateLabel("Ctrl-Alt-S: BlackSmith Salvage", 20, 65+$iY, $DimX-40, $fontLeading)
local $hLabel01 = GUICtrlCreateLabel("Avoid Cols:   ", 30, 85+$iY, 80, $fontLeading + 2)
local $hInput01 = GUICtrlCreateInput(_ArrayToString($avoidColumns, ','), 115, 82+$iY,$DimX-135, 22)
local $hLabel02 = GUICtrlCreateLabel("Avoid Rows:   ", 30, 105+$iY, 80, $fontLeading + 2)
local $hInput02 = GUICtrlCreateInput(_ArrayToString($avoidCells, ','), 115, 102+$iY,$DimX-135, 22)

$iY += 125
GUICtrlCreateGroup("", 11, $iY, $DimX-22,105)
local $hLabelE = GUICtrlCreateLabel("Ctrl-Alt-M: Myriam Enchantment", 20, $iY, $DimX-99, $fontLeading)
local $hLabel1 = GUICtrlCreateLabel("Property:", 30, 25+$iY, 80, $fontLeading + 2)
local $hInput1 = GUICtrlCreateInput("Critical Hit Damage", 115, 22+$iY,$DimX-135, 22)
local $hLabel2 = GUICtrlCreateLabel("Value:   ", 30, 50+$iY, 80, $fontLeading + 2)
local $hInput2 = GUICtrlCreateInput("50", 115, 47+$iY,$DimX-135, 22)
local $hLabel3 = GUICtrlCreateLabel("Retry:   ", 30, 75+$iY, 80, $fontLeading + 2)
local $hInput3 = GUICtrlCreateInput("100"      , 115, 72+$iY,$DimX-135, 22)

$iY += 105
GUICtrlCreateGroup("", 11, $iY, $DimX-22, 53)
local $hLabelF = GUICtrlCreateLabel("Ctrl-Alt-A: Abort Current Task", 20, 10+$iY, $DimX-99, $fontLeading)
local $hLabelG = GUICtrlCreateLabel("Ctrl-Alt-X: EXIT APPLICATION", 20, 30+$iY, $DimX-99, $fontLeading)

$iY += 53
GUICtrlCreateGroup("", 11, $iY, $DimX-22, 32)
local $hLabelH = GUICtrlCreateLabel(stringformat("Screen Size: W=%d H=%d Ratio=%.2f", $sWidth,$sHeight,$sRatio), 20, 10+$iY, $DimX-35, $fontLeading + 2)

;Set Fonts
GUICtrlSetFont($hLabelA,  $fontTitleHeight, $FW_HEAVY, 0, $sFont, $fontQuality)
GUICtrlSetFont($hLabelB,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabelC,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
GUICtrlSetFont($hLabelD,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabel01,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
GUICtrlSetFont($hInput01,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabel02,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
GUICtrlSetFont($hInput02,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabelE,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabel1,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
GUICtrlSetFont($hInput1,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabel2,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
GUICtrlSetFont($hInput2,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabel3,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
GUICtrlSetFont($hInput3,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabelF,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
GUICtrlSetFont($hLabelG,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

GUICtrlSetFont($hLabelH,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

GUICtrlSetColor($hLabelA,0x009900)
GUICtrlSetColor($hLabelB,0x0000FF)
GUICtrlSetColor($hLabelC,0x0000FF)
GUICtrlSetColor($hLabelD,0x0000FF)
GUICtrlSetColor($hLabelE,0x0000FF)
GUICtrlSetColor($hLabelF,0x0000FF)
GUICtrlSetColor($hLabelG,0x0000FF)
GUICtrlSetColor($hLabelH,0x0000FF)

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
  ;Print( stringformat("%02d:%02d:%02d OCR",@HOUR,@MIN,@SEC) )
  ClipPut("")
  $cli_cmd = stringformat("%s %d %d %d %d %s ", 'C:\Capture2Text\Capture2Text_CLI.exe -s "' , $x1, $y1, $x2, $y2, '" --clipboard')
  RunWait(@ComSpec & " /c" & $cli_cmd, 'C:\Capture2Text\', @SW_HIDE)
  sleep(100)
  return( ClipGet() )
endfunc

;-------------------------------------------------------------------------------
; Main GUISetState Routine
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
; Ctrl-Alt Routines
;-------------------------------------------------------------------------------
func IsKanaiEmpty($x,$y)
  $x = Floor(209*$sRatio)+Floor(56*$sRatio)*$x
  $y = Floor(404*$sRatio)+Floor(56*$sRatio)*$y
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

; TODO: Fix the SearchPixel() function to use local values
func IsRareItem($x,$y)
  $x = $InvX+$x*$DivInvX
  $y = $InvY+$y*$DivInvY
  MouseMove($x,$y,0)
  local $timeout = SetTimeOut(500)    ;500ms timeout
  while NOT IsTimeOut($timeout)
    sleep(50)
    if SearchPixel($x-Floor(349.5*$sRatio),Floor(400*$sRatio),$x-Floor(349.5*$sRatio),Floor(600*$sRatio),0xFFFF00,2) then  ;Yellow?
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
endfunc

func KanaiCubeRecipe($pattern)
  $ABORT = false
  Print("Waiting for " & $pattern)
  DO
    local $text = OpticalRead($windowPageLeft,$windowPageTop,$windowPageRight,$windowPageBottom)
    Print("Waiting for " & $pattern & " / " & $text)
    sleep(500)
  UNTIL StringRegExp($text,'(?i)' & $pattern)>0
  Print($pattern & " Ready!")
  return(1)
endfunc

func GoToPage($pattern)
  ClickMouse("Left",$KanaiRecipesX,$KanaiRecipesY,1,10)
  ClickMouse("Left",$KanaiPagesX,$KanaiPagesY,$pattern-1,10)
EndFunc

func UpgradeRares()
  WaitDiablo3("CUBE")
  GoToPage(3)
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
  KanaiCubeRecipe("PAGE [6789]")
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
  local $searchPixelLeft = Floor(841*$sRatio)
  local $searchPixelTop = Floor(371*$sRatio)
  local $searchPixelRight = Floor(845*$sRatio)
  local $searchPixelBottom = Floor(375*$sRatio)
  WaitDiablo3("SALVAGE")

  $arrAvoidColumns = StringSplit(GUICtrlRead($hInput01), ',',$STR_NOCOUNT )
  $arrAvoidCells = StringSplit(GUICtrlRead($hInput02), ',',$STR_NOCOUNT )

  ; Click the Legendary Salvage button
  ClickMouse("Left", $ForgeX, $ForgeY, 1, 100)

  for $y = 0 to 5
    $x = 0
    while ($x<10)
      if $ABORT then exitloop
      if ((_ArraySearch($arrAvoidColumns,$x+1) >= 0) AND (_ArraySearch($arrAvoidCells, $y+1) >= 0)) Then
        ; reconsider life! Do nothing!
      Else
          local $try = 2
          Print(stringformat("Salvage Item (%d,%d)", $x,$y))
          while ($try>0) AND (IsInventoryEmpty($x,$y)=0)
            ClickMouse("Left", $InvX+$DivInvX*$x, $InvY+$DivInvY*$y, 1, 50)
            sleep(50)
            if SearchPixel($searchPixelLeft, $searchPixelTop, $searchPixelRight, $searchPixelBottom, 0xF3AA55, 8) then
              ; Use Enter key as oppose to click location. Faster and easier.
              send("{ENTER}")
            endif
            $try -= 1
          wend
      EndIf
      $x += 1
    wend
  next
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

  local $mouseClickPosX = Floor(400*$sRatio)

  ; Screen Locations of title bar
  local $x1=Floor(77*$sRatio), $x2=Floor(440*$sRatio)
  local $y0=Floor(395*$sRatio), $dy=Floor(44*$sRatio)

  ; Position of the "...Property to Replace" button
  local $EnchantX=Floor(265*$sRatio), $EnchantY=Floor(780*$sRatio)

  ; Title Bar
  local $titleBarLeft = Floor(125*$sRatio)
  local $titleBarTop = Floor(349*$sRatio)
  local $titleBarRight = Floor(400*$sRatio)
  local $titleBarBottom = Floor(367*$sRatio)

  ; CheckSum line
  local $checkSumLeft = Floor(125*$sRatio)
  local $checkSumTop = Floor(358*$sRatio)
  local $checkSumRight = Floor(400*$sRatio)
  local $checkSumBottom = Floor(358*$sRatio)

  ; SearchPixel checking for reroll available
  local $searchPixelLeft = Floor(82*$sRatio)
  local $searchPixelTop = Floor(429*$sRatio)
  local $searchPixelRight = Floor(86*$sRatio)
  local $searchPixelBottom = Floor(490*$sRatio)

  local $fontHeight = Floor(10*$sRatio)

  ;move mouse out of the way all the time to prevent interference
  MouseMove($EnchantX,$EnchantY,1)

  WHILE (($Attempts>0) AND ($ABORT=false))
    if ($CheckSumReplace=0) then
      ; Position of the "Replace a Previously Enchanted Property" or "Select a Property to Replace"or "Select Replacement Property" header
      ;Print("read title bar")
      $text = OpticalRead($titleBarLeft,$titleBarTop,$titleBarRight,$titleBarBottom)    ;read title bar
	  Print("Current Text: " & $text)
      if StringInStr($text, "Replace a Previously Enchanted Property")>0 then
        $CheckSumReplace = PixelCheckSum($checkSumLeft,$checkSumTop,$checkSumRight,$checkSumBottom)
        $text = "Item is Ready for Enchantment"
      endif
    elseif $CheckSumReplace = PixelCheckSum($checkSumLeft,$checkSumTop,$checkSumRight,$checkSumBottom) then
;      Print("click reroll bar")
      ClickMouse("left", $EnchantX, $EnchantY, 1, 10)      ;click REROLL bar until actual enchanting
      sleep(250)
    elseif SearchPixel($x1, $y0+$dy*2, $x2, $y0+$dy*2, 0x6969FF, 4) then
;      Print("here they come")
      $text = ""
      if ($ThisChoice=-1) then
        $OCR = OpticalRead($x1,$y0+$dy*0-$fontHeight,$x2,$y0+$dy*0+$fontHeight)
        if StringInStr($OCR, $DesiredProperty) then
          $number = GetNumber($OCR)
          if ($number >= $ThisNumber) then
            $ThisChoice = 0
            $ThisNumber = $number
          endif
        endif
      endif

      ;1st Random Choice
      $OCR = OpticalRead($x1,$y0+$dy*1-$fontHeight,$x2,$y0+$dy*1+$fontHeight)
      $number = GetNumber($OCR)
      $text &= "(" & $number & ") " & $OCR & @CRLF
      if StringInStr($OCR, $DesiredProperty) then
        if ($number >= $ThisNumber) then
          $ThisChoice = 1
          $ThisNumber = $number
        endif
      endif

      ;2nd Random Choice
      $OCR = OpticalRead($x1,$y0+$dy*2-$fontHeight,$x2,$y0+$dy*2+$fontHeight)
      $number = GetNumber($OCR)
      $text &= "(" & $number & ") " & $OCR & @CRLF
      if StringInStr($OCR, $DesiredProperty) then
        if ($number >= $ThisNumber) then
          $ThisChoice = 2
          $ThisNumber = $number
        endif
      endif

      Print("Counter: " & $Attempts & @CRLF & "Current Value: " & $ThisNumber & "/" & $DesiredNumber & "/" & $number & " " & $DesiredProperty & @CRLF & $text)
      while SearchPixel($searchPixelLeft, $searchPixelTop, $searchPixelRight, $searchPixelBottom, 0x6969FF, 4)
        ;while there are still 2 rerolls to choose
        if ($ThisChoice=-1) then
          ClickMouse("left", $mouseClickPosX, $y0+$dy*0, 1, 10)
        else
          ClickMouse("left", $mouseClickPosX, $y0+$dy*$ThisChoice, 1, 10)
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
    ;Print("Counter: " & $Attempts & @CRLF & "Current Value: " & $ThisNumber & @CRLF & $text)
    Sleep(100)
  WEND
  Print("Done")
  $ABORT = true
endfunc
