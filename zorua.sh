#!/bin/bash

CONFIG_FILE="configs/config.ini"

WEBVIEW_DOWNLOAD_LINK=$(grep -A 10 "\[system\]" "$CONFIG_FILE" | grep -m 1 "^webview_download_link" | cut -d'=' -f2 | tr -d '[:space:]')
WEBVIEW_DOWNLOAD_LINK_130=$(grep -A 10 "\[system\]" "$CONFIG_FILE" | grep -m 1 "^webview_download_link_130" | cut -d'=' -f2 | tr -d '[:space:]')

LOG_INFO_COLOR=$(grep -A 10 "\[logging\]" "$CONFIG_FILE" | grep -m 1 "^logging_info_color" | cut -d'=' -f2 | tr -d "[:space:]'" )
LOG_WARNING_COLOR=$(grep -A 10 "\[logging\]" "$CONFIG_FILE" | grep -m 1 "^logging_warning_color" | cut -d'=' -f2 | tr -d "[:space:]'" )
LOG_ERROR_COLOR=$(grep -A 10 "\[logging\]" "$CONFIG_FILE" | grep -m 1 "^logging_error_color" | cut -d'=' -f2 | tr -d "[:space:]'" )
LOG_SUCCES_COLOR=$(grep -A 10 "\[logging\]" "$CONFIG_FILE" | grep -m 1 "^logging_succes_color" | cut -d'=' -f2 | tr -d "[:space:]'" )
LOG_NC_COLOR=$(grep -A 10 "\[logging\]" "$CONFIG_FILE" | grep -m 1 "^logging_nc_color" | cut -d'=' -f2 | tr -d "[:space:]'" )

POGO_VERSION=$(grep -A 10 "\[pogo\]" "$CONFIG_FILE" | grep -m 1 "^version" | cut -d'=' -f2 | tr -d '[:space:]')
POGO_MIRROR_URL=$(grep -A 10 "\[pogo\]" "$CONFIG_FILE" | grep -m 1 "^mirror_url" | cut -d'=' -f2 | tr -d '[:space:]')
POGO_ARCH=$(grep -A 10 "\[pogo\]" "$CONFIG_FILE" | grep -m 1 "^arch" | cut -d'=' -f2 | tr -d '[:space:]')
POGO_APK_ARCH=$(grep -A 10 "\[pogo\]" "$CONFIG_FILE" | grep -m 1 "^apk_arch" | cut -d'=' -f2 | tr -d '[:space:]')

COSMOG_DOWNLOAD_LINK=$(grep -A 10 "\[cosmog\]" "$CONFIG_FILE" | grep -m 1 "^download_link" | cut -d'=' -f2 | tr -d '[:space:]')
COSMOG_PACKAGE_NAME=$(grep -A 10 "\[cosmog\]" "$CONFIG_FILE" | grep -m 1 "^package_name" | cut -d'=' -f2 | tr -d '[:space:]')

POGOLIB_MIRROR_URL=$(grep -A 10 "\[pogolib\]" "$CONFIG_FILE" | grep -m 1 "^mirror_url" | cut -d'=' -f2 | tr -d '[:space:]')
POGOLIB_ARCH=$(grep -A 10 "\[pogolib\]" "$CONFIG_FILE" | grep -m 1 "^arch" | cut -d'=' -f2 | tr -d '[:space:]')
POGOLIB_VERSION=$(grep -A 10 "\[pogolib\]" "$CONFIG_FILE" | grep -m 1 "^version" | cut -d'=' -f2 | tr -d '[:space:]')


MAPWORLD_DOWNLOAD_LINK=$(grep -A 10 "\[furtif_tools\]" "$CONFIG_FILE" | grep -m 1 "^mapworld_download_link" | cut -d'=' -f2 | tr -d '[:space:]')


ADB_DEVICE_FILE=$(grep -A 10 "\[adb\]" "$CONFIG_FILE" | grep -m 1 "^device_file" | cut -d'=' -f2 | tr -d '[:space:]')

current_time() {
  echo "$(date '+%Y-%m-%d %H:%M:%S')"
}

log_info() {
  echo -e "${LOG_INFO_COLOR}[ZORUA][$(current_time)][INFO] $1${LOG_NC_COLOR}"
}

log_warning() {
  echo -e "${LOG_WARNING_COLOR}[ZORUA][$(current_time)][WARNING] $1${LOG_NC_COLOR}"
}

