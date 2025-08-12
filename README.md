# Tiler
A macOS window management app for moving and resizing windows using keyboard shortcuts.
## Prerequisite
Tiler works on macOS Sonoma 14.6 and later.
## Installing
You can install the app from the releases here on Github, or through homebrew:
```
brew tap eriklinnarson/tiler
brew install --cask tiler
```
## Running the app
Tiler uses the Accessiblity API to control your windows, and therefore requires you to grant these permissions. A prompt for this will be presented the first time you launch the app, wich will take you to the page in settings where you can allow this. You can also go there manually by navigating to `Settings` -> `Privacy & Security` -> `Accessibility`.

When Accessibility permissions have been granted, you can start using the app. Clicking on the menu bar item will present you with a list of available commands. You can perform these actions right from the menu bar, but it's more intended to be a cheat sheet for their keybindings. You can update these keybindings by clicking on `Preferences` in the bottom of the menu bar.
