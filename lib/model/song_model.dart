class Song {
  final String artist;
  final String title;
  final String path;
  final String duration;
  final bool isPlaying;

  const Song(
      {required this.artist,
      required this.title,
      required this.path,
      required this.duration,
      this.isPlaying = false});
}
