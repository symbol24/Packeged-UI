# packed-ui

Packed Ui is intended as an all-in-one menu system starting point, for game jams and small projects. The plugin contains:

- A UI canvas autload that is automatically set by the plugin config.
    - Conatins the signals used by Packed UI and signals for the user to connect to for unpausing and loading out of the game from Pause menu.

- A main menu with buttons created at runtime with pre-determined possible button names. (See main_menu.gd)

- An Options/Settings menu with basic functionailty:
    - Sliders for Master, Music and SFX buses, intended to be used with either the Simple Audio Manger plugin, or your own system.
    - Window mode and sizes that function out of the box.
    - Language selection based on available loaded localization. If none are loaded, the option is not displayed.

- A credits menu, that uses a resource to load sections containing a title, l;ist of images and list of names.

- Popups:
    - A small popup that is timed and display text and optional icon.
    - A large popup that has:
        - Confirm and cancel buttons.
        - A severity system.
        - Title and text fields.
        - Icons dependent on severity.
        - A timing system to allow the popup to timeout cancel.

- A Pause menu that has a button to display the options menu, a return to game button and a button to return to Main Menu.
    - Mainly empty to allow users to fill it themselves.

- Player UI, intended to be empty to allow users to fill it themselves.

- An end result screen, intended to be empty to allow users to fill it themselves.

Due to the size and complexity of the Packed UI, not everything will be 100% on version 1.0, and I will require as much feedback and issues as possoble to update the plugin.

The ui elements use the godot themes and a lot of Type Variants. Have a look at  addons\PackedUi\default_theme.tres

To contact me directly, you can find me on twitch @ twitch.tv/symbol24 or send me an email at symbol24.info@gmail.com.