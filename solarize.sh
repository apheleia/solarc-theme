#!/bin/bash

# Directory that the pre-downloaded arc theme source can be located in
ARC_DIRECTORY=
# Whether or not to download arc
ARC_NEED_DOWNLOAD=true
# If downloading arc, which version to download (this should be the most recently validated version)
if [ -z $ARC_VERSION ]; then
    ARC_VERSION="20210412"
fi
# Defaults to number of CPUs for multithreading the find/exec commands
JOBS=`nproc`

usage()
{
    echo "Calling this script with no arguments will download the most recently validated version \n"
    echo " of Arc theme and then process it. You can use --arc-version (or -v) to download a specific \n"
    echo " version of Arc theme, or use --arc-directory (or -d) to process a pre-downloaded Arc theme \n"
    echo " You may also use --jobs (or -j) to specify how many threads should be used during the build\n\n"
    echo "You may also see this message if you used invalid arguments. "
}

while [ "$1" != "" ]; do
    case $1 in
        -d | --arc-directory )  shift
                                ARC_DIRECTORY="$1"
                                ARC_NEED_DOWNLOAD=false
                                ;;
        -v | --arc-version )    shift
                                ARC_VERSION="$1"
                                ;;
        -j | --jobs )           shift
                                JOBS="$1"
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

# Arc colors
## SCSS
A_BASE="404552"
A_TEXT="d3dae3"
A_BG="383c4a"
A_FG="$A_TEXT"
A_SELECTED_FG="ffffff"
A_SELECTED_BG="5294e2"
A_WARNING="f27835"
A_ERROR="fc4138"
A_SUCCESS="73d216"
A_DESTRUCTIVE="f04a50"
A_SUGGESTED="4dadd4"
A_DROP_TARGET="f08437"
A_WM_BUTTON_CLOSE_BG="cc575d"
A_WM_BUTTON_CLOSE_HOVER_BG="d7787d"
A_WM_BUTTON_CLOSE_ACTIVE_BG="be3841"
A_WM_ICON_CLOSE_BG="2f343f"
A_WM_BUTTON_HOVER_BG="454c5c"
A_WM_BUTTON_ACTIVE_BG="$A_SELECTED_BG"
A_WM_BUTTON_HOVER_BORDER="262932"
A_WM_ICON_BG="90939b"
A_WM_ICON_UNFOCUSED_BG="666a74"
A_WM_ICON_HOVER_BG="c4c7cc"
A_WM_ICON_ACTIVE_BG="$A_SELECTED_FG"
A_WINDOW_BG="353945"
A_DARK_SIDEBAR_FG="bac3cf"
## SVG
A_BLUE="5294e2" # Duplicate of $A_SELECTED_BG
A_WHITE="f9fafb"
A_LIGHT_MENUBAR="e7e8eb"
A_DARK="383c4a" # Duplicate of $A_BG
A_DARKEST="2f343f" # Duplicate of $A_WM_ICON_CLOSE_BG
A_DARKEST2="2f343d"
A_DARK_BUTTON="353a47"
A_LIGHT_BUTTON="2d323f"
A_OTHER_LIGHT_BUTTON="444a58"
A_MODAL="323644"
A_ASSET_DARK="2e3340"
A_ASSET_DARK2="313541"
A_ASSET_GREY="bebebe"
A_ASSET_BORDER="2c303a"
A_ASSET_LIGHTER_BG="3e4350"
A_ASSET_VARIOUS_DARK1="262934"
A_ASSET_VARIOUS_DARK2="2d303b"
A_ASSET_VARIOUS_DARK3="2d323d"
A_GNOME_PANEL_BG="252a35"
A_GNOME_PANEL_BORDER="0f1116"
A_GTK2_TOOLBAR="70788d"
A_GTK2_TOOLBAR_DARK="afb8c5"
A_CLOSE_BUTTON_GREY="f8f8f9"
A_LIGHT_BG="f5f6f7"
A_SWITCH_OFF_BG="5b627b"
A_LIGHT_FG="3b3e45"
## GTK2
A_GTK2_SENSITIVE_STROKE="2b2e39"
A_GTK2_INSENSITIVE_FG_COLOR="7c818c"
A_GTK2_INSENSITIVE_STROKE="303440"
A_GTK2_BUTTON_HOVER="505666"
A_GTK2_SCROLLBAR_BG="3e434f"
A_GTK2_SCROLLBAR_FG="767b87"
A_GTK2_SCROLLBAR_FG_HOVER="8f939d"
A_GTK2_SLIDER_STROKE="262933"
A_GTK2_LIGHT_SENSITIVE_BG="fcfdfd"
A_GTK2_LIGHT_SENSITIVE_STROKE="cfd6e6"
A_GTK2_LIGHT_INSENSITIVE_BG="fbfcfc"
A_GTK2_LIGHT_INSENSITIVE_FG="a9acb2"
A_GTK2_LIGHT_INSENSITIVE_STROKE="e2e7ef"
A_GTK2_LIGHT_ACTIVE_BG="d3d8e2"
A_GTK2_LIGHT_ACTIVE_STROKE="b7c0d3"
A_GTK2_LIGHT_SCROLLBAR_BG="fcfcfc"
A_GTK2_LIGHT_SCROLLBAR_FG="b8babf"
A_GTK2_LIGHT_SCROLLBAR_FG_HOVER="d3d4d8"
A_GTK2_LIGHT_SCROLLBAR_BORDER="dbdfe3"
A_GTK2_LIGHT_SLIDER_STROKE="cbd2e3"
A_GTK2_LIGHT_TAB_BORDER="dde3e9"
A_GTK2_LIGHT_MENUBAR_STROKE="d7d8dd"
A_GTK2_LIGHT_FRAME_BORDER="dfdfdf"
## Openbox
A_OPENBOX_MENU_ITEM_BG="454a54"
A_OPENBOX_MENU_ITEM_FG="a8adb5"
A_OPENBOX_MENU_TITLE_BG="2d3036"
## Plank
A_PLANK_FILL_START="53;;57;;69;;242"
A_PLANK_FILL_END="53;;57;;69;;242"
A_PLANK_OUTER_STROKE="22;;26;;38;;255"
A_PLANK_INNER_STROKE="53;;57;;69;;0"

