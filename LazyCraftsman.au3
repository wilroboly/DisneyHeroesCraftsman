;----------------------------------------------------------------------------
; Author:  Wilco
;----------------------------------------------------------------------------
#include <GuiListBox.au3>
#include <GUIConstantsEx.au3>
#include <guiconstants.au3>
#include <ColorConstants.au3>
#include <FontConstants.au3>
#include <Color.au3>
#include <Array.au3>
#include <Helper.au3>
;~ #include <Crafting.au3>
#Include <Enhancement.au3>

;---------------------------------------------------------------------------------------------------
; Disney Heroes Window Constants
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
;~ GLOBAL $titleBarLeft = Floor(125*$sRatio)
;~ GLOBAL $titleBarTop = Floor(349*$sRatio)
;~ GLOBAL $titleBarRight = Floor(400*$sRatio)
;~ GLOBAL $titleBarBottom = Floor(367*$sRatio)

;~ GLOBAL $windowLabelLeft = Floor(265*$sRatio)-Floor(80*$sRatio) ; 265-80
;~ GLOBAL $windowLabelTop = Floor(135*$sRatio)-Floor(10*$sRatio) ; 135-10
;~ GLOBAL $windowLabelRight = Floor(265*$sRatio)+Floor(80*$sRatio) ; 265+80
;~ GLOBAL $windowLabelBottom = Floor(135*$sRatio)+Floor(10*$sRatio) ; 135+10
GLOBAL $windowLabelLeft = Floor(665*$bRatio)
GLOBAL $windowLabelTop = Floor(70*$bRatio)
GLOBAL $windowLabelRight = Floor(1282*$bRatio)
GLOBAL $windowLabelBottom = Floor(136*$bRatio)

;~ GLOBAL $windowPageLeft = Floor(665*$sRatio)
;~ GLOBAL $windowPageTop = Floor(785*$sRatio)
;~ GLOBAL $windowPageRight = Floor(775*$sRatio)
;~ GLOBAL $windowPageBottom = Floor(800*$sRatio)

;---------------------------------------------------------------------------------------------------
; DH Window Element Constants
;---------------------------------------------------------------------------------------------------
Global $test

;---------------------------------------------------------------------------------------------------
; D3 Inventory Box Constants
;---------------------------------------------------------------------------------------------------
;~ GLOBAL $InvX = Floor(1428.5*$sRatio), $InvY=Floor(609.5*$sRatio)                ;Center of top left item on backpack
;~ GLOBAL $DivInvX = Floor(50.5*$sRatio)                                           ;inventory square X size
;~ GLOBAL $DivInvY = Floor(50*$sRatio)                                             ;inventory square Y size
;~ GLOBAL $TransmuteX = Floor(264*$sRatio), $TransmuteY=Floor(827*$sRatio)         ;transmute button
;~ GLOBAL $KanaiRecipesX = Floor(432*$sRatio), $KanaiRecipesY=Floor(827*$sRatio)   ;Kanai Recipes page button
;~ GLOBAL $KanaiPagesX = Floor(857*$sRatio), $KanaiPagesY=Floor(830*$sRatio)       ;Kanai Page right button
;~ GLOBAL $CraftedX = Floor(280*$sRatio), $CraftedY=Floor(420*$sRatio)             ;top center item on kanai cube (cell10)
;~ GLOBAL $ForgeX = Floor(165*$sRatio), $ForgeY=Floor(288*$sRatio)                 ;Salvage Forge button
;~ GLOBAL $FillX = Floor(718*$sRatio), $FillY=Floor(841*$sRatio)                   ;Kanai Recipe Fill
GLOBAL $avoidColumns[] = [10]
GLOBAL $avoidCells[] = [1,2]

;----------------------------------------------------------------------------
; Timing Routines
;----------------------------------------------------------------------------
GLOBAL $ABORT = false
GLOBAL $CLOCK = TimerInit()
GLOBAL $PAUSE = 0

Func SetTimeOut($t)
  return( TimerDiff($CLOCK)-$PAUSE+$t )
EndFunc

Func IsTimeOut($t)
  return( ($t - TimerDiff($CLOCK) + $PAUSE) <= 0 )
EndFunc

Func GetTimeOut($t)
  return( $t - TimerDiff($CLOCK) + $PAUSE )
EndFunc

;---------------------------------------------------------------------------------------------------
;          Screen Functions
;---------------------------------------------------------------------------------------------------
Func ClickMouse($button,$x,$y,$c,$s)
  MouseMove($x,$y,1)
  if $s>0 then sleep($s)
  MouseClick($button,$x,$y,$c,0)
