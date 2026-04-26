#!/bin/sh
# ============================================================
# inst_strings.sh - HBWired AddOn Stringtable Integration
#
# stringtable_de.txt           -> Mapping ParameterID -> stringTable-Key
# translate.lang.extension.js  -> stringTable-Key -> lesbarer Text (Statusansicht)
# translate.lang.stringtable.js -> stringTable-Key -> lesbarer Text (Kanalparameter)
# ============================================================

STRINGTABLE=/www/config/stringtable_de.txt
EXTENSION_DE=/www/webui/js/lang/de/translate.lang.extension.js
EXTENSION_EN=/www/webui/js/lang/en/translate.lang.extension.js
STRINGTABLE_JS_DE=/www/webui/js/lang/de/translate.lang.stringtable.js
STRINGTABLE_JS_EN=/www/webui/js/lang/en/translate.lang.stringtable.js

# -------------------------------------------------------
# Fuegt Zeile in stringtable_de.txt ein, falls nicht vorhanden.
# Format: KEY<TAB>${stringTableKey}
# -------------------------------------------------------
add_st() {
    local KEY="$1"
    local VALKEY="$2"
    if ! grep -qF "${KEY}	" "${STRINGTABLE}"; then
        HB_INS=$(printf '%s\t${%s}' "${KEY}" "${VALKEY}")
        export HB_INS
        awk 'BEGIN { ins=ENVIRON["HB_INS"]; done=0 }
             { print }
             END { if (!done) { print ins } }' \
            "${STRINGTABLE}" > "${STRINGTABLE}.tmp" \
            && mv "${STRINGTABLE}.tmp" "${STRINGTABLE}"
        echo "  stringtable: +${KEY}"
    fi
}

del_st() {
    local KEY="$1"
    HB_DEL="${KEY}	"
    export HB_DEL
    awk 'BEGIN { del=ENVIRON["HB_DEL"] }
         index($0, del) != 1 { print }' \
        "${STRINGTABLE}" > "${STRINGTABLE}.tmp" \
        && mv "${STRINGTABLE}.tmp" "${STRINGTABLE}"
}

# -------------------------------------------------------
# Fuegt Eintrag in translate.lang.extension.js ein.
# Anker: die letzte Zeile die nur "  }" enthaelt
# -------------------------------------------------------
add_tr() {
    local FILE="$1"
    local KEY="$2"
    local VAL="$3"
    if ! grep -qF "\"${KEY}\"" "${FILE}"; then
        HB_INS="    \"${KEY}\" : \"${VAL}\","
        export HB_INS
        awk 'BEGIN { ins=ENVIRON["HB_INS"] }
             { lines[NR]=$0 }
             END {
                 last=0
                 for(i=NR;i>=1;i--) {
                     if(lines[i]=="  }") { last=i; break }
                 }
                 prev=last-1
                 if(prev>=1 && lines[prev] !~ /,$/ && lines[prev] !~ /^[[:space:]]*\/\//) {
                     lines[prev] = lines[prev] ","
                 }
                 for(i=1;i<=NR;i++) {
                     if(i==last) print ins
                     print lines[i]
                 }
             }' \
            "${FILE}" > "${FILE}.tmp" \
            && mv "${FILE}.tmp" "${FILE}"
        echo "  translation: +${KEY} in $(basename ${FILE})"
    fi
}

del_tr() {
    local FILE="$1"
    local KEY="$2"
    HB_DEL="\"${KEY}\""
    export HB_DEL
    awk 'BEGIN { del=ENVIRON["HB_DEL"] }
         index($0, del) == 0 { print }' \
        "${FILE}" > "${FILE}.tmp" \
        && mv "${FILE}.tmp" "${FILE}"
}