log_error() {
  echo -e "${LOG_ERROR_COLOR}[ZORUA][$(current_time)][ERROR] $1${LOG_NC_COLOR}"
}

log_succes() {
  echo -e "${LOG_SUCCES_COLOR}[ZORUA][$(current_time)][SUCCESS] $1${LOG_NC_COLOR}"
}

clear_space () {
    log_info "Starting the clear space Zorua funcion..."

        devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"

    for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"
        
        log_info "Clearin cache"
        adb -s "$device_ip" shell "su -c 'rm -rf /data/data/*/cache'"

        log_info "Clearing logs..."
        adb -s "$device_ip" shell "su -c 'rm -rf /data/log/*'"

        log_info "Clearing logcat..."
        adb -s "$device_ip" shell "su -c 'logcat -c'"

        log_info "Trimming cache down..."
        adb -s "$device_ip" "su -c pm trim-caches 512G"

        log_info "Clearing temp..."
        adb -s "$device_ip" "su -c rm -rf /data/app/vmdl*.tmp"

        log_info "Stopping Pogo..."
        adb -s "$device_ip" shell "su -c 'am force-stop com.nianticlabs.pokemongo'"

        log_info "Clearing Pogo cache..."
        adb -s "$device_ip" shell "su -c 'rm -rf /data/data/com.nianticlabs.pokemongo/cache/*'"

        log_info "Clearing Playstore cache..."
        adb -s $i shell "su -c 'pm clear com.google.android.gms'"

        log_info "Cleaing Chrome cache..."
        adb -s $i shell "su -c 'pm clear com.android.chrome'"

        log_info "Clearing android cache..."
        adb -s $i shell "su -c 'pm clear com.android.vending'"

        log_info "Clearing google cache..."
        adb -s $i shell "su -c 'pm clear com.google.android.inputmethod.latin'"

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done
}





update_pogo_lib() {
    log_info "Updating lib..."
    VERSIONS=$(curl -s "${POGOLIB_MIRROR_URL}/index.json")

    VERSIONS=$(echo "$VERSIONS" | jq 'map(.version |= sub(".apkm"; ""))')

    VERSIONS=$(echo "$VERSIONS" | jq 'sort_by(.version | split(".")[1] | tonumber) | reverse')

    if [[ "$POGOLIB_VERSION" == "latest" ]]; then
        POGOLIB_VERSION=$(echo "$VERSIONS" | jq -r ".[] | select(.arch == \"$POGOLIB_ARCH\") | .version" | head -n 1)
        if [[ -z "$POGOLIB_VERSION" ]]; then
            log_error "Unable to find a version on the mirror for arch $POGOLIB_ARCH"
            exit 1
        fi
        log_info "Requested latest version for $POGOLIB_ARCH is $POGOLIB_VERSION."
    else
        POGOLIB_VERSION=$(echo "$VERSIONS" | jq -r ".[] | select(.version == \"$POGOLIB_VERSION\" and .arch == \"$POGOLIB_ARCH\") | .version")
        if [[ -z "$POGOLIB_VERSION" ]]; then
            log_error "Version $POGOLIB_VERSION with arch $POGOLIB_ARCH does not exist on the mirror."
            exit 1
        fi
    fi


    IS_APKM=$(echo "$POGOLIB_VERSION" | grep -E "\.apkm$" > /dev/null && echo "true" || echo "false")

    log_info "Creating TMP Directory..."
    TMP_DIR=$(mktemp -d)

    log_info "Downloading the PoGo APKM from the Mirror..."
    DOWNLOAD_URL="${POGOLIB_MIRROR_URL}/apks/com.nianticlabs.pokemongo_${POGOLIB_ARCH}_${POGOLIB_VERSION}.apkm"
    wget -P "$TMP_DIR" "$DOWNLOAD_URL"

    log_info "Unzipping PoGo APKM"
    unzip "$TMP_DIR/com.nianticlabs.pokemongo_*.apkm" -d "$TMP_DIR"

    log_info "Creating directory for the split APK..."
    mkdir "$TMP_DIR/split"

    log_info "Unzipping the Split APK..."
    unzip "$TMP_DIR/split_config.*.apk" -d "$TMP_DIR/split"

    log_info "CP'ing the PoGoLib to root TMP directory..."
    cp "$TMP_DIR/split/lib/${POGOLIB_ARCH}/libNianticLabsPlugin.so" "$TMP_DIR/libNianticLabsPlugin.so"

    log_info "Creating directory for the PoGoLib in this directory..."
    mkdir "$POGOLIB_ARCH"

    log_info "CP'ing the PoGoLib from the TMP directory to the arch folder in this directory..."
    cp "$TMP_DIR/libNianticLabsPlugin.so" "./$POGOLIB_ARCH/libNianticLabsPlugin.so"

    log_info "Deleting TMP directory..."
    rm -rf "$TMP_DIR"

    log_succes "Successfully downloaded version $POGOLIB_VERSION for arch $POGOLIB_ARCH."

        devices=()
        while IFS= read -r device_ip; do
            if [ -n "$device_ip" ]; then
                devices+=("$device_ip")
            fi
        done < "$ADB_DEVICE_FILE"

        for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"
        
        log_info "Pushing the PoGoLib to $device_ip /data/local/tmp..."
        adb -s "$device_ip" push "$POGOLIB_ARCH/libNianticLabsPlugin.so" "/data/local/tmp"

        log_info "CP'ing PoGoLib to $COSMOG_PACKAGE_NAME/files/libNianticLabsPlugin.so..."
        adb -s "$device_ip" shell "su -c 'cp /data/local/tmp/libNianticLabsPlugin.so /data/data/$COSMOG_PACKAGE_NAME/files/libNianticLabsPlugin.so'"
        
        log_info "Chmodding PoGoLib with 777..."
        adb -s "$device_ip" shell "su -c 'chmod 777 /data/data/$COSMOG_PACKAGE_NAME/files/libNianticLabsPlugin.so'"
        
        log_info "Removing PoGoLib from /data/local/tmp..."
        adb -s "$device_ip" shell "su -c 'rm /data/local/tmp/libNianticLabsPlugin.so'"
        
        log_info "Force restarting Cosmog..."
        adb -s "$device_ip" shell am force-stop $COSMOG_PACKAGE_NAME
        adb -s "$device_ip" shell monkey -p $COSMOG_PACKAGE_NAME -c android.intent.category.LAUNCHER 1

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done
}


