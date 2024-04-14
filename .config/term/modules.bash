# add ble.sh
# https://github.com/akinomyoga/ble.sh
TC_BLE_SOURCE_DIR=$TC_MODULES_DIR/ble
TC_BLE_SCRIPT=$TC_BLE_SOURCE_DIR/out/ble.sh
if [[ ! -f $TC_BLE_SCRIPT ]]; then
    DebugMessage "ble.sh not found!"
    # Check if the submodule is initialized
    # We can do that by checking if the status of the submodule begins with a dash --> Not initialized
    TC_BLE_SUBMODULE_STATUS=$(cd $TC_MODULES_DIR && git submodule status)
    if [[ $TC_BLE_SUBMODULE_STATUS == -* ]]; then
        DebugMessage "Could not find ble submodule. Running git submodule update --init --recursive."
        (cd $TC_MODULES_DIR && git submodule update --init --recursive)
    fi

    unset TC_BLE_SUBMODULE_STATUS

    if command -v make &> /dev/null
    then
        DebugMessage "Building ble.sh"
        make -C $TC_BLE_SOURCE_DIR install
    else
        DebugMessage "No \"make\" in path! Cannot build ble.sh"
        unset TC_BLE_SOURCE_DIR TC_BLE_SCRIPT
        return
    fi
fi

DebugMessage "Sourcing ble.sh"
if is_windows; then
    Warn "Ble cannot bind some functionality - expect some errors on windows!"
fi

source $TC_BLE_SCRIPT

unset TC_BLE_SOURCE_DIR TC_BLE_SCRIPT