# Solarized colors
## Common
S_YELLOW="b58900"
S_ORANGE="cb4b16"
S_RED="dc322f"
S_MAGENTA="d33682"
S_VIOLET="6c71c4"
S_BLUE="268bd2"
S_CYAN="2aa198"
S_GREEN="859900"
## Dark
S_BASE03="002b36"
S_BASE02="073642"
S_BASE01="586e75"
S_BASE00="657b83"
S_BASE0="839496"
S_BASE1="93a1a1"
S_BASE2="eee8d5"
S_BASE3="fdf6e3"

declare -A REPLACE
REPLACE[$A_BASE]=$S_BASE03
REPLACE[$A_TEXT]=$S_BASE0
REPLACE[$A_BG]=$S_BASE02
REPLACE[$A_FG]=$S_BASE0
REPLACE[$A_SELECTED_FG]=$S_BASE3
REPLACE[$A_SELECTED_BG]=$S_BLUE
REPLACE[$A_WARNING]=$S_ORANGE
REPLACE[$A_ERROR]=$S_RED
REPLACE[$A_SUCCESS]=$S_GREEN
REPLACE[$A_DESTRUCTIVE]=$S_RED
REPLACE[$A_SUGGESTED]=$S_CYAN
REPLACE[$A_DROP_TARGET]=$S_YELLOW
REPLACE[$A_WM_BUTTON_CLOSE_BG]=$S_RED
REPLACE[$A_WM_BUTTON_CLOSE_HOVER_BG]=$S_ORANGE
REPLACE[$A_WM_BUTTON_CLOSE_ACTIVE_BG]=$S_RED
REPLACE[$A_WM_ICON_CLOSE_BG]=$S_BASE03
REPLACE[$A_WM_BUTTON_HOVER_BG]=$S_BASE00
REPLACE[$A_WM_BUTTON_ACTIVE_BG]=$S_BLUE
REPLACE[$A_WM_BUTTON_HOVER_BORDER]=$S_BASE03
REPLACE[$A_WM_ICON_BG]=$S_BASE1
REPLACE[$A_WM_ICON_UNFOCUSED_BG]=$S_BASE00
REPLACE[$A_WM_ICON_HOVER_BG]=$S_BASE1
REPLACE[$A_WM_ICON_ACTIVE_BG]=$S_BASE3
REPLACE[$A_WINDOW_BG]=$S_BASE02
REPLACE[$A_DARK_SIDEBAR_FG]=$S_BASE00
REPLACE[$A_WHITE]=$S_BASE3
REPLACE[$A_LIGHT_MENUBAR]=$S_BASE3
REPLACE[$A_DARKEST2]=$S_BASE03
REPLACE[$A_DARK_BUTTON]=$S_BASE03
REPLACE[$A_LIGHT_BUTTON]=$S_BASE02
REPLACE[$A_MODAL]=$S_BASE03
REPLACE[$A_ASSET_DARK]=$S_BASE03
REPLACE[$A_ASSET_DARK2]=$S_BASE02
REPLACE[$A_ASSET_GREY]=$S_BASE00
REPLACE[$A_ASSET_BORDER]=$S_BASE00
REPLACE[$A_ASSET_VARIOUS_DARK1]=$S_BASE00
REPLACE[$A_ASSET_VARIOUS_DARK2]=$S_BASE03
REPLACE[$A_ASSET_VARIOUS_DARK3]=$S_BASE03
REPLACE[$A_GNOME_PANEL_BG]=$S_BASE03
REPLACE[$A_GNOME_PANEL_BORDER]=$S_BASE03
REPLACE[$A_GTK2_TOOLBAR]=$S_BASE0
REPLACE[$A_GTK2_TOOLBAR_DARK]=$S_BASE00
REPLACE[$A_CLOSE_BUTTON_GREY]=$S_BASE02
REPLACE[$A_LIGHT_BG]=$S_BASE2
REPLACE[$A_GTK2_INSENSITIVE_FG_COLOR]=$S_BASE01
REPLACE[$A_SWITCH_OFF_BG]=$S_BASE01
REPLACE[$A_LIGHT_FG]=$S_BASE00
# Openbox
REPLACE[$A_OPENBOX_MENU_ITEM_BG]=$S_BASE03
REPLACE[$A_OPENBOX_MENU_ITEM_FG]=$S_BASE0
REPLACE[$A_OPENBOX_MENU_TITLE_BG]=$S_BASE02
# GTK2 tweaks
REPLACE[$A_ASSET_LIGHTER_BG]="033441"
REPLACE[$A_OTHER_LIGHT_BUTTON]="003340"
REPLACE[$A_GTK2_SENSITIVE_STROKE]="041f26"
REPLACE[$A_GTK2_INSENSITIVE_STROKE]="052932"
REPLACE[$A_GTK2_BUTTON_HOVER]="00475a"
REPLACE[$A_GTK2_SCROLLBAR_BG]="002731"
REPLACE[$A_GTK2_SCROLLBAR_FG]="395c64"
REPLACE[$A_GTK2_SCROLLBAR_FG_HOVER]="2c525b"
REPLACE[$A_GTK2_SLIDER_STROKE]="041f26"
REPLACE[$A_GTK2_LIGHT_SENSITIVE_BG]="f1ecdc"
REPLACE[$A_GTK2_LIGHT_SENSITIVE_STROKE]="a6a49b"
REPLACE[$A_GTK2_LIGHT_INSENSITIVE_BG]="f0ebd9"
REPLACE[$A_GTK2_LIGHT_INSENSITIVE_FG]="8c8c88"
REPLACE[$A_GTK2_LIGHT_INSENSITIVE_STROKE]="a2aca8"
REPLACE[$A_GTK2_LIGHT_ACTIVE_BG]="e1d6b4"
REPLACE[$A_GTK2_LIGHT_ACTIVE_STROKE]=$S_BLUE
REPLACE[$A_GTK2_LIGHT_SCROLLBAR_BG]="fdf4de"
REPLACE[$A_GTK2_LIGHT_SCROLLBAR_FG]="a6a49b"
REPLACE[$A_GTK2_LIGHT_SCROLLBAR_FG_HOVER]="b8b5aa"
REPLACE[$A_GTK2_LIGHT_SCROLLBAR_BORDER]="e1d6b4"
REPLACE[$A_GTK2_LIGHT_SLIDER_STROKE]="908f89"
REPLACE[$A_GTK2_LIGHT_TAB_BORDER]="e1d6b4"
REPLACE[$A_GTK2_LIGHT_MENUBAR_STROKE]="e1d6b4"
REPLACE[$A_GTK2_LIGHT_FRAME_BORDER]="e1d6b4"
# Plank tweaks
REPLACE[$A_PLANK_FILL_START]="7;;54;;66;;255"
REPLACE[$A_PLANK_FILL_END]="7;;54;;66;;255"
REPLACE[$A_PLANK_OUTER_STROKE]="5;;18;;29;;255"
REPLACE[$A_PLANK_INNER_STROKE]="0;;43;;54;;0"

