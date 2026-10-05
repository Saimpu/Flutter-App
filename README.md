# Civicly — Smart City Services

A responsive Flutter app prototype for finding and requesting everyday city services. It uses Flutter Material widgets only and has no third-party package dependencies.

## Features

- Responsive service grid: 2 columns below 600 px, 3 columns from 600–1023 px, and 4 columns at 1024 px and wider.
- Home, Explore, Saved, and Profile sections with bottom navigation on smaller screens and a navigation rail on wide screens.
- Search across service names, categories, and descriptions; filter by category and service status.
- Service detail sheets with status, contact information, response-time guidance, save controls, and a request form.
- In-session saved services and a local request list.
- City selector, sample city notices, quick help contacts, and light/dark appearance settings.

## Project layout

```text
lib/
  app/                 App theme and root widget
  data/                Sample city service directory
  models/              Service data model
  screens/             Navigation shell and app pages
  widgets/             Reusable service detail UI
android/ ios/ linux/ macos/ web/ windows/   Flutter platform targets
test/                  Reserved for app tests
```

The platform folders are placeholders in this workspace because the Flutter SDK is not installed here. With Flutter installed, open a terminal in this folder and generate the standard native/web runners with:

```sh
flutter create --platforms=android,ios,linux,macos,web,windows .
```

Then run the app:

```sh
flutter pub get
flutter run
```

## Demo data

Weather, air quality, city notices, contact guidance, and service statuses are sample content. Requests and saved services stay in memory for the current app session; no city system or backend is connected.
