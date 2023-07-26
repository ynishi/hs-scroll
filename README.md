# hs-scroll

- require
  - xdotool
  - xclip
  - ImageMagick
  - Setting Ctrl+Alt+Print take window's screen shot.
- cabal
- ghc-8.10

## install

- If you don't setup ghc with version, remove cabal.project file and try. GHC version 8 is supported, 9 is not work.

```
git clone ...
cd ...
cabal install
```

### install dependency lib

```
sudo apt install libglib2.0-dev
sudo apt install xdotool
sudo apt install libgtk-3-dev
```

## run

- via cabal or run executable

### via cabal

```
cabal run
```

### run executable

```
# cli
hs-scroll
# gtk
hs-scroll-gui
```
