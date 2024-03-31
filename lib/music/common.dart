import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/theme_config.dart';

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar({
    Key? key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  }) : super(key: key);

  @override
  SeekBarState createState() => SeekBarState();
}

class SeekBarState extends State<SeekBar> {
  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 3.0,
        thumbColor: Colors.black,
        activeTrackColor: Colors.black,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3,disabledThumbRadius: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 20,
            margin: EdgeInsets.only(right: 25,left: 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("$_dur")
                        ?.group(1) ??
                        '$_dur',
                    style: Theme.of(context).textTheme.caption),

                Text(
                    RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                        .firstMatch("$_remaining")
                        ?.group(1) ??
                        '$_remaining',
                    style: Theme.of(context).textTheme.caption),
              ],
            )
          ),
          Container(
            height: 5,
            child: Stack(
              children: [
                SliderTheme(
                  data: _sliderThemeData.copyWith(
                    thumbShape: HiddenThumbComponentShape(),
                    activeTrackColor: Colors.blue.shade100,
                    inactiveTrackColor: ThemeColor.gray25,
                    activeTickMarkColor: ThemeColor.black,
                  ),
                  child: ExcludeSemantics(
                    child: Slider(
                      min: 0.0,
                      activeColor: ThemeColor.gray25,
                      max: widget.duration.inMilliseconds.toDouble(),
                      value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                          widget.duration.inMilliseconds.toDouble()),
                      onChanged: (value) {
                        setState(() {
                          _dragValue = value;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged!(Duration(milliseconds: value.round()));
                        }
                      },
                      onChangeEnd: (value) {
                        if (widget.onChangeEnd != null) {
                          widget.onChangeEnd!(Duration(milliseconds: value.round()));
                        }
                        _dragValue = null;
                      },
                    ),
                  ),
                ),

                SliderTheme(
                  data: _sliderThemeData.copyWith(
                    inactiveTrackColor: ThemeColor.gray25,
                    activeTrackColor: Colors.black
                  ),
                  child: Slider(
                    min: 0.0,
                    max: widget.duration.inMilliseconds.toDouble(),
                    value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                        widget.duration.inMilliseconds.toDouble()),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(Duration(milliseconds: value.round()));
                      }
                    },
                    onChangeEnd: (value) {
                      if (widget.onChangeEnd != null) {
                        widget.onChangeEnd!(Duration(milliseconds: value.round()));
                      }
                      _dragValue = null;
                    },
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  Duration get _remaining => widget.duration - widget.position;
  Duration get _dur => widget.duration;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 5.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
