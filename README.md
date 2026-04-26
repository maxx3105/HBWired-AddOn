# HBWired-AddOn

[![Build Addon](https://github.com/maxx3105/HBWired-AddOn/actions/workflows/build.yml/badge.svg)](https://github.com/maxx3105/HBWired-AddOn/actions/workflows/build.yml)
[![Releases](https://img.shields.io/github/v/release/maxx3105/HBWired-AddOn)](https://github.com/maxx3105/HBWired-AddOn/releases/latest)

Homematic/OpenCCU AddOn für HBWired-Geräte (HomeBrew Wired, basierend auf der [HBWired-Library](https://github.com/thorsten-pferdekaemper/HBWired) von Thorsten Pferdekaemper).

---

## Unterstützte Geräte

| Gerät | Modell-ID | Quelle | Beschreibung |
|---|---|---|---|
| HBW-1W-T10 | 0x81 | Fhem.de | 1-Wire 10-Kanal Temperatursensor |
| HBW-LC-BL-4 | 0x82 | Fhem.de | 4-Kanal Jalousieaktor |
| HBW-LC-SW-8 | 0x83 | Fhem.de | 8-Kanal Schaltaktor |
| HBW-SEN-EP | 0x84 | Fhem.de | Energiemessmodul |
| HBW-WDS-C7 | 0x88 | Fhem.de | Wettersensor C7 |
| HBW-SYS-PM | 0x8D | Fhem.de | System Power Monitor |
| HBW-LC-BL-8 | 0x92 | Fhem.de | 8-Kanal Jalousieaktor |
| HBW-LC-SW-12 | 0x93 | Fhem.de | 12-Kanal Schaltaktor |
| HBW-SEN-KEY-12 | 0x95 | Fhem.de | 12-Kanal Tasterschnittstelle |
| HBW-SC-10-DIM-6 | 0x96 | Fhem.de | 10-Kanal Schalter + 6-Kanal Dimmer |
| HBW-CC-VD | 0x97 | Fhem.de | Ventilstellantrieb |
| HBW-SEN-DB-4 | 0x98 | Fhem.de | 4-Kanal Türklingelsensor |
| HBW-CC-WW-SPKTS | 0x99 | Fhem.de | Warmwassersteuerung |
| HBW-CC-DT3-T6 | 0x9C | Fhem.de | Klimasteuerung |
| HBW-SEN-SC-12-DR | 0xA6 | Fhem.de | 12-Kanal Schließerkontakt |
| HBW-DIS-KEY-4 | 0x71 | Fhem.de | Display mit 4 Tasten |
| HBW-LC-SW8-DR | 0x70 | Fhem.de | 8-Kanal Schaltaktor DIN-Rail |
| HBW-LC-DIM4-DR | 0x71 | Fhem.de | 4-Kanal Dimmaktor DIN-Rail |
| HBW-IO-12 | 0x72 | Fhem.de | 12-Kanal I/O Modul |
| HBW-SENS-SC8 | 0x73 | Fhem.de | 8-Kanal Schließerkontakt |

---

## Kompatibilität

✅ OpenCCU / RaspberryMatic / CCU3 ab Firmware **3.47.x**

---

## Endbenutzer-Anleitung

### Installation

1. Aktuelles Release-tgz von der [Releases-Seite](https://github.com/maxx3105/HBWired-AddOn/releases/latest) herunterladen
2. CCU WebUI öffnen → **Einstellungen** → **Systemsteuerung** → **Zusatzsoftware**
3. Heruntergeladenes `hbwired-ccu-addon_x.x.x.tgz` hochladen
4. Die CCU startet automatisch neu — danach ist das Addon aktiv

> ⚠️ Bei einer bestehenden Installation zuerst das alte Addon **deinstallieren**, dann das neue installieren.

### Gerät anlernen

Da es sich um HBWired (RS485-Bus) handelt, werden die Geräte nicht per Funk angelernt, sondern über den RS485-Bus der CCU erkannt. Nach der Installation des Addons und einem Neustart sollten die Geräte automatisch erkannt werden:

### Deinstallation

CCU WebUI → **Einstellungen** → **Systemsteuerung** → **Zusatzsoftware** → **HBWired Community** → **Deinstallieren**

---

## Entwickler-Anleitung

### Repository-Struktur

```
HBWired-AddOn/
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions: automatischer Build & Release
├── src/
│   ├── addon/                 # XML-Gerätebeschreibungen, Bilder, Installskript
│   │   ├── *.xml              # CCU-Gerätebeschreibungen (hs485types)
│   │   ├── *.png              # Gerätebilder
│   │   ├── installHBWired     # Installationsscript (fwmap, DEVDB.tcl, XMLs)
│   │   └── VERSION            # Aktuelle Versionsnummer
│   ├── ccu1/                  # CCU1-spezifische Dateien
│   ├── ccu2/                  # CCU2-spezifische Dateien
│   ├── ccu3/                  # CCU3-spezifische Dateien
│   ├── ccurm/                 # RaspberryMatic-spezifische Dateien
│   ├── www/                   # WebUI-Seite des Addons
│   ├── rc.d/
│   │   └── hbwired            # Start/Stop/Uninstall-Script
│   └── update_script          # Wird beim CCU-Update ausgeführt
├── .gitignore
└── README.md
```

### Neues Release erstellen

1. Versionsnummer in `src/addon/VERSION` erhöhen
2. Änderungen committen und pushen
3. Git-Tag mit der Versionsnummer setzen:
   ```sh
   git tag 1.0.3
   git push origin 1.0.3
   ```
4. GitHub Actions baut automatisch das `.tgz` und erstellt ein Release

### Neues Gerät hinzufügen

1. XML-Gerätebeschreibung nach `src/addon/` kopieren (Namensschema: `hbw_geraetename.xml`)
2. Gerätebild (250x250px) nach `src/addon/` als `HBW-GERAET.png` und `HBW-GERAET_thumb.png` (50x50px)
3. In `src/addon/installHBWired` eintragen:
   - `fwmap`-Eintrag: `HXxV0  dummy.hex  @0x0000  #HBW-GERAET-NAME`
   - `add_dev`-Aufruf: `add_dev "HBW-GERAET-NAME" "Beschreibung"`
4. Tabelle in dieser README ergänzen
5. Versionsnummer erhöhen und Release erstellen (siehe oben)

---

## Change Log

### 1.0.2
- Unterstützung für weitere Geräte aus der FHEM-Community
- Verbessertes Installations- und Deinstallationsscript

### 1.0.0 — 17.04.2024
- Initiales Release
- Orientierte sich an Jérômes [JP-HB-Devices-addon](https://github.com/jp112sdl/JP-HB-Devices-addon)
- Unterstützung für HBW-1W-T10

---

## Lizenz

Dieses Werk ist lizenziert unter einer [Creative Commons Namensnennung - Nicht-kommerziell - Weitergabe unter gleichen Bedingungen 4.0 International Lizenz](https://creativecommons.org/licenses/by-nc-sa/4.0/).
