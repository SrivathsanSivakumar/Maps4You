## Maps4You

![iTunes App Store](https://img.shields.io/itunes/v/1632049180?label=App%20Store)

## Table of Contents

<!-- no toc -->
- [About](#about)
- [Usage](#usage)
- [File Description and Dependencies](#file-description-and-dependencies)

## About

Maps4You is a simple Google Maps to Waze/Apple Maps link converter developed in response to users to who prefer to use Waze, but recieve location links in more commonly used apps. 

Since August 2022, It has been published on the app store.

The app is developed fully with Flutter(Dart), with the help of some [external libraries](#file-description-and-dependencies), and uses Google's Geocoding API.

![Share from Google Maps](https://i.imgur.com/XXIF7sf.gif)

## Usage

There are two ways to use the app:

1. **Share a link from Google Maps directly**: This is demonstrated in the [gif](#about) above. For any location, hit the share button and select Maps4You, and you will get a pop-up box asking where you'd like to open that location. 

2. **Share a link manually**: Utilize the text bar under _Manual Activity_ in the app to paste in a Google Maps link. This will also provide you with the same pop-up box asking where you would like to open that location. 

## File Description and Dependencies
- Most of the code is written in Dart, and Swift is used to enable sharing a location from Google Maps directly to the app.

| File Name | Description                                 |
|-----------|---------------------------------------------|
| main.dart | Initializes app and calls main_screen.dart |
| main_screen.dart | Creates home screen and displays pop-up to open in Waze/Apple Maps once a link has been shared. <br /> <br /> External Libraries: <br /> 1. external_app_launcher <br /> 2. bulleted_list <br /> 3. mailto <br /> 4. receive_sharing_intent <br /> 5. url_launcher_string <br /> 6. conv_link.dart
|conv_link.dart | Makes an API call to get the geocode from the shared link and generates a Waze/Apple Maps link with the geocode and returns it to main_screen.dart <br /> <br/> Dependencies: <br /> 1. Geocoding API  <br /> 2. google_geocoding