update_cosmog() {
    log_info "Updating Cosmog..."

    log_info "Creating data directory..."
    mkdir data
    log_info "Creating data/apks directory..."
    mkdir data/apks    

    wget -O data/apks/cosmog.apk $COSMOG_DOWNLOAD_LINK

    devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"
    for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"

        log_info "Installing/Updating Cosmog on $device_ip..."
        adb -s "$device_ip" install data/apks/cosmog.apk

        log_info "Force restarting Cosmog on $device_ip..."
        adb -s "$device_ip" shell am force-stop $COSMOG_PACKAGE_NAME
        adb -s "$device_ip" shell monkey -p $COSMOG_PACKAGE_NAME -c android.intent.category.LAUNCHER 1

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done
}

update_webview() {

    log_info "Updating WebView..."
    log_info "Creating data directory..."
    mkdir data

    log_info "Creating APK directory..."
    mkdir data/apks

    log_info "Wgetting WebView APK..."
    wget -O data/apks/webview.apk $WEBVIEW_DOWNLOAD_LINK

    log_info "Wgetting newer WebView APK..."
    wget -O data/apks/webview130.apk $WEBVIEW_DOWNLOAD_LINK_130 

    devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"
        for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"
        
        log_info "Pushing the WebView APK to $device_ip /data/local/tmp/webview.apk..."
        adb -s "$device_ip" push "data/apks/webview.apk" "/data/local/tmp/webview.apk"
        log_info "Setting DEV settings to 1..."
        adb -s "$device_ip" shell "su -c 'settings put global development_settings_enabled 1'"
        log_info "Remounting system..."
        adb -s "$device_ip" shell "su -c 'mount -o rw,remount /'"
        log_info "Making WebView directory..."
        adb -s "$device_ip" shell "su -c 'mkdir /system/app/GoogleWebView'"
        log_info "MV'ing the WebView APK from /data/local/tmp to /system/app/GoogleWebView"
        adb -s "$device_ip" shell "su -c 'mv /data/local/tmp/webview.apk /system/app/GoogleWebView/webview.apk'"
        log_info "Chmodding the webview apk..."
        adb -s "$device_ip" shell "su -c 'chmod 644 /system/app/GoogleWebView/webview.apk'"
        log_info "Mounting system..."
        adb -s "$device_ip" shell "su -c 'mount -o ro,remount /'"
        log_info "Rebooting..."
        adb -s "$device_ip" shell "su -c 'reboot'"
        log_info "Zorua takes a nap for 120 seconds and will see you again when the device came back..."
        sleep 120
        adb connect "$device_ip"
        log_info "Setting new WebView APK as standard..."
        adb -s "$device_ip" shell "su -c 'cmd webviewupdate set-webview-implementation com.google.android.webview'"
        log_info "Installing newer WebView APK..."
        adb -s $device_ip install data/apks/webview130.apk
        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done
}

