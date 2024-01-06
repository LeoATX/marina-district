import 'package:http/http.dart';
import 'dart:convert';
import 'main.dart';

void main() async {
  String genre = await getGenre('Marina District, San Francisco, CA');
  List<dynamic> songs = await getSongs(genre);
  print(songs);
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

Future<List> getSongs(String genre) async {
  // TODO: delete for prod, only for testing purposes
  const clientId = '783911c86b494ab282bd1623ca55998b';
  const clientSecret = 'ec709b7a62a04f10aa873ce1d49a7a86';
  dynamic response = (await post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body:
          'grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret'));
  spotifyToken = jsonDecode(response.body)['access_token'];
  // TODO: END TODO.

/*
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

  const uri = 'api.spotify.com';
  Map<String, String> headers = {'Authorization': 'Bearer $spotifyToken'};
  Map<String, String> params = {
    'market': 'US',
    'seed_genres': genre,
    'target_popularity': '100'
  };
  response = (await get(Uri.https(uri, 'v1/recommendations', params),
          headers: headers))
      .body;
  return jsonDecode(response['tracks']);
}
