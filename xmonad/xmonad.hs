import XMonad
-- xmobar setup
import XMonad.Hooks.DynamicLog
import System.IO
import XMonad.Hooks.ManageDocks
-- import XMonad.Util.Run(spawnPipe)
-- additional key settings
import XMonad.Util.EZConfig(additionalKeys)
-- GridSelect
import XMonad.Actions.GridSelect
-- Dolphin dialog do float
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place

import XMonad.Hooks.SetWMName

import qualified XMonad.StackSet as W

-- Layout --------------------------------------------------------------
import XMonad.Layout.Circle
import XMonad.Layout.MagicFocus
import XMonad.Layout.Dishes
import XMonad.Layout.OneBig
import XMonad.Layout.SimpleFloat
import XMonad.Layout.SimplestFloat
import XMonad.Layout.PerWorkspace
------------------------------------------------------------------------

import XMonad.Layout.BorderResize

-- import XMonad.Layout.Minimize
-- import XMonad.Layout.Accordion

-- настроить с ansys
-- import XMonad.Layout.Grid

import XMonad.Actions.SimpleDate

import qualified Data.Map as M
import XMonad.Actions.PerWorkspaceKeys
import XMonad.Layout.MouseResizableTile

------------------------------------------------------------------------
import XMonad.Actions.MouseResize
import XMonad.Layout.WindowArranger

------------------------------------------------------------------------
-- import XMonad.Hooks.XPropManage
-- import XMonad.Actions.TagWindows
-- import Data.List
------------------------------------------------------------------------

------------------------------------------------------------------------
import XMonad.Hooks.UrgencyHook
import XMonad.Util.NamedWindows
import XMonad.Util.Run
 
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
  urgencyHook LibNotifyUrgencyHook w = do
    name     <- getName w
    Just idx <- fmap (W.findTag w) $ gets windowset
    safeSpawn "notify-send" [show name, "workspace " ++ idx]
------------------------------------------------------------------------

  

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
               , className                       =? "GoldenDict"                         --> doCenterFloat
               , className                       =? "Catfish"                            --> doCenterFloat
               , className                       =? "Xfce4-settings-manager"             --> doCenterFloat
               , className                       =? "Xfce4-appfinder"                    --> doCenterFloat
               , className                       =? "Slack"                              --> doCenterFloat

               , stringProperty "WM_ICON_NAME"   =? "Unlock Keyring"                     --> doCenterFloat
               , stringProperty "WM_ICON_NAME"   =? "File Operation Progress"            --> doCenterFloat
               , stringProperty "WM_ICON_NAME"   =? "Task Manager"                       --> doCenterFloat
               , stringProperty "WM_ICON_NAME"   =? "Thunderbird Preferences"            --> doCenterFloat
               , stringProperty "WM_WINDOW_ROLE" =? "CallWindow"                         --> doCenterFloat
               , className                       =? "Claws-mail"                         --> doCenterFloat


               , className =? "Claws-mail" <&&> stringProperty "WM_WINDOW_ROLE" =? "mainwindow"  --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
               , className =? "Xarchiver"  <&&> stringProperty "WM_ICON_NAME" =? "Extract files" --> doRectFloat (W.RationalRect 0.2 0.2 0.2 0.5)
               , className =? "Xarchiver"                                                        --> doRectFloat (W.RationalRect 0.2 0.2 0.7 0.7)
------------------------------------------------------------------------
               -- ansys settings
               , title     =? "Define Material Model Behavior" --> doFloat
               , title     =? "ANSYS Process Status"           --> doFloat
               , appName   =? "dlgAnsysGUI"                    --> doShift "7"
               , className =? "AnsMessageBox"                  --> doCenterFloat
               -- icem cfd settings
               , className =? "Toplevel"                       --> doFloat
               ]

-- myManageHook = composeAll . concat $
--     [
--     [ className =? i --> doFloat | i <- myClassFloats ]
--     , [className =? "Gsimplecal" --> placeHook (fixed (1,0.02)) <+> doFloat ]
--     , [ className =? "Dolphin" <&&> role /=? "Dolphin#1" --> doFloat ]
--     ]
--     where
--         myClassFloats = ["mplayer2", "AnsMessageBox", "Smplayer", "ANSYS150", "Skype"]
--         role = stringProperty "WM_WINDOW_ROLE"

------------------------------------------------------------------------
-- myWorkspaces = ["1:web","2:files","3:emacs","4:lo","5:IM", "6:vm"]  ++ map show [7..8] ++ ["9:idea"]
myWorkspaces = ["1:web","2:files","3:emacs","4:lo","5:IM", "6:vm"]  ++ map show [7..9]

myTerm = "urxvt"

--Mouse pointer settings
myFocusFollowsMouse = False
myClickJustFocuses = True
-- Width of the window border in pixels.
myBorderWidth   = 2

-- -- Border colors for unfocused and focused windows, respectively.
-- myNormalBorderColor  = "#dddddd"
-- myFocusedBorderColor = "#ff0000"

myNormalBorderColor  = "#353945"
myFocusedBorderColor = "#ffffff"

