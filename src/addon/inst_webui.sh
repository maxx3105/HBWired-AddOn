#!/bin/sh
# ============================================================
# inst_webui.sh - HBWired AddOn WebUI Integration
#
# Traegt Parameter-Uebersetzungen direkt in webui.js ein via elvST Array.
# Die CCU sucht in elvST nach dem reinen Parameter-ID (ohne Kanaltyp-Prefix).
# ============================================================

WEBUIFILE=/www/webui/webui.js
WEBUISEARCH_DEV="DEV_HIGHLIGHT[[:space:]]*=[[:space:]]*new Array();"
WEBUISEARCH_ST="elvST[[:space:]]*=[[:space:]]*new Array();"

add_device() {
    local DEVICE="$1"
    local DESC="$2"
    local IMG="$3"
    local THUMB="$4"
    if [ ! -f "$WEBUIFILE" ]; then return 0; fi
    if [ -z "$(grep "DEV_LIST.push('${DEVICE}')" $WEBUIFILE)" ]; then
        local INSERT="\nDEV_HIGHLIGHT['${DEVICE}'] = new Object();\nDEV_LIST.push('${DEVICE}');\nDEV_DESCRIPTION['${DEVICE}']='${DESC}';\nDEV_PATHS['${DEVICE}'] = new Object();\nDEV_PATHS['${DEVICE}']['50'] = '\/config\/img\/devices\/50\/${THUMB}';\nDEV_PATHS['${DEVICE}']['250'] = '\/config\/img\/devices\/250\/${IMG}';"
        sed -i "s/\(${WEBUISEARCH_DEV}\)/\1${INSERT}/g" $WEBUIFILE
        echo "  webui device: +${DEVICE}"
    fi
}

del_device() {
    local DEVICE="$1"
    if [ ! -f "$WEBUIFILE" ]; then return 0; fi
    sed -i "/DEV_HIGHLIGHT\['${DEVICE}'\]/d" $WEBUIFILE
    sed -i "/DEV_LIST.push('${DEVICE}')/d" $WEBUIFILE
    sed -i "/DEV_DESCRIPTION\['${DEVICE}'\]/d" $WEBUIFILE
    sed -i "/DEV_PATHS\['${DEVICE}'\]/d" $WEBUIFILE
}

add_elvst() {
    local PARAM="$1"
    local STKEY="$2"
    if [ ! -f "$WEBUIFILE" ]; then return 0; fi
    if [ -z "$(grep "elvST\['${PARAM}'\]" $WEBUIFILE)" ]; then
        local INSERT="\nelvST['${PARAM}'] = '\${${STKEY}}';"
        sed -i "s/\(${WEBUISEARCH_ST}\)/\1${INSERT}/g" $WEBUIFILE
        echo "  webui: +${PARAM}"
    fi
}

del_elvst() {
    local PARAM="$1"
    if [ ! -f "$WEBUIFILE" ]; then return 0; fi
    sed -i "/elvST\['${PARAM}'\]/d" $WEBUIFILE
}

