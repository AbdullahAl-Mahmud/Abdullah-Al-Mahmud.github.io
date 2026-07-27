# PUST Transit — Flutter Web MVP

**PUST Transit** is a polished Flutter Web demonstration for Pabna University of Science and Technology. It presents simulated live bus tracking, route visualization, ETA updates, schedules, driver details, announcements, emergency contacts, and a responsive Material 3 interface.

> Smart Campus Transportation, Connected in Real Time.

## Demo features

- Three independently moving demo buses
- OpenStreetMap map powered by `flutter_map`
- Simulated location updates every two seconds
- Route polylines and ten bus stops
- ETA, speed, seat availability, current stop, and next stop
- Bus details with route progress and driver information
- Morning, afternoon, and evening schedules
- Announcements and emergency contact screens
- Light and dark themes
- Responsive mobile, tablet, and desktop layouts
- Riverpod-based state management
- No login, Firebase project, API key, or paid map service required

## Technology

- Flutter and Dart
- Flutter Web
- Material 3
- Riverpod
- `flutter_map`
- OpenStreetMap
- `latlong2`

## Project structure

```text
lib/
├── main.dart
├── app.dart
├── models/
├── providers/
├── screens/
├── services/
├── theme/
├── utils/
└── widgets/
web/
test/
.github/workflows/
vercel.json
vercel_build.sh
```

## Requirements

The project is configured for Flutter 3.44.8, which is pinned in the included Vercel and GitHub Actions build scripts. A newer compatible stable release may also work.

Verify your setup:

```bash
flutter --version
flutter doctor
```

## Run locally

```bash
git clone YOUR_REPOSITORY_URL
cd pust_transit_demo
flutter pub get
flutter run -d chrome
```

## Analyze and test

```bash
flutter analyze
flutter test
```

## Build the web application

```bash
flutter build web --release
```

Flutter generates the deployable website in:

```text
build/web/
```

To preview the release build locally:

```bash
cd build/web
python -m http.server 8080
```

Then open `http://localhost:8080`.

## Deploy to Vercel

### Option A — Let Vercel install Flutter

This repository includes:

- `vercel.json`
- `vercel_build.sh`

The build script installs Flutter stable when Flutter is unavailable, then runs:

```bash
flutter pub get
flutter build web --release
```

Steps:

1. Upload the complete project to a GitHub repository.
2. Sign in to Vercel and choose **Add New → Project**.
3. Import the GitHub repository.
4. Select **Other** as the framework preset.
5. Keep the root directory at the repository root.
6. The included `vercel.json` supplies the build command and output directory.
7. Deploy.

The Vercel Hobby plan can host the static demo without a paid map API. Flutter SDK installation during each uncached deployment can be relatively heavy.

### Option B — Build first, deploy static files

On a computer with Flutter installed:

```bash
flutter pub get
flutter build web --release
```

Deploy the contents of `build/web` as a static site. For Vercel CLI:

```bash
npm install -g vercel
cd build/web
vercel
```

For client-side navigation, keep the rewrite rule from `vercel.json` at the deployed project root.

### Option C — GitHub Actions build

The workflow at `.github/workflows/flutter_web.yml` automatically:

1. Installs Flutter stable
2. Gets dependencies
3. Runs analysis
4. Runs tests
5. Builds the web application
6. Uploads `build/web` as a workflow artifact

Open the repository’s **Actions** tab and run **Flutter Web Build**. Download the `pust-transit-web` artifact after the workflow succeeds.

## Upload to GitHub

From the project folder:

```bash
git init
git add .
git commit -m "Create PUST Transit Flutter Web MVP"
git branch -M main
git remote add origin YOUR_GITHUB_REPOSITORY_URL
git push -u origin main
```

Do not upload only the files inside `lib`. Upload the complete project folder, including `pubspec.yaml`, `web`, `vercel.json`, and `.github`.

## OpenStreetMap attribution

The map uses OpenStreetMap tiles and displays the required attribution text in the map interface:

```text
© OpenStreetMap contributors
```

For a high-traffic production service, use a compliant tile provider or host tiles according to OpenStreetMap’s tile usage policy rather than relying on the public tile server at scale.

## Demo-data notice

All bus positions, drivers, routes, schedules, seat counts, phone numbers, weather information, and student data are demonstration values. Tracking is simulated locally and does not use real GPS.

## MVP limitations

- No student authentication
- No Firebase connection
- No driver application
- No real GPS or background tracking
- No push notifications
- No transport-office admin dashboard
- Emergency phone numbers are placeholders except Bangladesh’s national 999 service
- Approximate map coordinates should be verified before production use

## Recommended production improvements

- Firebase Authentication and role-based access
- Firestore or Realtime Database
- Driver GPS publishing with permission controls
- Push notifications through Firebase Cloud Messaging
- Admin dashboard for routes, schedules, alerts, and vehicle status
- Verified PUST routes and stop coordinates
- Privacy policy, security rules, monitoring, and audit logs
- Production tile provider and caching strategy

## License

This project is provided as a university transportation demonstration. Replace demo data and complete security, privacy, and operational review before production deployment.
