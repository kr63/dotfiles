import XMonad hiding ( (|||) )
import XMonad.Config.Xfce
-- import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.EZConfig
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
import XMonad.Layout.Accordion

import XMonad.Layout.Spacing
import XMonad.Layout hiding ( (|||) )
import XMonad.Hooks.InsertPosition
import XMonad.Actions.Submap
import Data.Map as M

import XMonad.Layout.NoBorders
import XMonad.Layout.NoFrillsDecoration
import XMonad.Actions.PerWorkspaceKeys 
import XMonad.Actions.Navigation2D
import XMonad.Actions.WithAll

import XMonad.Layout.BinarySpacePartition

main = do
    xmproc <- spawnPipe "xmobar ./xmobarrc"
    xmonad $ def
        { terminal = "xterm"
        , borderWidth = 4
        , layoutHook = myLayoutHook
        , manageHook = insertPosition End Newer <+> manageHook def
        , handleEventHook = docksEventHook <+> handleEventHook def
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "grey" "" . shorten 50
                    }
        } `additionalKeysP` myKeys

defaultLayouts = avoidStruts $ Tall 1 (0.03) (0.6) ||| Circle ||| Full

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
  
myTabsLayout = avoidStruts
               $ addTabs shrinkText def {fontName = "xft:Monospace-12"}
               $ Simplest

myFlexLayout = avoidStruts
               $ windowNavigation
               $ addTopBar
               $ addTabs shrinkText myTabTheme
               $ subLayout [] (Simplest ||| Accordion)
               $ ResizableTall 1 (1/20) (2/3) []
  
myLayoutHook = onWorkspace "2" myTabsLayout $
               onWorkspace "3" myFlexLayout $
               defaultLayouts
  
myKeys =
    [
      ("M-j", windowGo D True)
    , ("M-k", windowGo U True)
    , ("M-h", windowGo R True)
    , ("M-l", windowGo L True)
    , ("M-w h", sendMessage $ pullWindow L)
    , ("M-w l", sendMessage $ pullWindow R)
    , ("M-w j", sendMessage $ pullWindow D)
    , ("M-w k", sendMessage $ pullWindow U)
    , ("M-w M-h", sendMessage $ pushWindow L)
    , ("M-w M-l", sendMessage $ pushWindow R)
    , ("M-w M-j", sendMessage $ pushWindow D)
    , ("M-w M-k", sendMessage $ pushWindow U)
    , ("M-w u", withFocused $ sendMessage . UnMerge)
    , ("M-w m", withFocused $ sendMessage . MergeAll)
    , ("M-<Backspace>" , kill)
    , ("M-S-<Backspace>", killAll)
    , ("M-S-h", sendMessage Shrink)
    , ("M-S-l", sendMessage Expand)
    , ("M-S-j", sendMessage MirrorShrink)
    , ("M-S-k", sendMessage MirrorExpand)
    --
    , ("M-C-j", windows W.swapDown)
    , ("M-C-k", windows W.swapUp)
    , ("M-'", onGroup W.focusDown')
    , ("M-;", onGroup W.focusUp')
    ]