myStartupHook = do
    setWMName "LG3D"
    spawn "emacs --daemon"
    spawn "xfsettingsd"
    spawn "xfce4-volumed"
    spawn "feh --no-xinerama --bg-fill /home/lxuser/software/wallpaper-2330974.jpg"
    spawn "~/.xmonad/startup.sh"
    -- spawn "thunderbird-bin"
    -- spawn "firefox"
    -- spawn "xfce4-power-manager"
    -- spawn "pnmixer"
    spawn "dbus-launch nm-applet"
    spawn "urxvt"
    spawn "emacsclient -c"
    spawn "thunar"
    -- spawn "gmpc -h &"
    -- spawn "claws-mail"
    spawn "google-chrome-stable"
    spawn "compton"
    -- spawn ""

------------------------------------------------------------------------
-- workspaceModkeys = [ (mod1Mask, map show ([1..4] ++ [6..9])) -- use Alt as modkey on all workspaces
--                    , (mod4Mask, ["5"])                       -- save 5th (use Win there)
--                    ]
--
-- modifiedKeysList conf = [
--         (( mod4Mask, xK_s), spawn "xfce4-settings-manager")
--         ]
--
-- unmodifiedKeys conf = [
--         (( mod1Mask, xK_f), spawn "firefox-bin")
--         ]
--
--
-- keysList conf = concat (map modifyKey (modifiedKeysList conf)) ++ (unmodifiedKeys conf)
--
-- modifyKey :: ((KeyMask, KeySym), X()) -> [((KeyMask, KeySym), X())]
-- modifyKey k = map (f k) workspaceModkeys
--   where
--     f ((mask, key), action) (mod, workspaces) = ((mask .|. mod, key), bindOn (map (\w -> (w, action)) workspaces))
--
-- myKeys conf = M.fromList $ keysList conf


-- myLayout = tiled ||| Mirror tiled ||| Full
-- myLayout = tiled ||| Circle ||| Full ||| Accordion
    -- where
    --     tiled = Tall nmaster delta ratio
    --     nmaster = 1
    --     ratio = 0.69
    --     delta = 5/100
-- myLayout = magicFocus (Tall 1 (0.03) (0.69) ||| Circle) ||| Full ||| Dishes 2 (1/6) ||| OneBig (1) (3/4)
-- myLayout = magicFocus (Tall 1 (0.03) (0.69) ||| Circle) ||| Full


defaultLayouts = Tall 1 (0.03) (0.6) ||| Circle ||| Full
myLayout = onWorkspace "8:vm" Full $ onWorkspace "4:lo" Full $ defaultLayouts
-- myLayout = onWorkspace "8:vm" Full $ onWorkspace "4:lo" Full $ onWorkspace "9:idea" mouseResizableTile $ defaultLayouts


  
------------------------------------------------------------------------
main = do
    xmproc <- spawnPipe "xmobar ~/.xmonad/xmobarrc"
    xmonad $ withUrgencyHook LibNotifyUrgencyHook $ def
      {
        -- modMask = mod1Mask,
        modMask = mod4Mask,
        -- keys = myKeys,
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
        -- layoutHook = avoidStruts  $  layoutHook defaultConfig,
        layoutHook = avoidStruts $ myLayout,
        logHook = dynamicLogWithPP xmobarPP {
            ppOutput = hPutStrLn xmproc
            , ppTitle = xmobarColor "grey" "" . shorten 50
            }
        }`additionalKeys`
        [
        (( mod4Mask, xK_e), spawn "thunar"),
        (( mod4Mask, xK_o), spawn "emacsclient -c"),
        -- (( mod4Mask, xK_p), spawn "exe=`dmenu_run -b -nb black -fn 'Terminus-18'` && eval \"exec $exe\""),
        (( mod4Mask, xK_p), spawn "rofi -show drun"),
        (( mod4Mask, xK_s), spawn "xfce4-settings-manager"),
        (( mod4Mask .|. shiftMask, xK_t), spawn "xfce4-taskmanager"),
        (( 0, xK_Print), spawn "xfce4-screenshooter"),
        (( mod4Mask, xK_g), spawn "google-chrome-stable")
        -- (( 0, button3), (\w -> focus w >> mouseResizeWindow w))
        -- (( mod4Mask, button3), \w -> focus w >> Flex.mouseResizeEdgeWindow  (3%5) w)
        -- (( Control, xK_f), spawn "catfish")
        -- (( mod4Mask, xK_m), withFocused minimizeWindow),
        -- (( mod4Mask .|. shiftMask, xK_m), sendMessage RestoreNextMinimizedWin),
        -- (( mod4Mask, xK_d), date),
        -- (( mod4Mask, xK_f), spawn "firefox-bin"),
        -- (( mod4Mask, xK_e), spawn "dolphin"),
        -- -- gridSelect
        -- (( mod1Mask, xK_g ), goToSelected defaultGSConfig),
        -- (( mod1Mask, xK_Print ), spawn "scrot"),
        -- (( mod1Mask .|. shiftMask , xK_Print ), spawn "scrot -d 3")
        ]
