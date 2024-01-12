import 'package:http/http.dart';
import 'dart:convert';
import 'main.dart';

void main() async {
  // String genre = await getGenre('Marina District, San Francisco, CA');

  // TODO: delete for prod, only for testing purposes
  // const clientId = '783911c86b494ab282bd1623ca55998b';
  // const clientSecret = '21a9960a92b949f696d019697f8db578';
  // dynamic response = (await post(
  //     Uri.parse('https://accounts.spotify.com/api/token'),
  //     headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  //     body:
  //         'grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret'));
  // spotifyToken = jsonDecode(response.body)['access_token'];
  // TODO: END TODO.

  final String genre = await getGenre('Santa Clara, California');
  print(genre);
}

Future<String> getGenre(String address) async {
  const uri = 'api.openai.com';
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer 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'
  };
  List<String> genres = [
    'acoustic',
    'afrobeat',
    'alt-rock',
    'alternative',
    'ambient',
    'anime',
    'black-metal',
    'bluegrass',
    'blues',
    'bossanova',
    'brazil',
    'breakbeat',
    'british',
    'cantopop',
    'chicago-house',
    'children',
    'chill',
    'classical',
    'club',
    'comedy',
    'country',
    'dance',
    'dancehall',
    'death-metal',
    'deep-house',
    'detroit-techno',
    'disco',
    'disney',
    'drum-and-bass',
    'dub',
    'dubstep',
    'edm',
    'electro',
    'electronic',
    'emo',
    'folk',
    'forro',
    'french',
    'funk',
    'garage',
    'german',
    'gospel',
    'goth',
    'grindcore',
    'groove',
    'grunge',
    'guitar',
    'happy',
    'hard-rock',
    'hardcore',
    'hardstyle',
    'heavy-metal',
    'hip-hop',
    'holidays',
    'honky-tonk',
    'house',
    'idm',
    'indian',
    'indie',
    'indie-pop',
    'industrial',
    'iranian',
    'j-dance',
    'j-idol',
    'j-pop',
    'j-rock',
    'jazz',
    'k-pop',
    'kids',
    'latin',
    'latino',
    'malay',
    'mandopop',
    'metal',
    'metal-misc',
    'metalcore',
    'minimal-techno',
    'movies',
    'mpb',
    'new-age',
    'new-release',
    'opera',
    'pagode',
    'party',
    'philippines-opm',
    'piano',
    'pop',
    'pop-film',
    'post-dubstep',
    'power-pop',
    'progressive-house',
    'psych-rock',
    'punk',
    'punk-rock',
    'r-n-b',
    'rainy-day',
    'reggae',
    'reggaeton',
    'road-trip',
    'rock',
    'rock-n-roll',
    'rockabilly',
    'romance',
    'sad',
    'salsa',
    'samba',
    'sertanejo',
    'show-tunes',
    'singer-songwriter',
    'ska',
    'sleep',
    'songwriter',
    'soul',
    'soundtracks',
    'spanish',
    'study',
    'summer',
    'swedish',
    'synth-pop',
    'tango',
    'techno',
    'trance',
    'trip-hop',
    'turkish',
    'work-out',
    'world-music'
  ];

  String body = """
  {
    "model": "gpt-3.5-turbo-1106",
    "response_format": {"type": "json_object"},
    "messages": [
      {
        "role": "user",
        "content":
            "Which one of the following genres $genres fits the atmosphere of $address in JSON"
      }
    ],
    "temperature": 0.2
  }""";
  String response = (await post(Uri.https(uri, 'v1/chat/completions'),
          headers: headers, body: body))
      .body;
  // print(response);
  String genre = jsonDecode(
      jsonDecode(response)['choices'][0]['message']['content'])['genre'];

  return genre;
}

Future<List> getTracks(String genre) async {
  const uri = 'api.spotify.com';
  Map<String, String> headers = {'Authorization': 'Bearer $spotifyToken'};
  Map<String, String> params = {
    'market': 'US',
    'seed_genres': genre,
    'target_popularity': '100'
  };
  print('getting spotify tracks');
  // Response response = (await get(
  //     Uri.https(uri, 'v1/recommendations', params), headers: headers));
  // TODO: remove after rate limit
  Response response = Response(recommendationBody, 200);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['tracks'];
  } else {
    print("spotify recommendation status code: ${response.statusCode}");
    print("${response.body}, ${response.headers}");
    throw Error;
  }
/*
SAMPLE RESPONSE

{
  "seeds": [
    {
      "afterFilteringSize": 0,
      "afterRelinkingSize": 0,
      "href": "string",
      "id": "string",
      "initialPoolSize": 0,
      "type": "string"
    }
  ],
  "tracks": [
    {
      "album": {
        "album_type": "compilation",
        "total_tracks": 9,
        "available_markets": [
          "CA",
          "BR",
          "IT"
        ],
        "external_urls": {
          "spotify": "string"
        },
        "href": "string",
        "id": "2up3OPMp9Tb4dAKM2erWXQ",
        "images": [
          {
            "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
            "height": 300,
            "width": 300
          }
        ],
        "name": "string",
        "release_date": "1981-12",
        "release_date_precision": "year",
        "restrictions": {
          "reason": "market"
        },
        "type": "album",
        "uri": "spotify:album:2up3OPMp9Tb4dAKM2erWXQ",
        "artists": [
          {
            "external_urls": {
              "spotify": "string"
            },
            "href": "string",
            "id": "string",
            "name": "string",
            "type": "artist",
            "uri": "string"
          }
        ]
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "string"
          },
          "followers": {
            "href": "string",
            "total": 0
          },
          "genres": [
            "Prog rock",
            "Grunge"
          ],
          "href": "string",
          "id": "string",
          "images": [
            {
              "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
              "height": 300,
              "width": 300
            }
          ],
          "name": "string",
          "popularity": 0,
          "type": "artist",
          "uri": "string"
        }
      ],
      "available_markets": [
        "string"
      ],
      "disc_number": 0,
      "duration_ms": 0,
      "explicit": false,
      "external_ids": {
        "isrc": "string",
        "ean": "string",
        "upc": "string"
      },
      "external_urls": {
        "spotify": "string"
      },
      "href": "string",
      "id": "string",
      "is_playable": false,
      "linked_from": {},
      "restrictions": {
        "reason": "string"
      },
      "name": "string",
      "popularity": 0,
      "preview_url": "string",
      "track_number": 0,
      "type": "track",
      "uri": "string",
      "is_local": false
    }
  ]
}
*/
}

