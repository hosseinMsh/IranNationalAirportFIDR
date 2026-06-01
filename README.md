<p align="center">
  <img src="assets/images/logo.png" width="120" height="120" alt="FIDS Iran Logo"/>
</p>

<h1 align="center">✈️ Iran FIDS</h1>
<p align="center">
  <strong>Flight Information Display System for Iranian Airports</strong>
  <br>
  A Flutter app that fetches real-time flight data (arrivals & departures) from <a href="https://fids.airport.ir">fids.airport.ir</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Web-blue" alt="Platform"/>
  <img src="https://img.shields.io/badge/Flutter-3.11+-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License"/>
</p>

---

## ✨ Features

- 📋 **Real-time flight info** — Arrivals & departures for 30+ Iranian airports
- 🔍 **Smart search** — Filter by airline, flight number, or origin
- 🏷️ **Status filters** — Landed, Delayed, Cancelled, On Schedule, Check-in, In Progress, Departed
- 🌍 **Multi-language** — فارسی · العربية · English (with RTL support)
- 🗺️ **Navigation** — OpenStreetMap with airport markers
- 🧭 **Get directions** — Balad · Neshan · Google Maps · Apple Maps · Waze
- 🔄 **Pull-to-refresh** — Swipe down to reload live data
- 🌙 **Material 3** — Modern UI with smooth animations

## 📸 Screenshots

| Splash | Airports | Flights | Map |
|--------|----------|---------|-----|
| <img src="assets/images/welcome.png" width="200"/> | Airport list with cards | Arrivals/Departures tabs | OpenStreetMap with nav buttons |

## 🛠️ Tech Stack

| Package | Usage |
|---------|-------|
| [`flutter`](https://flutter.dev) | UI framework (Material 3) |
| [`http`](https://pub.dev/packages/http) | HTTP client for web scraping |
| [`html`](https://pub.dev/packages/html) | HTML parser for flight tables |
| [`flutter_map`](https://pub.dev/packages/flutter_map) | OpenStreetMap integration |
| [`latlong2`](https://pub.dev/packages/latlong2) | Latitude/Longitude data types |
| [`url_launcher`](https://pub.dev/packages/url_launcher) | Open navigation apps |
| [`provider`](https://pub.dev/packages/provider) *(built-in)* | ChangeNotifier for i18n |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.11+
- Dart 3.11+
- Android Studio / Xcode (for platform builds)

### Installation

```bash
# Clone the repo
git clone https://github.com/yourusername/airport_fiids.git
cd airport_fiids

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build for platforms

```bash
# Android
flutter build apk

# iOS
flutter build ios

# macOS
flutter build macos

# Web
flutter build web
```

## 🌐 Supported Airports

<details>
<summary>Click to expand — 33 airports</summary>

| # | Airport | IATA | Coordinates |
|---|---------|------|-------------|
| 1 | **Mehrabad** (مهرآباد) | THR | 35.6892, 51.3134 |
| 2 | **Mashhad** (مشهد) | MHD | 36.2352, 59.6439 |
| 3 | **Shiraz** (شیراز) | SYZ | 29.5392, 52.5898 |
| 4 | **Tabriz** (تبریز) | TBZ | 38.1339, 46.2350 |
| 5 | **Isfahan** (اصفهان) | IFN | 32.7508, 51.8613 |
| 6 | **Ahvaz** (اهواز) | AWZ | 31.3374, 48.7626 |
| 7 | **Bushehr** (بوشهر) | BUZ | 28.9448, 50.8346 |
| 8 | **Kerman** (کرمان) | KER | 30.2744, 56.9517 |
| 9 | **Bandar Abbas** (بندرعباس) | BND | 27.2183, 56.3778 |
| 10 | **Sari** (ساری) | SRY | 36.6283, 53.1936 |
| … | *and 23 more* | | |

</details>

## 🌍 Internationalization

The app supports 3 languages with automatic RTL detection:

| Language | Code | Direction |
|----------|------|-----------|
| فارسی | `fa` | RTL |
| العربية | `ar` | RTL |
| English | `en` | LTR |

Switch languages anytime from the app bar menu.

## 🗺️ Navigation Apps

Tap the map icon on any airport card to open the map screen with **5 navigation options**:

| App | Icon | Country |
|-----|------|---------|
| <img src="https://balad.ir/favicon.ico" width="16"/> Balad | 🗺️ | Iran |
| <img src="https://neshan.org/favicon.ico" width="16"/> Neshan | 🧭 | Iran |
| <img src="https://google.com/favicon.ico" width="16"/> Google Maps | 🗺️ | Global |
| <img src="https://apple.com/favicon.ico" width="16"/> Apple Maps | 🧭 | Global |
| <img src="https://waze.com/favicon.ico" width="16"/> Waze | 🚗 | Global |

## 🧱 Project Structure

```
lib/
├── main.dart                 # App entry point + theme
├── models/
│   ├── airport.dart          # Airport data model
│   └── flight.dart           # Flight data model
├── screens/
│   ├── splash_screen.dart    # Animated splash screen
│   ├── airport_list_screen.dart  # Airport list with search
│   ├── flights_screen.dart   # Arrivals/Departures tabs
│   └── airport_map_screen.dart   # Map + navigation
├── services/
│   ├── app_constants.dart    # Theme & config constants
│   ├── extensions.dart       # String utilities
│   ├── fids_service.dart     # Web scraping service
│   ├── flight_cache.dart     # In-memory cache
│   ├── screen_transitions.dart  # Route animations
│   └── translations.dart     # i18n service
└── widgets/
    ├── empty_state.dart      # Empty list placeholder
    ├── error_view.dart       # Error display widget
    ├── flight_card.dart      # Flight info card
    └── loading_indicator.dart # Loading spinner
```

## 📄 License

This project is licensed under the MIT License.

---

<p align="center">
  Made with ❤️ and Flutter
  <br>
  <sub>Data sourced from <a href="https://fids.airport.ir">fids.airport.ir</a></sub>
</p>
