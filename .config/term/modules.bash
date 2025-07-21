# add ble.sh
# https://github.com/akinomyoga/ble.sh
TC_BLE_SOURCE_DIR=$TC_MODULES_DIR/ble
TC_BLE_INSTALL_DIR=$TC_MODULES_DIR/ble-install
TC_BLE_SCRIPT=$TC_BLE_INSTALL_DIR/share/blesh/ble.sh
if [[ ! -f $TC_BLE_SCRIPT ]]; then
    DebugMessage "ble.sh not found!"
    # Check if the submodule is initialized
    # We can do that by checking if the status of the submodule begins with a dash --> Not initialized
    TC_BLE_SUBMODULE_STATUS=$(cd $TC_MODULES_DIR && git submodule status)
    if [[ $TC_BLE_SUBMODULE_STATUS == -* ]]; then
        DebugMessage "Could not find ble submodule. Running git submodule update --init --recursive."
        (cd $TC_MODULES_DIR && git submodule update --init --recursive --depth 1 --shallow-submodules)
    fi

    unset TC_BLE_SUBMODULE_STATUS

    if command -v make &>/dev/null; then
        DebugMessage "Building ble.sh"
        (cd $TC_BLE_SOURCE_DIR && make && make PREFIX="$TC_BLE_INSTALL_DIR" install)
    else
        DebugMessage "No \"make\" in path! Cannot build ble.sh"
        unset TC_BLE_SOURCE_DIR TC_BLE_SCRIPT TC_BLE_INSTALL_DIR
        return
    fi
fi


DebugMessage "Sourcing ble.sh"
if is_windows; then
    Warn "Ble cannot bind some functionality - expect some errors on windows!"
fi

source $TC_BLE_SCRIPT --rcfile "$HOME/.blerc"

DebugMessage "Sourcing ble extensions"

source_files $TC_MODULES_DIR/ble-ext


# Update ble.sh
# We use our update function to check if we should perform the update
# The first parameter is the identifier for the update, the second is the time in seconds that should be waited before the next update attempt/check
if should_perform_update ble 86400; then
    DebugMessage "Updating ble.sh"

    ble-update
fi

unset TC_BLE_SOURCE_DIR TC_BLE_SCRIPT TC_BLE_PREFIX TC_BLE_INSTALL_DIR
