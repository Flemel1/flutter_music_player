

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SongCard extends StatelessWidget {
  final String artist;
  final String title;
  final bool isPlaying;
  final int millis;

  const SongCard(
      {Key? key,
      required this.artist,
      required this.title,
      required this.millis,
      required this.isPlaying})
      : super(key: key);

  String _millisToMinutes(int millis) {
    var minutes = (millis / 60000).floor();
    var seconds = int.parse(((millis % 60000) / 1000).toStringAsFixed(0));
    return "${minutes}. ${seconds < 10 ? '0' : seconds}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(15.0),
      color: Color(0xFF1E1D1D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlutterLogo(
              size: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: Text(
                    artist,
                    softWrap: true,
                    style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    title,
                    style:
                        GoogleFonts.openSans(color: Colors.white, fontSize: 12),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        _millisToMinutes(millis),
                        style: GoogleFonts.openSans(
                            color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(
                        width: 35,
                      ),
                      isPlaying ? Text('Playing Now', style: GoogleFonts.openSans(color: Colors.white),) : Text(''),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
