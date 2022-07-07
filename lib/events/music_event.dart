import 'package:equatable/equatable.dart';

class MusicEvent extends Equatable {
  @override

  List<Object?> get props => [];
}

class GetSongs extends MusicEvent {}

class SelectedSong extends MusicEvent {
  final String artist;
  final String title;

  SelectedSong({required this.artist, required this.title});

  @override

  List<Object?> get props => [artist, title];
}