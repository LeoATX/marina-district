import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key, required this.tracks, required this.players});

  // track info in json format used to build view
  final List tracks;

  // preview players
  final List players;

  @override
  State<StatefulWidget> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  ValueNotifier<int> songViewIndex = ValueNotifier(0);
  List trackAlbums = [];
  List trackImages = [];
  List trackArtists = [];
  List trackNames = [];
  List trackURLs = [];

  @override
  void initState() {
    super.initState();
    for (final track in widget.tracks) {
      trackAlbums.add(track['album']['name']);
      trackImages.add(track['album']['images'][0]['url']);

      // parse artist names
      late String artistName;
      for (var index = 0; index < track['artists'].length; index++) {
        if (index == 0) {
          artistName = track['artists'][index]['name'];
        } else {
          artistName = "$artistName, ${track['artists'][index]['name']}";
        }
      }
      trackArtists.add(artistName);
      trackNames.add(track['name']);
      trackURLs.add(track['external_urls']['spotify']);
      if (track['preview_url'] != null) {
        trackURLs.add(track['preview_url']);
      } else {
        trackURLs.add(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double chevronRatio = 0.05;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * chevronRatio,
          child: CupertinoButton(
              padding: const EdgeInsets.all(0),
              minSize: 0,
              borderRadius: BorderRadius.zero,
              onPressed: () {
                setState(() {
                  if (songViewIndex == 0) {
                    songViewIndex.value = widget.tracks.length - 1;
                  } else {
                    songViewIndex.value -= 1;
                  }
                });
              },
              child: Icon(
                CupertinoIcons.left_chevron,
                color: CupertinoTheme.of(context).barBackgroundColor,
              )),
        ),

        // center song view stack & play controls
        Center(
          child: IndexedStack(
            alignment: Alignment.center,
            index: songViewIndex.value,
            children: <Widget>[
              for (var index = 0; index < widget.tracks.length; index++)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      trackNames[index],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(trackArtists[index]),
                    const SizedBox(height: 20),
                    // Album Image
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.64,
                        height: MediaQuery.of(context).size.width * 0.64,
                        child: Image.network(trackImages[index].toString())),
                    Opacity(
                      opacity: 0.4,
                      child: Text(
                        trackAlbums[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // TODO: implement play/pause
                    StatefulBuilder(builder:
                        (BuildContext context, StateSetter setPlayPause) {
                      if (widget.players[index] != null) {
                        return CupertinoButton(
                            color: CupertinoColors.white,
                            onPressed: () {
                              AudioPlayer player = widget.players[index];
                              player.play();
                            },
                            child: const Icon(CupertinoIcons.play_circle_fill,
                                color: CupertinoColors.white));
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    CupertinoButton(
                      color: CupertinoTheme.of(context).barBackgroundColor,
                      onPressed: () async {
                        await launchUrl(Uri.parse(trackURLs[index]));
                      },
                      child: SizedBox(
                        height: 16,
                        child: Image.asset(
                          'assets/Spotify_Logo_CMYK_Green.png',
                        ),
                      ),
                    )
                  ],
                )
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * chevronRatio,
          child: CupertinoButton(
              padding: const EdgeInsets.all(0),
              minSize: 0,
              borderRadius: BorderRadius.zero,
              onPressed: () {
                setState(() {
                  if (songViewIndex == widget.tracks.length - 1) {
                    songViewIndex.value = 0;
                  } else {
                    songViewIndex.value += 1;
                  }
                });
              },
              child: Icon(
                CupertinoIcons.right_chevron,
                color: CupertinoTheme.of(context).barBackgroundColor,
              )),
        ),
      ],
    );
  }
}
