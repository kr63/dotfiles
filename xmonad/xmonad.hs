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

import Foreign.C.Types
  
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
    , ("M-<F12>", spawn "telegram-desktop")
    , ("M-<F11>", spawn "skypeforlinux")
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

myFont = "xft:DejaVu Sans-10"

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
    , decoHeight            = 12
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
--------------------------------------------------------------------------------
    spawn "xrandr --dpi 144"
    spawn "evolution"
    spawn "~/software/idea-IU/bin/idea.sh"
    -- refresh
    -- spawn ""

--------------------------------------------------------------------------------
-- Application manage hooks
--------------------------------------------------------------------------------
-- Взять значение свойства окна
getProp :: Atom -> Window -> X (Maybe [CLong])
getProp a w = withDisplay $ \dpy -> io $ getWindowProperty32 dpy a w
-- Эта функция проверяет, выставлено ли свойство окна name в значение value
checkAtom name value = ask >>= \w -> liftX $ do
          a <- getAtom name
          val <- getAtom value
          mbr <- getProp a w
          case mbr of
            Just [r] -> return $ elem (fromIntegral r) [val]
            _ -> return False
  
myManageHook = composeAll
               [ className                     =? "Xfce4-notifyd"             --> doIgnore
               , className                     =? "URxvt"                     --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               , className                     =? "Xfrun4"                    --> doCenterFloat
               , className                     =? "Wine"                      --> doCenterFloat
               , className                     =? "Google-chrome"             --> doShift "1"
               , className                     =? "Thunar"                    --> doShift "2"
               , className                     =? "Emacs"                     --> doShift "3"
               , appName                       =? "libreoffice"               --> doShift "4"
               , title                         =? "LibreOffice"               --> doShift "4"
               , appName                       =? "VirtualBox"                --> doShift "6"
               , className                     =? "Evolution"                 --> doShift "6"
               , className                     =? "Skype"                     --> doShift "5"
               , className                     =? "TelegramDesktop"           --> doCenterFloat
               , className                     =? "Gmpc"                      --> doCenterFloat
               , className                     =? "mpv"                       --> doCenterFloat
               , className                     =? "GoldenDict"                --> doCenterFloat
               , className                     =? "Catfish"                   --> doCenterFloat
               , className                     =? "Xfce4-settings-manager"    --> doCenterFloat
               , className                     =? "Xfce4-appfinder"           --> doCenterFloat
               , className                     =? "Slack"                     --> doCenterFloat
               , className                     =? "Gedit"                     --> doCenterFloat
               , className                     =? "Evolution"                 --> doCenterFloat
               , className                     =? "Gnome-system-monitor"      --> doCenterFloat
               , className                     =? "Org.gnome.gedit"           --> doCenterFloat
               , className                     =? "File-roller"               --> doCenterFloat
               , className                     =? "Xfce4-screenshooter"       --> doCenterFloat
               , className                     =? "Pamac-manager"             --> doCenterFloat
               , stringProperty "WM_ICON_NAME" =? "File Operation Progress"   --> doCenterFloat
               , stringProperty "WM_ICON_NAME" =? "Reminders"                 --> doCenterFloat
               , checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_DIALOG" --> doCenterFloat
               , checkAtom "_NET_WM_WINDOW_TYPE" "_NET_WM_WINDOW_TYPE_MENU"   --> doCenterFloat
               ]