# -------------------------------------------------------
# INSTALL
# -------------------------------------------------------
do_install() {
    echo "=== inst_strings.sh: install ==="

    # TEMPSENSOR (HBW-1W-T10)
    add_st "TEMPSENSOR|SEND_DELTA_TEMP"       "stringTableHbwSendDeltaTemp"
    add_st "TEMPSENSOR|SEND_MIN_INTERVAL"     "stringTableHbwSendMinInterval"
    add_st "TEMPSENSOR|SEND_MAX_INTERVAL"     "stringTableHbwSendMaxInterval"
    add_st "TEMPSENSOR|SEND_MAX_INTERVALL"    "stringTableHbwSendMaxInterval"
    add_st "TEMPSENSOR|OFFSET"                "stringTableHbwOffset"
    add_st "TEMPSENSOR|ONEWIRE_TYPE"          "stringTableHbwOnewireType"
    add_st "TEMPSENSOR|TEMPERATURE"           "stringTableHbwTemperature"

    # SENSOR
    add_st "SENSOR|EVENT_DELAYTIME"           "stringTableHbwEventDelaytime"
    add_st "SENSOR|INPUT_LOCKED"              "stringTableHbwInputLocked"
    add_st "SENSOR|INVERTED"                  "stringTableHbwInverted"
    add_st "SENSOR|NOTIFY"                    "stringTableHbwNotify"
    add_st "SENSOR|TRANSMIT_TRY_MAX"          "stringTableHbwTransmitTryMax"

    # KEY
    add_st "KEY|INPUT_TYPE"                   "stringTableHbwInputType"
    add_st "KEY|INPUT_LOCKED"                 "stringTableHbwInputLocked"
    add_st "KEY|INVERTED"                     "stringTableHbwInverted"
    add_st "KEY|LONG_PRESS_TIME"              "stringTableHbwLongPressTime"
    add_st "KEY|PULLUP"                       "stringTableHbwPullup"
    add_st "KEY|REPEAT_LONG_PRESS"            "stringTableHbwRepeatLongPress"
    add_st "KEY|SUPPRESS_NUM"                 "stringTableHbwSuppressNum"
    add_st "KEY|SUPPRESS_TIME"                "stringTableHbwSuppressTime"
    add_st "KEY|BUZZER"                       "stringTableHbwBuzzer"

    # SWITCH
    add_st "SWITCH|INVERTED"                  "stringTableHbwInverted"
    add_st "SWITCH|LOGGING"                   "stringTableHbwLogging"
    add_st "SWITCH|OUTPUT_BEHAVIOUR"          "stringTableHbwOutputBehaviour"
    add_st "SWITCH|OUTPUT_LOCKED"             "stringTableHbwOutputLocked"

    # DIMMER
    add_st "DIMMER|AUTO_BRIGHTNESS"           "stringTableHbwAutoBrightness"
    add_st "DIMMER|AUTO_OFF_DELAY"            "stringTableHbwAutoOffDelay"
    add_st "DIMMER|DIM_MAX_LEVEL"             "stringTableHbwDimMaxLevel"
    add_st "DIMMER|DIM_MIN_LEVEL"             "stringTableHbwDimMinLevel"
    add_st "DIMMER|LOGGING"                   "stringTableHbwLogging"
    add_st "DIMMER|MAX_ON_TIME"               "stringTableHbwMaxOnTime"
    add_st "DIMMER|MAX_OUTPUT_RANGE"          "stringTableHbwMaxOutputRange"
    add_st "DIMMER|MAX_TEMP"                  "stringTableHbwMaxTemp"
    add_st "DIMMER|ON_TIME"                   "stringTableHbwOnTime"
    add_st "DIMMER|OUTPUT_VOLTAGE"            "stringTableHbwOutputVoltage"
    add_st "DIMMER|POWER_ON_STATE"            "stringTableHbwPowerOnState"
    add_st "DIMMER|PWM_RANGE"                 "stringTableHbwPwmRange"

    # BLIND
    add_st "BLIND|CHANGE_OVER_DELAY"          "stringTableHbwChangeOverDelay"
    add_st "BLIND|LOGGING"                    "stringTableHbwLogging"
    add_st "BLIND|MOTOR_STARTUP_DELAY"        "stringTableHbwMotorStartupDelay"
    add_st "BLIND|REFERENCE_RUNNING_TIME_BOTTOM_TOP" "stringTableHbwRefRunTimeBottomTop"
    add_st "BLIND|REFERENCE_RUNNING_TIME_TOP_BOTTOM" "stringTableHbwRefRunTimeTopBottom"
    add_st "BLIND|REFERENCE_RUN_COUNTER"      "stringTableHbwRefRunCounter"

    # VALVE
    add_st "VALVE|INVERTED"                   "stringTableHbwInverted"
    add_st "VALVE|LIMIT_LOWER"                "stringTableHbwLimitLower"
    add_st "VALVE|LIMIT_UPPER"                "stringTableHbwLimitUpper"
    add_st "VALVE|LOCKED"                     "stringTableHbwLocked"
    add_st "VALVE|LOGGING"                    "stringTableHbwLogging"
    add_st "VALVE|SWITCH_TIME"                "stringTableHbwSwitchTime"
    add_st "VALVE|VALVE_ERROR_POS"            "stringTableHbwValveErrorPos"

    # ANALOG_INPUT / ANALOGSENSOR
    add_st "ANALOG_INPUT|SEND_DELTA_VALUE"    "stringTableHbwSendDeltaValue"
    add_st "ANALOG_INPUT|SEND_MIN_INTERVAL"   "stringTableHbwSendMinInterval"
    add_st "ANALOG_INPUT|SEND_MAX_INTERVAL"   "stringTableHbwSendMaxInterval"
    add_st "ANALOG_INPUT|UPDATE_INTERVAL"     "stringTableHbwUpdateInterval"
    add_st "ANALOGSENSOR|ENABLED"             "stringTableHbwEnabled"
    add_st "ANALOGSENSOR|NOTIFY"              "stringTableHbwNotify"
    add_st "ANALOGSENSOR|SAMPLE_INTERVAL"     "stringTableHbwSampleInterval"

    # COUNTER_INPUT
    add_st "COUNTER_INPUT|ENABLED"            "stringTableHbwEnabled"
    add_st "COUNTER_INPUT|INVERTED"           "stringTableHbwInverted"
    add_st "COUNTER_INPUT|SEND_DELTA_COUNT"   "stringTableHbwSendDeltaCount"
    add_st "COUNTER_INPUT|SEND_MIN_INTERVAL"  "stringTableHbwSendMinInterval"
    add_st "COUNTER_INPUT|SEND_MAX_INTERVAL"  "stringTableHbwSendMaxInterval"

    # WEATHER
    add_st "WEATHER|RX_TIMEOUT"              "stringTableHbwRxTimeout"
    add_st "WEATHER|SEND_DELTA_TEMP"         "stringTableHbwSendDeltaTemp"
    add_st "WEATHER|SEND_MIN_INTERVAL"       "stringTableHbwSendMinInterval"
    add_st "WEATHER|SEND_MAX_INTERVAL"       "stringTableHbwSendMaxInterval"
    add_st "WEATHER|SENSOR_ID"               "stringTableHbwSensorId"
    add_st "WEATHER|STORM_THRESHOLD_LEVEL"   "stringTableHbwStormThreshold"
    add_st "WEATHER|STORM_TRIGGER_COUNT"     "stringTableHbwStormTriggerCount"

    # DELTA_T
    add_st "DELTA_T|CYCLE_TIME"              "stringTableHbwCycleTime"
    add_st "DELTA_T|DELTA_TEMP"              "stringTableHbwDeltaTemp"
    add_st "DELTA_T|ERROR_STATE"             "stringTableHbwErrorState"
    add_st "DELTA_T|HYSTERESIS"              "stringTableHbwHysteresis"
    add_st "DELTA_T|HYSTERESIS_FOR_DELTAT"   "stringTableHbwHysteresisForDeltaT"
    add_st "DELTA_T|HYSTERESIS_FOR_T1_MAX"   "stringTableHbwHysteresisForT1Max"
    add_st "DELTA_T|HYSTERESIS_FOR_T2_MIN"   "stringTableHbwHysteresisForT2Min"
    add_st "DELTA_T|INVERTED"                "stringTableHbwInverted"
    add_st "DELTA_T|LOCKED"                  "stringTableHbwLocked"
    add_st "DELTA_T|LOGGING"                 "stringTableHbwLogging"
    add_st "DELTA_T|PULS_ON_CYCLE"           "stringTableHbwPulsOnCycle"
    add_st "DELTA_T|T1_MAX"                  "stringTableHbwT1Max"
    add_st "DELTA_T|T2_MIN"                  "stringTableHbwT2Min"
    add_st "DELTA_T1|ERROR_RETRY"            "stringTableHbwErrorRetry"
    add_st "DELTA_T1|RECEIVE_MAX_INTERVAL"   "stringTableHbwReceiveMaxInterval"
    add_st "DELTA_T2|ERROR_RETRY"            "stringTableHbwErrorRetry"
    add_st "DELTA_T2|RECEIVE_MAX_INTERVAL"   "stringTableHbwReceiveMaxInterval"

    # PID
    add_st "PID|CYCLE_TIME"                  "stringTableHbwCycleTime"
    add_st "PID|DEFAULT_SET_POINT"           "stringTableHbwDefaultSetPoint"
    add_st "PID|DERIVATIVE"                  "stringTableHbwDerivative"
    add_st "PID|INTEGRAL"                    "stringTableHbwIntegral"
    add_st "PID|POWERON_MODE"                "stringTableHbwPowerOnMode"
    add_st "PID|PROPORTIONAL"                "stringTableHbwProportional"

    # DISPLAY
    add_st "DISPLAY|AUTO_CYCLE"              "stringTableHbwAutoCycle"
    add_st "DISPLAY|CHARACTERS_PER_LINE"     "stringTableHbwCharsPerLine"
    add_st "DISPLAY|DISPLAY_LINES"           "stringTableHbwDisplayLines"
    add_st "DISPLAY|INVERT_DISPLAY"          "stringTableHbwInvertDisplay"
    add_st "DISPLAY|POWER_ON_STATE"          "stringTableHbwPowerOnState"
    add_st "DISPLAY|REFRESH_RATE"            "stringTableHbwRefreshRate"
    add_st "DISPLAY_LINE|AUTO_CYCLE"         "stringTableHbwAutoCycle"
    add_st "DISPLAY_LINE|DEFAULT_TEXT"       "stringTableHbwDefaultText"
    add_st "DISPLAY_V_SWITCH|DISPLAY_TEXT"   "stringTableHbwDisplayText"
    add_st "DISPLAY_V_TEMP|DIGITS"           "stringTableHbwDigits"
    add_st "DISPLAY_V_TEMP|FACTOR"           "stringTableHbwFactor"

    # BUS POWER / MODULE BUS VOLTAGE
    add_st "BUS POWER|ALARM_MAX_POWER"       "stringTableHbwAlarmMaxPower"
    add_st "BUS POWER|ALARM_MAX_VOLTAGE"     "stringTableHbwAlarmMaxVoltage"
    add_st "BUS POWER|ALARM_MIN_VOLTAGE"     "stringTableHbwAlarmMinVoltage"
    add_st "BUS POWER|ENABLED"               "stringTableHbwEnabled"
    add_st "BUS POWER|KEY_EVENT_ALARM"       "stringTableHbwKeyEventAlarm"
    add_st "BUS POWER|SAMPLE_RATE"           "stringTableHbwSampleRate"
    add_st "BUS POWER|SEND_MIN_INTERVAL"     "stringTableHbwSendMinInterval"
    add_st "BUS POWER|SEND_MAX_INTERVAL"     "stringTableHbwSendMaxInterval"
    add_st "MODULE BUS VOLTAGE|SEND_DELTA_VALUE"  "stringTableHbwSendDeltaValue"
    add_st "MODULE BUS VOLTAGE|SEND_MIN_INTERVAL" "stringTableHbwSendMinInterval"
    add_st "MODULE BUS VOLTAGE|SEND_MAX_INTERVAL" "stringTableHbwSendMaxInterval"
    add_st "MODULE BUS VOLTAGE|UPDATE_INTERVAL"   "stringTableHbwUpdateInterval"

    # Deutsch - extension.js UND stringtable.js
    for F in "${EXTENSION_DE}" "${STRINGTABLE_JS_DE}"; do
        add_tr "${F}" "stringTableHbwSendDeltaTemp"        "Sendedifferenz Temperatur"
        add_tr "${F}" "stringTableHbwSendDeltaValue"       "Sendedifferenz Wert"
        add_tr "${F}" "stringTableHbwSendDeltaCount"       "Sendedifferenz Z%E4hler"
        add_tr "${F}" "stringTableHbwSendMinInterval"      "Minimales Sendeintervall"
        add_tr "${F}" "stringTableHbwSendMaxInterval"      "Maximales Sendeintervall"
        add_tr "${F}" "stringTableHbwOffset"               "Offset"
        add_tr "${F}" "stringTableHbwOnewireType"          "1-Wire Sensor Typ"
        add_tr "${F}" "stringTableHbwTemperature"          "Temperatur"
        add_tr "${F}" "stringTableHbwEventDelaytime"       "Ereignis Verz%F6gerungszeit"
        add_tr "${F}" "stringTableHbwInputLocked"          "Eingang gesperrt"
        add_tr "${F}" "stringTableHbwInverted"             "Invertiert"
        add_tr "${F}" "stringTableHbwNotify"               "Benachrichtigung"
        add_tr "${F}" "stringTableHbwTransmitTryMax"       "Max. Sendeversuche"
        add_tr "${F}" "stringTableHbwInputType"            "Eingangstyp"
        add_tr "${F}" "stringTableHbwLongPressTime"        "Langdruckzeit"
        add_tr "${F}" "stringTableHbwPullup"               "Pull-Up Widerstand"
        add_tr "${F}" "stringTableHbwRepeatLongPress"      "Langdruck wiederholen"
        add_tr "${F}" "stringTableHbwSuppressNum"          "Anzahl unterd. Ereignisse"
        add_tr "${F}" "stringTableHbwSuppressTime"         "Unterd%FCckungszeit"
        add_tr "${F}" "stringTableHbwBuzzer"               "Summer"
        add_tr "${F}" "stringTableHbwLogging"              "Logging"
        add_tr "${F}" "stringTableHbwOutputBehaviour"      "Ausgangsverhalten"
        add_tr "${F}" "stringTableHbwOutputLocked"         "Ausgang gesperrt"
        add_tr "${F}" "stringTableHbwAutoBrightness"       "Automatische Helligkeit"
        add_tr "${F}" "stringTableHbwAutoOffDelay"         "Autom. Ausschaltverzög."
        add_tr "${F}" "stringTableHbwDimMaxLevel"          "Max. Dimmpegel"
        add_tr "${F}" "stringTableHbwDimMinLevel"          "Min. Dimmpegel"
        add_tr "${F}" "stringTableHbwMaxOnTime"            "Max. Einschaltdauer"
        add_tr "${F}" "stringTableHbwMaxOutputRange"       "Max. Ausgangsbereich"
        add_tr "${F}" "stringTableHbwMaxTemp"              "Maximaltemperatur"
        add_tr "${F}" "stringTableHbwOnTime"               "Einschaltdauer"
        add_tr "${F}" "stringTableHbwOutputVoltage"        "Ausgangsspannung"
        add_tr "${F}" "stringTableHbwPowerOnState"         "Einschaltzustand"
        add_tr "${F}" "stringTableHbwPwmRange"             "PWM-Bereich"
        add_tr "${F}" "stringTableHbwChangeOverDelay"      "Umschaltverzögerung"
        add_tr "${F}" "stringTableHbwMotorStartupDelay"    "Motor-Anlaufverzögerung"
        add_tr "${F}" "stringTableHbwRefRunTimeBottomTop"  "Referenzzeit unten-oben"
        add_tr "${F}" "stringTableHbwRefRunTimeTopBottom"  "Referenzzeit oben-unten"
        add_tr "${F}" "stringTableHbwRefRunCounter"        "Referenzfahrtz%E4hler"
        add_tr "${F}" "stringTableHbwLimitLower"           "Untere Begrenzung"
        add_tr "${F}" "stringTableHbwLimitUpper"           "Obere Begrenzung"
        add_tr "${F}" "stringTableHbwLocked"               "Gesperrt"
        add_tr "${F}" "stringTableHbwSwitchTime"           "Schaltzeit"
        add_tr "${F}" "stringTableHbwValveErrorPos"        "Ventilpos. bei Fehler"
        add_tr "${F}" "stringTableHbwUpdateInterval"       "Aktualisierungsintervall"
        add_tr "${F}" "stringTableHbwEnabled"              "Aktiviert"
        add_tr "${F}" "stringTableHbwSampleInterval"       "Messintervall"
        add_tr "${F}" "stringTableHbwSampleRate"           "Messrate"
        add_tr "${F}" "stringTableHbwRxTimeout"            "Empfangs-Timeout"
        add_tr "${F}" "stringTableHbwSensorId"             "Sensor ID"
        add_tr "${F}" "stringTableHbwStormThreshold"       "Sturmschwellwert"
        add_tr "${F}" "stringTableHbwStormTriggerCount"    "Sturmausl%F6seanzahl"
        add_tr "${F}" "stringTableHbwCycleTime"            "Zykluszeit"
        add_tr "${F}" "stringTableHbwDeltaTemp"            "Temperaturdifferenz"
        add_tr "${F}" "stringTableHbwErrorState"           "Fehlerzustand"
        add_tr "${F}" "stringTableHbwHysteresis"           "Hysterese"
        add_tr "${F}" "stringTableHbwHysteresisForDeltaT"  "Hysterese f. Temp.diff."
        add_tr "${F}" "stringTableHbwHysteresisForT1Max"   "Hysterese f. T1 Max"
        add_tr "${F}" "stringTableHbwHysteresisForT2Min"   "Hysterese f. T2 Min"
        add_tr "${F}" "stringTableHbwPulsOnCycle"          "Puls Ein-Zyklus"
        add_tr "${F}" "stringTableHbwT1Max"                "T1 Maximum"
        add_tr "${F}" "stringTableHbwT2Min"                "T2 Minimum"
        add_tr "${F}" "stringTableHbwErrorRetry"           "Fehlerwiederholung"
        add_tr "${F}" "stringTableHbwReceiveMaxInterval"   "Max. Empfangsintervall"
        add_tr "${F}" "stringTableHbwDefaultSetPoint"      "Standard-Sollwert"
        add_tr "${F}" "stringTableHbwDerivative"           "Differentialanteil (D)"
        add_tr "${F}" "stringTableHbwIntegral"             "Integralanteil (I)"
        add_tr "${F}" "stringTableHbwPowerOnMode"          "Einschaltmodus"
        add_tr "${F}" "stringTableHbwProportional"         "Proportionalanteil (P)"
        add_tr "${F}" "stringTableHbwAutoCycle"            "Automatischer Zyklus"
        add_tr "${F}" "stringTableHbwCharsPerLine"         "Zeichen pro Zeile"
        add_tr "${F}" "stringTableHbwDisplayLines"         "Anzahl Zeilen"
        add_tr "${F}" "stringTableHbwInvertDisplay"        "Display invertieren"
        add_tr "${F}" "stringTableHbwRefreshRate"          "Aktualisierungsrate"
        add_tr "${F}" "stringTableHbwDefaultText"          "Standardtext"
        add_tr "${F}" "stringTableHbwDisplayText"          "Anzeigetext"
        add_tr "${F}" "stringTableHbwDigits"               "Dezimalstellen"
        add_tr "${F}" "stringTableHbwFactor"               "Faktor"
        add_tr "${F}" "stringTableHbwAlarmMaxPower"        "Alarm Max. Leistung"
        add_tr "${F}" "stringTableHbwAlarmMaxVoltage"      "Alarm Max. Spannung"
        add_tr "${F}" "stringTableHbwAlarmMinVoltage"      "Alarm Min. Spannung"
        add_tr "${F}" "stringTableHbwKeyEventAlarm"        "Tasten-Ereignis Alarm"
    done

    # Englisch - extension.js UND stringtable.js
    for F in "${EXTENSION_EN}" "${STRINGTABLE_JS_EN}"; do
        add_tr "${F}" "stringTableHbwSendDeltaTemp"        "Send delta temperature"
        add_tr "${F}" "stringTableHbwSendDeltaValue"       "Send delta value"
        add_tr "${F}" "stringTableHbwSendDeltaCount"       "Send delta count"
        add_tr "${F}" "stringTableHbwSendMinInterval"      "Min. send interval"
        add_tr "${F}" "stringTableHbwSendMaxInterval"      "Max. send interval"
        add_tr "${F}" "stringTableHbwOffset"               "Offset"
        add_tr "${F}" "stringTableHbwOnewireType"          "1-Wire sensor type"
        add_tr "${F}" "stringTableHbwTemperature"          "Temperature"
        add_tr "${F}" "stringTableHbwEventDelaytime"       "Event delay time"
        add_tr "${F}" "stringTableHbwInputLocked"          "Input locked"
        add_tr "${F}" "stringTableHbwInverted"             "Inverted"
        add_tr "${F}" "stringTableHbwNotify"               "Notify"
        add_tr "${F}" "stringTableHbwTransmitTryMax"       "Max. transmit tries"
        add_tr "${F}" "stringTableHbwInputType"            "Input type"
        add_tr "${F}" "stringTableHbwLongPressTime"        "Long press time"
        add_tr "${F}" "stringTableHbwPullup"               "Pull-up resistor"
        add_tr "${F}" "stringTableHbwRepeatLongPress"      "Repeat long press"
        add_tr "${F}" "stringTableHbwSuppressNum"          "Suppress event count"
        add_tr "${F}" "stringTableHbwSuppressTime"         "Suppress time"
        add_tr "${F}" "stringTableHbwBuzzer"               "Buzzer"
        add_tr "${F}" "stringTableHbwLogging"              "Logging"
        add_tr "${F}" "stringTableHbwOutputBehaviour"      "Output behaviour"
        add_tr "${F}" "stringTableHbwOutputLocked"         "Output locked"
        add_tr "${F}" "stringTableHbwAutoBrightness"       "Auto brightness"
        add_tr "${F}" "stringTableHbwAutoOffDelay"         "Auto off delay"
        add_tr "${F}" "stringTableHbwDimMaxLevel"          "Max. dim level"
        add_tr "${F}" "stringTableHbwDimMinLevel"          "Min. dim level"
        add_tr "${F}" "stringTableHbwMaxOnTime"            "Max. on time"
        add_tr "${F}" "stringTableHbwMaxOutputRange"       "Max. output range"
        add_tr "${F}" "stringTableHbwMaxTemp"              "Max. temperature"
        add_tr "${F}" "stringTableHbwOnTime"               "On time"
        add_tr "${F}" "stringTableHbwOutputVoltage"        "Output voltage"
        add_tr "${F}" "stringTableHbwPowerOnState"         "Power on state"
        add_tr "${F}" "stringTableHbwPwmRange"             "PWM range"
        add_tr "${F}" "stringTableHbwChangeOverDelay"      "Change over delay"
        add_tr "${F}" "stringTableHbwMotorStartupDelay"    "Motor startup delay"
        add_tr "${F}" "stringTableHbwRefRunTimeBottomTop"  "Ref. run time bottom-top"
        add_tr "${F}" "stringTableHbwRefRunTimeTopBottom"  "Ref. run time top-bottom"
        add_tr "${F}" "stringTableHbwRefRunCounter"        "Reference run counter"
        add_tr "${F}" "stringTableHbwLimitLower"           "Lower limit"
        add_tr "${F}" "stringTableHbwLimitUpper"           "Upper limit"
        add_tr "${F}" "stringTableHbwLocked"               "Locked"
        add_tr "${F}" "stringTableHbwSwitchTime"           "Switch time"
        add_tr "${F}" "stringTableHbwValveErrorPos"        "Valve error position"
        add_tr "${F}" "stringTableHbwUpdateInterval"       "Update interval"
        add_tr "${F}" "stringTableHbwEnabled"              "Enabled"
        add_tr "${F}" "stringTableHbwSampleInterval"       "Sample interval"
        add_tr "${F}" "stringTableHbwSampleRate"           "Sample rate"
        add_tr "${F}" "stringTableHbwRxTimeout"            "RX timeout"
        add_tr "${F}" "stringTableHbwSensorId"             "Sensor ID"
        add_tr "${F}" "stringTableHbwStormThreshold"       "Storm threshold"
        add_tr "${F}" "stringTableHbwStormTriggerCount"    "Storm trigger count"
        add_tr "${F}" "stringTableHbwCycleTime"            "Cycle time"
        add_tr "${F}" "stringTableHbwDeltaTemp"            "Temperature delta"
        add_tr "${F}" "stringTableHbwErrorState"           "Error state"
        add_tr "${F}" "stringTableHbwHysteresis"           "Hysteresis"
        add_tr "${F}" "stringTableHbwHysteresisForDeltaT"  "Hysteresis for delta T"
        add_tr "${F}" "stringTableHbwHysteresisForT1Max"   "Hysteresis for T1 max"
        add_tr "${F}" "stringTableHbwHysteresisForT2Min"   "Hysteresis for T2 min"
        add_tr "${F}" "stringTableHbwPulsOnCycle"          "Pulse on cycle"
        add_tr "${F}" "stringTableHbwT1Max"                "T1 maximum"
        add_tr "${F}" "stringTableHbwT2Min"                "T2 minimum"
        add_tr "${F}" "stringTableHbwErrorRetry"           "Error retry"
        add_tr "${F}" "stringTableHbwReceiveMaxInterval"   "Max. receive interval"
        add_tr "${F}" "stringTableHbwDefaultSetPoint"      "Default setpoint"
        add_tr "${F}" "stringTableHbwDerivative"           "Derivative (D)"
        add_tr "${F}" "stringTableHbwIntegral"             "Integral (I)"
        add_tr "${F}" "stringTableHbwPowerOnMode"          "Power on mode"
        add_tr "${F}" "stringTableHbwProportional"         "Proportional (P)"
        add_tr "${F}" "stringTableHbwAutoCycle"            "Auto cycle"
        add_tr "${F}" "stringTableHbwCharsPerLine"         "Characters per line"
        add_tr "${F}" "stringTableHbwDisplayLines"         "Display lines"
        add_tr "${F}" "stringTableHbwInvertDisplay"        "Invert display"
        add_tr "${F}" "stringTableHbwRefreshRate"          "Refresh rate"
        add_tr "${F}" "stringTableHbwDefaultText"          "Default text"
        add_tr "${F}" "stringTableHbwDisplayText"          "Display text"
        add_tr "${F}" "stringTableHbwDigits"               "Digits"
        add_tr "${F}" "stringTableHbwFactor"               "Factor"
        add_tr "${F}" "stringTableHbwAlarmMaxPower"        "Alarm max. power"
        add_tr "${F}" "stringTableHbwAlarmMaxVoltage"      "Alarm max. voltage"
        add_tr "${F}" "stringTableHbwAlarmMinVoltage"      "Alarm min. voltage"
        add_tr "${F}" "stringTableHbwKeyEventAlarm"        "Key event alarm"
    done

    echo "=== inst_strings.sh: install done ==="
}

