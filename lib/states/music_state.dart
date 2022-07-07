import 'package:equatable/equatable.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player_flutter/model/song_model.dart';

enum MusicStatus { loading, loaded, error }

class MusicState extends Equatable {
  final List<Song> songs;
  final MusicStatus status;

  const MusicState(
      {this.status = MusicStatus.loading, this.songs = const <Song>[]});

  MusicState copyWith(
      {required List<Song> songs, required MusicStatus status}) {
    return MusicState(songs: songs, status: status);
  }

  @override
  List<Object?> get props => [songs, status];
}
