# android-kbd-layouts

Physical keyboard layouts for Android that bring macOS-style shortcuts to an external (Mac) keyboard and make Caps Lock switch the input language.

The layouts are plain key character map (`.kcm`) overlays shipped in a code-less APK. They need no root, no accessibility service and no background process: Android loads them like any built-in keyboard layout.

## What it does

| Keys | Action |
|---|---|
| Caps Lock | Switch input language (e.g. EN ↔ RU) |
| Command + C / V / X | Copy / Paste / Cut, including in the Linux Terminal app |
| Command + T / A / Z / W / L / F … | Same as Ctrl + key (new tab, select all, undo, …) |
| Ctrl + C in a terminal | Unchanged, sends SIGINT |
| Command + Tab | Recent apps overview |
| Command + Space | App launcher with search |
| Option + Tab | Native app switcher (hold Option, press Tab to cycle) |

Included layouts:

- English (US), Caps Lock switch
- Russian, Caps Lock switch
- Russian (Mac), Caps Lock switch

They are based on the stock AOSP layouts, so typing is unchanged; only the keys above behave differently.

## How it works

- Caps Lock is remapped to `LANGUAGE_SWITCH`.
- Command (left and right) is remapped to **right Ctrl**, so it works as Ctrl in every app, while the physical Ctrl key stays **left Ctrl**. The layout tells the two apart, which is why Command + C can copy while Ctrl + C still interrupts a terminal program.
- Right Ctrl + C / V / X is replaced with the `COPY` / `PASTE` / `CUT` key codes, right Ctrl + Tab with `APP_SWITCH` and right Ctrl + Space with `ALL_APPS`.

Command is deliberately not used as Android's Meta (Action) key: the system intercepts Meta key combinations for its own shortcuts, so they never reach apps.

## Requirements

- Android 14 or newer. Tested on a Pixel 10 Pro XL running Android 17.
- An external keyboard with a Command key (any Mac keyboard).
- `adb` with USB or wireless debugging enabled on the phone.

## Install

### Download

Get the prebuilt APK from [Releases](https://github.com/kvaps/android-kbd-layouts/releases), or build it yourself.

### Build

On Debian or Ubuntu:

```sh
sudo apt install aapt apksigner zipalign android-framework-res default-jre-headless
git clone https://github.com/kvaps/android-kbd-layouts
cd android-kbd-layouts
./build.sh
```

The first build generates a signing key, `debug.keystore`. Keep it: updates must be signed with the same key, otherwise the app has to be uninstalled before a new build can be installed.

### Install on the phone

```sh
adb install -r build/kbd-layouts.apk
```

Use the downloaded file name instead if you took the APK from Releases.

### Select the layouts

Open **Settings → System → Keyboard → Physical keyboard → *your keyboard*** and pick the matching layout for every input language listed there:

- English → **English (US), Caps Lock switch**
- Russian → **Russian, Caps Lock switch** (or the Mac variant)

Every enabled language needs a Caps Lock switch layout. Caps Lock cycles through all languages enabled in your on-screen keyboard (e.g. Gboard). A language left on a stock layout turns Caps Lock back into plain Caps Lock, so you get stuck in that language. Either assign *English (US), Caps Lock switch* to extra Latin-script languages or remove the languages you do not need.

### Keep the system modifier swap off

Do not swap Ctrl and Action under **Physical keyboard → Modifier keys**. With the swap on, the physical Ctrl key turns into Meta, and Ctrl + C no longer reaches the terminal.

## Limitations

- Command + Tab opens the overview instead of the hold-to-cycle switcher: a layout can only replace a key with a single key code, it cannot add Alt. Use Option + Tab for the switcher.
- With Command acting as Ctrl, it no longer works as Android's Action key (for example, pressing it alone does not open the app drawer). Command + Space covers the launcher.
- Caps Lock no longer toggles capital letters. Use Shift.

## Uninstall

```sh
adb uninstall io.kvaps.kbdlayouts
```

## License

[Apache License 2.0](LICENSE). The layouts are derived from the Android Open Source Project keyboard layouts, which are licensed under the same terms.