do_install() {
    echo "=== inst_webui.sh: install ==="

    # Geräte in webui.js registrieren
    add_device "HBW-LC-SW8-DR"   "HBWired 8ch Switch"    "HBW-LC-SW8-DR.png"    "HBW-LC-SW8-DR_thumb.png"
    add_device "HBW-LC-DIM4-DR"  "HBWired 4ch Dimmer"    "HBW-LC-DIM4-DR.png"   "HBW-LC-DIM4-DR_thumb.png"
    add_device "HBW-IO-12"       "HBWired 12ch I/O"      "HBW-IO-12.png"        "HBW-IO-12_thumb.png"
    add_device "HBW-SENS-SC8"    "HBWired 8ch Sensor"    "HBW-SENS-SC8.png"     "HBW-SENS-SC8_thumb.png"
    add_device "HBW-1W-T10"      "HBWired 1Wire Temp"    "HBW-1W-T10.png"       "HBW-1W-T10_thumb.png"
    add_device "HBW-LC-BL-4"     "HBWired 4ch Blind"     "HBW-LC-BL-4.png"      "HBW-LC-BL-4_thumb.png"
    add_device "HBW-LC-SW-8"     "HBWired 8ch Switch v2" "HBW-LC-SW-8.png"      "HBW-LC-SW-8_thumb.png"
    add_device "HBW-SEN-EP"      "HBWired Energy"        "HBW-SEN-EP.png"       "HBW-SEN-EP_thumb.png"
    add_device "HBW-WDS-C7"      "HBWired Weather"       "HBW-WDS-C7.png"       "HBW-WDS-C7_thumb.png"
    add_device "HBW-SYS-PM"      "HBWired Power"         "HBW-SYS-PM.png"       "HBW-SYS-PM_thumb.png"
    add_device "HBW-LC-BL-8"     "HBWired 8ch Blind"     "HBW-LC-BL-8.png"      "HBW-LC-BL-8_thumb.png"
    add_device "HBW-LC-SW-12"    "HBWired 12ch Switch"   "HBW-LC-SW-12.png"     "HBW-LC-SW-12_thumb.png"
    add_device "HBW-SEN-KEY-12"  "HBWired 12ch Key"      "HBW-SEN-KEY-12.png"   "HBW-SEN-KEY-12_thumb.png"
    add_device "HBW-SC-10-DIM-6" "HBWired 10SW+6DIM"     "HBW-SC-10-DIM-6.png"  "HBW-SC-10-DIM-6_thumb.png"
    add_device "HBW-CC-VD"       "HBWired Valve"         "HBW-CC-VD.png"        "HBW-CC-VD_thumb.png"
    add_device "HBW-SEN-DB-4"    "HBWired Doorbell"      "HBW-SEN-DB-4.png"     "HBW-SEN-DB-4_thumb.png"
    add_device "HBW-CC-WW-SPKTS" "HBWired Heating"       "HBW-CC-WW-SPKTS.png"  "HBW-CC-WW-SPKTS_thumb.png"
    add_device "HBW-CC-DT3-T6"   "HBWired Climate"       "HBW-CC-DT3-T6.png"    "HBW-CC-DT3-T6_thumb.png"
    add_device "HBW-SEN-SC-12-DR" "HBWired 12ch Sensor"  "HBW-SEN-SC-12-DR.png" "HBW-SEN-SC-12-DR_thumb.png"
    add_device "HBW-DIS-KEY-4"   "HBWired Display"       "HBW-DIS-KEY-4.png"    "HBW-DIS-KEY-4_thumb.png"

    # Parameter-IDs ohne Kanaltyp-Prefix
    add_elvst "SEND_DELTA_TEMP"                 "stringTableHbwSendDeltaTemp"
    add_elvst "SEND_DELTA_VALUE"                "stringTableHbwSendDeltaValue"
    add_elvst "SEND_DELTA_COUNT"                "stringTableHbwSendDeltaCount"
    add_elvst "SEND_MIN_INTERVAL"               "stringTableHbwSendMinInterval"
    add_elvst "SEND_MAX_INTERVAL"               "stringTableHbwSendMaxInterval"
    add_elvst "SEND_MAX_INTERVALL"              "stringTableHbwSendMaxInterval"
    add_elvst "OFFSET"                          "stringTableHbwOffset"
    add_elvst "ONEWIRE_TYPE"                    "stringTableHbwOnewireType"
    add_elvst "TEMPERATURE"                     "stringTableHbwTemperature"
    add_elvst "EVENT_DELAYTIME"                 "stringTableHbwEventDelaytime"
    add_elvst "INPUT_LOCKED"                    "stringTableHbwInputLocked"
    add_elvst "INVERTED"                        "stringTableHbwInverted"
    add_elvst "NOTIFY"                          "stringTableHbwNotify"
    add_elvst "TRANSMIT_TRY_MAX"               "stringTableHbwTransmitTryMax"
    add_elvst "INPUT_TYPE"                      "stringTableHbwInputType"
    add_elvst "LONG_PRESS_TIME"                 "stringTableHbwLongPressTime"
    add_elvst "PULLUP"                          "stringTableHbwPullup"
    add_elvst "REPEAT_LONG_PRESS"              "stringTableHbwRepeatLongPress"
    add_elvst "SUPPRESS_NUM"                    "stringTableHbwSuppressNum"
    add_elvst "SUPPRESS_TIME"                   "stringTableHbwSuppressTime"
    add_elvst "BUZZER"                          "stringTableHbwBuzzer"
    add_elvst "LOGGING"                         "stringTableHbwLogging"
    add_elvst "OUTPUT_BEHAVIOUR"               "stringTableHbwOutputBehaviour"
    add_elvst "OUTPUT_LOCKED"                   "stringTableHbwOutputLocked"
    add_elvst "AUTO_BRIGHTNESS"                "stringTableHbwAutoBrightness"
    add_elvst "AUTO_OFF_DELAY"                 "stringTableHbwAutoOffDelay"
    add_elvst "DIM_MAX_LEVEL"                   "stringTableHbwDimMaxLevel"
    add_elvst "DIM_MIN_LEVEL"                   "stringTableHbwDimMinLevel"
    add_elvst "MAX_ON_TIME"                     "stringTableHbwMaxOnTime"
    add_elvst "MAX_OUTPUT_RANGE"               "stringTableHbwMaxOutputRange"
    add_elvst "MAX_TEMP"                        "stringTableHbwMaxTemp"
    add_elvst "ON_TIME"                         "stringTableHbwOnTime"
    add_elvst "OUTPUT_VOLTAGE"                 "stringTableHbwOutputVoltage"
    add_elvst "POWER_ON_STATE"                 "stringTableHbwPowerOnState"
    add_elvst "PWM_RANGE"                       "stringTableHbwPwmRange"
    add_elvst "CHANGE_OVER_DELAY"              "stringTableHbwChangeOverDelay"
    add_elvst "MOTOR_STARTUP_DELAY"            "stringTableHbwMotorStartupDelay"
    add_elvst "REFERENCE_RUNNING_TIME_BOTTOM_TOP" "stringTableHbwRefRunTimeBottomTop"
    add_elvst "REFERENCE_RUNNING_TIME_TOP_BOTTOM" "stringTableHbwRefRunTimeTopBottom"
    add_elvst "REFERENCE_RUN_COUNTER"          "stringTableHbwRefRunCounter"
    add_elvst "LIMIT_LOWER"                     "stringTableHbwLimitLower"
    add_elvst "LIMIT_UPPER"                     "stringTableHbwLimitUpper"
    add_elvst "LOCKED"                          "stringTableHbwLocked"
    add_elvst "SWITCH_TIME"                     "stringTableHbwSwitchTime"
    add_elvst "VALVE_ERROR_POS"                "stringTableHbwValveErrorPos"
    add_elvst "UPDATE_INTERVAL"                "stringTableHbwUpdateInterval"
    add_elvst "ENABLED"                         "stringTableHbwEnabled"
    add_elvst "SAMPLE_INTERVAL"                "stringTableHbwSampleInterval"
    add_elvst "SAMPLE_RATE"                     "stringTableHbwSampleRate"
    add_elvst "RX_TIMEOUT"                      "stringTableHbwRxTimeout"
    add_elvst "SENSOR_ID"                       "stringTableHbwSensorId"
    add_elvst "STORM_THRESHOLD_LEVEL"          "stringTableHbwStormThreshold"
    add_elvst "STORM_TRIGGER_COUNT"            "stringTableHbwStormTriggerCount"
    add_elvst "CYCLE_TIME"                      "stringTableHbwCycleTime"
    add_elvst "DELTA_TEMP"                      "stringTableHbwDeltaTemp"
    add_elvst "ERROR_STATE"                     "stringTableHbwErrorState"
    add_elvst "HYSTERESIS"                      "stringTableHbwHysteresis"
    add_elvst "HYSTERESIS_FOR_DELTAT"          "stringTableHbwHysteresisForDeltaT"
    add_elvst "HYSTERESIS_FOR_T1_MAX"          "stringTableHbwHysteresisForT1Max"
    add_elvst "HYSTERESIS_FOR_T2_MIN"          "stringTableHbwHysteresisForT2Min"
    add_elvst "PULS_ON_CYCLE"                   "stringTableHbwPulsOnCycle"
    add_elvst "T1_MAX"                          "stringTableHbwT1Max"
    add_elvst "T2_MIN"                          "stringTableHbwT2Min"
    add_elvst "ERROR_RETRY"                     "stringTableHbwErrorRetry"
    add_elvst "RECEIVE_MAX_INTERVAL"           "stringTableHbwReceiveMaxInterval"
    add_elvst "DEFAULT_SET_POINT"              "stringTableHbwDefaultSetPoint"
    add_elvst "DERIVATIVE"                      "stringTableHbwDerivative"
    add_elvst "INTEGRAL"                        "stringTableHbwIntegral"
    add_elvst "POWERON_MODE"                    "stringTableHbwPowerOnMode"
    add_elvst "PROPORTIONAL"                    "stringTableHbwProportional"
    add_elvst "AUTO_CYCLE"                      "stringTableHbwAutoCycle"
    add_elvst "CHARACTERS_PER_LINE"            "stringTableHbwCharsPerLine"
    add_elvst "DISPLAY_LINES"                   "stringTableHbwDisplayLines"
    add_elvst "INVERT_DISPLAY"                 "stringTableHbwInvertDisplay"
    add_elvst "REFRESH_RATE"                    "stringTableHbwRefreshRate"
    add_elvst "DEFAULT_TEXT"                    "stringTableHbwDefaultText"
    add_elvst "ALARM_MAX_POWER"                "stringTableHbwAlarmMaxPower"
    add_elvst "ALARM_MAX_VOLTAGE"              "stringTableHbwAlarmMaxVoltage"
    add_elvst "ALARM_MIN_VOLTAGE"              "stringTableHbwAlarmMinVoltage"
    add_elvst "KEY_EVENT_ALARM"                "stringTableHbwKeyEventAlarm"
    add_elvst "OWN_ADDRESS"                    "stringTableHbwOwnAddress"
    add_elvst "REMOVE_SENSOR"                  "stringTableHbwRemoveSensor"

    echo "=== inst_webui.sh: install done ==="
}

