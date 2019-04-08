import XMonad hiding ( (|||) )
import XMonad.Config.Xfce
import XMonad.Util.EZConfig(additionalKeys)

import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Replace(replace)

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W

import XMonad.Layout.LayoutCombinators
import XMonad.Layout.LayoutScreens
import XMonad.Layout.TwoPane
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Layout.Circle

myManageHook = composeAll
               [ className                       =? "Xfce4-notifyd"                      --> doIgnore
               , className                       =? "URxvt"                              --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               , className                       =? "Xfrun4"                             --> doCenterFloat
               , className                       =? "Wine"                               --> doCenterFloat
               , className                       =? "Google-chrome"                      --> doShift "1"
               , className                       =? "Thunar"                             --> doShift "2"
               , className                       =? "Emacs"                              --> doShift "3"
               , appName                         =? "libreoffice"                        --> doShift "4"
               , title                           =? "LibreOffice"                        --> doShift "4"
               , appName                         =? "VirtualBox"                         --> doShift "6"
               , className                       =? "Skype"                              --> doShift "5"
               , className                       =? "mpv"                                --> doCenterFloat
               , className                       =? "GoldenDict"                         --> doCenterFloat
               , className                       =? "Catfish"                            --> doCenterFloat
               , className                       =? "Xfce4-settings-manager"             --> doCenterFloat
               , className                       =? "Xfce4-appfinder"                    --> doCenterFloat
               , className                       =? "Slack"                              --> doCenterFloat
               , className                       =? "Gedit"                              --> doCenterFloat
               , className                       =? "Evolution"                          --> doCenterFloat
               , className                       =? "Gnome-system-monitor"               --> doCenterFloat
               ]

defaultLayouts = Tall 1 (0.03) (0.6) ||| Circle ||| Full
myLayout = defaultLayouts

myStartupHook = do
    spawn "~/.xmonad/startup.sh"
    spawn "xfce4-panel -r"
    spawn "compton"
    spawn "emacs --daemon"
    spawn "urxvt"
    spawn "thunar"
    spawn "google-chrome-stable"
    -- spawn ""

main = do
  replace
  xmonad $ ewmh xfceConfig
    { terminal = "urxvt"
    , startupHook = myStartupHook
    , modMask     = mod4Mask
    , manageHook = myManageHook <+> manageDocks <+> manageHook xfceConfig
    , borderWidth = 2
    , normalBorderColor = "#353945"
    , focusedBorderColor = "#ffffff"
    , layoutHook = avoidStruts $ myLayout
    }`additionalKeys`
    [
    (( mod4Mask, xK_p), spawn "xfce4-appfinder"),
    (( mod4Mask, xK_e), spawn "thunar"),
    (( mod4Mask, xK_o), spawn "emacsclient -c"),
    (( mod4Mask, xK_s), spawn "xfce4-settings-manager"),
    (( mod4Mask .|. shiftMask, xK_t), spawn "gnome-system-monitor"),
    (( 0, xK_Print), spawn "xfce4-screenshooter"),
    (( mod4Mask, xK_g), spawn "google-chrome-stable")
    ]

