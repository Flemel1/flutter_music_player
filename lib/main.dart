import 'package:flutter/material.dart';

// @dart=2.9
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_flutter/blocs/music_bloc.dart';
import 'package:music_player_flutter/card.dart';
import 'package:music_player_flutter/events/music_event.dart';
import 'package:music_player_flutter/model/song_model.dart';
import 'package:music_player_flutter/pages/play_page.dart';
import 'package:music_player_flutter/states/music_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MusicBloc>(
      create: (context) => MusicBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'Flutter Music Player'),
        },
        onGenerateRoute: (RouteSettings settings) {
          final routes = <String, WidgetBuilder>{
            '/play': (context) {
              final Map<String, dynamic> arguments =
                  settings.arguments as Map<String, dynamic>;
              final AudioPlayer player = arguments['player'];
              final String artist = arguments['artist'];
              final String title = arguments['title'];
              return PlayPage(
                player: player,
                artist: artist,
                title: title,
              );
            },
          };
          WidgetBuilder builder = routes[settings.name]!;
          return MaterialPageRoute(builder: (context) => builder(context));
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();

  Future<List<SongInfo>> _fetchingSongs() async {
    final songs =
        await FlutterAudioQuery().getSongs(sortType: SongSortType.RECENT_YEAR);
    return songs;
  }

  void _playingSong(
      {required String path,
      required String artist,
      required String title}) async {
    final duration = await player.setFilePath(path);
    final arguments = <String, dynamic>{
      'player': player,
      'artist': artist,
      'title': title
    };
    // await player.play();
    Navigator.pushNamed(context, '/play', arguments: arguments);
  }

  @override
  void dispose() {

    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121112),
      body: BlocBuilder<MusicBloc, MusicState>(
        builder: (context, state) {
          if (state.status == MusicStatus.loading || state.status == MusicStatus.error) {
            print('loading..');
            context.read<MusicBloc>().add(GetSongs());
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<Song> allSong = state.songs;
          return ListView.builder(
            itemBuilder: (context, index) {
              final artist = allSong[index].artist;
              final title = allSong[index].title;
              final millis = int.parse(allSong[index].duration);
              final path = allSong[index].path;
              final isPlaying = allSong[index].isPlaying;

              return GestureDetector(
                onTap: () =>
                    _playingSong(path: path, artist: artist, title: title),
                child: SongCard(
                  artist: artist,
                  title: title,
                  millis: millis,
                  isPlaying: isPlaying,
                ),
              );
            },
            itemCount: allSong.length,
          );
        },
      ),
    );
  }
}