update_pogo () {
    log_info "Updating PoGo..."
    log_info "Creating data direcotory..."
    mkdir data

    log_info "Creating apks directory..."
    mkdir data/apks

    log_info "Creating pogo directory..."
    mkdir data/apks/pogo

    log_info "Finding latest version on $POGO_MIRROR_URL..."

    POGO_VERSIONS=$(curl -s "${POGOLIB_MIRROR_URL}/index.json")
    POGO_VERSIONS=$(echo "$POGO_VERSIONS" | jq 'map(.version |= sub(".apkm"; ""))')
    POGO_VERSIONS=$(echo "$POGO_VERSIONS" | jq 'sort_by(.version | split(".")[1] | tonumber) | reverse')

    POGO_VERSION=$(echo "$POGO_VERSIONS" | jq -r ".[] | select(.arch == \"$POGO_ARCH\") | .version" | head -n 1)

    if [[ -z "$POGO_VERSION" ]]; then
        log_error "Unable to find a version on the mirror for arch $POGO_ARCH"
        exit 1
    else
        log_info "Requested latest version for $POGO_ARCH is $POGO_VERSION."
        POGO_VERSION=$(echo "$POGO_VERSIONS" | jq -r ".[] | select(.version == \"$POGO_VERSION\" and .arch == \"$POGO_ARCH\") | .version")
        if [[ -z "$POGO_VERSION" ]]; then
            log_error "Version $POGO_VERSION with arch $POGO_ARCH does not exist on the mirror."
            exit 1
        fi
    fi

    IS_APKM=$(echo "$POGO_VERSION" | grep -E "\.apkm$" > /dev/null && echo "true" || echo "false")

    log_info "Downloading the PoGo APKM from the $POGO_MIRROR_URL..."
    DOWNLOAD_URL="${POGO_MIRROR_URL}/apks/com.nianticlabs.pokemongo_${POGO_ARCH}_${POGO_VERSION}.apkm"
    wget -O "data/apks/pogo/pogo.apkm" "$DOWNLOAD_URL"

    log_info "Unzipping PoGo.apkm..."
    unzip data/apks/pogo/pogo.apkm
    
    devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"

    for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"

        log_info "Installing new PoGo APK on $device_ip..."
        adb -s "$device_ip" install-multiple -r data/apks/pogo/base.apk data/apks/pogo/split_config.$POGO_APK_ARCH.apk

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done
}


clear_atv_cache () {
    log_info "Clearing ATV Cache..."
        devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"
        for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"

        log_info "Clearing ATV Cache on $device_ip..."
        adb -s "$device_ip" shell "su -c 'cmd package list packages|cut -d":" -f2|while read package ;do pm clear --cache-only $package;done'"

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done
}

restart_cosmog() {
    log_info "Restarting Cosmog..."
        devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"
        for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"

        log_info "Force closing Cosmog on $device_ip..."
        adb -s "$device_ip" shell "am force-stop $COSMOG_PACKAGE_NAME"

        log_info "Starting Cosmog again on $device_ip..."
        adb -s "$device_ip" shell "monkey -p $COSMOG_PACKAGE_NAME -c android.intent.category.LAUNCHER 1"

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done    
}


