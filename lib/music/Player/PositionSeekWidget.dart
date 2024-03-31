
import 'package:flutter/material.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const PositionSeekWidget({
    required this.currentPosition,
    required this.duration,
    required this.seekTo,
  });

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 15,right: 15,top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: Text(durationToString(widget.currentPosition)),
                ),
                SizedBox(
                  child: Text(durationToString(widget.duration)),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 5,left: 5,right: 5),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.black,
                inactiveTrackColor: Colors.black12,
                trackShape: RectangularSliderTrackShape(),
                trackHeight: 3.0,
                thumbColor: Colors.black87,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayColor: Colors.black87.withAlpha(32),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
              ),
              child: Container(
                child: Slider(
                  min: 0,
                  max: widget.duration.inMilliseconds.toDouble(),
                  value: percent * widget.duration.inMilliseconds.toDouble(),
                  onChangeEnd: (newValue) {
                    setState(() {
                      listenOnlyUserInterraction = false;
                      widget.seekTo(_visibleValue);
                    });
                  },
                  onChangeStart: (_) {
                    setState(() {
                      listenOnlyUserInterraction = true;
                    });
                  },
                  onChanged: (newValue) {
                    setState(() {
                      final to = Duration(milliseconds: newValue.floor());
                      _visibleValue = to;
                    });
                  },
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
