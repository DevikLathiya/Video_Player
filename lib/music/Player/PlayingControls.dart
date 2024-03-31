import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class PlayingControls extends StatelessWidget {
  final bool isPlaying;
  final LoopMode? loopMode;
  final bool isPlaylist;
  final Function()? onPrevious;
  final Function() onPlay;
  final Function()? onNext;
  final Function()? toggleLoop;
  final Function()? onStop;

  PlayingControls({
    required this.isPlaying,
    this.isPlaylist = false,
    this.loopMode,
    this.toggleLoop,
    this.onPrevious,
    required this.onPlay,
    this.onNext,
    this.onStop,
  });

  Widget _loopIcon(BuildContext context) {
    final iconSize = 34.0;
    if (loopMode == LoopMode.none) {
      return Container(
        margin: EdgeInsets.only(right: 15),
        child: Icon(
        Icons.repeat,
        size: 22,
        color: Colors.grey,
      ),
      );
    } else if (loopMode == LoopMode.playlist) {
      return Icon(
        Icons.repeat,
        size: 22,
        color: Colors.black,
      );
    } else {
      //single
      return Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.repeat_one,
            size: 22,
            color: Colors.black,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: () {
            if (toggleLoop != null) toggleLoop!();
          },
          child: _loopIcon(context),
        ),
        SizedBox(
          width: 12,
        ),
        GestureDetector(
          onTap: isPlaylist ? onPrevious : null,
          child: Icon(Icons.fast_rewind),
        ),
        SizedBox(
          width: 12,
        ),
        GestureDetector(
          onTap: onPlay,
          child: Icon(
            isPlaying
                ? Icons.pause
                : Icons.play_arrow,
            size: 32,
          ),
        ),
        SizedBox(
          width: 12,
        ),
        GestureDetector(
          onTap: isPlaylist ? onNext : null,
          child: Icon(Icons.fast_forward),
        ),
        SizedBox(
          width: 25,
        ),
        if (onStop != null)
          GestureDetector(
            onTap: onPlay,
            child: Icon(
              Icons.shuffle,
              size: 22,
            ),
          ),
      ],
    );
  }
}
