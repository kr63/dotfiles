import XMonad hiding ( (|||) )
import XMonad.Config.Xfce
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Replace(replace)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutScreens
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Circle

import XMonad.Util.Run            -- spawnPipe, hPutStrln
import XMonad.Hooks.DynamicLog    -- dynamicLogWithPP
import XMonad.Hooks.ManageHelpers -- helper functions to be used in manageHook
import XMonad.Hooks.SetWMName     -- setWMName

import XMonad.Layout.Tabbed
import XMonad.Layout.Simplest
import XMonad.Layout.Combo
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowNavigation
import XMonad.Layout.SubLayouts
import XMonad.Layout.BoringWindows
import XMonad.Layout.ResizableTile

import XMonad.Layout.Spacing
import XMonad.Layout hiding ( (|||) )
import XMonad.Hooks.InsertPosition
import XMonad.Actions.Submap
import Data.Map as M

import XMonad.Layout.NoBorders
import XMonad.Layout.NoFrillsDecoration
  

main = do
    xmproc <- spawnPipe "xmobar ./xmobarrc"
    xmonad $ def
        { terminal = "xterm"
        , borderWidth = 4
        , layoutHook = avoidStruts $ myLayout
        , manageHook = insertPosition End Newer <+> manageHook def
        , handleEventHook = docksEventHook <+> handleEventHook def
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "grey" "" . shorten 50
                    }
        } `additionalKeys` myKeys

defaultLayouts = Tall 1 (0.03) (0.6) ||| Circle ||| Full

------------------------------------------------------------------------------
-- Layout with tabs 1
myTabsLayout1 = avoidStruts
    $ addTopBar
    $ addTabs shrinkText myTabTheme
    $ Simplest

base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"

active      = blue
activeWarn  = red
inactive    = base02
focusColor  = blue
unfocusColor = base02

myFont      = "xft:Monospace-12"

topBarTheme = def
    { fontName              = myFont
    , inactiveBorderColor   = base03
    , inactiveColor         = base03
    , inactiveTextColor     = base03
    , activeBorderColor     = active
    , activeColor           = active
    , activeTextColor       = active
    , urgentBorderColor     = red
    , urgentTextColor       = yellow
    , decoHeight            = 10
    }

myTabTheme = def
    { fontName              = myFont
    , activeColor           = active
    , inactiveColor         = base02
    , activeBorderColor     = active
    , inactiveBorderColor   = base02
    , activeTextColor       = base03
    , inactiveTextColor     = base00
    }

addTopBar = noFrillsDeco shrinkText topBarTheme
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Layout with tabs 2
myTabsLayout2 = avoidStruts
    -- $ addTabs shrinkText def {fontName = "xft:Monospace-12"}
    $ addTabs shrinkText myTabTheme
    $ Simplest
------------------------------------------------------------------------------
  
myLayout = onWorkspace "2" myTabsLayout1 $
           onWorkspace "3" myTabsLayout2 $
           defaultLayouts

myKeys =
    [
      ((mod1Mask, xK_c), submap . M.fromList $
        [ ((0, xK_r), sendMessage $ Go R)
        , ((0, xK_l), sendMessage $ Go L)
        , ((0, xK_u), sendMessage $ Go U)
        , ((0, xK_d), sendMessage $ Go D)
        , ((shiftMask, xK_r), sendMessage $ Move R)
        , ((shiftMask, xK_l), sendMessage $ Move L)
        , ((shiftMask, xK_u), sendMessage $ Move U)
        , ((shiftMask, xK_d), sendMessage $ Move D)
        ])
    ----------------------------------------
    -- sublayouts
    , ((mod1Mask, xK_g), submap . M.fromList $
        [ ((mod1Mask, xK_h), sendMessage $ pullGroup L)
        , ((mod1Mask, xK_l), sendMessage $ pullGroup R)
        , ((mod1Mask, xK_k), sendMessage $ pullGroup U)
        , ((mod1Mask, xK_j), sendMessage $ pullGroup D)
        , ((mod1Mask .|. shiftMask, xK_h), sendMessage $ pushGroup L)
        , ((mod1Mask .|. shiftMask, xK_l), sendMessage $ pushGroup R)
        , ((mod1Mask .|. shiftMask, xK_k), sendMessage $ pushGroup U)
        , ((mod1Mask .|. shiftMask, xK_j), sendMessage $ pushGroup D)
        ])
    , ((mod1Mask, xK_w), submap . M.fromList $
        [ ((mod1Mask, xK_h), sendMessage $ pullWindow L)
        , ((mod1Mask, xK_l), sendMessage $ pullWindow R)
        , ((mod1Mask, xK_k), sendMessage $ pullWindow U)
        , ((mod1Mask, xK_j), sendMessage $ pullWindow D)
        , ((mod1Mask .|. shiftMask, xK_h), sendMessage $ pushWindow L)
        , ((mod1Mask .|. shiftMask, xK_l), sendMessage $ pushWindow R)
        , ((mod1Mask .|. shiftMask, xK_k), sendMessage $ pushWindow U)
        , ((mod1Mask .|. shiftMask, xK_j), sendMessage $ pushWindow D)
        ])
    , ((mod1Mask, xK_m), withFocused (sendMessage . MergeAll))
    , ((mod1Mask, xK_u), withFocused (sendMessage . UnMerge))
    , ((mod1Mask .|. controlMask, xK_period), onGroup W.focusUp')
    , ((mod1Mask .|. controlMask, xK_comma), onGroup W.focusDown')
    ]
