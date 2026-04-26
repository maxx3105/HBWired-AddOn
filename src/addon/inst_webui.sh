#!/bin/sh
# ============================================================
# inst_webui.sh - HBWired AddOn WebUI Integration
#
# Traegt Parameter-Uebersetzungen direkt in webui.js ein via elvST Array.
# Die CCU sucht in elvST nach dem reinen Parameter-ID (ohne Kanaltyp-Prefix).
# ============================================================

WEBUIFILE=/www/webui/webui.js
WEBUISEARCH="elvST[[:space:]]*=[[:space:]]*new Array();"

add_elvst() {
    local PARAM="$1"
    local STKEY="$2"
    if [ ! -f "$WEBUIFILE" ]; then return 0; fi
    if [ -z "$(grep "elvST\['${PARAM}'\]" $WEBUIFILE)" ]; then
        local INSERT="\nelvST['${PARAM}'] = '\${${STKEY}}';"
        sed -i "s/\(${WEBUISEARCH}\)/\1${INSERT}/g" $WEBUIFILE
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

    echo "=== inst_webui.sh: install done ==="
}

do_uninstall() {
    echo "=== inst_webui.sh: uninstall ==="
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
        ALARM_MIN_VOLTAGE KEY_EVENT_ALARM
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