EndFunc

Func MouseClock()
  local $t = (@SEC+@MSEC/1000) * 2 * 3.141592653589793 / 5    ;5 seconds to make a circle
  MouseMove(Floor(960*$sRatio)+240*sin($t),100,0)
EndFunc

local $PrintTimeOut = SetTimeOut(60000)

Func Print($text)
  ToolTip( $text, Floor(100*$sRatio), Floor(50*$sRatio), "Info")
  $PrintTimeOut = SetTimeOut(5000)
EndFunc

Func SearchPixel($x1,$y1,$x2,$y2,$color,$tolerance)
  PixelSearch ($x1,$y1,$x2,$y2,$color,$tolerance)
  if @error = 1 then
    return(0)
  else
    return(1)
  endif
EndFunc

;----------------------------------------------------------------------------
;      Hotkey Routines
;----------------------------------------------------------------------------
Func Terminate()
  exit(-1)
EndFunc

Func Stop()
  $ABORT = true
EndFunc


;~ HotKeySet( "^!u",  "UpgradeRares" )
;~ HotKeySet( "^!c",  "ConvertMaterial" )
;~ HotKeySet( "^!s",  "SalvageLegendary" )
;~ HotKeySet( "^!m",  "Crafting" )
HotKeySet( "^!a",  "Stop" )
HotKeySet( "^!x",  "Terminate" )

;-------------------------------------------------------------------------------
;  GUI Routines
;-------------------------------------------------------------------------------
GLOBAL $TITLE = "The Lazy Craftsman DH Edition 1.0";
GLOBAL $sFont = "Calibri"
GLOBAL $fontLeading = 18
GLOBAL $fontTitleHeight = 14
GLOBAL $fontOptionHeight = 11
GLOBAL $fontQuality = $CLEARTYPE_QUALITY

GLOBAL $DimX = 350
GLOBAL $DimY = 350; 272

GLOBAL $MW = GUICreate($TITLE, $DimX, $DimY)

Func BuildGUI() ; $DimX, $DimY, $fontLeading
  local $iY=8
  local $iLineHeight = $fontLeading + 2
  local $iLeftMargin = 20
  local $iRightMargin = 40
  local $startingPosition = 0

  local $hGroupA = GUICtrlCreateGroup("", 5, $iY, $DimX-10,$DimY-19)
  $pos = OptionPosition($startingPosition, $iLineHeight, $iY-5)
  local $hLabelA = GUICtrlCreateLabel("Options", $iLeftMargin, $pos, 60, $fontLeading + 2)

  GUICtrlSetFont($hLabelA,  $fontTitleHeight, $FW_HEAVY, 0, $sFont, $fontQuality)
  GUICtrlSetColor($hLabelA,0x009900)

  BuildEnhancements($iY, $startingPosition, $iLeftMargin, $iRightMargin, $iLineHeight)
  ;~ BuildOptions($iY)
  $iY += 125
  ;~ BuildControlGroup($iY)
  $iY += 105
  BuildAdminControls($iY)
  $iY += 53
  BuildDebugWindow($iY)
  Return True
EndFunc