print_config() {
    log_info "LOG_INFO_COLOR = $LOG_INFO_COLOR"
    log_info "LOG_WARNING_COLOR = $LOG_WARNING_COLOR"
    log_info "LOG_ERROR_COLOR = $LOG_ERROR_COLOR"
    log_info "LOG_SUCCES_COLOR = $LOG_SUCCES_COLOR"
    log_info "LOG_NC_COLOR = $LOG_NC_COLOR"

    log_info "WEBVIEW_DOWNLOAD_LINK - $WEBVIEW_DOWNLOAD_LINK"
    log_info "WEBVIEW_DOWNLOAD_LINK_130 = $WEBVIEW_DOWNLOAD_LINK_130"

    log_info "POGO_VERSION = $POGO_VERSION"
    log_info "POGO_MIRROR_URL = $POGO_MIRROR_URL"
    log_info "POGO_ARCH = $POGO_ARCH"
    log_info "POGO_APK_ARCH = $POGO_APK_ARCH"

    log_info "COSMOG_DOWNLOAD_LINK = $COSMOG_DOWNLOAD_LINK"
    log_info "COSMOG_PACKAGE_NAME = $COSMOG_PACKAGE_NAME"

    log_info "POGOLIB_MIRROR_URL = $POGOLIB_MIRROR_URL"
    log_info "POGOLIB_ARCH = $POGOLIB_ARCH"
    log_info "POGOLIB_VERSION = $POGOLIB_VERSION"

    log_info "MAPWORLD_DOWNLOAD_LINK = $MAPWORLD_DOWNLOAD_LINK"

    log_info "ADB_DEVICE_FILE = $ADB_DEVICE_FILE"

    log_info "test"
    log_warning "test"
    log_error "test"
    log_succes "test"
}

print_version() {
    log_info "⠁⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠈⠛⣷⣶⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠨⢻⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠴⠦⠴
    ⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣽⡆⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠈⢳⣦⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⢀⣿⣿⣷⡀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⣶⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣷⣄⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⣀⣤⣶⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⣻⣿⣿⣿⣿⣿⣿⣷⡄⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀   ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣿⣿⣿⣿⣿⠟⠉⠛⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⡿⠏⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⣤⣤⣤⣤⡄⣤⣤⣤⣤⣤⣤⣔⣯⣄⣀⡀⠀⠀⠀⠀⠀⠀⠸⣿⣿⣿⣿⠇⠘⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠘⠛⠛⠻⠛⡛⢛⠓⠛⠟⠛⠛⠺⠛⠛⠛⠛⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⠀⠀⠀⠉⠋⠁⠉⠉⠉⠋⠉⠙⠉⠩⠻⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
        ⠀⠀⠀⠀⠀⠈⠃⢀⠃⠀⠀⠐⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⣈⣻⣡⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡙⠻⢿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"    
    log_info "Zorua Version 1.0.0"

}

