import XMonad
import System.IO
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.NamedWindows
import XMonad.Util.Run
import XMonad.Actions.GridSelect

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook

import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Layout.Circle
import XMonad.Layout.MagicFocus
import XMonad.Layout.Dishes
import XMonad.Layout.OneBig
import XMonad.Layout.SimpleFloat
import XMonad.Layout.SimplestFloat
import XMonad.Layout.PerWorkspace
import XMonad.Layout.BorderResize
import XMonad.Layout.MouseResizableTile

import XMonad.Actions.SimpleDate
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Actions.MouseResize
 
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
  urgencyHook LibNotifyUrgencyHook w = do
    name     <- getName w
    Just idx <- fmap (W.findTag w) $ gets windowset
    safeSpawn "notify-send" [show name, "workspace " ++ idx]


------------------------------------------------------------------------
-- My Hooks
myManageHook = composeAll
               [ className                       =? "Xfce4-notifyd"                      --> doIgnore
               , className                       =? "URxvt"                              --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               , className                       =? "Wine"                               --> doCenterFloat
               , className                       =? "Google-chrome"                      --> doShift "1:web"
               , className                       =? "Firefox"                            --> doShift "1:web"
               , appName                         =? "Places" <&&> className =? "Firefox" --> doCenterFloat
               , className                       =? "Thunar"                             --> doShift "2:files"
               , className                       =? "Emacs"                              --> doShift "3:emacs"
               -- , className                       =? "jetbrains-idea"                     --> doShift "9:idea"
               , appName                         =? "libreoffice"                        --> doShift "4:lo"
               , title                           =? "LibreOffice"                        --> doShift "4:lo"
               , appName                         =? "VirtualBox"                         --> doShift "6:vm"
               , className                       =? "Thunderbird"                        --> doShift "5:IM"
               , className                       =? "Skype"                              --> doShift "5:IM"
               , appName                         =? "Msgcompose"                         --> doCenterFloat
               , className                       =? "mpv"                                --> doCenterFloat
               , className                       =? "vlc"                                --> doCenterFloat
               , className                       =? "xmessage"                           --> doCenterFloat
               , className                       =? "Gmpc"                               --> doCenterFloat
               , className                       =? "Goldendict"                         --> doCenterFloat
               , className                       =? "Catfish"                            --> doCenterFloat
               , className                       =? "Xfce4-settings-manager"             --> doCenterFloat
               , className                       =? "Xfce4-appfinder"                    --> doCenterFloat
               , className                       =? "Slack"                              --> doCenterFloat
               , className                       =? "Gedit"                              --> doCenterFloat
               -- , className                       =? "Alltray"                            --> doCenterFloat
               , className                       =? "Evolution"                          --> doCenterFloat
               , className                       =? "Gnome-system-monitor"               --> doCenterFloat

               , stringProperty "WM_ICON_NAME"   =? "Unlock Keyring"                     --> doCenterFloat
               , stringProperty "WM_ICON_NAME"   =? "File Operation Progress"            --> doCenterFloat
               , stringProperty "WM_ICON_NAME"   =? "Task Manager"                       --> doCenterFloat
               , stringProperty "WM_ICON_NAME"   =? "Thunderbird Preferences"            --> doCenterFloat
               , stringProperty "WM_WINDOW_ROLE" =? "CallWindow"                         --> doCenterFloat
               , className                       =? "Claws-mail"                         --> doCenterFloat


               , className =? "Claws-mail" <&&> stringProperty "WM_WINDOW_ROLE" =? "mainwindow"  --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               , className =? "Xarchiver"  <&&> stringProperty "WM_ICON_NAME" =? "Extract files" --> doRectFloat (W.RationalRect 0.2 0.2 0.2 0.5)
               , className =? "Xarchiver"                                                        --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               ]

myWorkspaces = ["1:web","2:files","3:emacs","4:lo","5:IM", "6:vm"]  ++ map show [7..9]
myTerm = "urxvt"
myFocusFollowsMouse = False
myClickJustFocuses = True
myBorderWidth   = 2
myNormalBorderColor  = "#353945"
myFocusedBorderColor = "#ffffff"

myStartupHook = do
    setWMName "LG3D"
    spawn "emacs --daemon"
    spawn "xfsettingsd"
    spawn "xfce4-volumed"
    spawn "feh --no-xinerama --bg-fill /home/lxuser/software/wallpaper-2330974.jpg"
    spawn "~/.xmonad/startup.sh"
    spawn "dbus-launch nm-applet"
    spawn "urxvt"
    spawn "emacsclient -c"
    spawn "thunar"
    spawn "google-chrome-stable"
    spawn "compton"
    spawn "alltray evolution"
    -- spawn ""

defaultLayouts = Tall 1 (0.03) (0.6) ||| Circle ||| Full
myLayout = onWorkspace "8:vm" Full $ onWorkspace "4:lo" Full $ defaultLayouts
  
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ withUrgencyHook LibNotifyUrgencyHook $ def
      {
        modMask = mod4Mask,
        startupHook = myStartupHook,
        terminal = myTerm,
        manageHook = myManageHook <+> manageDocks <+> manageHook def,
        handleEventHook = docksEventHook <+> handleEventHook def,
        borderWidth = myBorderWidth,

        normalBorderColor = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

        focusFollowsMouse = myFocusFollowsMouse,
        clickJustFocuses = myClickJustFocuses,
        workspaces  = myWorkspaces,
        layoutHook = avoidStruts $ myLayout,
        logHook = dynamicLogWithPP xmobarPP {
            ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "grey" "" . shorten 50
            }
        }`additionalKeys`
        [
        (( mod4Mask, xK_e), spawn "thunar"),
        (( mod4Mask, xK_o), spawn "emacsclient -c"),
        (( mod4Mask, xK_p), spawn "rofi -show drun"),
        (( mod4Mask, xK_s), spawn "xfce4-settings-manager"),
        (( mod4Mask .|. shiftMask, xK_t), spawn "gnome-system-monitor"),
        (( 0, xK_Print), spawn "xfce4-screenshooter"),
        (( mod4Mask, xK_g), spawn "google-chrome-stable")
        ]