String recommendationBody = """{
  "tracks": [
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/2cCUtGK9sDU2EoElnk0GNB"
            },
            "href": "https://api.spotify.com/v1/artists/2cCUtGK9sDU2EoElnk0GNB",
            "id": "2cCUtGK9sDU2EoElnk0GNB",
            "name": "The National",
            "type": "artist",
            "uri": "spotify:artist:2cCUtGK9sDU2EoElnk0GNB"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/2JhR4tjuc3MIKa8v2JaKze"
        },
        "href": "https://api.spotify.com/v1/albums/2JhR4tjuc3MIKa8v2JaKze",
        "id": "2JhR4tjuc3MIKa8v2JaKze",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273dde1a49f8cdfdeffc14b8b85",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02dde1a49f8cdfdeffc14b8b85",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851dde1a49f8cdfdeffc14b8b85",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Trouble Will Find Me",
        "release_date": "2013-05-27",
        "release_date_precision": "day",
        "total_tracks": 13,
        "type": "album",
        "uri": "spotify:album:2JhR4tjuc3MIKa8v2JaKze"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/2cCUtGK9sDU2EoElnk0GNB"
          },
          "href": "https://api.spotify.com/v1/artists/2cCUtGK9sDU2EoElnk0GNB",
          "id": "2cCUtGK9sDU2EoElnk0GNB",
          "name": "The National",
          "type": "artist",
          "uri": "spotify:artist:2cCUtGK9sDU2EoElnk0GNB"
        }
      ],
      "disc_number": 1,
      "duration_ms": 245240,
      "explicit": true,
      "external_ids": {
        "isrc": "GBAFL1300064"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/50M7nY1oQuNHecs0ahWAtI"
      },
      "href": "https://api.spotify.com/v1/tracks/50M7nY1oQuNHecs0ahWAtI",
      "id": "50M7nY1oQuNHecs0ahWAtI",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/7rbCL7W893Zonbfnevku5s"
        },
        "href": "https://api.spotify.com/v1/tracks/7rbCL7W893Zonbfnevku5s",
        "id": "7rbCL7W893Zonbfnevku5s",
        "type": "track",
        "uri": "spotify:track:7rbCL7W893Zonbfnevku5s"
      },
      "name": "I Need My Girl",
      "popularity": 68,
      "preview_url": "https://p.scdn.co/mp3-preview/d566beee419ec326f51b69b5cdbb2fd9285f3e00?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 10,
      "type": "track",
      "uri": "spotify:track:50M7nY1oQuNHecs0ahWAtI"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/4aEnNH9PuU1HF3TsZTru54"
            },
            "href": "https://api.spotify.com/v1/artists/4aEnNH9PuU1HF3TsZTru54",
            "id": "4aEnNH9PuU1HF3TsZTru54",
            "name": "Caribou",
            "type": "artist",
            "uri": "spotify:artist:4aEnNH9PuU1HF3TsZTru54"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/0w0dCGr6wZ0bJIuPaK2Qzb"
        },
        "href": "https://api.spotify.com/v1/albums/0w0dCGr6wZ0bJIuPaK2Qzb",
        "id": "0w0dCGr6wZ0bJIuPaK2Qzb",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273f17a21e49e78cf696245bcc1",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02f17a21e49e78cf696245bcc1",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851f17a21e49e78cf696245bcc1",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Can't Do Without You",
        "release_date": "2014-06-04",
        "release_date_precision": "day",
        "total_tracks": 1,
        "type": "album",
        "uri": "spotify:album:0w0dCGr6wZ0bJIuPaK2Qzb"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/4aEnNH9PuU1HF3TsZTru54"
          },
          "href": "https://api.spotify.com/v1/artists/4aEnNH9PuU1HF3TsZTru54",
          "id": "4aEnNH9PuU1HF3TsZTru54",
          "name": "Caribou",
          "type": "artist",
          "uri": "spotify:artist:4aEnNH9PuU1HF3TsZTru54"
        }
      ],
      "disc_number": 1,
      "duration_ms": 236400,
      "explicit": false,
      "external_ids": {
        "isrc": "DED621401192"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/35p0Z5yZDogaXoWXhMVEv4"
      },
      "href": "https://api.spotify.com/v1/tracks/35p0Z5yZDogaXoWXhMVEv4",
      "id": "35p0Z5yZDogaXoWXhMVEv4",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/7dpOCuGJOlxDhEouNQNCBM"
        },
        "href": "https://api.spotify.com/v1/tracks/7dpOCuGJOlxDhEouNQNCBM",
        "id": "7dpOCuGJOlxDhEouNQNCBM",
        "type": "track",
        "uri": "spotify:track:7dpOCuGJOlxDhEouNQNCBM"
      },
      "name": "Can't Do Without You",
      "popularity": 43,
      "preview_url": "https://p.scdn.co/mp3-preview/bef80fbf38f7fc67e1b078285d5eeb6c824c3e21?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 1,
      "type": "track",
      "uri": "spotify:track:35p0Z5yZDogaXoWXhMVEv4"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/7Ln80lUS6He07XvHI8qqHH"
            },
            "href": "https://api.spotify.com/v1/artists/7Ln80lUS6He07XvHI8qqHH",
            "id": "7Ln80lUS6He07XvHI8qqHH",
            "name": "Arctic Monkeys",
            "type": "artist",
            "uri": "spotify:artist:7Ln80lUS6He07XvHI8qqHH"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/5bU1XKYxHhEwukllT20xtk"
        },
        "href": "https://api.spotify.com/v1/albums/5bU1XKYxHhEwukllT20xtk",
        "id": "5bU1XKYxHhEwukllT20xtk",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b2734f669de38690faf2cf88c245",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e024f669de38690faf2cf88c245",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d000048514f669de38690faf2cf88c245",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "AM",
        "release_date": "2013-09-09",
        "release_date_precision": "day",
        "total_tracks": 12,
        "type": "album",
        "uri": "spotify:album:5bU1XKYxHhEwukllT20xtk"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7Ln80lUS6He07XvHI8qqHH"
          },
          "href": "https://api.spotify.com/v1/artists/7Ln80lUS6He07XvHI8qqHH",
          "id": "7Ln80lUS6He07XvHI8qqHH",
          "name": "Arctic Monkeys",
          "type": "artist",
          "uri": "spotify:artist:7Ln80lUS6He07XvHI8qqHH"
        }
      ],
      "disc_number": 1,
      "duration_ms": 193030,
      "explicit": false,
      "external_ids": {
        "isrc": "GBCEL1300371"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/0NdTUS4UiNYCNn5FgVqKQY"
      },
      "href": "https://api.spotify.com/v1/tracks/0NdTUS4UiNYCNn5FgVqKQY",
      "id": "0NdTUS4UiNYCNn5FgVqKQY",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/30uJNlHIjfDeE4vr8g9fpf"
        },
        "href": "https://api.spotify.com/v1/tracks/30uJNlHIjfDeE4vr8g9fpf",
        "id": "30uJNlHIjfDeE4vr8g9fpf",
        "type": "track",
        "uri": "spotify:track:30uJNlHIjfDeE4vr8g9fpf"
      },
      "name": "Snap Out Of It",
      "popularity": 82,
      "preview_url": "https://p.scdn.co/mp3-preview/f2ab7daa4bbd9ad5889c0dda818c40fe60b66406?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 10,
      "type": "track",
      "uri": "spotify:track:0NdTUS4UiNYCNn5FgVqKQY"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/6zvul52xwTWzilBZl6BUbT"
            },
            "href": "https://api.spotify.com/v1/artists/6zvul52xwTWzilBZl6BUbT",
            "id": "6zvul52xwTWzilBZl6BUbT",
            "name": "Pixies",
            "type": "artist",
            "uri": "spotify:artist:6zvul52xwTWzilBZl6BUbT"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/2fv7PQkt5BZqwGx21wiSc1"
        },
        "href": "https://api.spotify.com/v1/albums/2fv7PQkt5BZqwGx21wiSc1",
        "id": "2fv7PQkt5BZqwGx21wiSc1",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273fff51eaa87f4a6d7eaab4e65",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02fff51eaa87f4a6d7eaab4e65",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851fff51eaa87f4a6d7eaab4e65",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Surfer Rosa",
        "release_date": "1988",
        "release_date_precision": "year",
        "total_tracks": 13,
        "type": "album",
        "uri": "spotify:album:2fv7PQkt5BZqwGx21wiSc1"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/6zvul52xwTWzilBZl6BUbT"
          },
          "href": "https://api.spotify.com/v1/artists/6zvul52xwTWzilBZl6BUbT",
          "id": "6zvul52xwTWzilBZl6BUbT",
          "name": "Pixies",
          "type": "artist",
          "uri": "spotify:artist:6zvul52xwTWzilBZl6BUbT"
        }
      ],
      "disc_number": 1,
      "duration_ms": 234973,
      "explicit": false,
      "external_ids": {
        "isrc": "GBAFL0700145"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/7wCmS9TTVUcIhRalDYFgPy"
      },
      "href": "https://api.spotify.com/v1/tracks/7wCmS9TTVUcIhRalDYFgPy",
      "id": "7wCmS9TTVUcIhRalDYFgPy",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/6z5KJH8tgGvPFOqoSScPgS"
        },
        "href": "https://api.spotify.com/v1/tracks/6z5KJH8tgGvPFOqoSScPgS",
        "id": "6z5KJH8tgGvPFOqoSScPgS",
        "type": "track",
        "uri": "spotify:track:6z5KJH8tgGvPFOqoSScPgS"
      },
      "name": "Where Is My Mind? - Remastered",
      "popularity": 81,
      "preview_url": "https://p.scdn.co/mp3-preview/03da0b85c9fa2fb5e621e97d4fb145a17aaf7ef1?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 7,
      "type": "track",
      "uri": "spotify:track:7wCmS9TTVUcIhRalDYFgPy"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/7zsin6IgVsR1rqSRCNYDwq"
            },
            "href": "https://api.spotify.com/v1/artists/7zsin6IgVsR1rqSRCNYDwq",
            "id": "7zsin6IgVsR1rqSRCNYDwq",
            "name": "Family of the Year",
            "type": "artist",
            "uri": "spotify:artist:7zsin6IgVsR1rqSRCNYDwq"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/14SCnv027L0HidHq0URIDu"
        },
        "href": "https://api.spotify.com/v1/albums/14SCnv027L0HidHq0URIDu",
        "id": "14SCnv027L0HidHq0URIDu",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b2731980a53c08d4911caa77d249",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e021980a53c08d4911caa77d249",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d000048511980a53c08d4911caa77d249",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Loma Vista",
        "release_date": "2012-07-10",
        "release_date_precision": "day",
        "total_tracks": 11,
        "type": "album",
        "uri": "spotify:album:14SCnv027L0HidHq0URIDu"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7zsin6IgVsR1rqSRCNYDwq"
          },
          "href": "https://api.spotify.com/v1/artists/7zsin6IgVsR1rqSRCNYDwq",
          "id": "7zsin6IgVsR1rqSRCNYDwq",
          "name": "Family of the Year",
          "type": "artist",
          "uri": "spotify:artist:7zsin6IgVsR1rqSRCNYDwq"
        }
      ],
      "disc_number": 1,
      "duration_ms": 190280,
      "explicit": false,
      "external_ids": {
        "isrc": "CAN111200237"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/1B10XgaxSXRLAFq967oMpF"
      },
      "href": "https://api.spotify.com/v1/tracks/1B10XgaxSXRLAFq967oMpF",
      "id": "1B10XgaxSXRLAFq967oMpF",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/6GRDI9suQHikFP6euIXnpq"
        },
        "href": "https://api.spotify.com/v1/tracks/6GRDI9suQHikFP6euIXnpq",
        "id": "6GRDI9suQHikFP6euIXnpq",
        "type": "track",
        "uri": "spotify:track:6GRDI9suQHikFP6euIXnpq"
      },
      "name": "Hero",
      "popularity": 69,
      "preview_url": "https://p.scdn.co/mp3-preview/d0f2fc3d011af3cef5f196482ab579d51b4e6aeb?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 5,
      "type": "track",
      "uri": "spotify:track:1B10XgaxSXRLAFq967oMpF"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/7mnBLXK823vNxN3UWB7Gfz"
            },
            "href": "https://api.spotify.com/v1/artists/7mnBLXK823vNxN3UWB7Gfz",
            "id": "7mnBLXK823vNxN3UWB7Gfz",
            "name": "The Black Keys",
            "type": "artist",
            "uri": "spotify:artist:7mnBLXK823vNxN3UWB7Gfz"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/00evzQcmYUA8nSjrfGSqUZ"
        },
        "href": "https://api.spotify.com/v1/albums/00evzQcmYUA8nSjrfGSqUZ",
        "id": "00evzQcmYUA8nSjrfGSqUZ",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b2736663eb7fb2143ab687b917dc",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e026663eb7fb2143ab687b917dc",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d000048516663eb7fb2143ab687b917dc",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Gotta Get Away",
        "release_date": "2014-08-19",
        "release_date_precision": "day",
        "total_tracks": 1,
        "type": "album",
        "uri": "spotify:album:00evzQcmYUA8nSjrfGSqUZ"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7mnBLXK823vNxN3UWB7Gfz"
          },
          "href": "https://api.spotify.com/v1/artists/7mnBLXK823vNxN3UWB7Gfz",
          "id": "7mnBLXK823vNxN3UWB7Gfz",
          "name": "The Black Keys",
          "type": "artist",
          "uri": "spotify:artist:7mnBLXK823vNxN3UWB7Gfz"
        }
      ],
      "disc_number": 1,
      "duration_ms": 180173,
      "explicit": false,
      "external_ids": {
        "isrc": "USNO11400187"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/0zo4T5c5VV42554ySEc5J6"
      },
      "href": "https://api.spotify.com/v1/tracks/0zo4T5c5VV42554ySEc5J6",
      "id": "0zo4T5c5VV42554ySEc5J6",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/3wf3jWAQHsnPNfUtNSQvkz"
        },
        "href": "https://api.spotify.com/v1/tracks/3wf3jWAQHsnPNfUtNSQvkz",
        "id": "3wf3jWAQHsnPNfUtNSQvkz",
        "type": "track",
        "uri": "spotify:track:3wf3jWAQHsnPNfUtNSQvkz"
      },
      "name": "Gotta Get Away",
      "popularity": 54,
      "preview_url": "https://p.scdn.co/mp3-preview/ad250077b738f36402f41b23cafd515b0aa62823?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 11,
      "type": "track",
      "uri": "spotify:track:0zo4T5c5VV42554ySEc5J6"
    },
    {
      "album": {
        "album_type": "COMPILATION",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/7MhMgCo0Bl0Kukl93PZbYS"
            },
            "href": "https://api.spotify.com/v1/artists/7MhMgCo0Bl0Kukl93PZbYS",
            "id": "7MhMgCo0Bl0Kukl93PZbYS",
            "name": "Blur",
            "type": "artist",
            "uri": "spotify:artist:7MhMgCo0Bl0Kukl93PZbYS"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/6P3DICUiFYGBz5Ptdn57sG"
        },
        "href": "https://api.spotify.com/v1/albums/6P3DICUiFYGBz5Ptdn57sG",
        "id": "6P3DICUiFYGBz5Ptdn57sG",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273c0775e7c2d4aa62d994c770f",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02c0775e7c2d4aa62d994c770f",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851c0775e7c2d4aa62d994c770f",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Midlife: A Beginner's Guide to Blur",
        "release_date": "2009-06-14",
        "release_date_precision": "day",
        "total_tracks": 32,
        "type": "album",
        "uri": "spotify:album:6P3DICUiFYGBz5Ptdn57sG"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7MhMgCo0Bl0Kukl93PZbYS"
          },
          "href": "https://api.spotify.com/v1/artists/7MhMgCo0Bl0Kukl93PZbYS",
          "id": "7MhMgCo0Bl0Kukl93PZbYS",
          "name": "Blur",
          "type": "artist",
          "uri": "spotify:artist:7MhMgCo0Bl0Kukl93PZbYS"
        }
      ],
      "disc_number": 1,
      "duration_ms": 121880,
      "explicit": false,
      "external_ids": {
        "isrc": "GBAYE9600015"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/68dF2fJhETbjO3BVr3WUHo"
      },
      "href": "https://api.spotify.com/v1/tracks/68dF2fJhETbjO3BVr3WUHo",
      "id": "68dF2fJhETbjO3BVr3WUHo",
      "is_local": false,
      "is_playable": true,
      "name": "Song 2",
      "popularity": 13,
      "preview_url": "https://p.scdn.co/mp3-preview/292139885ad767b4b8f01d18a4bb437d0075cdf9?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 7,
      "type": "track",
      "uri": "spotify:track:68dF2fJhETbjO3BVr3WUHo"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/053q0ukIDRgzwTr4vNSwab"
            },
            "href": "https://api.spotify.com/v1/artists/053q0ukIDRgzwTr4vNSwab",
            "id": "053q0ukIDRgzwTr4vNSwab",
            "name": "Grimes",
            "type": "artist",
            "uri": "spotify:artist:053q0ukIDRgzwTr4vNSwab"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/48a7rOjTzpD1zzJAteeveE"
        },
        "href": "https://api.spotify.com/v1/albums/48a7rOjTzpD1zzJAteeveE",
        "id": "48a7rOjTzpD1zzJAteeveE",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273cdd80f8264878306d278cd2a",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02cdd80f8264878306d278cd2a",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851cdd80f8264878306d278cd2a",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Visions",
        "release_date": "2012-02-21",
        "release_date_precision": "day",
        "total_tracks": 13,
        "type": "album",
        "uri": "spotify:album:48a7rOjTzpD1zzJAteeveE"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/053q0ukIDRgzwTr4vNSwab"
          },
          "href": "https://api.spotify.com/v1/artists/053q0ukIDRgzwTr4vNSwab",
          "id": "053q0ukIDRgzwTr4vNSwab",
          "name": "Grimes",
          "type": "artist",
          "uri": "spotify:artist:053q0ukIDRgzwTr4vNSwab"
        }
      ],
      "disc_number": 1,
      "duration_ms": 255320,
      "explicit": false,
      "external_ids": {
        "isrc": "CA21O1200002"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/3cjvqsvvU80g7WJPMVh8iq"
      },
      "href": "https://api.spotify.com/v1/tracks/3cjvqsvvU80g7WJPMVh8iq",
      "id": "3cjvqsvvU80g7WJPMVh8iq",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/4sCYKMatyhazyy6r2N7Hp2"
        },
        "href": "https://api.spotify.com/v1/tracks/4sCYKMatyhazyy6r2N7Hp2",
        "id": "4sCYKMatyhazyy6r2N7Hp2",
        "type": "track",
        "uri": "spotify:track:4sCYKMatyhazyy6r2N7Hp2"
      },
      "name": "Genesis",
      "popularity": 71,
      "preview_url": "https://p.scdn.co/mp3-preview/30cb10937f86a6cb00a54516de2cedc0d962f076?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 2,
      "type": "track",
      "uri": "spotify:track:3cjvqsvvU80g7WJPMVh8iq"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/0epOFNiUfyON9EYx7Tpr6V"
            },
            "href": "https://api.spotify.com/v1/artists/0epOFNiUfyON9EYx7Tpr6V",
            "id": "0epOFNiUfyON9EYx7Tpr6V",
            "name": "The Strokes",
            "type": "artist",
            "uri": "spotify:artist:0epOFNiUfyON9EYx7Tpr6V"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/3HFbH1loOUbqCyPsLuHLLh"
        },
        "href": "https://api.spotify.com/v1/albums/3HFbH1loOUbqCyPsLuHLLh",
        "id": "3HFbH1loOUbqCyPsLuHLLh",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b2730f35726025e0f025da4c688f",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e020f35726025e0f025da4c688f",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d000048510f35726025e0f025da4c688f",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Room On Fire",
        "release_date": "2003-10-28",
        "release_date_precision": "day",
        "total_tracks": 11,
        "type": "album",
        "uri": "spotify:album:3HFbH1loOUbqCyPsLuHLLh"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/0epOFNiUfyON9EYx7Tpr6V"
          },
          "href": "https://api.spotify.com/v1/artists/0epOFNiUfyON9EYx7Tpr6V",
          "id": "0epOFNiUfyON9EYx7Tpr6V",
          "name": "The Strokes",
          "type": "artist",
          "uri": "spotify:artist:0epOFNiUfyON9EYx7Tpr6V"
        }
      ],
      "disc_number": 1,
      "duration_ms": 219826,
      "explicit": false,
      "external_ids": {
        "isrc": "USRC10301519"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/57Xjny5yNzAcsxnusKmAfA"
      },
      "href": "https://api.spotify.com/v1/tracks/57Xjny5yNzAcsxnusKmAfA",
      "id": "57Xjny5yNzAcsxnusKmAfA",
      "is_local": false,
      "is_playable": true,
      "name": "Reptilia",
      "popularity": 79,
      "preview_url": "https://p.scdn.co/mp3-preview/35521d82091e8c9a6a1cee80fb59dc2f6b5cb776?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 2,
      "type": "track",
      "uri": "spotify:track:57Xjny5yNzAcsxnusKmAfA"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/4LEiUm1SRbFMgfqnQTwUbQ"
            },
            "href": "https://api.spotify.com/v1/artists/4LEiUm1SRbFMgfqnQTwUbQ",
            "id": "4LEiUm1SRbFMgfqnQTwUbQ",
            "name": "Bon Iver",
            "type": "artist",
            "uri": "spotify:artist:4LEiUm1SRbFMgfqnQTwUbQ"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/1JlvIsP2f6ckoa62aN7kLn"
        },
        "href": "https://api.spotify.com/v1/albums/1JlvIsP2f6ckoa62aN7kLn",
        "id": "1JlvIsP2f6ckoa62aN7kLn",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273567b0a6defc057bcbfaedadb",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02567b0a6defc057bcbfaedadb",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851567b0a6defc057bcbfaedadb",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Bon Iver",
        "release_date": "2011-06-21",
        "release_date_precision": "day",
        "total_tracks": 10,
        "type": "album",
        "uri": "spotify:album:1JlvIsP2f6ckoa62aN7kLn"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/4LEiUm1SRbFMgfqnQTwUbQ"
          },
          "href": "https://api.spotify.com/v1/artists/4LEiUm1SRbFMgfqnQTwUbQ",
          "id": "4LEiUm1SRbFMgfqnQTwUbQ",
          "name": "Bon Iver",
          "type": "artist",
          "uri": "spotify:artist:4LEiUm1SRbFMgfqnQTwUbQ"
        }
      ],
      "disc_number": 1,
      "duration_ms": 336613,
      "explicit": true,
      "external_ids": {
        "isrc": "US38Y1113503"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/1ILEK6NRfxoseoPnolRcVA"
      },
      "href": "https://api.spotify.com/v1/tracks/1ILEK6NRfxoseoPnolRcVA",
      "id": "1ILEK6NRfxoseoPnolRcVA",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/4fbvXwMTXPWaFyaMWUm9CR"
        },
        "href": "https://api.spotify.com/v1/tracks/4fbvXwMTXPWaFyaMWUm9CR",
        "id": "4fbvXwMTXPWaFyaMWUm9CR",
        "type": "track",
        "uri": "spotify:track:4fbvXwMTXPWaFyaMWUm9CR"
      },
      "name": "Holocene",
      "popularity": 68,
      "preview_url": "https://p.scdn.co/mp3-preview/b04aea21beb0ad1181f219390be169b97b32e9fb?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 3,
      "type": "track",
      "uri": "spotify:track:1ILEK6NRfxoseoPnolRcVA"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/53XhwfbYqKCa1cC15pYq2q"
            },
            "href": "https://api.spotify.com/v1/artists/53XhwfbYqKCa1cC15pYq2q",
            "id": "53XhwfbYqKCa1cC15pYq2q",
            "name": "Imagine Dragons",
            "type": "artist",
            "uri": "spotify:artist:53XhwfbYqKCa1cC15pYq2q"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/2M0IZTKgkN3ZpYluF4lKAM"
        },
        "href": "https://api.spotify.com/v1/albums/2M0IZTKgkN3ZpYluF4lKAM",
        "id": "2M0IZTKgkN3ZpYluF4lKAM",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273d8941843ba4d684f76a94956",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02d8941843ba4d684f76a94956",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851d8941843ba4d684f76a94956",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Radioactive",
        "release_date": "2014-01-01",
        "release_date_precision": "day",
        "total_tracks": 1,
        "type": "album",
        "uri": "spotify:album:2M0IZTKgkN3ZpYluF4lKAM"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/53XhwfbYqKCa1cC15pYq2q"
          },
          "href": "https://api.spotify.com/v1/artists/53XhwfbYqKCa1cC15pYq2q",
          "id": "53XhwfbYqKCa1cC15pYq2q",
          "name": "Imagine Dragons",
          "type": "artist",
          "uri": "spotify:artist:53XhwfbYqKCa1cC15pYq2q"
        },
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/2YZyLoL8N0Wb9xBt1NhZWg"
          },
          "href": "https://api.spotify.com/v1/artists/2YZyLoL8N0Wb9xBt1NhZWg",
          "id": "2YZyLoL8N0Wb9xBt1NhZWg",
          "name": "Kendrick Lamar",
          "type": "artist",
          "uri": "spotify:artist:2YZyLoL8N0Wb9xBt1NhZWg"
        }
      ],
      "disc_number": 1,
      "duration_ms": 276040,
      "explicit": true,
      "external_ids": {
        "isrc": "USUM71400693"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/69yfbpvmkIaB10msnKT7Q5"
      },
      "href": "https://api.spotify.com/v1/tracks/69yfbpvmkIaB10msnKT7Q5",
      "id": "69yfbpvmkIaB10msnKT7Q5",
      "is_local": false,
      "is_playable": true,
      "name": "Radioactive",
      "popularity": 65,
      "preview_url": null,
      "track_number": 1,
      "type": "track",
      "uri": "spotify:track:69yfbpvmkIaB10msnKT7Q5"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/11wRdbnoYqRddKBrpHt4Ue"
            },
            "href": "https://api.spotify.com/v1/artists/11wRdbnoYqRddKBrpHt4Ue",
            "id": "11wRdbnoYqRddKBrpHt4Ue",
            "name": "Kasabian",
            "type": "artist",
            "uri": "spotify:artist:11wRdbnoYqRddKBrpHt4Ue"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/048UGU6AjxKlcWbcUH6TXZ"
        },
        "href": "https://api.spotify.com/v1/albums/048UGU6AjxKlcWbcUH6TXZ",
        "id": "048UGU6AjxKlcWbcUH6TXZ",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b2732e8cf25608e9a80519980593",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e022e8cf25608e9a80519980593",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d000048512e8cf25608e9a80519980593",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "eez-eh",
        "release_date": "2014-09-16",
        "release_date_precision": "day",
        "total_tracks": 1,
        "type": "album",
        "uri": "spotify:album:048UGU6AjxKlcWbcUH6TXZ"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/11wRdbnoYqRddKBrpHt4Ue"
          },
          "href": "https://api.spotify.com/v1/artists/11wRdbnoYqRddKBrpHt4Ue",
          "id": "11wRdbnoYqRddKBrpHt4Ue",
          "name": "Kasabian",
          "type": "artist",
          "uri": "spotify:artist:11wRdbnoYqRddKBrpHt4Ue"
        }
      ],
      "disc_number": 1,
      "duration_ms": 179933,
      "explicit": false,
      "external_ids": {
        "isrc": "GBARL1400517"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/0v6WAhivOPQ4LRbm6zUY4L"
      },
      "href": "https://api.spotify.com/v1/tracks/0v6WAhivOPQ4LRbm6zUY4L",
      "id": "0v6WAhivOPQ4LRbm6zUY4L",
      "is_local": false,
      "is_playable": true,
      "name": "eez-eh",
      "popularity": 8,
      "preview_url": null,
      "track_number": 1,
      "type": "track",
      "uri": "spotify:track:0v6WAhivOPQ4LRbm6zUY4L"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/5nCi3BB41mBaMH9gfr6Su0"
            },
            "href": "https://api.spotify.com/v1/artists/5nCi3BB41mBaMH9gfr6Su0",
            "id": "5nCi3BB41mBaMH9gfr6Su0",
            "name": "fun.",
            "type": "artist",
            "uri": "spotify:artist:5nCi3BB41mBaMH9gfr6Su0"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/7iycyHwOW2plljYIK6I1Zo"
        },
        "href": "https://api.spotify.com/v1/albums/7iycyHwOW2plljYIK6I1Zo",
        "id": "7iycyHwOW2plljYIK6I1Zo",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b27305fb4e9947c6edaf3836766e",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e0205fb4e9947c6edaf3836766e",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d0000485105fb4e9947c6edaf3836766e",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Some Nights",
        "release_date": "2012-02-21",
        "release_date_precision": "day",
        "total_tracks": 12,
        "type": "album",
        "uri": "spotify:album:7iycyHwOW2plljYIK6I1Zo"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/5nCi3BB41mBaMH9gfr6Su0"
          },
          "href": "https://api.spotify.com/v1/artists/5nCi3BB41mBaMH9gfr6Su0",
          "id": "5nCi3BB41mBaMH9gfr6Su0",
          "name": "fun.",
          "type": "artist",
          "uri": "spotify:artist:5nCi3BB41mBaMH9gfr6Su0"
        }
      ],
      "disc_number": 1,
      "duration_ms": 277040,
      "explicit": true,
      "external_ids": {
        "isrc": "USAT21104050"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/6t6oULCRS6hnI7rm0h5gwl"
      },
      "href": "https://api.spotify.com/v1/tracks/6t6oULCRS6hnI7rm0h5gwl",
      "id": "6t6oULCRS6hnI7rm0h5gwl",
      "is_local": false,
      "is_playable": true,
      "name": "Some Nights",
      "popularity": 72,
      "preview_url": "https://p.scdn.co/mp3-preview/270d1a141e0493689e31d43c42b464e23583b820?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 2,
      "type": "track",
      "uri": "spotify:track:6t6oULCRS6hnI7rm0h5gwl"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/7gP3bB2nilZXLfPHJhMdvc"
            },
            "href": "https://api.spotify.com/v1/artists/7gP3bB2nilZXLfPHJhMdvc",
            "id": "7gP3bB2nilZXLfPHJhMdvc",
            "name": "Foster The People",
            "type": "artist",
            "uri": "spotify:artist:7gP3bB2nilZXLfPHJhMdvc"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/7Kmmw7Z5D2UD5MVwdm10sT"
        },
        "href": "https://api.spotify.com/v1/albums/7Kmmw7Z5D2UD5MVwdm10sT",
        "id": "7Kmmw7Z5D2UD5MVwdm10sT",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273121d5f92cf90576907dfb1e5",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02121d5f92cf90576907dfb1e5",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851121d5f92cf90576907dfb1e5",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Torches",
        "release_date": "2011-05-23",
        "release_date_precision": "day",
        "total_tracks": 10,
        "type": "album",
        "uri": "spotify:album:7Kmmw7Z5D2UD5MVwdm10sT"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7gP3bB2nilZXLfPHJhMdvc"
          },
          "href": "https://api.spotify.com/v1/artists/7gP3bB2nilZXLfPHJhMdvc",
          "id": "7gP3bB2nilZXLfPHJhMdvc",
          "name": "Foster The People",
          "type": "artist",
          "uri": "spotify:artist:7gP3bB2nilZXLfPHJhMdvc"
        }
      ],
      "disc_number": 1,
      "duration_ms": 239600,
      "explicit": false,
      "external_ids": {
        "isrc": "USSM11002931"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/7w87IxuO7BDcJ3YUqCyMTT"
      },
      "href": "https://api.spotify.com/v1/tracks/7w87IxuO7BDcJ3YUqCyMTT",
      "id": "7w87IxuO7BDcJ3YUqCyMTT",
      "is_local": false,
      "is_playable": true,
      "name": "Pumped Up Kicks",
      "popularity": 86,
      "preview_url": "https://p.scdn.co/mp3-preview/2213bf4173a9b50a807a30121ed6b559a7778209?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 2,
      "type": "track",
      "uri": "spotify:track:7w87IxuO7BDcJ3YUqCyMTT"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/053q0ukIDRgzwTr4vNSwab"
            },
            "href": "https://api.spotify.com/v1/artists/053q0ukIDRgzwTr4vNSwab",
            "id": "053q0ukIDRgzwTr4vNSwab",
            "name": "Grimes",
            "type": "artist",
            "uri": "spotify:artist:053q0ukIDRgzwTr4vNSwab"
          },
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/4yuvRDaF5kWkFLq6q1Fev4"
            },
            "href": "https://api.spotify.com/v1/artists/4yuvRDaF5kWkFLq6q1Fev4",
            "id": "4yuvRDaF5kWkFLq6q1Fev4",
            "name": "Blood Diamonds",
            "type": "artist",
            "uri": "spotify:artist:4yuvRDaF5kWkFLq6q1Fev4"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/5UIDadF0rMa4LqHAucuMpK"
        },
        "href": "https://api.spotify.com/v1/albums/5UIDadF0rMa4LqHAucuMpK",
        "id": "5UIDadF0rMa4LqHAucuMpK",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b27357268a413afd1823332fd380",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e0257268a413afd1823332fd380",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d0000485157268a413afd1823332fd380",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Go",
        "release_date": "2014-07-03",
        "release_date_precision": "day",
        "total_tracks": 1,
        "type": "album",
        "uri": "spotify:album:5UIDadF0rMa4LqHAucuMpK"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/053q0ukIDRgzwTr4vNSwab"
          },
          "href": "https://api.spotify.com/v1/artists/053q0ukIDRgzwTr4vNSwab",
          "id": "053q0ukIDRgzwTr4vNSwab",
          "name": "Grimes",
          "type": "artist",
          "uri": "spotify:artist:053q0ukIDRgzwTr4vNSwab"
        },
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/4yuvRDaF5kWkFLq6q1Fev4"
          },
          "href": "https://api.spotify.com/v1/artists/4yuvRDaF5kWkFLq6q1Fev4",
          "id": "4yuvRDaF5kWkFLq6q1Fev4",
          "name": "Blood Diamonds",
          "type": "artist",
          "uri": "spotify:artist:4yuvRDaF5kWkFLq6q1Fev4"
        }
      ],
      "disc_number": 1,
      "duration_ms": 240759,
      "explicit": false,
      "external_ids": {
        "isrc": "GBAFL1400162"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/6U6UC3Xg5ukTBQIy245bAo"
      },
      "href": "https://api.spotify.com/v1/tracks/6U6UC3Xg5ukTBQIy245bAo",
      "id": "6U6UC3Xg5ukTBQIy245bAo",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/47muNlVTjDtQfyUqDaiFlN"
        },
        "href": "https://api.spotify.com/v1/tracks/47muNlVTjDtQfyUqDaiFlN",
        "id": "47muNlVTjDtQfyUqDaiFlN",
        "type": "track",
        "uri": "spotify:track:47muNlVTjDtQfyUqDaiFlN"
      },
      "name": "Go",
      "popularity": 44,
      "preview_url": "https://p.scdn.co/mp3-preview/3d4e5eb1a9837b42809c4c9ce0134ae8a5d4cba8?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 1,
      "type": "track",
      "uri": "spotify:track:6U6UC3Xg5ukTBQIy245bAo"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/5INjqkS1o8h1imAzPqGZBb"
            },
            "href": "https://api.spotify.com/v1/artists/5INjqkS1o8h1imAzPqGZBb",
            "id": "5INjqkS1o8h1imAzPqGZBb",
            "name": "Tame Impala",
            "type": "artist",
            "uri": "spotify:artist:5INjqkS1o8h1imAzPqGZBb"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/18pAHfrVm2PjpohNEGGCII"
        },
        "href": "https://api.spotify.com/v1/albums/18pAHfrVm2PjpohNEGGCII",
        "id": "18pAHfrVm2PjpohNEGGCII",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b27339c5ff049f9df1aca6b5d105",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e0239c5ff049f9df1aca6b5d105",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d0000485139c5ff049f9df1aca6b5d105",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Elephant",
        "release_date": "2012-01-01",
        "release_date_precision": "day",
        "total_tracks": 3,
        "type": "album",
        "uri": "spotify:album:18pAHfrVm2PjpohNEGGCII"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/5INjqkS1o8h1imAzPqGZBb"
          },
          "href": "https://api.spotify.com/v1/artists/5INjqkS1o8h1imAzPqGZBb",
          "id": "5INjqkS1o8h1imAzPqGZBb",
          "name": "Tame Impala",
          "type": "artist",
          "uri": "spotify:artist:5INjqkS1o8h1imAzPqGZBb"
        }
      ],
      "disc_number": 1,
      "duration_ms": 211226,
      "explicit": false,
      "external_ids": {
        "isrc": "AUUM71200495"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/6qZjm61s6u8Ead9sWxCDro"
      },
      "href": "https://api.spotify.com/v1/tracks/6qZjm61s6u8Ead9sWxCDro",
      "id": "6qZjm61s6u8Ead9sWxCDro",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/5bSZ7X47NVL7hPO3a4HpF1"
        },
        "href": "https://api.spotify.com/v1/tracks/5bSZ7X47NVL7hPO3a4HpF1",
        "id": "5bSZ7X47NVL7hPO3a4HpF1",
        "type": "track",
        "uri": "spotify:track:5bSZ7X47NVL7hPO3a4HpF1"
      },
      "name": "Elephant",
      "popularity": 75,
      "preview_url": null,
      "track_number": 9,
      "type": "track",
      "uri": "spotify:track:6qZjm61s6u8Ead9sWxCDro"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/6u11Qbko2N2hP4lTBYjX86"
            },
            "href": "https://api.spotify.com/v1/artists/6u11Qbko2N2hP4lTBYjX86",
            "id": "6u11Qbko2N2hP4lTBYjX86",
            "name": "Peter Bjorn and John",
            "type": "artist",
            "uri": "spotify:artist:6u11Qbko2N2hP4lTBYjX86"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/3FDYmCinR2Mx94ukKJKDew"
        },
        "href": "https://api.spotify.com/v1/albums/3FDYmCinR2Mx94ukKJKDew",
        "id": "3FDYmCinR2Mx94ukKJKDew",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273db2c07b93263280a636c1567",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02db2c07b93263280a636c1567",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851db2c07b93263280a636c1567",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Writer's Block",
        "release_date": "2007-02-20",
        "release_date_precision": "day",
        "total_tracks": 14,
        "type": "album",
        "uri": "spotify:album:3FDYmCinR2Mx94ukKJKDew"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/6u11Qbko2N2hP4lTBYjX86"
          },
          "href": "https://api.spotify.com/v1/artists/6u11Qbko2N2hP4lTBYjX86",
          "id": "6u11Qbko2N2hP4lTBYjX86",
          "name": "Peter Bjorn and John",
          "type": "artist",
          "uri": "spotify:artist:6u11Qbko2N2hP4lTBYjX86"
        }
      ],
      "disc_number": 1,
      "duration_ms": 276693,
      "explicit": false,
      "external_ids": {
        "isrc": "SEBPA0600024"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/4dyx5SzxPPaD8xQIid5Wjj"
      },
      "href": "https://api.spotify.com/v1/tracks/4dyx5SzxPPaD8xQIid5Wjj",
      "id": "4dyx5SzxPPaD8xQIid5Wjj",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/6M6UoxIPn4NOWW0x7JPRfv"
        },
        "href": "https://api.spotify.com/v1/tracks/6M6UoxIPn4NOWW0x7JPRfv",
        "id": "6M6UoxIPn4NOWW0x7JPRfv",
        "type": "track",
        "uri": "spotify:track:6M6UoxIPn4NOWW0x7JPRfv"
      },
      "name": "Young Folks",
      "popularity": 80,
      "preview_url": null,
      "track_number": 3,
      "type": "track",
      "uri": "spotify:track:4dyx5SzxPPaD8xQIid5Wjj"
    },
    {
      "album": {
        "album_type": "ALBUM",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/6g0mn3tzAds6aVeUYRsryU"
            },
            "href": "https://api.spotify.com/v1/artists/6g0mn3tzAds6aVeUYRsryU",
            "id": "6g0mn3tzAds6aVeUYRsryU",
            "name": "The War On Drugs",
            "type": "artist",
            "uri": "spotify:artist:6g0mn3tzAds6aVeUYRsryU"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/14xxjLlbGy8ACm4MorBjD5"
        },
        "href": "https://api.spotify.com/v1/albums/14xxjLlbGy8ACm4MorBjD5",
        "id": "14xxjLlbGy8ACm4MorBjD5",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b2733d26fed2a5a4e270a4485de6",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e023d26fed2a5a4e270a4485de6",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d000048513d26fed2a5a4e270a4485de6",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Lost In The Dream",
        "release_date": "2014-03-18",
        "release_date_precision": "day",
        "total_tracks": 10,
        "type": "album",
        "uri": "spotify:album:14xxjLlbGy8ACm4MorBjD5"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/6g0mn3tzAds6aVeUYRsryU"
          },
          "href": "https://api.spotify.com/v1/artists/6g0mn3tzAds6aVeUYRsryU",
          "id": "6g0mn3tzAds6aVeUYRsryU",
          "name": "The War On Drugs",
          "type": "artist",
          "uri": "spotify:artist:6g0mn3tzAds6aVeUYRsryU"
        }
      ],
      "disc_number": 1,
      "duration_ms": 298920,
      "explicit": false,
      "external_ids": {
        "isrc": "US38W1431002"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/0rUIff1QHd5zlOBtlHVqd9"
      },
      "href": "https://api.spotify.com/v1/tracks/0rUIff1QHd5zlOBtlHVqd9",
      "id": "0rUIff1QHd5zlOBtlHVqd9",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/71jGGLe5VtEHjIk5dU2W3S"
        },
        "href": "https://api.spotify.com/v1/tracks/71jGGLe5VtEHjIk5dU2W3S",
        "id": "71jGGLe5VtEHjIk5dU2W3S",
        "type": "track",
        "uri": "spotify:track:71jGGLe5VtEHjIk5dU2W3S"
      },
      "name": "Red Eyes",
      "popularity": 67,
      "preview_url": "https://p.scdn.co/mp3-preview/00678bcdffdcf06833475e009f79c0c4e34d55ef?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 2,
      "type": "track",
      "uri": "spotify:track:0rUIff1QHd5zlOBtlHVqd9"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/7Ln80lUS6He07XvHI8qqHH"
            },
            "href": "https://api.spotify.com/v1/artists/7Ln80lUS6He07XvHI8qqHH",
            "id": "7Ln80lUS6He07XvHI8qqHH",
            "name": "Arctic Monkeys",
            "type": "artist",
            "uri": "spotify:artist:7Ln80lUS6He07XvHI8qqHH"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/7sJfrkaEHizL6RwLfDp67F"
        },
        "href": "https://api.spotify.com/v1/albums/7sJfrkaEHizL6RwLfDp67F",
        "id": "7sJfrkaEHizL6RwLfDp67F",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b273a1e18f0c908c0d6a6377b31d",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e02a1e18f0c908c0d6a6377b31d",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d00004851a1e18f0c908c0d6a6377b31d",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "R U Mine? / Electricity",
        "release_date": "2012-04-24",
        "release_date_precision": "day",
        "total_tracks": 2,
        "type": "album",
        "uri": "spotify:album:7sJfrkaEHizL6RwLfDp67F"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/7Ln80lUS6He07XvHI8qqHH"
          },
          "href": "https://api.spotify.com/v1/artists/7Ln80lUS6He07XvHI8qqHH",
          "id": "7Ln80lUS6He07XvHI8qqHH",
          "name": "Arctic Monkeys",
          "type": "artist",
          "uri": "spotify:artist:7Ln80lUS6He07XvHI8qqHH"
        }
      ],
      "disc_number": 1,
      "duration_ms": 200187,
      "explicit": false,
      "external_ids": {
        "isrc": "GBCEL1200081"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/6c5QZx2v9753q26g1Fvo2F"
      },
      "href": "https://api.spotify.com/v1/tracks/6c5QZx2v9753q26g1Fvo2F",
      "id": "6c5QZx2v9753q26g1Fvo2F",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/4eACecQhCB5NxFfGjfmIXI"
        },
        "href": "https://api.spotify.com/v1/tracks/4eACecQhCB5NxFfGjfmIXI",
        "id": "4eACecQhCB5NxFfGjfmIXI",
        "type": "track",
        "uri": "spotify:track:4eACecQhCB5NxFfGjfmIXI"
      },
      "name": "R U Mine?",
      "popularity": 47,
      "preview_url": "https://p.scdn.co/mp3-preview/2d1323b9339b3868bfbf0d3edb1a25472676567b?cid=fd450101dca740f6a3f9859265aa2e4f",
      "track_number": 1,
      "type": "track",
      "uri": "spotify:track:6c5QZx2v9753q26g1Fvo2F"
    },
    {
      "album": {
        "album_type": "SINGLE",
        "artists": [
          {
            "external_urls": {
              "spotify": "https://open.spotify.com/artist/6VxCmtR7S3yz4vnzsJqhSV"
            },
            "href": "https://api.spotify.com/v1/artists/6VxCmtR7S3yz4vnzsJqhSV",
            "id": "6VxCmtR7S3yz4vnzsJqhSV",
            "name": "Sheppard",
            "type": "artist",
            "uri": "spotify:artist:6VxCmtR7S3yz4vnzsJqhSV"
          }
        ],
        "external_urls": {
          "spotify": "https://open.spotify.com/album/4GhtfAgvmWifKe6LrMlnqx"
        },
        "href": "https://api.spotify.com/v1/albums/4GhtfAgvmWifKe6LrMlnqx",
        "id": "4GhtfAgvmWifKe6LrMlnqx",
        "images": [
          {
            "height": 640,
            "url": "https://i.scdn.co/image/ab67616d0000b2735b0a054f744fa214874675ca",
            "width": 640
          },
          {
            "height": 300,
            "url": "https://i.scdn.co/image/ab67616d00001e025b0a054f744fa214874675ca",
            "width": 300
          },
          {
            "height": 64,
            "url": "https://i.scdn.co/image/ab67616d000048515b0a054f744fa214874675ca",
            "width": 64
          }
        ],
        "is_playable": true,
        "name": "Geronimo",
        "release_date": "2014-01-01",
        "release_date_precision": "day",
        "total_tracks": 1,
        "type": "album",
        "uri": "spotify:album:4GhtfAgvmWifKe6LrMlnqx"
      },
      "artists": [
        {
          "external_urls": {
            "spotify": "https://open.spotify.com/artist/6VxCmtR7S3yz4vnzsJqhSV"
          },
          "href": "https://api.spotify.com/v1/artists/6VxCmtR7S3yz4vnzsJqhSV",
          "id": "6VxCmtR7S3yz4vnzsJqhSV",
          "name": "Sheppard",
          "type": "artist",
          "uri": "spotify:artist:6VxCmtR7S3yz4vnzsJqhSV"
        }
      ],
      "disc_number": 1,
      "duration_ms": 218227,
      "explicit": false,
      "external_ids": {
        "isrc": "AUIYA1400002"
      },
      "external_urls": {
        "spotify": "https://open.spotify.com/track/0qt5f5EL92o8Snzopsv0en"
      },
      "href": "https://api.spotify.com/v1/tracks/0qt5f5EL92o8Snzopsv0en",
      "id": "0qt5f5EL92o8Snzopsv0en",
      "is_local": false,
      "is_playable": true,
      "linked_from": {
        "external_urls": {
          "spotify": "https://open.spotify.com/track/21Go4aMyLGP40ANI3TU0Fn"
        },
        "href": "https://api.spotify.com/v1/tracks/21Go4aMyLGP40ANI3TU0Fn",
        "id": "21Go4aMyLGP40ANI3TU0Fn",
        "type": "track",
        "uri": "spotify:track:21Go4aMyLGP40ANI3TU0Fn"
      },
      "name": "Geronimo",
      "popularity": 73,
      "preview_url": null,
      "track_number": 1,
      "type": "track",
      "uri": "spotify:track:0qt5f5EL92o8Snzopsv0en"
    }
  ],
  "seeds": [
    {
      "initialPoolSize": 148,
      "afterFilteringSize": 148,
      "afterRelinkingSize": 148,
      "id": "indie-pop",
      "type": "GENRE",
      "href": null
    }
  ]
}""";