setup_furtif_tools() {
    log_info "Setting up device for Furtif tools..."
    log_info "Installing furtif tools..."
    log_info "Creating data directory..."
    mkdir data

    log_info "Creating APKs directory..."
    mkdir data/apks

    log_info "Wgetting Furtif Tools APK..."
    wget -O data/apks/mapworld.apk $MAPWORLD_DOWNLOAD_URL

    log_info "Wgetting WebView APK..."
    wget -O data/apks/webview.apk $WEBVIEW_DOWNLOAD_LINK

    log_info "Wgetting newer WebView APK..."
    wget -O data/apks/webview130.apk $WEBVIEW_DOWNLOAD_LINK_130

    log_info "Creating latest PIF module..."
    log_info "Creating data directory..."
    mkdir data

    log_info "Creating modules directory..."
    mkdir data/modules

    log_info "Creating PIF directory..."
    mkdir data/modules/playintegrityfix

    log_info "Creating final direcotry..."
    mkdir data/modules/playintegrityfix/final

    PIF_LATEST_RELEASE=$(curl -s "https://api.github.com/repos/chiteroman/PlayIntegrityFix/releases/latest")

    PIF_DOWNLOAD_URL=$(echo $PIF_LATEST_RELEASE | grep -oP '"browser_download_url": "\K(.*?)(?=")' | grep .zip)

    if [ -n "$PIF_DOWNLOAD_URL" ]; then
        log_info "Getting latest release from:" "$PIF_DOWNLOAD_URL"
        wget -O data/modules/playintegrityfix/playintegrityfix.zip "$PIF_DOWNLOAD_URL"
        log_succes "Downloaded latest PIF"
    else
        log_error "Couldn't find a download link for the latest release."
    fi
    log_info "Unzipping latest PIF..."
    unzip -d data/modules/playintegrityfix/final data/modules/playintegrityfix/playintegrityfix.zip

    log_info "Setting ro.adb.secure to 0..."
    sed -i 's/^resetprop_if_diff ro.adb.secure 1$/resetprop_if_diff ro.adb.secure 0/' data/modules/playintegrityfix/final/post-fs-data.sh

    log_info "Zipping PIF to make a Magisk Module..."
    cd data/modules/playintegrityfix/final || exit 1
    zip -r ../pif.zip ./*
    cd - || exit 1
    log_succes "Magisk module created succesfully..."    

    devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"
        for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"
        
        log_info "Removing current PIF on $device_ip..."
        adb -s "$device_ip" shell "su -c 'cd data/adb/modules && rm -rf playintegrityfix'"

        log_info "Rebooting $device_ip..."
        adb -s "$device_ip" shell "reboot"

        log_info "Zorua takes a 2 minute nap waiting for the device to come back..."
        sleep 120

        log_info "Pushing latest PIF to $device_ip"
        adb -s "$device_ip" push data/modules/playintegrityfix/pif.zip /data/local/tmp

        log_info "Installing latest PIF to $device_ip..."
        adb -s "$device_ip" shell "su -c 'magisk --install-module /data/local/tmp/pif.zip'"

        log_info "Removing downloaded PIF module from /data/local/tmp on $device_ip..."
        adb -s $device_ip shell "rm -rf /data/local/tmp/pif.zip"

        log_info "Rebooting $device_ip..." 
        adb -s "$device_ip" shell "reboot"

        log_info "Zorua takes a 120 second nap to wait for the device to come back..."
        sleep 120

        log_info "Pushing the WebView APK to $device_ip /data/local/tmp/webview.apk..."
        adb -s "$device_ip" push "data/apks/webview.apk" "/data/local/tmp/webview.apk"

        log_info "Setting DEV settings to 1..."
        adb -s "$device_ip" shell "su -c 'settings put global development_settings_enabled 1'"

        log_info "Remounting system..."
        adb -s "$device_ip" shell "su -c 'mount -o rw,remount /'"

        log_info "Making WebView directory..."
        adb -s "$device_ip" shell "su -c 'mkdir /system/app/GoogleWebView'"

        log_info "MV'ing the WebView APK from /data/local/tmp to /system/app/GoogleWebView"
        adb -s "$device_ip" shell "su -c 'mv /data/local/tmp/webview.apk /system/app/GoogleWebView/webview.apk'"

        log_info "Chmodding the webview apk..."
        adb -s "$device_ip" shell "su -c 'chmod 644 /system/app/GoogleWebView/webview.apk'"

        log_info "Mounting system..."
        adb -s "$device_ip" shell "su -c 'mount -o ro,remount /'"

        log_info "Rebooting..."
        adb -s "$device_ip" shell "su -c 'reboot'"

        log_info "Zorua takes a nap for 120 seconds and will see you again when the device came back..."
        sleep 120

        log_info "Connecting again to $device_ip"
        adb connect "$device_ip"

        log_info "Setting new WebView APK as standard..."
        adb -s "$device_ip" shell "su -c 'cmd webviewupdate set-webview-implementation com.google.android.webview'"

        log_info "Installing newer WebView APK..."
        adb -s $device_ip install data/apks/webview130.apk

        log_info "Installing Furtif Tools..."
        adb -s $device_ip install data/apks/mapworld.apk

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done   
}   

update_furtif_tools () {

    log_info "Creating data directory..."
    mkdir data
    log_info "Creating APKs directory..."
    mkdir data/apks
    log_info "Wgetting mapworld apk..."
    wget -O data/apks/mapworld.apk "$MAPWORLD_DOWNLOAD_LINK"

            devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"
        for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"

        log_info "Installing Mapworld APK on $device_ip..."
        adb -s "$device_ip" install data/apks/mapworld.apk

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done
}

update_pif_module() {
    log_info "Creating latest PIF module..."
    log_info "Creating data directory..."
    mkdir data

    log_info "Creating modules directory..."
    mkdir data/modules

    log_info "Creating PIF directory..."
    mkdir data/modules/playintegrityfix

    log_info "Creating final direcotry..."
    mkdir data/modules/playintegrityfix/final

    PIF_LATEST_RELEASE=$(curl -s "https://api.github.com/repos/chiteroman/PlayIntegrityFix/releases/latest")

    PIF_DOWNLOAD_URL=$(echo $PIF_LATEST_RELEASE | grep -oP '"browser_download_url": "\K(.*?)(?=")' | grep .zip)

    if [ -n "$PIF_DOWNLOAD_URL" ]; then
        log_info "Getting latest release from:" "$PIF_DOWNLOAD_URL"
        wget -O data/modules/playintegrityfix/playintegrityfix.zip "$PIF_DOWNLOAD_URL"
        log_succes "Downloaded latest PIF"
    else
        log_error "Couldn't find a download link for the latest release."
    fi
    log_info "Unzipping latest PIF..."
    unzip -d data/modules/playintegrityfix/final data/modules/playintegrityfix/playintegrityfix.zip

    log_info "Setting ro.adb.secure to 0..."
    sed -i 's/^resetprop_if_diff ro.adb.secure 1$/resetprop_if_diff ro.adb.secure 0/' data/modules/playintegrityfix/final/post-fs-data.sh

    log_info "Zipping PIF to make a Magisk Module..."
    cd data/modules/playintegrityfix/final || exit 1
    zip -r ../pif.zip ./*
    cd - || exit 1
    
    log_succes "Magisk module created succesfully..."

        devices=()
    while IFS= read -r device_ip; do
        if [ -n "$device_ip" ]; then
            devices+=("$device_ip")
        fi
    done < "$ADB_DEVICE_FILE"
        for device_ip in "${devices[@]}"; do
        log_info "Connecting to $device_ip..."
        adb connect "$device_ip"

        log_info "Removing current PIF on $device_ip..."
        adb -s "$device_ip" shell "su -c 'cd data/adb/modules && rm -rf playintegrityfix'"

        log_info "Rebooting $device_ip..."
        adb -s "$device_ip" shell "reboot"

        log_info "Zorua takes a 2 minute nap waiting for the device to come back..."
        sleep 120

        log_info "Pushing latest PIF to $device_ip"
        adb -s "$device_ip" push data/modules/playintegrityfix/pif.zip /data/local/tmp

        log_info "Installing latest PIF to $device_ip..."
        adb -s "$device_ip" shell "su -c 'magisk --install-module /data/local/tmp/pif.zip'"

        log_info "Removing downloaded PIF module from /data/local/tmp on $device_ip..."
        adb -s $device_ip shell "rm -rf /data/local/tmp/pif.zip"

        log_info "Rebooting $device_ip..." 
        adb -s "$device_ip" shell "reboot"

        log_info "Disconnecting from $device_ip..."
        adb disconnect "$device_ip"
    done    
}    




help() {
    log_info "--update_lib will update all devices to the pogo library you specified."
    log_info "--update_cosmog will update all devices to the latest cosmog."
    log_info "--help (this command) will show you all options."
    log_info "--print_config will show you all configured options."
    log_info "--version will show you the version of Zorua you are on."
    log_info "--update_webview will update the Android Webview on all devices in configs/device.txt, this is needed on some ROMs for Furtif Tools."
    log_info "--update_pogo will update PoGo on all devices in configs/devices.txt"
    log_info "--clear_atv_cache will clear the cache on ATVs. This is especially useful on the TX9S. This will delete Magisk, so you have to click on Magisk again to let it reinstall itself" 
    log_ingo "--restart_cosmog will force restart the Cosmog MITM"
    log_info "--setup_furtif_tools will run the setup function and get your atv from nothing to up and running"
    log_info "--update_pif_module will update to the latest PlayIntegrityFix with ro.adb.secure set to 0"
    log_info "--clear_space will clear up space on the Android device"

}




while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --update_lib)
            if [ "$COSMOG_ENABLED" == "true" ]; then
                update_pogo_lib
            else
                echo "Cosmog module not enabled."
                shift 2
            fi
            ;;
        --update_cosmog)
            if [ "$COSMOG_ENABLED" == "true" ]; then
                update_cosmog
            else
                echo "Cosmog module not enabled."
                shift
            fi
            ;;
        --help)
                help 
            ;;     
        --print_config)
                print_config 
            ;;                
        --version)
                print_version 
            ;;                                                     
        --update_webview)
                update_webview 
            ;;                                  
        --update_pogo)
                update_pogo 
            ;;                    
        --clear_atv_cache)
                clear_atv_cache 
            ;;                    
        --restart_cosmog)
                restart_cosmog
            ;;                    
        --setup_furtif_tools)
                setup_furtif_tools 
            ;;
        --clear_space)
                clear_space
            ;;            
        --update_pif_module)
                update_pif_module
            ;;
        --update_furtif_tools)
                update_furtif_tools
            ;;                                        
        *)
            echo "Unknown option: $1"
            shift
            ;;
    esac
    shift
done
