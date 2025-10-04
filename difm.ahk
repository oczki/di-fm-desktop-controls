#Requires AutoHotkey v2.0
#SingleInstance Force
KeyHistory 0
Persistent

difmAppExe  := "brave.exe"
difmAppPath := "C:\Program Files\BraveSoftware\Brave-Browser\Application\chrome_proxy.exe"
difmAppArgs := "--profile-directory=Default --app-id=hkmmhjbfkcoebffpjoijaejomhndkkec"
difmWinClass := "Chrome_WidgetWin_1"
difmWinTitle := "di.fm"
difmWinWidth := 680
difmWinHeight := 106
difmDoubleKeyDelayMs := 300

#InputLevel 1

difmGetWindow() {
  DetectHiddenWindows true
  return WinExist(difmWinTitle " ahk_class " difmWinClass " ahk_exe " difmAppExe)
}

difmShowWindow(hwnd) {
  WinShow(hwnd)
  WinActivate(hwnd)
  mon := MonitorGetPrimary()
  MonitorGet(mon, &left, &top, &right, &bottom)
  WinMove(left - 8, top - 34, difmWinWidth, difmWinHeight, hwnd)
}

difmHideWindow(hwnd) {
  difmMoveWindowOffscreen(hwnd)
}

difmActivateWindowOffscreen(hwnd) {
  WinShow(hwnd)
  WinActivate(hwnd)
  difmMoveWindowOffscreen(hwnd)
}

difmMoveWindowOffscreen(hwnd) {
  mon := MonitorGetPrimary()
  MonitorGet(mon, &left, &top, &right, &bottom)
  WinMove(left, top - 300, difmWinWidth, difmWinHeight, hwnd)
}

difmWindowIsVisible(hwnd) {
  WinGetPos(&difmX, &difmY, &difmWidth, &difmHeight, hwnd)
  MonitorGet(MonitorGetPrimary(), &left, &top, &right, &bottom)
  return (top < difmY + difmHeight)
}

difmToggleWindow(hwnd) {
  if (difmWindowIsVisible(hwnd)) {
    difmHideWindow(hwnd)
  } else {
    difmShowWindow(hwnd)
  }
}

difmSpawnWindow() {
  Run(difmAppPath " " difmAppArgs)
  WinWait(difmWinTitle " ahk_class " difmWinClass " ahk_exe " difmAppExe, , 10000)
  return difmGetWindow()
}

difmOnePlayPress() {
  hwnd := difmGetWindow()
  if (hwnd) {
    isWindowVisible := difmWindowIsVisible(hwnd)
    lastActiveWindow := WinExist("A")
    if (!isWindowVisible) {
      difmActivateWindowOffscreen(hwnd)
    }
    ControlFocus(hwnd)
    ControlSend(" ", , hwnd)
    if (!isWindowVisible) {
      if (lastActiveWindow) {
        WinActivate(lastActiveWindow)
      }
      difmHideWindow(hwnd)
    }
  } else {
    SendInput("{Media_Play_Pause}")
  }
}

difmTwoPlayPresses() {
  hwnd := difmGetWindow()
  if (hwnd) {
    difmToggleWindow(hwnd)
  } else {
    hwnd := difmSpawnWindow()
    if (hwnd) {
      difmShowWindow(hwnd)
    }
  }
}

Media_Play_Pause::
KeyMediaPlayPause(ThisHotkey) {
  static keyPresses := 0
  if (keyPresses > 0) {
    keyPresses += 1
    return
  }
  
  keyPresses := 1
  SetTimer AfterDelay, -difmDoubleKeyDelayMs
  
  AfterDelay() {
    SendLevel 0
    if (keyPresses = 1) {
      difmOnePlayPress()
    }
    else if (keyPresses = 2) {
      difmTwoPlayPresses()
    }
    keyPresses := 0
  }
}
