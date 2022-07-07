import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player_flutter/model/song_model.dart';
import 'package:music_player_flutter/states/music_state.dart';

import '../events/music_event.dart';

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(const MusicState()) {
    on<GetSongs>(_fetchingSongs);
    on<SelectedSong>(_selectedSong);
  }

  void _fetchingSongs(GetSongs event, Emitter<MusicState> emitter) async {
    try {
      final List<SongInfo> songs = await FlutterAudioQuery()
          .getSongs(sortType: SongSortType.RECENT_YEAR);
      final List<Song> mySongs = songs.map((song) {
        return Song(artist: song.artist, title: song.title, path: song.filePath, duration: song.duration);
      }).toList();
      emit(state.copyWith(songs: mySongs, status: MusicStatus.loaded));
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(songs: <Song>[], status: MusicStatus.error));
    }
  }

  void _selectedSong(SelectedSong event, Emitter<MusicState> emitter) {
    final artist = event.artist;
    final title = event.title;
    final List<Song> currentSongs = state.songs;
    final List<Song> playingSongs = currentSongs.map((song) {
      final isPlaying = (song.artist == artist && song.title == title) ? true : false;
      return Song(artist: song.artist, title: song.title, path: song.path, duration: song.duration, isPlaying: isPlaying);
    }).toList();
    emit(state.copyWith(songs: playingSongs, status: MusicStatus.loaded));
  }
}
