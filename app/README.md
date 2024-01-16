# The Marina Project

This project was inspired by day trip in Marina District, San Francisco. I've always associated the places I visit with the songs I listen to at the time. Conversely, some of the songs I listen to remind myself of some particular place. Therefore, I wanted my project to create memories through songs.

## Features

Marina Project requires the use of live location & internet connectivity for full functionality.
### Core Features
- [x] User's location is constantly updated through the Google Geocoding API in order to get the neighborhood of that the user is in. If that information is not available, there are a few fallbacks including the city, county, state, etc.
- [x] A "Get Song" button is used to fetch songs through a series of tasks, which then populates a popup that contains a stack of songs that fit the atmosphere of the user's neighborhood.
- [x] In the song pop up page, the user can view the title, artist, album & album art of the song. In addition, there is a preview button that plays a short 30s track that previews the song if available. They have the option to open this song on Spotify and add it to their library.
### QOL Features
- [x] The app bar located on top of the app displays the neighborhood the user is in.
- [x] The preview map tracks the user's location as they walk or drive. A recenter button is available to recenter the map.
- [x] The preview map has a beautiful retro styling.

## Tech Stack

This project is created through Dart & Flutter. Google Cloud's Maps API is used for visual presentation and address reverse geocoding. Spotify's recommendations API is used to obtain songs and previews. OpenAI's Text Generation is used to provide a seed value to Spotify.


## Setup
A .env file is necessary to hold the environment variables
```
openAPIKey = [key]
spotifyClientSecret = [secret]
```

`ios/Runner.xcodeproj` requires additional configuration to conform to Apple ID & Bundle Identifiers.

The app could be built by the following command after `flutter pub upgrade` is run.
```
flutter run --dart-define-from-file=.env
```