<h1 align="center">Anikki</h1>

<p align="center">
  <img src="assets/anikki_desktop.png" height="300" />
  <img src="assets/anikki_mobile.png" height="300" />
</p>


> Anikki is currently being developped as a hobby of mine and many things are subject to change.

## Features

* Stream (almost) any anime using torrent or hosted videos
* Automatic anime watch list tracking with AniList or MyAnimeList.
* Manage local anime files with Anilist/TMDB information
* Check what animes you set to watch whenever they are out
* Browse your watch list and watch anything from there
* Download or play (almost) any anime on the fly
* Embedded player (with [media_kit](https://github.com/alexmercerind/media_kit))
* Search for any torrent on [nyaa.si](https://nyaa.si)
* Search for any anime, staff or character information
* Remote torrent client connection for [Transmission](https://transmissionbt.com) and [QBitTorrent](https://www.qbittorrent.org)
  * QBitTorrent is recommended for a smoother streaming experience.
* More to come?

## Building

1. Install [Flutter](https://flutter.dev) for you platform
2. Clone this repo

```bash
git clone --recursive https://github.com/Kylart/Anikki

cd Anikki
cp .env.example .env

flutter build <platform>
```

## Develop

```bash
flutter run
```

###  To re-generate Anilist schema and classes
You will need [nodejs](https://nodejs.org) installed.

```bash
# Generate Anilist types
cd scripts
npm install && npm run gen:schema

cd ..
dart run build_runner build

# (Optional) If you want to work on the Anilist types
dart run build_runner watch
```

### Run tests

#### Unit tests
```bash
flutter test
```

#### Integration tests
> Very limited for now
```bash
flutter test integration_test
```

### Architecture
This project is implementing the architecture described by the [BloC library](https://bloclibrary.dev/#/architecture) for now.

## Contributing
Any contribution is appreciated.

### What to do
You can see what are the next things on the roadmap [on this Trello board](https://trello.com/b/HPDfWARB/anikki).

Feel free to contact me on Discord if you need any details on the implementation!

### How to
1. Fork it!
2. Create your feature branch: git checkout -b my-new-feature
3. Commit your changes: git commit -am 'Add some feature'
4. Push to the branch: git push origin my-new-feature
5. Submit a pull request.

## License
MIT License

Copyright © 2022 & onwards, Kylart <kylart.dev@gmail.com>

## Credits
[App icon by Freepik](https://www.freepik.com/free-vector/hand-drawn-kitsune-logo-template_27596778.htm#query=anime%20logo%20collection&position=8&from_view=search&track=ais)

# Disclaimer
Anikki is designed solely for providing access to publicly available content. It is not intended to support or promote piracy or copyright infringement. As the creator of this app, I hereby declare that I am not responsible for, and in no way associated with, any external links or the content they direct to.

It is essential to understand that all the content available through this app are found freely accessible on the internet and the app does not host any copyrighted content. I do not exercise control over the nature, content, or availability of the websites linked within the app.

If you have any concerns or objections regarding the content provided by this app, please contact the respective website owners, webmasters, or hosting providers. Thank you.
