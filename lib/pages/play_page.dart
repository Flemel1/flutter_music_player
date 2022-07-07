import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_flutter/blocs/music_bloc.dart';
import 'package:music_player_flutter/events/music_event.dart';

class PlayPage extends StatefulWidget {
  final String artist;
  final String title;
  final AudioPlayer player;

  const PlayPage(
      {Key? key,
      required this.player,
      required this.artist,
      required this.title})
      : super(key: key);

  @override
  State<PlayPage> createState() =>
      _PlayPageState(player: player, artist: artist, title: title);
}

class _PlayPageState extends State<PlayPage> {
  final String artist;
  final String title;
  final AudioPlayer player;

  _PlayPageState(
      {required this.artist, required this.title, required this.player});

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Now Playing',
          style: GoogleFonts.openSans(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  artist,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 18),
                ),
                Text(
                  title,
                  style:
                      GoogleFonts.openSans(color: Colors.white, fontSize: 14),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: StreamBuilder<Duration?>(
                    stream: player.positionStream,
                    builder: (context, snapshot) {
                      final Duration? duration = snapshot.data;
                      final Duration progress = duration ?? Duration.zero;
                      final Duration total = player.duration ?? Duration.zero;

                      return ProgressBar(
                        progress: progress,
                        total: total,
                        onSeek: (duration) {
                          player.seek(duration);
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<PlayerState>(
                      stream: player.playerStateStream,
                      builder: (context, snapshot) {
                        final playerState = snapshot.data;
                        final processingState = playerState?.processingState;
                        if (processingState == ProcessingState.loading ||
                            processingState == ProcessingState.buffering) {
                          // 2
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            width: 64.0,
                            height: 64.0,
                            child: CircularProgressIndicator(),
                          );
                        } else if (player.playing != true) {
                          // 3
                          return IconButton(
                            icon: Icon(Icons.play_arrow),
                            iconSize: 64.0,
                            onPressed: () {
                              player.play();
                              context.read<MusicBloc>().add(
                                  SelectedSong(artist: artist, title: title));
                            },
                          );
                        } else if (processingState !=
                            ProcessingState.completed) {
                          // 4
                          context
                              .read<MusicBloc>()
                              .add(SelectedSong(artist: artist, title: title));
                          return IconButton(
                            icon: Icon(Icons.pause),
                            iconSize: 64.0,
                            onPressed: player.pause,
                          );
                        } else {
                          // 5
                          return IconButton(
                            icon: Icon(Icons.replay),
                            iconSize: 64.0,
                            onPressed: () => player.seek(Duration.zero,
                                index: player.effectiveIndices?.first),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
