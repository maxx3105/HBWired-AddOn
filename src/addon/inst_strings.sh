#!/bin/sh
# ============================================================
# inst_strings.sh - HBWired AddOn Stringtable Integration
#
# stringtable_de.txt            -> Mapping ParameterID -> stringTable-Key
# translate.lang.stringtable.js -> stringTable-Key -> lesbarer Text
# ============================================================

STRINGTABLE=/www/config/stringtable_de.txt
STRINGTABLE_JS_DE=/www/webui/js/lang/de/translate.lang.stringtable.js
STRINGTABLE_JS_EN=/www/webui/js/lang/en/translate.lang.stringtable.js

# -------------------------------------------------------
# Fuegt Zeile in stringtable_de.txt ein (falls nicht vorhanden)
# -------------------------------------------------------
add_st() {
    local KEY="$1"
    local VALKEY="$2"
    if [ -z "$(grep "$KEY" $STRINGTABLE)" ]; then
        echo -e "${KEY}\t\${${VALKEY}}" >> $STRINGTABLE
        echo "  stringtable: +${KEY}"
    fi
}

del_st() {
    local KEY="$1"
    sed -i "/^${KEY}	/d" $STRINGTABLE
}

# -------------------------------------------------------
# Fuegt Eintrag in translate.lang.stringtable.js ein
# Anker: "dummy" : "",
# -------------------------------------------------------
add_tr() {
    local FILE="$1"
    local KEY="$2"
    local VAL="$3"
    if [ ! -f "$FILE" ]; then return 0; fi
    if [ -z "$(grep "\"${KEY}\"" $FILE)" ]; then
        sed -i "s/\"dummy\" : \"\",/\"dummy\" : \"\",\n    \"${KEY}\" : \"${VAL}\",/" $FILE
        echo "  translation: +${KEY} in $(basename $FILE)"
    fi
}