Func BuildEnhancements($iY, $startingPosition, $iLeftMargin, $iRightMargin, $iLineHeight)
  $pos = OptionPosition($startingPosition, $iLineHeight, $iY)
  local $hLabelD = GUICtrlCreateLabel("Ctrl-Alt-E: Enhance Skill", $iLeftMargin, $pos, $DimX - $iRightMargin, $fontLeading)
  GUICtrlSetFont($hLabelD,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetColor($hLabelD,0x0000FF)

  $pos = OptionPosition($startingPosition, 0, $iY)
  GUICtrlCreateGroup("", $iLeftMargin-9, $pos-6, $DimX-22,60)

  $pos = OptionPosition($startingPosition, $fontLeading, $iY)
  local $hLabel1 = GUICtrlCreateLabel("Add:", $iLeftMargin+10, $pos-13, $iLeftMargin+20, $fontLeading + 2)
  local $hInput1 = GUICtrlCreateInput("1", $iLeftMargin+30+5, $pos-15, 40, $fontLeading+2)
  local $hLabel2 = GUICtrlCreateLabel("Remove:", $iLeftMargin+80, $pos-13, $iLeftMargin+40, $fontLeading + 2)
  local $hInput2 = GUICtrlCreateInput("0", $iLeftMargin+120+5, $pos-15, 40, $fontLeading+2)

  Return True
EndFunc

Func BuildOptions($iY)
  local $hLabelB = GUICtrlCreateLabel("Ctrl-Alt-U: Kanai Upgrade Rare", 20, 25+$iY, $DimX-40, $fontLeading)
  local $hLabelC = GUICtrlCreateLabel("Ctrl-Alt-C: Kanai Convert Mats", 20, 45+$iY, $DimX-40, $fontLeading)
  local $hLabelD = GUICtrlCreateLabel("Ctrl-Alt-S: BlackSmith Salvage", 20, 65+$iY, $DimX-40, $fontLeading)
  local $hLabel01 = GUICtrlCreateLabel("Avoid Cols:   ", 30, 85+$iY, 80, $fontLeading + 2)
  local $hInput01 = GUICtrlCreateInput(_ArrayToString($avoidColumns, ','), 115, 82+$iY,$DimX-135, 22)
  local $hLabel02 = GUICtrlCreateLabel("Avoid Rows:   ", 30, 105+$iY, 80, $fontLeading + 2)
  local $hInput02 = GUICtrlCreateInput(_ArrayToString($avoidCells, ','), 115, 102+$iY,$DimX-135, 22)

  GUICtrlSetFont($hLabelB,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

  GUICtrlSetFont($hLabelC,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetFont($hLabelD,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

  GUICtrlSetFont($hLabel01,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetFont($hInput01,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

  GUICtrlSetFont($hLabel02,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetFont($hInput02,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

  GUICtrlSetColor($hLabelB,0x0000FF)
  GUICtrlSetColor($hLabelC,0x0000FF)
  GUICtrlSetColor($hLabelD,0x0000FF)

  Return True
EndFunc

Func BuildControlGroup($iY)
  GUICtrlCreateGroup("", 11, $iY, $DimX-22,105)
  local $hLabelE = GUICtrlCreateLabel("Ctrl-Alt-M: Myriam Enchantment", 20, $iY, $DimX-99, $fontLeading)
  local $hLabel1 = GUICtrlCreateLabel("Property:", 30, 25+$iY, 80, $fontLeading + 2)
  local $hInput1 = GUICtrlCreateInput("Critical Hit Damage", 115, 22+$iY,$DimX-135, 22)
  local $hLabel2 = GUICtrlCreateLabel("Value:   ", 30, 50+$iY, 80, $fontLeading + 2)
  local $hInput2 = GUICtrlCreateInput("50", 115, 47+$iY,$DimX-135, 22)
  local $hLabel3 = GUICtrlCreateLabel("Retry:   ", 30, 75+$iY, 80, $fontLeading + 2)
  local $hInput3 = GUICtrlCreateInput("100"      , 115, 72+$iY,$DimX-135, 22)

  GUICtrlSetFont($hLabelE,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

  GUICtrlSetFont($hLabel1,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetFont($hInput1,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

  GUICtrlSetFont($hLabel2,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetFont($hInput2,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

  GUICtrlSetFont($hLabel3,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetFont($hInput3,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

  GUICtrlSetColor($hLabelE,0x0000FF)

  Return True
EndFunc

Func BuildAdminControls($iY)
  GUICtrlCreateGroup("", 11, $iY, $DimX-22, 53)
  local $hLabelF = GUICtrlCreateLabel("Ctrl-Alt-A: Abort Current Task", 20, 10+$iY, $DimX-99, $fontLeading)
  local $hLabelG = GUICtrlCreateLabel("Ctrl-Alt-X: EXIT APPLICATION", 20, 30+$iY, $DimX-99, $fontLeading)

  GUICtrlSetFont($hLabelF,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)
  GUICtrlSetFont($hLabelG,  $fontOptionHeight, $FW_MEDIUM, 0, $sFont, $fontQuality)

  GUICtrlSetColor($hLabelF,0x0000FF)
  GUICtrlSetColor($hLabelG,0x0000FF)

  Return True
EndFunc

Func BuildDebugWindow($iY)
  GUICtrlCreateGroup("", 11, $iY, $DimX-22, 32)
  local $hLabelH = GUICtrlCreateLabel(stringformat("Screen Size: W=%d H=%d Ratio=%.2f", $sWidth,$sHeight,$sRatio), 20, 10+$iY, $DimX-35, $fontLeading + 2)

  GUICtrlSetFont($hLabelH,  $fontOptionHeight, $FW_NORMAL, 0, $sFont, $fontQuality)

  GUICtrlSetColor($hLabelH,0x0000FF)

  Return True
EndFunc

;-------------------------------------------------------------------------------
; Main GUISetState Routine
;-------------------------------------------------------------------------------
BuildGUI()
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


