#! /usr/bin/bash

# Ensure we are running under bash
if [ "$BASH_SOURCE" = "" ]; then
    /usr/bin/bash "$0"
    exit 0
fi

#
# Load bash-menu script
#
# NOTE: Ensure this is done before using
#       or overriding menu functions/variables.
#
scriptDir=$(dirname $0)
if [ $# = 0 ]; then
    echo "No directory provided. Please specify a valid game directory."
    exit
fi
installDir=$1
bitness="Unknown"
if [ ! -d $installDir ]; then
    echo "Invalid directory provided. Please specify a valid game directory."
    exit
fi

. "$scriptDir/bash-menu.sh"


################################
## Example Menu Actions
##
## They should return 1 to indicate that the menu
## should continue, or return 0 to signify the menu
## should exit.
################################
windowsH() {
    setupBitMenu
    menuInit
    menuLoop
    setupMenu
    menuInit

    echo "SmokeAPI Hook Mode Installer"
    echo ""
    echo "Installing SmokeAPI Hook Mode ($bitness-Bit)"
    if [ $bitness = "unknown" ]; then
        exit
    fi

    echo "[1/3] Copying SmokeAPI.dll"
    if [ $bitness = "64" ]; then
        cp "$scriptDir/assets/SmokeAPI/steam_api64.dll" "$installDir/SmokeAPI.dll"
    elif [ $bitness = "32" ]; then
        cp "$scriptDir/assets/SmokeAPI/steam_api.dll" "$installDir/SmokeAPI.dll"
    fi

    echo "[2/3] Copying version.dll"
    cp "$scriptDir/assets/SmokeAPI/version$bitness.dll" "$installDir/version.dll"

    echo "[3/3] Checking for SmokeAPI.config.json"
    if [ -f "$installDir/SmokeAPI.config.json" ]; then
        echo "Existing SmokeAPI.config.json found, skipping copying";
    else
        echo "[3/3] Copying SmokeAPI.config.json"
        cp "$scriptDir/assets/SmokeAPI/SmokeAPI.config.json" "$installDir/SmokeAPI.config.json"
    fi

    echo "SmokeAPI Hook Mode x$bitness installation complete. Proton users please refer to github for Steam Launch arguments."

    echo ""
    echo -n "Press Enter to return to menu"
    read response

    return 1
}

windowsP() {
    setupBitMenu
    menuInit
    menuLoop
    setupMenu
    menuInit

    echo "SmokeAPI Proxy Mode Installer"
    echo ""
    echo "Installing SmokeAPI Proxy Mode ($bitness-Bit)"
    if [ $bitness = "unknown" ]; then
        exit
    fi

    bitnessStr=$bitness
    if [ $bitness = "32" ]; then
        bitnessStr=""
    fi

    echo "[1/3] Renaming original steam_api$bitness.dll"
    echo "Checking for existing install"
    if [ -f "$installDir/steam_api""$bitnessStr""_o.dll" ]; then
        userCont=" "
        echo "SmokeAPI proxy mode has been installed before. Only reinstall if SmokeAPI has been replaced (steam integrity check). "
        read -p "Do you wish to install it again? (y/N) " userCont
        if [ $userCont = "y" ] || [ $userCont = "Y" ]; then
            echo "Overriding steam_api""$bitnessStr""_o.dll."
        else
            echo "Cancelling installation."
            exit
        fi
    fi
    cp "$installDir/steam_api$bitnessStr.dll" "$installDir/steam_api""$bitnessStr""_o.dll"

    echo "[2/3] Copying SmokeAPI.dll"
    cp "$scriptDir/assets/SmokeAPI/steam_api$bitness.dll" "$installDir/steam_api$bitness.dll"

    echo "[3/3] Checking for SmokeAPI.config.json"
    if [ -f "$installDir/SmokeAPI.config.json" ]; then
        echo "Existing SmokeAPI.config.json found, skipping copying";
    else
        echo "[3/3] Copying SmokeAPI.config.json"
        cp "$scriptDir/assets/SmokeAPI/SmokeAPI.config.json" "$installDir/SmokeAPI.config.json"
    fi

    echo "SmokeAPI Proxy Mode x$bitness installation complete."

    echo ""
    echo -n "Press Enter to return to menu"
    read response

    return 1
}

linuxO() {
    echo "CreamLinux Installer (x32/x64)"
    echo ""

    echo "[1/4] Copying lib32Creamlinux.so"
    cp "$scriptDir/assets/CreamLinux/lib32Creamlinux.so" "$installDir/lib32Creamlinux.so"

    echo "[2/4] Copying lib64Creamlinux.so"
    cp "$scriptDir/assets/CreamLinux/lib64Creamlinux.so" "$installDir/lib64Creamlinux.so"

    echo "[3/4] Copying cream.sh"
    cp "$scriptDir/assets/CreamLinux/cream.sh" "$installDir/cream.sh"

    echo "[4/4] Checking for cream_api.ini"
    if [ -f "$installDir/cream_api.ini" ]; then
        echo "Existing cream_api.ini found, skipping copying";
    else
        echo "[4/4] Copying cream_api.ini"
        cp "$scriptDir/assets/CreamLinux/cream_api.ini" "$installDir/cream_api.ini"
    fi

    echo "CreamLinux installation complete."

    echo ""
    echo "Please add the following to your steam launch arguments: sh ./cream.sh %command%"

    echo ""
    echo -n "Press Enter to return to menu"
    read response

    return 1
}

bit32() {
    bitness="32"
    return 0
}

bit64() {
    bitness="64"
    return 0
}

bitHelp() {
    echo "Bitness Help"
    echo "This is a free open source steam DLC unlocking script available from https://github.com/lily-software/DLCUnlockerScript"
    echo ""
    echo "64-Bit is the usual standard, if you are unsure just select 64-Bit. Otherwise, you can determine it by whether the game directory uses 'steam_api.dll' (32-bit) or 'steam_api64.dll' (64-bit). If for whatever reason the game has both, try using the 64-bit version first, and then also the 32-bit version if that doesn't work."

    echo ""
    echo -n "Press Enter to return to menu"
    read response

    return 1
}

helpM() {
    echo "DLC Unlocker Help"
    echo "This is a free open source steam DLC unlocking script available from https://github.com/lily-software/DLCUnlockerScript"
    echo ""
    echo "Hook Mode vs Proxy Mode"
    echo "- In Hook Mode, no files are replaced, instead SmokeAPI will 'hook' into the Steam API file each launch. This is the recommended installation method, however will require additional Steam launch arguments for users using Proton. This can be found in the github readme."
    echo "- In Proxy Mode, the original Steam API is renamed and SmokeAPI takes its place. This will break should you decide to validate the game files with Steam and you will have to reinstall the proxy. This is the recommended installation method for Linux users on Proton."
    echo ""
    echo "Linux DLC Unlocking"
    echo "This script was originally created to help with installing SmokeAPI/CreamLinux on Linux. If you are using Linux with Proton and wish to use SmokeAPI's hook mode, please read the wiki provided on github as there are a lot of small things that can go wrong.It is recommended that if possible you do not use Proton and instead opt for the native CreamAPI hook. Unfortunately, you will still have to specify each unlocked DLC manually."

    echo ""
    echo -n "Press Enter to return to menu"
    read response

    return 1
}

installerInfo() {
    echo "[v0.1.0] [MIT License] DLC Unlocker Script"
    echo "This is a free open source steam DLC unlocking script available from https://github.com/lily-software/DLCUnlockerScript"
    echo ""

    echo "Projects Utilised + Licensing"
    echo "[20180720] [MIT License] Bash Menu from      bash-menu https://github.com/barbw1re/bash-menu"
    echo "[ v2.0.3 ] [MIT License] CreamLinux from creamlinux https://github.com/anticitizn/creamlinux"
    echo "[ v2.0.5 ] [ Unlicense ] SmokeAPI from       SmokeAPI https://github.com/acidicoala/SmokeAPI"
    echo "[ v3.0.2 ] [ Unlicense ] Version API from  Koaloader https://github.com/acidicoala/Koaloader"

    echo ""
    echo -n "Press Enter to return to menu"
    read response

    return 1
}

exitM() {
    exit
}

setupBitMenu() {
    ## Menu Item Text
    ## NOTE: If these are not all the same width
    ##       the menu highlight will look wonky
    menuItems=(
        "1. 64-Bit"
        "2. 32-Bit"
        "3. Help  "
        "4. Exit  "
    )

    ## Menu Item Actions
    menuActions=(
        bit64
        bit32
        bitHelp
        exitM
    )

    ## Override Defaults
    menuTitle=" Select Game Bitness"
    menuFooter=" "
    menuWidth=40
    menuLeft=25
    menuHighlight=$DRAW_COL_YELLOW
}

setupMenu() {
    ## Menu Item Text
    ## NOTE: If these are not all the same width
    ##       the menu highlight will look wonky
    menuItems=(
        "1. Windows/Proton       (Hook)"
        "2. Windows/Proton      (Proxy)"
        "3. Linux Native     (Override)"
        "4. Unsure/Help                "
        "5. Installer Info             "
        "6. Exit                       "
    )

    ## Menu Item Actions
    menuActions=(
        windowsH
        windowsP
        linuxO
        helpM
        installerInfo
        exitM
    )

    ## Override Defaults
    menuTitle=" Select Unlocking Method"
    menuFooter=" Enter=Select, Navigate via Up/Down/Number"
    menuWidth=60
    menuLeft=25
    menuHighlight=$DRAW_COL_BLUE
}


################################
## Run Menu
################################
setupMenu
menuInit
menuLoop

exit 0