# -------------------------------------------------------
# UNINSTALL
# -------------------------------------------------------
do_uninstall() {
    echo "=== inst_strings.sh: uninstall ==="

    for KEY in \
        "TEMPSENSOR|SEND_DELTA_TEMP" "TEMPSENSOR|SEND_MIN_INTERVAL" \
        "TEMPSENSOR|SEND_MAX_INTERVAL" "TEMPSENSOR|SEND_MAX_INTERVALL" \
        "TEMPSENSOR|OFFSET" "TEMPSENSOR|ONEWIRE_TYPE" "TEMPSENSOR|TEMPERATURE" \
        "SENSOR|EVENT_DELAYTIME" "SENSOR|INPUT_LOCKED" "SENSOR|INVERTED" \
        "SENSOR|NOTIFY" "SENSOR|TRANSMIT_TRY_MAX" \
        "KEY|INPUT_TYPE" "KEY|INPUT_LOCKED" "KEY|INVERTED" "KEY|LONG_PRESS_TIME" \
        "KEY|PULLUP" "KEY|REPEAT_LONG_PRESS" "KEY|SUPPRESS_NUM" \
        "KEY|SUPPRESS_TIME" "KEY|BUZZER" \
        "SWITCH|INVERTED" "SWITCH|LOGGING" "SWITCH|OUTPUT_BEHAVIOUR" "SWITCH|OUTPUT_LOCKED" \
        "DIMMER|AUTO_BRIGHTNESS" "DIMMER|AUTO_OFF_DELAY" "DIMMER|DIM_MAX_LEVEL" \
        "DIMMER|DIM_MIN_LEVEL" "DIMMER|LOGGING" "DIMMER|MAX_ON_TIME" \
        "DIMMER|MAX_OUTPUT_RANGE" "DIMMER|MAX_TEMP" "DIMMER|ON_TIME" \
        "DIMMER|OUTPUT_VOLTAGE" "DIMMER|POWER_ON_STATE" "DIMMER|PWM_RANGE" \
        "BLIND|CHANGE_OVER_DELAY" "BLIND|LOGGING" "BLIND|MOTOR_STARTUP_DELAY" \
        "BLIND|REFERENCE_RUNNING_TIME_BOTTOM_TOP" "BLIND|REFERENCE_RUNNING_TIME_TOP_BOTTOM" \
        "BLIND|REFERENCE_RUN_COUNTER" \
        "VALVE|INVERTED" "VALVE|LIMIT_LOWER" "VALVE|LIMIT_UPPER" "VALVE|LOCKED" \
        "VALVE|LOGGING" "VALVE|SWITCH_TIME" "VALVE|VALVE_ERROR_POS" \
        "ANALOG_INPUT|SEND_DELTA_VALUE" "ANALOG_INPUT|SEND_MIN_INTERVAL" \
        "ANALOG_INPUT|SEND_MAX_INTERVAL" "ANALOG_INPUT|UPDATE_INTERVAL" \
        "ANALOGSENSOR|ENABLED" "ANALOGSENSOR|NOTIFY" "ANALOGSENSOR|SAMPLE_INTERVAL" \
        "COUNTER_INPUT|ENABLED" "COUNTER_INPUT|INVERTED" "COUNTER_INPUT|SEND_DELTA_COUNT" \
        "COUNTER_INPUT|SEND_MIN_INTERVAL" "COUNTER_INPUT|SEND_MAX_INTERVAL" \
        "WEATHER|RX_TIMEOUT" "WEATHER|SEND_DELTA_TEMP" "WEATHER|SEND_MIN_INTERVAL" \
        "WEATHER|SEND_MAX_INTERVAL" "WEATHER|SENSOR_ID" \
        "WEATHER|STORM_THRESHOLD_LEVEL" "WEATHER|STORM_TRIGGER_COUNT" \
        "DELTA_T|CYCLE_TIME" "DELTA_T|DELTA_TEMP" "DELTA_T|ERROR_STATE" \
        "DELTA_T|HYSTERESIS" "DELTA_T|HYSTERESIS_FOR_DELTAT" \
        "DELTA_T|HYSTERESIS_FOR_T1_MAX" "DELTA_T|HYSTERESIS_FOR_T2_MIN" \
        "DELTA_T|INVERTED" "DELTA_T|LOCKED" "DELTA_T|LOGGING" \
        "DELTA_T|PULS_ON_CYCLE" "DELTA_T|T1_MAX" "DELTA_T|T2_MIN" \
        "DELTA_T1|ERROR_RETRY" "DELTA_T1|RECEIVE_MAX_INTERVAL" \
        "DELTA_T2|ERROR_RETRY" "DELTA_T2|RECEIVE_MAX_INTERVAL" \
        "PID|CYCLE_TIME" "PID|DEFAULT_SET_POINT" "PID|DERIVATIVE" \
        "PID|INTEGRAL" "PID|POWERON_MODE" "PID|PROPORTIONAL" \
        "DISPLAY|AUTO_CYCLE" "DISPLAY|CHARACTERS_PER_LINE" "DISPLAY|DISPLAY_LINES" \
        "DISPLAY|INVERT_DISPLAY" "DISPLAY|POWER_ON_STATE" "DISPLAY|REFRESH_RATE" \
        "DISPLAY_LINE|AUTO_CYCLE" "DISPLAY_LINE|DEFAULT_TEXT" \
        "DISPLAY_V_SWITCH|DISPLAY_TEXT" "DISPLAY_V_TEMP|DIGITS" "DISPLAY_V_TEMP|FACTOR" \
        "BUS POWER|ALARM_MAX_POWER" "BUS POWER|ALARM_MAX_VOLTAGE" \
        "BUS POWER|ALARM_MIN_VOLTAGE" "BUS POWER|ENABLED" "BUS POWER|KEY_EVENT_ALARM" \
        "BUS POWER|SAMPLE_RATE" "BUS POWER|SEND_MIN_INTERVAL" "BUS POWER|SEND_MAX_INTERVAL" \
        "MODULE BUS VOLTAGE|SEND_DELTA_VALUE" "MODULE BUS VOLTAGE|SEND_MIN_INTERVAL" \
        "MODULE BUS VOLTAGE|SEND_MAX_INTERVAL" "MODULE BUS VOLTAGE|UPDATE_INTERVAL"
    do
        del_st "${KEY}"
    done

    for STKEY in \
        stringTableHbwSendDeltaTemp stringTableHbwSendDeltaValue stringTableHbwSendDeltaCount \
        stringTableHbwSendMinInterval stringTableHbwSendMaxInterval stringTableHbwOffset \
        stringTableHbwOnewireType stringTableHbwTemperature stringTableHbwEventDelaytime \
        stringTableHbwInputLocked stringTableHbwInverted stringTableHbwNotify \
        stringTableHbwTransmitTryMax stringTableHbwInputType stringTableHbwLongPressTime \
        stringTableHbwPullup stringTableHbwRepeatLongPress stringTableHbwSuppressNum \
        stringTableHbwSuppressTime stringTableHbwBuzzer stringTableHbwLogging \
        stringTableHbwOutputBehaviour stringTableHbwOutputLocked stringTableHbwAutoBrightness \
        stringTableHbwAutoOffDelay stringTableHbwDimMaxLevel stringTableHbwDimMinLevel \
        stringTableHbwMaxOnTime stringTableHbwMaxOutputRange stringTableHbwMaxTemp \
        stringTableHbwOnTime stringTableHbwOutputVoltage stringTableHbwPowerOnState \
        stringTableHbwPwmRange stringTableHbwChangeOverDelay stringTableHbwMotorStartupDelay \
        stringTableHbwRefRunTimeBottomTop stringTableHbwRefRunTimeTopBottom \
        stringTableHbwRefRunCounter stringTableHbwLimitLower stringTableHbwLimitUpper \
        stringTableHbwLocked stringTableHbwSwitchTime stringTableHbwValveErrorPos \
        stringTableHbwUpdateInterval stringTableHbwEnabled stringTableHbwSampleInterval \
        stringTableHbwSampleRate stringTableHbwRxTimeout stringTableHbwSensorId \
        stringTableHbwStormThreshold stringTableHbwStormTriggerCount stringTableHbwCycleTime \
        stringTableHbwDeltaTemp stringTableHbwErrorState stringTableHbwHysteresis \
        stringTableHbwHysteresisForDeltaT stringTableHbwHysteresisForT1Max \
        stringTableHbwHysteresisForT2Min stringTableHbwPulsOnCycle stringTableHbwT1Max \
        stringTableHbwT2Min stringTableHbwErrorRetry stringTableHbwReceiveMaxInterval \
        stringTableHbwDefaultSetPoint stringTableHbwDerivative stringTableHbwIntegral \
        stringTableHbwPowerOnMode stringTableHbwProportional stringTableHbwAutoCycle \
        stringTableHbwCharsPerLine stringTableHbwDisplayLines stringTableHbwInvertDisplay \
        stringTableHbwRefreshRate stringTableHbwDefaultText stringTableHbwDisplayText \
        stringTableHbwDigits stringTableHbwFactor stringTableHbwAlarmMaxPower \
        stringTableHbwAlarmMaxVoltage stringTableHbwAlarmMinVoltage stringTableHbwKeyEventAlarm
    do
        for F in "${EXTENSION_DE}" "${EXTENSION_EN}" "${STRINGTABLE_JS_DE}" "${STRINGTABLE_JS_EN}"; do
            del_tr "${F}" "${STKEY}"
        done
    done

    echo "=== inst_strings.sh: uninstall done ==="
}

case "$1" in
    ""|install)  do_install   ;;
    uninstall)   do_uninstall ;;
    *)
        echo "Usage: $(basename $0) {install|uninstall}"
        exit 1
        ;;
esac
