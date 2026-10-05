# Civicly — Smart City Services

**A responsive Flutter app for discovering and requesting everyday city services.**

Live demo: https://saimpu.github.io/Flutter-App/

## Project report

### Abstract

Civicly brings common municipal services into one mobile-friendly dashboard. Residents can browse city services, search by keyword, narrow results by category or status, review service information, save useful services, and prepare a demo service request. The interface adapts to phone, tablet, and desktop widths using Flutter's MediaQuery.

### Problem statement

City information is often split across departments and websites. This project demonstrates a single, clear starting point where residents can find common services and understand how to contact the relevant provider.

### Objectives

- Present a directory of city services in a clear, responsive grid.
- Make services easier to find through search and filters.
- Provide useful service details, status, contact guidance, and request forms.
- Offer a consistent experience across narrow and wide screens.
- Keep the project lightweight and easy to run using Flutter and its built-in Material widgets.

### Responsive design

The service grid reads the available width with MediaQuery.sizeOf(context) and changes its column count at these breakpoints:

| Available width | Service grid | Main navigation |
| --- | ---: | --- |
| Under 600 px | 2 columns | Bottom navigation |
| 600–1023 px | 3 columns | Bottom navigation below 900 px; navigation rail from 900 px |
| 1024 px and wider | 4 columns | Navigation rail |

The app also adjusts page padding, city controls, profile details, and service detail sheets for smaller screens.

### Features

- **Home dashboard:** city overview, sample weather and air-quality indicators, service count, city updates, and quick actions.
- **Service directory:** 12 sample services grouped by category, with availability/status information.
- **Search and filters:** search service names, categories, and descriptions; filter by category and status.
- **Service details:** descriptions, status, contact information, response guidance, save control, and a request form.
- **Explore, Saved, and Profile:** dedicated navigation destinations, saved services, recent in-session requests, help information, and appearance controls.
- **City and help actions:** sample city selection, notices, request shortcuts, and emergency contact guidance.
- **Light and dark themes:** switch the interface appearance from the app controls.

### Implementation and structure

The app is written in Dart with Flutter Material 3. It has no third-party package dependencies; pubspec.yaml uses only the Flutter SDK.

~~~text
lib/
  main.dart                       App entry point
  app/smart_city_app.dart         Root widget and light/dark themes
  data/city_services.dart         Sample service directory and city content
  models/
    city_service.dart             Service data model
    city_request.dart             Demo request model
  screens/
    app_shell.dart                Responsive navigation and app actions
    services_screen.dart          Search, filters, and responsive grid
    profile_screen.dart           Profile, help, and recent requests
  widgets/
    service_details_sheet.dart    Service information and request form
android/ ios/ linux/ macos/ web/ windows/
                                Flutter platform targets
.github/workflows/deploy.yml     GitHub Pages deployment workflow
~~~

### Run locally

Install the Flutter SDK, then run these commands from the project root:

~~~sh
flutter pub get
flutter run
~~~

To launch the web version in Chrome:

~~~sh
flutter run -d chrome
~~~

### Deployment

The GitHub Actions workflow at .github/workflows/deploy.yml builds the Flutter web app and publishes it to GitHub Pages. It runs on pushes to main and can also be started manually from the repository's Actions tab. GitHub Pages must use GitHub Actions as its publishing source. The build sets the /Flutter-App/ base path used by this repository.

### Scope and limitations

This is a front-end project prototype. Service records, weather, air quality, notices, and contact details are sample content. Saved items, theme selection, and submitted demo requests are held in app memory for the current session. The app does not connect to a municipal backend, authenticate residents, send requests to a city department, or persist changes after the app closes.

### Possible future work

- Connect service records, city updates, and request submission to a municipal API.
- Add resident sign-in and durable saved services and request history.
- Provide verified live status, location-aware services, and map directions.
- Add localization and configurable accessibility preferences.