do_uninstall() {
    echo "=== inst_webui.sh: uninstall ==="

    # Geräte aus webui.js entfernen
    for DEV in HBW-LC-SW8-DR HBW-LC-DIM4-DR HBW-IO-12 HBW-SENS-SC8 HBW-1W-T10                HBW-LC-BL-4 HBW-LC-SW-8 HBW-SEN-EP HBW-WDS-C7 HBW-SYS-PM                HBW-LC-BL-8 HBW-LC-SW-12 HBW-SEN-KEY-12 HBW-SC-10-DIM-6                HBW-CC-VD HBW-SEN-DB-4 HBW-CC-WW-SPKTS HBW-CC-DT3-T6                HBW-SEN-SC-12-DR HBW-DIS-KEY-4; do
        del_device "$DEV"
    done
    for PARAM in \
        SEND_DELTA_TEMP SEND_DELTA_VALUE SEND_DELTA_COUNT \
        SEND_MIN_INTERVAL SEND_MAX_INTERVAL SEND_MAX_INTERVALL \
        OFFSET ONEWIRE_TYPE TEMPERATURE EVENT_DELAYTIME \
        INPUT_LOCKED INVERTED NOTIFY TRANSMIT_TRY_MAX \
        INPUT_TYPE LONG_PRESS_TIME PULLUP REPEAT_LONG_PRESS \
        SUPPRESS_NUM SUPPRESS_TIME BUZZER LOGGING \
        OUTPUT_BEHAVIOUR OUTPUT_LOCKED AUTO_BRIGHTNESS AUTO_OFF_DELAY \
        DIM_MAX_LEVEL DIM_MIN_LEVEL MAX_ON_TIME MAX_OUTPUT_RANGE \
        MAX_TEMP ON_TIME OUTPUT_VOLTAGE POWER_ON_STATE PWM_RANGE \
        CHANGE_OVER_DELAY MOTOR_STARTUP_DELAY \
        REFERENCE_RUNNING_TIME_BOTTOM_TOP REFERENCE_RUNNING_TIME_TOP_BOTTOM \
        REFERENCE_RUN_COUNTER LIMIT_LOWER LIMIT_UPPER LOCKED \
        SWITCH_TIME VALVE_ERROR_POS UPDATE_INTERVAL ENABLED \
        SAMPLE_INTERVAL SAMPLE_RATE RX_TIMEOUT SENSOR_ID \
        STORM_THRESHOLD_LEVEL STORM_TRIGGER_COUNT CYCLE_TIME \
        DELTA_TEMP ERROR_STATE HYSTERESIS HYSTERESIS_FOR_DELTAT \
        HYSTERESIS_FOR_T1_MAX HYSTERESIS_FOR_T2_MIN PULS_ON_CYCLE \
        T1_MAX T2_MIN ERROR_RETRY RECEIVE_MAX_INTERVAL \
        DEFAULT_SET_POINT DERIVATIVE INTEGRAL POWERON_MODE PROPORTIONAL \
        AUTO_CYCLE CHARACTERS_PER_LINE DISPLAY_LINES INVERT_DISPLAY \
        REFRESH_RATE DEFAULT_TEXT ALARM_MAX_POWER ALARM_MAX_VOLTAGE \
        ALARM_MIN_VOLTAGE KEY_EVENT_ALARM OWN_ADDRESS REMOVE_SENSOR
    do
        del_elvst "${PARAM}"
    done
    echo "=== inst_webui.sh: uninstall done ==="
}

case "$1" in
    ""|install)  do_install   ;;
    uninstall)   do_uninstall ;;
    *)
        echo "Usage: $(basename $0) {install|uninstall}"
        exit 1
        ;;
esac
