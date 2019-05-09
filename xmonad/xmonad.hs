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
import XMonad.Layout.WindowNavigation
import XMonad.Layout.TwoPane
import XMonad.Layout.Circle
  
main = do
    replace
    xmonad $ ewmh xfceConfig
        { terminal = "urxvt"
        , modMask     = mod4Mask
        , borderWidth = 2
        , normalBorderColor = "#353945"
        , focusedBorderColor = "#ffffff"
        , startupHook = myStartupHook
        , manageHook = myManageHook <+> manageDocks <+> manageHook xfceConfig
        , layoutHook = avoidStruts $ myLayout
        } `additionalKeys` myKeys

--------------------------------------------------------------------------------
-- key bindigns
--------------------------------------------------------------------------------
myKeys =
    [ ((mod4Mask, xK_p), spawn "xfce4-appfinder")
    , ((mod4Mask, xK_e), spawn "thunar")
    , ((mod4Mask, xK_o), spawn "emacsclient -c")
    , ((mod4Mask, xK_s), spawn "xfce4-settings-manager")
    , ((mod4Mask .|. shiftMask, xK_t), spawn "gnome-system-monitor")
    , ((0, xK_Print), spawn "xfce4-screenshooter")
    , ((mod4Mask, xK_g), spawn "google-chrome-stable")
    -- , ((mod4Mask .|. shiftMask,                 xK_space), layoutScreens 2 (TwoPane 0.5 0.5))
    -- , ((mod4Mask .|. controlMask .|. shiftMask, xK_space), rescreen)
    , ((mod4Mask, xK_d ), sendMessage $ JumpToLayout "tile")
    , ((mod4Mask, xK_m ), sendMessage $ JumpToLayout "coltile")
    , ((mod4Mask,                 xK_Right), sendMessage $ Go R)
    , ((mod4Mask,                 xK_Left ), sendMessage $ Go L)
    , ((mod4Mask,                 xK_Up   ), sendMessage $ Go U)
    , ((mod4Mask,                 xK_Down ), sendMessage $ Go D)
    , ((mod4Mask .|. controlMask, xK_Right), sendMessage $ Swap R)
    , ((mod4Mask .|. controlMask, xK_Left ), sendMessage $ Swap L)
    , ((mod4Mask .|. controlMask, xK_Up   ), sendMessage $ Swap U)
    , ((mod4Mask .|. controlMask, xK_Down ), sendMessage $ Swap D)
    ]

--------------------------------------------------------------------------------
-- layout & workspace definition
--------------------------------------------------------------------------------
-- Разделить экран по вертикали в отношении 3:1
onebig = windowNavigation (tile ***|* coltile)
           where
             -- компоновка для левой части
             -- master-окно занимает 3/4 по высоте
             tile = Full
             -- компоновка для правой части
             -- располагает все окна в один столбец
             coltile = Full

defaultLayouts = Tall 1 (0.03) (0.6) ||| Circle ||| Full
ideaLayout = TwoPane (3/100) (1/2) ||| Full
myLayout = onWorkspace "9" (ideaLayout) $ -- ideaLayout will be used on workspace "9"
           onWorkspace "8" onebig $
           defaultLayouts                 -- defaultLayout will be used on all other workspaces.

--------------------------------------------------------------------------------
-- auto startup
--------------------------------------------------------------------------------
myStartupHook = do
    spawn "~/.xmonad/startup.sh"
    spawn "xfce4-panel -r"
    spawn "compton"
    spawn "emacs --daemon"
    spawn "urxvt"
    spawn "thunar"
    spawn "google-chrome-stable"
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
