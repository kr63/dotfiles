import XMonad hiding ( (|||) )
import XMonad.Config.Xfce
import XMonad.Util.EZConfig
import XMonad.Util.Replace(replace)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutScreens
import XMonad.Layout.PerWorkspace
import XMonad.Layout.WindowNavigation
-- import XMonad.Layout.TwoPane
import XMonad.Layout.Circle
  

import XMonad.Actions.Navigation2D
import XMonad.Actions.WithAll
import XMonad.Layout.NoFrillsDecoration
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Accordion
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Operations 

  
main = do
    replace
    xmonad $ withNavigation2DConfig myNavigation2DConfig
           $ ewmh xfceConfig
        { terminal = "urxvt"
        , modMask     = mod4Mask
        , borderWidth = 2
        , normalBorderColor = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor
        , startupHook = myStartupHook
        , manageHook = myManageHook <+> manageDocks <+> manageHook xfceConfig
        , layoutHook = myLayoutHook
        } `additionalKeysP` myKeys

myNormalBorderColor     = "#000000"
myFocusedBorderColor    = active

--------------------------------------------------------------------------------
-- key bindigns
--------------------------------------------------------------------------------
myKeys =
    [
      --------------------------------------------------------------------------
      -- Launchers
      ("M-p", spawn "xfce4-appfinder")
    , ("M-d", spawn "thunar")
    , ("M-o", spawn "emacsclient -c")
    , ("M-s", spawn "xfce4-settings-manager")
    , ("M-S-t", spawn "gnome-system-monitor")
    , ("<Print>", spawn "xfce4-screenshooter")
    , ("M-g", spawn "google-chrome-stable")
      --------------------------------------------------------------------------
    --
      --------------------------------------------------------------------------
      -- Windows Manage
    , ("M-j", windowGo D True)
    , ("M-k", windowGo U True)
    , ("M-h", windowGo L True)
    , ("M-l", windowGo R True)
    , ("M-i h", sendMessage $ pullWindow L)
    , ("M-i l", sendMessage $ pullWindow R)
    , ("M-i j", sendMessage $ pullWindow D)
    , ("M-i k", sendMessage $ pullWindow U)
    , ("M-i M-h", sendMessage $ pushWindow L)
    , ("M-i M-l", sendMessage $ pushWindow R)
    , ("M-i M-j", sendMessage $ pushWindow D)
    , ("M-i M-k", sendMessage $ pushWindow U)
    , ("M-i u", withFocused $ sendMessage . UnMerge)
    , ("M-i m", withFocused $ sendMessage . MergeAll)
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
    , ("M-q", sendMessage ToggleStruts)
    ]

--------------------------------------------------------------------------------
-- layout & workspace definition
--------------------------------------------------------------------------------

base00  = "#657b83"
base01  = "#586e75"
base02  = "#073642"
base03  = "#002b36"
red     = "#dc322f"
blue    = "#268bd2"
yellow  = "#b58900"

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
  
-- myTabsLayout = avoidStruts
--                $ addTabs shrinkText def {fontName = "xft:Monospace-12"}
--                $ Simplest

mySpacing = spacing 10
myGaps = gaps [(U, 10),(D, 10),(L, 10),(R, 10)]

myFlexLayout = avoidStruts
               $ windowNavigation
               $ addTopBar
               $ addTabs shrinkText myTabTheme
               $ subLayout [] (Simplest ||| Accordion)
               -- $ mySpacing $ myGaps $ ResizableTall 1 (0.025) (2/3) []
               $ ResizableTall 1 (0.025) (2/3) []

defaultLayouts = avoidStruts $ myFlexLayout ||| Circle ||| Full
  
-- myLayoutHook = onWorkspace "2" myTabsLayout $
--                onWorkspace "3" myFlexLayout $
--                defaultLayouts
myLayoutHook = defaultLayouts
 
myNavigation2DConfig = def
    { defaultTiledNavigation = centerNavigation
    , floatNavigation = centerNavigation
    , screenNavigation = lineNavigation
    , layoutNavigation = [("Full", centerNavigation)]
    , unmappedWindowRect = [("Full", singleWindowRect)]
    }


--------------------------------------------------------------------------------
-- auto startup
--------------------------------------------------------------------------------
myStartupHook = do
    spawn "google-chrome-stable"
    spawn "urxvt"
    spawn "compton"
    spawn "emacs --daemon"
    spawn "thunar"
    spawn "~/.xmonad/startup.sh"
    spawn "xfce4-panel -r"
    spawn "xfconf-query -c xfce4-panel -p /panels/panel-0/autohide-behavior -s 2" -- always hide xfce4-panel
    spawn "xfconf-query -c xfce4-panel -p /panels/panel-0/autohide-behavior -s 0" -- never hide xfce4-panel
    -- refresh
    spawn "xrandr --dpi 144"
    -- spawn ""

--------------------------------------------------------------------------------
-- Application manage hooks
--------------------------------------------------------------------------------
myManageHook = composeAll
               [ className                     =? "Xfce4-notifyd"           --> doIgnore
               , className                     =? "URxvt"                   --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               , className                     =? "Xfrun4"                  --> doCenterFloat
               , className                     =? "Wine"                    --> doCenterFloat
               , className                     =? "Google-chrome"           --> doShift "1"
               , className                     =? "Thunar"                  --> doShift "2"
               , className                     =? "Emacs"                   --> doShift "3"
               , appName                       =? "libreoffice"             --> doShift "4"
               , title                         =? "LibreOffice"             --> doShift "4"
               , appName                       =? "VirtualBox"              --> doShift "6"
               , className                     =? "Skype"                   --> doShift "5"
               , className                     =? "Gmpc"                    --> doCenterFloat
               , className                     =? "mpv"                     --> doCenterFloat
               , className                     =? "GoldenDict"              --> doCenterFloat
               , className                     =? "Catfish"                 --> doCenterFloat
               , className                     =? "Xfce4-settings-manager"  --> doCenterFloat
               , className                     =? "Xfce4-appfinder"         --> doCenterFloat
               , className                     =? "Slack"                   --> doCenterFloat
               , className                     =? "Gedit"                   --> doCenterFloat
               , className                     =? "Evolution"               --> doCenterFloat
               , className                     =? "Gnome-system-monitor"    --> doCenterFloat
               , className                     =? "Org.gnome.gedit"         --> doCenterFloat
               , className                     =? "File-roller"             --> doCenterFloat
               , className                     =? "Xfce4-screenshooter"     --> doCenterFloat
               , className                     =? "Pamac-manager"           --> doCenterFloat
               , stringProperty "WM_ICON_NAME" =? "File Operation Progress" --> doCenterFloat
               ]