CWD="`pwd`/arc-theme"
# Remove the arc-theme folder from a previous invocation of this script.
rm -rf "${CWD}"

if [ "$ARC_NEED_DOWNLOAD" = true ] ; then
    # Delete the Arc source from previous script invocations
    rm -rf "`pwd`/arc-theme-${ARC_VERSION}"

    # Pull the Arc source
    echo "### Downloading Arc source"
    wget --quiet "https://github.com/jnsh/arc-theme/releases/download/${ARC_VERSION}/arc-theme-${ARC_VERSION}.tar.xz"
    tar -xJf "arc-theme-${ARC_VERSION}.tar.xz"
    rm "arc-theme-${ARC_VERSION}.tar.xz"
    cp --recursive "`pwd`/arc-theme-${ARC_VERSION}" "${CWD}"
else
    # Copy the arc source to the arc-theme folder so that the source can be reused if necessary
    echo "### Copying pre-downloaded Arc source"
    cp --recursive "${ARC_DIRECTORY}" "${CWD}"
fi
cd "${CWD}"

echo "### Applying patch(es)"

echo "### Optimising SVGs"
find . -name "*.svg" -print0 | xargs --null -P $JOBS -I % inkscape --actions="export-plain-svg;vacuum-defs" % ;
FILETYPES=('.scss' '.svg' '.xpm' '.xml' 'rc' '.theme')

echo "### Replacing arc colors with solarized colors"
for filetype in "${FILETYPES[@]}"
do
    echo "## Replacing in ${filetype}"
    for K in ${!REPLACE[@]}
    do
        find . -type f -name "*${filetype}" -print0 | xargs --null -P $JOBS -I % sed -i "s/${K}/${REPLACE[$K]}/Ig" % ;
    done
done

# Correct index.theme metadata & output directories
for PATTERN in "index.theme*" "metacity-theme-*.xml"; do
    find "${CWD}/common" -name "${PATTERN}" -print0 | xargs --null -P $JOBS -I % sed -i "s/Arc/SolArc/g" % ;
done

# Arc theme has fully switched to meson building as of version 20210412
if [ -f "meson.build" ]; then
    sed -i "s/Arc/SolArc/g" meson.build;
    echo "### Patching complete! You may now run meson configure & meson install in arc-theme as you wish"
else
    sed -i "s/Arc/SolArc/g" configure.ac;
    echo "### Patching complete! You may now run autogen.sh & make in arc-theme as you wish"
fi
