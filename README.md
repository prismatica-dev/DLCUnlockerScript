# DLCUnlockerScript
A simple interactive bash script designed for installing SmokeAPI and CreamAPI on Windows and Linux (with or without Proton).

## Installing
### Cloning Repository
The following git commands will clone the repository. Alternatively [directly download it as a .zip](https://github.com/lily-software/DLCUnlockerScript/archive/refs/heads/main.zip).
```
git clone https://github.com/lily-software/dlcunlockerscript
cd dlcunlockerscript
```

### Arch User Repository
Users on Arch-based Linux distributions can use the [AUR package instead](https://aur.archlinux.org/packages/dlcunlockerscript).

## Usage
Run the script with the syntax `sh DLCUnlockerScript.sh C:/ExampleDirectory`

You will then be taken through interactive prompts based on the mode and system on which you wish to install. The script will automatically install the required files and recommended configuration file (unless already present).

### Arch Usage
The PKGBUILD file automatically adds the commands 'DLCUnlocker' and 'dlcunlocker' to the /usr/bin directory. This functions the same to 'sh DLCUnlockerScript.sh' and can be used with the syntax `dlcunlocker /directory-here/`

## Linux Users
For users running native Linux games through Steam with CreamLinux, you will only have to add `sh ./cream.sh %command%` to the game launch arguments in Steam.

If you are installing SmokeAPI for a game running through Proton, it is recommended you just use Proxy mode, as this does not require any additional launch arguments and will work in almost all cases.

However, if you insist on using Hook mode add the following to your arguments:
- 64-Bit Installation: `PROTON_LOG=1 WINEDLLOVERRIDES="SmokeAPI=n,b;steam_api64=n;version=n,b" %command%`
- 32-Bit Installation: `PROTON_LOG=1 WINEDLLOVERRIDES="SmokeAPI=n,b;steam_api=n;version=n,b" %command%`

`PROTON_LOG=1` is only used for debugging purposes.

## Troubleshooting
**THIS SCRIPT DOES NOT INSTALL DLC, IT JUST TELLS STEAM YOU OWN IT!!!**

Additionally, problems beyond the scope of the script (such as only certain DLCs not unlocking) do not need to be reported here. Report them on the corresponding forum post or github page.

### General
**THIS SCRIPT DOES NOT INSTALL DLC, IT JUST TELLS STEAM YOU OWN IT!!!**

SmokeAPI's hook mode tends to cause issues, try verifying the game files with Steam and then installing proxy mode instead.

### SmokeAPI/CreamLinux not loading
The game may have protection from DLC Unlockers or you may have installed with the wrong bitness. Try swapping between hook and proxy modes.

For Linux users, [ensure your Steam game launch arguments are correctly set.](https://github.com/lily-software/DLCUnlockerScript#linux-users).

### DLC Not Unlocked
With SmokeAPI, ensure a SmokeAPI.log.log file is being created when the game is launched as otherwise the installation has failed. Reinstall the default configuration file.
With CreamLinux, ensure you have specified the DLC steam id and name in the configuration file.

### Paradox Launcher warning that DLC is unowned
This is due to the launcher using a separate API which is not overridden by the script. The warning is purely visual and the game will still launch with DLC.

### Game Crashing with "version.dll not found"
This is caused by SmokeAPI's hook mode with Proton overriding other game DLLs and is a problem I had when testing Fallout 4. In these cases proxy mode should work instead, just verify the game files first. Alternatively, renaming `version.dll` to `anything-else.dll` and changing the WINEDLLOVERRIDES argument accordingly should fix it.

## Licensing
This is a free, open source project provided under the MIT License. Ideally, it would be provided under the Unlicense/BSD0/etc, but this is not possible due to relying on MIT licensed projects, requiring release under the same license.

### Licenses + Versions Used
- [20180720] [MIT License] Bash Menu from bash-menu https://github.com/barbw1re/bash-menu
- [v2.0.3] [MIT License] CreamLinux from creamlinux https://github.com/anticitizn/creamlinux
- [v2.0.5] [Unlicense] SmokeAPI from SmokeAPI https://github.com/acidicoala/SmokeAPI
- [v3.0.2] [Unlicense] Version API from Koaloader https://github.com/acidicoala/Koaloader
