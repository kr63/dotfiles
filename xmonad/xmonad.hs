import XMonad
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run            -- spawnPipe, hPutStrln
import XMonad.Hooks.ManageDocks   -- avoidStruts, docksEventHook
import XMonad.Hooks.DynamicLog    -- dynamicLogWithPP
import XMonad.Hooks.ManageHelpers -- helper functions to be used in manageHook
import XMonad.Hooks.SetWMName     -- setWMName
import XMonad.Layout.PerWorkspace -- onWorkspace
import XMonad.Layout.Circle
import XMonad.Layout.TwoPane

main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ def
        { terminal = "urxvt"
        , modMask = mod4Mask
        , borderWidth = 2
        , normalBorderColor  = "#353945"
        , focusedBorderColor = "#ffffff"
        , focusFollowsMouse = False
        , clickJustFocuses = True
        , workspaces  = myWorkspaces
        , startupHook = myStartupHook
        , manageHook = myManageHook <+> manageDocks <+> manageHook def
        , layoutHook = avoidStruts $ myLayout
        , handleEventHook = docksEventHook <+> handleEventHook def
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "grey" "" . shorten 50
                    }
        }
        `additionalKeys` myKeys

--------------------------------------------------------------------------------
-- key bindigns
myKeys =
    [ (( mod4Mask, xK_e), spawn "thunar")
    , (( mod4Mask, xK_o), spawn "emacsclient -c")
    , (( mod4Mask, xK_p), spawn "rofi -show drun")
    , (( mod4Mask, xK_s), spawn "xfce4-settings-manager")
    , (( mod4Mask .|. shiftMask, xK_t), spawn "gnome-system-monitor")
    , (( 0, xK_Print), spawn "xfce4-screenshooter")
    , (( mod4Mask, xK_g), spawn "google-chrome-stable")
    ]
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- layout & workspace definition
ideaLayout = TwoPane (3/100) (1/2) ||| Full
myLayout =
    onWorkspace "9" (ideaLayout) $          -- ideaLayout will be used on workspace "9"
    Tall 1 (0.03) (0.6) ||| Circle ||| Full -- layouts for the other workspaces
myWorkspaces = ["1:web","2:files","3:emacs","4:lo","5:IM", "6:vm"] ++ map show [7..9]
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- auto startup
myStartupHook = do
    setWMName "LG3D"
    spawn "~/.xmonad/startup.sh"
    spawn "emacs --daemon"
    spawn "xfsettingsd"
    spawn "xfce4-volumed"
    spawn "feh --no-xinerama --bg-fill /home/lxuser/software/wallpaper-2330974.jpg"
    spawn "dbus-launch nm-applet"
    spawn "urxvt"
    spawn "emacsclient -c"
    spawn "thunar"
    spawn "google-chrome-stable"
    spawn "compton"
    spawn "alltray evolution"
    -- spawn ""
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Application manage hooks
myManageHook = composeAll
               [ className                       =? "Xfce4-notifyd"                      --> doIgnore
               , className                       =? "URxvt"                              --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               , className                       =? "Wine"                               --> doCenterFloat
               , className                       =? "Google-chrome"                      --> doShift "1:web"
               , className                       =? "Firefox"                            --> doShift "1:web"
               , appName                         =? "Places" <&&> className =? "Firefox" --> doCenterFloat
               , className                       =? "Thunar"                             --> doShift "2:files"
               , className                       =? "Emacs"                              --> doShift "3:emacs"
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