del_tr() {
    local FILE="$1"
    local KEY="$2"
    sed -i "/\"${KEY}\"/d" $FILE
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

    # Deutsch
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSendDeltaTemp"        "Sendedifferenz Temperatur"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSendDeltaValue"       "Sendedifferenz Wert"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSendDeltaCount"       "Sendedifferenz Z%E4hler"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSendMinInterval"      "Minimales Sendeintervall"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSendMaxInterval"      "Maximales Sendeintervall"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwOffset"               "Offset"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwOnewireType"          "1-Wire Sensor Typ"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwTemperature"          "Temperatur"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwEventDelaytime"       "Ereignis Verz%F6gerungszeit"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwInputLocked"          "Eingang gesperrt"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwInverted"             "Invertiert"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwNotify"               "Benachrichtigung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwTransmitTryMax"       "Max. Sendeversuche"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwInputType"            "Eingangstyp"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwLongPressTime"        "Langdruckzeit"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwPullup"               "Pull-Up Widerstand"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwRepeatLongPress"      "Langdruck wiederholen"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSuppressNum"          "Anzahl unterd. Ereignisse"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSuppressTime"         "Unterd%FCckungszeit"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwBuzzer"               "Summer"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwLogging"              "Logging"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwOutputBehaviour"      "Ausgangsverhalten"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwOutputLocked"         "Ausgang gesperrt"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwAutoBrightness"       "Automatische Helligkeit"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwAutoOffDelay"         "Autom. Ausschaltverzög."
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDimMaxLevel"          "Max. Dimmpegel"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDimMinLevel"          "Min. Dimmpegel"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwMaxOnTime"            "Max. Einschaltdauer"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwMaxOutputRange"       "Max. Ausgangsbereich"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwMaxTemp"              "Maximaltemperatur"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwOnTime"               "Einschaltdauer"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwOutputVoltage"        "Ausgangsspannung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwPowerOnState"         "Einschaltzustand"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwPwmRange"             "PWM-Bereich"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwChangeOverDelay"      "Umschaltverzögerung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwMotorStartupDelay"    "Motor-Anlaufverzögerung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwRefRunTimeBottomTop"  "Referenzzeit unten-oben"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwRefRunTimeTopBottom"  "Referenzzeit oben-unten"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwRefRunCounter"        "Referenzfahrtz%E4hler"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwLimitLower"           "Untere Begrenzung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwLimitUpper"           "Obere Begrenzung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwLocked"               "Gesperrt"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSwitchTime"           "Schaltzeit"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwValveErrorPos"        "Ventilpos. bei Fehler"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwUpdateInterval"       "Aktualisierungsintervall"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwEnabled"              "Aktiviert"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSampleInterval"       "Messintervall"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSampleRate"           "Messrate"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwRxTimeout"            "Empfangs-Timeout"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwSensorId"             "Sensor ID"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwStormThreshold"       "Sturmschwellwert"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwStormTriggerCount"    "Sturmausl%F6seanzahl"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwCycleTime"            "Zykluszeit"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDeltaTemp"            "Temperaturdifferenz"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwErrorState"           "Fehlerzustand"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwHysteresis"           "Hysterese"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwHysteresisForDeltaT"  "Hysterese f. Temp.diff."
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwHysteresisForT1Max"   "Hysterese f. T1 Max"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwHysteresisForT2Min"   "Hysterese f. T2 Min"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwPulsOnCycle"          "Puls Ein-Zyklus"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwT1Max"                "T1 Maximum"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwT2Min"                "T2 Minimum"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwErrorRetry"           "Fehlerwiederholung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwReceiveMaxInterval"   "Max. Empfangsintervall"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDefaultSetPoint"      "Standard-Sollwert"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDerivative"           "Differentialanteil (D)"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwIntegral"             "Integralanteil (I)"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwPowerOnMode"          "Einschaltmodus"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwProportional"         "Proportionalanteil (P)"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwAutoCycle"            "Automatischer Zyklus"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwCharsPerLine"         "Zeichen pro Zeile"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDisplayLines"         "Anzahl Zeilen"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwInvertDisplay"        "Display invertieren"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwRefreshRate"          "Aktualisierungsrate"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDefaultText"          "Standardtext"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDisplayText"          "Anzeigetext"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwDigits"               "Dezimalstellen"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwFactor"               "Faktor"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwAlarmMaxPower"        "Alarm Max. Leistung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwAlarmMaxVoltage"      "Alarm Max. Spannung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwAlarmMinVoltage"      "Alarm Min. Spannung"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwKeyEventAlarm"        "Tasten-Ereignis Alarm"
    add_tr "$STRINGTABLE_JS_DE" "stringTableHbwOwnAddress"           "Ger%E4teadresse"

    # Englisch
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSendDeltaTemp"        "Send delta temperature"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSendDeltaValue"       "Send delta value"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSendDeltaCount"       "Send delta count"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSendMinInterval"      "Min. send interval"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSendMaxInterval"      "Max. send interval"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwOffset"               "Offset"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwOnewireType"          "1-Wire sensor type"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwTemperature"          "Temperature"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwEventDelaytime"       "Event delay time"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwInputLocked"          "Input locked"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwInverted"             "Inverted"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwNotify"               "Notify"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwTransmitTryMax"       "Max. transmit tries"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwInputType"            "Input type"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwLongPressTime"        "Long press time"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwPullup"               "Pull-up resistor"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwRepeatLongPress"      "Repeat long press"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSuppressNum"          "Suppress event count"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSuppressTime"         "Suppress time"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwBuzzer"               "Buzzer"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwLogging"              "Logging"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwOutputBehaviour"      "Output behaviour"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwOutputLocked"         "Output locked"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwAutoBrightness"       "Auto brightness"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwAutoOffDelay"         "Auto off delay"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDimMaxLevel"          "Max. dim level"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDimMinLevel"          "Min. dim level"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwMaxOnTime"            "Max. on time"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwMaxOutputRange"       "Max. output range"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwMaxTemp"              "Max. temperature"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwOnTime"               "On time"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwOutputVoltage"        "Output voltage"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwPowerOnState"         "Power on state"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwPwmRange"             "PWM range"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwChangeOverDelay"      "Change over delay"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwMotorStartupDelay"    "Motor startup delay"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwRefRunTimeBottomTop"  "Ref. run time bottom-top"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwRefRunTimeTopBottom"  "Ref. run time top-bottom"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwRefRunCounter"        "Reference run counter"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwLimitLower"           "Lower limit"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwLimitUpper"           "Upper limit"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwLocked"               "Locked"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSwitchTime"           "Switch time"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwValveErrorPos"        "Valve error position"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwUpdateInterval"       "Update interval"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwEnabled"              "Enabled"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSampleInterval"       "Sample interval"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSampleRate"           "Sample rate"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwRxTimeout"            "RX timeout"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwSensorId"             "Sensor ID"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwStormThreshold"       "Storm threshold"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwStormTriggerCount"    "Storm trigger count"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwCycleTime"            "Cycle time"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDeltaTemp"            "Temperature delta"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwErrorState"           "Error state"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwHysteresis"           "Hysteresis"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwHysteresisForDeltaT"  "Hysteresis for delta T"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwHysteresisForT1Max"   "Hysteresis for T1 max"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwHysteresisForT2Min"   "Hysteresis for T2 min"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwPulsOnCycle"          "Pulse on cycle"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwT1Max"                "T1 maximum"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwT2Min"                "T2 minimum"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwErrorRetry"           "Error retry"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwReceiveMaxInterval"   "Max. receive interval"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDefaultSetPoint"      "Default setpoint"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDerivative"           "Derivative (D)"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwIntegral"             "Integral (I)"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwPowerOnMode"          "Power on mode"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwProportional"         "Proportional (P)"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwAutoCycle"            "Auto cycle"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwCharsPerLine"         "Characters per line"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDisplayLines"         "Display lines"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwInvertDisplay"        "Invert display"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwRefreshRate"          "Refresh rate"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDefaultText"          "Default text"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDisplayText"          "Display text"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwDigits"               "Digits"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwFactor"               "Factor"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwAlarmMaxPower"        "Alarm max. power"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwAlarmMaxVoltage"      "Alarm max. voltage"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwAlarmMinVoltage"      "Alarm min. voltage"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwKeyEventAlarm"        "Key event alarm"
    add_tr "$STRINGTABLE_JS_EN" "stringTableHbwOwnAddress"           "Device address"

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
        stringTableHbwAlarmMaxVoltage stringTableHbwAlarmMinVoltage stringTableHbwKeyEventAlarm \
        stringTableHbwOwnAddress
    do
        del_tr "$STRINGTABLE_JS_DE" "${STKEY}"
        del_tr "$STRINGTABLE_JS_EN" "${STKEY}"
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
