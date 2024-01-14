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
  int songViewIndex = 0;
  List trackAlbums = [];
  List trackImages = [];
  List trackArtists = [];
  List trackNames = [];
  List trackURLs = [];

  // audio player used to play 30 sec previews
  late AudioPlayer player;

  // track if player is already playing
  bool isPlaying = false;

  // control the size of the chevron
  final double chevronRatio = 0.05;

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
    // handle repeated plays
    // if (isPlaying) {
    //   print('listening');
    //   player.playerStateStream.listen((playerState) {
    //     if (playerState.processingState == ProcessingState.completed) {
    //       print('end of song');
    //       setState(() {
    //         isPlaying = false;
    //         player.pause();
    //       });
    //     }
    //   });
    // }

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
                  if (isPlaying) {
                    player.pause();
                  }
                  isPlaying = false;
                  if (songViewIndex == 0) {
                    songViewIndex = widget.tracks.length - 1;
                  } else {
                    songViewIndex -= 1;
                  }
                });
              },
              child: Icon(
                CupertinoIcons.left_chevron,
                color: CupertinoTheme.of(context).textTheme.textStyle.color,
              )),
        ),

        // center song view stack & play controls
        Center(
          child: IndexedStack(
            alignment: Alignment.center,
            index: songViewIndex,
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

                    // play pause controls
                    SizedBox(
                      height: 44,
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter setPlayPause) {
                        if (widget.players[index] != null) {
                          // if the player is not playing
                          if (!isPlaying) {
                            return CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  player = widget.players[index];
                                  player.play();
                                  setState(() {
                                    isPlaying = !isPlaying;
                                  });
                                },
                                child: Icon(CupertinoIcons.play_circle_fill,
                                    color: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .color));
                          }
                          // display pause button
                          else {
                            return CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  player = widget.players[index];
                                  player.pause();
                                  setState(() {
                                    isPlaying = !isPlaying;
                                  });
                                },
                                child: Icon(CupertinoIcons.pause_circle_fill,
                                    color: CupertinoTheme.of(context)
                                        .textTheme
                                        .textStyle
                                        .color));
                          }
                        } else {
                          // player unavailable
                          return const Opacity(
                              opacity: 0.8,
                              child: Center(
                                  child: Text(
                                'preview unavailable 🥺',
                                style: TextStyle(fontSize: 12),
                              )));
                        }
                      }),
                    ),

                    const SizedBox(height: 20),

                    CupertinoButton(
                      color:
                          CupertinoTheme.of(context).textTheme.textStyle.color,
                      onPressed: () async {
                        player.pause();
                        isPlaying = false;
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
                  if (isPlaying) {
                    player.pause();
                  }
                  isPlaying = false;
                  if (songViewIndex == widget.tracks.length - 1) {
                    songViewIndex = 0;
                  } else {
                    songViewIndex += 1;
                  }
                });
              },
              child: Icon(
                CupertinoIcons.right_chevron,
                color: CupertinoTheme.of(context).textTheme.textStyle.color,
              )),
        ),
      ],
    );
  }
}
