# Personal Mac OSX config
Don’t blindly use my settings unless you know what that entails. Use at your own risk!

This configuration is intended only for macOS on Apple Silicon (`arm64`).

Run the installer from this directory:

```bash
./main.sh
```

The cleanup script is intentionally destructive and requires an explicit flag:

```bash
./modules/cleanUp.sh --yes
```

The installer also copies the Darktable stylesheet and LinearMouse configuration
to their macOS application-support directories.
