# Hotkeys for di.fm website

There's no official desktop player for **[di.fm](https://www.di.fm/)**! Argh!

I wanted to mimic the behavior of GPMDP (unofficial desktop player for Google Play Music, later rebranded to YouTube Music).  
Specifically, these features:
- Global hotkey to **play/pause music** via <kbd>Media Play/Pause</kbd> key
- Global hotkey to **show/hide the player's window** when <kbd>Media Play/Pause</kbd> is quickly pressed **twice**
- Have a **tiny player** that won't cover much of the screen

<img width="3839" height="2160" src="https://github.com/user-attachments/assets/de35274f-0f86-49e1-8048-569fb287e9a8" alt="Screenshot of a Windows desktop with a tiny music player docked in the top left corner."/>

---

## Requirements

- **Windows**
- A keyboard with a <kbd>Media Play/Pause</kbd> key. Not a hard requirement, but you'll have to edit the script yourself to change this.
- **[AutoHotkey v2](https://www.autohotkey.com/)**
- A Chromium web browser (I'm using **[Brave](https://brave.com/)**)
- **[Stylus](https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne)** or any other browser extension for injecting custom CSS

---

## Installation

This is done in two parts. The AHK script controls the playback and the player's window. The CSS hides unnecessary things on the page.

### AHK

1. Open [di.fm](https://www.di.fm/) in your browser.
2. In the browser's menu, navigate to **Save and share** → **Install page as app...** (in Edge it could be in the **More** section instead).
3. Enter the name of the "app". A new shortcut will appear on your desktop.
4. Right click on that shortcut and go to Properties. Copy the **Target** field. It will look like this:  
   `"C:\Program Files\BraveSoftware\Brave-Browser\Application\chrome_proxy.exe"  --profile-directory=Default --app-id=hkmmhjbfkcoebffpjoijaejomhndkkec`
5. Download [difm.ahk](https://github.com/oczki/di-fm-desktop-controls/blob/main/difm.ahk). Don't run it yet.
6. Open the script in your text editor. Edit these lines:
   ```autohotkey
   difmAppExe  := "brave.exe"
   difmAppPath := "C:\Program Files\BraveSoftware\Brave-Browser\Application\chrome_proxy.exe"
   difmAppArgs := "--profile-directory=Default --app-id=hkmmhjbfkcoebffpjoijaejomhndkkec"
   ```
   - For `difmAppExe`, you can use AHK's Window Spy and hover over the player's window.  
     <img width="332" height="138" alt="image" src="https://github.com/user-attachments/assets/02ea154f-3641-4487-83ed-2daa92daf64d" />
   - For `difmAppPath` and `difmAppArgs`, use the value from the shortcut's Target you just copied.
7. (Optional) Edit other constants of the script, like the max duration between key presses to be considered a double press.
8. Save the AHK script and run it.


### CSS

1. Open [di.fm](https://www.di.fm/) in your browser.
2. Look for Stylus's icon in the browser's extensions section. Click on it.
3. Replace the style with contents of [difm.user.css](https://github.com/oczki/di-fm-desktop-controls/blob/main/difm.user.css).
4. Save and close Stylus's tab.


### Finalize

1. Close all di.fm tabs. They're not needed anymore, because you'll use the "app" (PWA).
2. Quickly double press the <kbd>Media Play/Pause</kbd> key. The player's window should appear in the corner of your primary screen.
3. Press this key once to play/pause the music.
4. Press this key twice to show/hide the player.
5. Consider adding the AHK script into your autostart, so it works across reboots.

---

The script works around Chromium's limitations by briefly focusing the player's window and sending a <kbd>Spacebar</kbd> key to the page. The focus is then restored to the last active window.

It sends `" "` instead of `"{Media_Play_Pause}"` to prevent conflicts with other tabs that are currently playing media.

---

## License

**[MIT](https://github.com/oczki/di-fm-desktop-controls/blob/main/LICENSE)**.
