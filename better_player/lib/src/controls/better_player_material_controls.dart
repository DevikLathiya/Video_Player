import 'dart:async';
import 'dart:ui';
import 'package:better_player/src/configuration/better_player_controls_configuration.dart';
import 'package:better_player/src/controls/better_player_clickable_widget.dart';
import 'package:better_player/src/controls/better_player_controls_state.dart';
import 'package:better_player/src/controls/better_player_material_progress_bar.dart';
import 'package:better_player/src/controls/better_player_multiple_gesture_detector.dart';
import 'package:better_player/src/controls/better_player_progress_colors.dart';
import 'package:better_player/src/core/better_player_controller.dart';
import 'package:better_player/src/core/better_player_utils.dart';
import 'package:better_player/src/video_player/video_player.dart';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BetterPlayerMaterialControls extends StatefulWidget {
  ///Callback used to send information if player bar is hidden or not
  final Function(bool visbility) onControlsVisibilityChanged;

  ///Controls config
  final BetterPlayerControlsConfiguration controlsConfiguration;
  final int? amountGiven;
  final ValueNotifier<String> movieName;
  final ValueNotifier<int>? currentIndex;
  final ValueNotifier<int>? previousIndex;
  final ValueNotifier<int>? nextIndex;
  final bool isPortrait;
  final int? avgRuntime;
  final String? videoType;
  final GestureTapCallback? onDialogShow;
  final GestureTapCallback? onPrevious;
  final GestureTapCallback? onNext;
  final GestureTapCallback onTap;
  final ValueNotifier<bool>? autoPlay;
  final void Function(bool)? onChanged;
  BetterPlayerMaterialControls({
    Key? key,
    required this.onControlsVisibilityChanged,
    required this.controlsConfiguration,
    required this.movieName,
    this.amountGiven,
    this.avgRuntime,
    this.videoType,
    this.onDialogShow,
    required this.isPortrait,
    required this.onTap,
    this.onPrevious,
    this.onNext,
    this.currentIndex,
    this.previousIndex,
    this.nextIndex,
    this.autoPlay,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BetterPlayerMaterialControlsState();
  }
}

class _BetterPlayerMaterialControlsState
    extends BetterPlayerControlsState<BetterPlayerMaterialControls> {
  VideoPlayerValue? _latestValue;
  double? _latestVolume;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _displayTapped = false;
  bool _wasLoading = false;
  VideoPlayerController? _controller;
  BetterPlayerController? _betterPlayerController;
  StreamSubscription? _controlsVisibilityStreamSubscription;
  bool isDialogShow = false;

  BetterPlayerControlsConfiguration get _controlsConfiguration =>
      widget.controlsConfiguration;

  bool isLockedControls = false;

  @override
  VideoPlayerValue? get latestValue => _latestValue;

  @override
  BetterPlayerController? get betterPlayerController => _betterPlayerController;

  @override
  BetterPlayerControlsConfiguration get betterPlayerControlsConfiguration =>
      _controlsConfiguration;

  @override
  Widget build(BuildContext context) {
    return buildLTRDirectionality(_buildMainWidget());
  }

  ///Builds main widget of the controls.
  Widget _buildMainWidget() {
    _wasLoading = isLoading(_latestValue);
    if (_latestValue?.hasError == true) {
      return Container(
        color: Colors.black,
        child: _buildErrorWidget(),
      );
    }
    return WillPopScope(
      onWillPop: () {
        if (!widget.isPortrait) {
          Navigator.of(context);
          widget.onTap.call();
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitDown,
            DeviceOrientation.portraitUp,
          ]);
        }
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () {
          if (BetterPlayerMultipleGestureDetector.of(context) != null) {
            BetterPlayerMultipleGestureDetector.of(context)!.onTap?.call();
          }

          if (!isLockedControls) {
            controlsNotVisible
                ? cancelAndRestartTimer()
                : changePlayerControlsNotVisible(true);
          }
        },
        onDoubleTap: () {
          if (BetterPlayerMultipleGestureDetector.of(context) != null) {
            BetterPlayerMultipleGestureDetector.of(context)!
                .onDoubleTap
                ?.call();
          }
          if (!isLockedControls) cancelAndRestartTimer();
        },
        onLongPress: () {
          if (BetterPlayerMultipleGestureDetector.of(context) != null) {
            BetterPlayerMultipleGestureDetector.of(context)!
                .onLongPress
                ?.call();
          }
        },
        child: Stack(
          children: [
            AbsorbPointer(
              absorbing: controlsNotVisible,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_wasLoading)
                    Center(child: _buildLoadingWidget())
                  // else
                  //   _buildHitArea(),
                  else
                    Container(
                        child: Center(
                            child: AnimatedOpacity(
                      opacity: controlsNotVisible ? 0.0 : 1.0,
                      duration: _controlsConfiguration.controlsHideTime,
                      onEnd: _onPlayerHide,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: Colors.black54,
                      ),
                    ))),
                  if (!_wasLoading)
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: _buildTopBar(),
                    ),
                  if (!_wasLoading)
                    Positioned(
                        bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
                  _buildNextVideoWidget(),
                ],
              ),
            ),
            if (!_wasLoading)
              Positioned(
                  bottom: 10,
                  left: 0,
                  child: AnimatedOpacity(
                    opacity:
                        controlsNotVisible && !isLockedControls ? 0.0 : 1.0,
                    duration: _controlsConfiguration.controlsHideTime,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isLockedControls = !isLockedControls;
                            if (isLockedControls) {
                              controlsNotVisible = true;
                            } else {
                              controlsNotVisible = false;
                            }
                          });
                        },
                        icon: Icon(
                          isLockedControls
                              ? Icons.lock_outline
                              : Icons.lock_open_outlined,
                          color: Colors.white,
                        )),
                  )),
            if (isDialogShow && widget.amountGiven != null)
              Align(
                alignment: Alignment(0.0, 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      width: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 400
                          : 300,
                      height: MediaQuery.of(context).orientation ==
                              Orientation.landscape
                          ? 230
                          : 170,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white30,
                            width: 2,
                          )),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              isDialogShow = false;
                              setState(() {});
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 2,
                                        color: Colors.amber,
                                      )),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.amber,
                                  )),
                            ),
                          ),
                          Text(
                            'You Won',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: MediaQuery.of(context).orientation ==
                                        Orientation.landscape
                                    ? 16
                                    : 12,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 20
                                : 10,
                          ),
                          Image.asset(
                            'assets/coin.png',
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? null
                                : 20,
                            width: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? null
                                : 20,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 8
                                : 2,
                          ),
                          Text(
                            '${widget.amountGiven} Coins',
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'Thank you for watching!!!',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    _controller?.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
    _controlsVisibilityStreamSubscription?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = _betterPlayerController;
    _betterPlayerController = BetterPlayerController.of(context);
    _controller = _betterPlayerController!.videoPlayerController;
    _latestValue = _controller!.value;
    // if (_betterPlayerController != null) {
    //   _betterPlayerController!.addEventsListener((p0) {
    //     if (_controller!.value.duration != null) {
    //       if (_controller!.value.position.inSeconds ==
    //           _controller!.value.duration!.inSeconds) {
    //         if (widget.autoPlay!.value) {
    //           if (widget.nextIndex != null) {
    //             if (widget.nextIndex!.value != -1) {
    //               //   widget.onNext!.call();
    //             }
    //           } else {
    //             //   widget.onNext!.call();
    //           }
    //         }
    //       }
    //     }
    //   });
    // }

    if (_betterPlayerController != null &&
        widget.videoType != null &&
        widget.onDialogShow != null) {
      _betterPlayerController!.addEventsListener((p0) {
        if (_controller != null) {
          if (_controller!.value.position.inSeconds == widget.avgRuntime) {
            if (widget.videoType == "Schemes") {
              isDialogShow = true;
            }
            widget.onDialogShow!.call();
            setState(() {});
          }
        }
      });
    }
    if (_oldController != _betterPlayerController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  Widget _buildErrorWidget() {
    final errorBuilder =
        _betterPlayerController!.betterPlayerConfiguration.errorBuilder;
    if (errorBuilder != null) {
      return errorBuilder(
          context,
          _betterPlayerController!
              .videoPlayerController!.value.errorDescription);
    } else {
      final textStyle = TextStyle(color: _controlsConfiguration.textColor);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              color: _controlsConfiguration.iconsColor,
              size: 42,
            ),
            Text(
              _betterPlayerController!.translations.generalDefaultError,
              style: textStyle,
            ),
            if (_controlsConfiguration.enableRetry)
              TextButton(
                onPressed: () {
                  _betterPlayerController!.retryDataSource();
                },
                child: Text(
                  _betterPlayerController!.translations.generalRetry,
                  style: textStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              )
          ],
        ),
      );
    }
  }

  Widget _buildTopBar() {
    if (!betterPlayerController!.controlsEnabled) {
      return const SizedBox();
    }

    return Container(
      child: (_controlsConfiguration.enableOverflowMenu)
          ? AnimatedOpacity(
              opacity: controlsNotVisible ? 0.0 : 1.0,
              duration: _controlsConfiguration.controlsHideTime,
              onEnd: _onPlayerHide,
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Visibility(
                            // visible: betterPlayerController!.isFullScreen,
                            child: IconButton(
                                onPressed: () {
                                  if (!betterPlayerController!.isFullScreen) {
                                    Navigator.pop(context);
                                  } else {
                                    _onExpandCollapse();
                                  }
                                },
                                icon: Icon(
                                  !betterPlayerController!.isFullScreen
                                      ? Icons.arrow_back
                                      : Icons.cancel, // Kishor
                                  color: !betterPlayerController!.isFullScreen
                                      ? Colors.white
                                      : betterPlayerControlsConfiguration
                                          .progressBarPlayedColor,
                                  size: 25,
                                )),
                          ),
                          Expanded(
                            child: ValueListenableBuilder<String>(
                                valueListenable: widget.movieName,
                                builder: (context, movieName, _) {
                                  return Text(
                                    movieName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.symmetric(
                        //       vertical: 12,
                        //       horizontal: MediaQuery.of(context).orientation ==
                        //               Orientation.landscape
                        //           ? 30
                        //           : 20),
                        //   child: ValueListenableBuilder<bool>(
                        //       valueListenable: widget.autoPlay!,
                        //       builder: (context, value, _) {
                        //         return Switch(
                        //           value: value,
                        //           onChanged: widget.onChanged,
                        //           activeColor: const Color(0xffFECC00),
                        //           activeTrackColor:
                        //               betterPlayerControlsConfiguration
                        //                   .progressBarPlayedColor,
                        //         );
                        //       }),
                        // ),

                        BetterPlayerMaterialClickableWidget(
                            onTap: () {
                              onShowMoreClicked();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal:
                                      MediaQuery.of(context).orientation ==
                                              Orientation.landscape
                                          ? 30
                                          : 20),
                              child: Icon(
                                Icons.settings_outlined,
                                color: _controlsConfiguration.iconsColor,
                              ),
                            )),
                        // BetterPlayerMaterialClickableWidget(
                        //     onTap: () {},
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(
                        //           vertical: 12,
                        //           horizontal: MediaQuery.of(context).orientation ==
                        //                   Orientation.landscape
                        //               ? 30
                        //               : 20),
                        //       child: Icon(
                        //         Icons.cast_outlined,
                        //         color: _controlsConfiguration.iconsColor,
                        //       ),
                        //     )),
                        if (_controlsConfiguration.enablePip)
                          _buildPipButtonWrapperWidget(
                              controlsNotVisible, _onPlayerHide)
                        else
                          const SizedBox(),
                        // _buildMoreButton(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox(),
    );
  }

  Widget _buildPipButton() {
    return BetterPlayerMaterialClickableWidget(
      onTap: () {
        betterPlayerController!.enablePictureInPicture(
            betterPlayerController!.betterPlayerGlobalKey!);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          betterPlayerControlsConfiguration.pipMenuIcon,
          color: betterPlayerControlsConfiguration.iconsColor,
        ),
      ),
    );
  }

  Widget _buildPipButtonWrapperWidget(
      bool hideStuff, void Function() onPlayerHide) {
    return FutureBuilder<bool>(
      future: betterPlayerController!.isPictureInPictureSupported(),
      builder: (context, snapshot) {
        final bool isPipSupported = snapshot.data ?? false;
        if (isPipSupported &&
            _betterPlayerController!.betterPlayerGlobalKey != null) {
          return AnimatedOpacity(
            opacity: hideStuff ? 0.0 : 1.0,
            duration: betterPlayerControlsConfiguration.controlsHideTime,
            onEnd: onPlayerHide,
            child: Container(
              height: betterPlayerControlsConfiguration.controlBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildPipButton(),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildMoreButton() {
    return BetterPlayerMaterialClickableWidget(
      onTap: () {
        // onShowMoreClicked();
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          _controlsConfiguration.overflowMenuIcon,
          color: _controlsConfiguration.iconsColor,
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    if (!betterPlayerController!.controlsEnabled) {
      return const SizedBox();
    }
    return AnimatedOpacity(
      opacity: controlsNotVisible ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      onEnd: _onPlayerHide,
      child: Container(
        height: _controlsConfiguration.controlBarHeight + 40.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  if (_controlsConfiguration.enablePlayPause)
                    _buildPlayPause(_controller!)
                  else
                    const SizedBox(),
                  if (_betterPlayerController!.isLiveStream())
                    _buildLiveWidget()
                  else
                    _controlsConfiguration.enableProgressText
                        ? Expanded(flex: 1, child: _buildPosition())
                        : const SizedBox(),
                  //const Spacer(),
                  if (_controlsConfiguration.enableMute)
                    _buildMuteButton(_controller)
                  else
                    const SizedBox(),
                  // if (_controlsConfiguration.enableFullscreen)
                  //   _buildExpandButton()
                  // else
                  //   const SizedBox(),
                ],
              ),
            ),
            if (_betterPlayerController!.isLiveStream()) const SizedBox(),
            if (!_wasLoading)
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildHitArea(),
                  )),

            // else
            //   _controlsConfiguration.enableProgressBar
            //       ? _buildProgressBar()
            //       : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveWidget() {
    return Text(
      _betterPlayerController!.translations.controlsLive,
      style: TextStyle(
          color: _controlsConfiguration.liveTextColor,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _buildExpandButton() {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: BetterPlayerMaterialClickableWidget(
        onTap: _onExpandCollapse,
        child: Container(
          height: _controlsConfiguration.controlBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Icon(
              _betterPlayerController!.isFullScreen
                  ? _controlsConfiguration.fullscreenDisableIcon
                  : _controlsConfiguration.fullscreenEnableIcon,
              color: _controlsConfiguration.iconsColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHitArea() {
    if (!betterPlayerController!.controlsEnabled) {
      return const SizedBox();
    }
    return _buildMiddleRow();
  }

  Widget _buildMiddleRow() {
    final isLandsScanp =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: _betterPlayerController?.isLiveStream() == true
          ? const SizedBox()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      changePlayerControlsNotVisible(false);
                      _hideTimer?.cancel();
                    },
                    icon: SizedBox()),
                //  Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (_controlsConfiguration.enableSkips)
                      _buildSkipButton()
                    else
                      const SizedBox(),
                    SizedBox(width: isLandsScanp ? 50 : 3),
                    ValueListenableBuilder<int>(
                        valueListenable:
                            widget.previousIndex ?? ValueNotifier(-1),
                        builder: (context, value, _) {
                          return IconButton(
                              onPressed: value == -1 ? null : widget.onPrevious,
                              icon: Image.asset(
                                'assets/previous.png',
                                width: 15,
                                height: 15,
                                color: value == -1
                                    ? Theme.of(context).disabledColor
                                    : Colors.white,
                              ));
                        }),
                    SizedBox(width: isLandsScanp ? 50 : 3),
                    _buildReplayButton(_controller!),
                    SizedBox(width: isLandsScanp ? 50 : 3),
                    ValueListenableBuilder<int>(
                        valueListenable: widget.nextIndex ?? ValueNotifier(-1),
                        builder: (context, value, _) {
                          return IconButton(
                              onPressed: value == -1 ? null : widget.onNext,
                              icon: Image.asset(
                                'assets/next_video.png',
                                width: 15,
                                height: 15,
                                color: value == -1
                                    ? Theme.of(context).disabledColor
                                    : Colors.white,
                              ));
                        }),
                    SizedBox(width: isLandsScanp ? 50 : 3),
                    if (_controlsConfiguration.enableSkips)
                      _buildForwardButton()
                    else
                      const SizedBox(),
                  ],
                ),

                //  Spacer(),

                if (_controlsConfiguration.enableFullscreen)
                  _buildExpandButton()
                else
                  const SizedBox(),

                // BetterPlayerMaterialClickableWidget(
                //     onTap: () {},
                //     child: Padding(
                //       padding: EdgeInsets.all(8),
                //       child: Icon(
                //         Icons.lock_outline,
                //         color: _controlsConfiguration.iconsColor,
                //       ),
                //     )),
              ],
            ),
    );
  }

  Widget _buildHitAreaClickableButton(
      {Widget? icon, required void Function() onClicked}) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 80.0, maxWidth: 80.0),
      child: BetterPlayerMaterialClickableWidget(
        onTap: onClicked,
        child: Align(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(48),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [icon!],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return IconButton(
      icon: Image.asset(
        'assets/rewind.png',
        width: 26,
        height: 26,
        color: _controlsConfiguration.iconsColor,
      ),
      onPressed: skipBack,
    );
  }

  Widget _buildForwardButton() {
    return IconButton(
      icon: Image.asset(
        'assets/forward.png',
        width: 24,
        height: 24,
        color: _controlsConfiguration.iconsColor,
      ),
      onPressed: skipForward,
    );
  }

  Widget _buildReplayButton(VideoPlayerController controller) {
    final bool isFinished = isVideoFinished(_latestValue);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          shape: BoxShape.circle),
      child: IconButton(
        icon: isFinished
            ? Icon(
                Icons.replay,
                size: 28,
                color: _controlsConfiguration.iconsColor,
              )
            : Icon(
                controller.value.isPlaying
                    ? _controlsConfiguration.pauseIcon
                    : _controlsConfiguration.playIcon,
                size: 28,
                color: _controlsConfiguration.iconsColor,
              ),
        onPressed: () {
          if (isFinished) {
            if (_latestValue != null && _latestValue!.isPlaying) {
              if (_displayTapped) {
                changePlayerControlsNotVisible(true);
              } else {
                cancelAndRestartTimer();
              }
            } else {
              _onPlayPause();
              changePlayerControlsNotVisible(true);
            }
          } else {
            _onPlayPause();
          }
        },
      ),
    );
  }

  Widget _buildNextVideoWidget() {
    return StreamBuilder<int?>(
      stream: _betterPlayerController!.nextVideoTimeStream,
      builder: (context, snapshot) {
        final time = snapshot.data;
        if (time != null && time > 0) {
          return BetterPlayerMaterialClickableWidget(
            onTap: () {
              _betterPlayerController!.playNextVideo();
            },
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(
                    bottom: _controlsConfiguration.controlBarHeight + 20,
                    right: 24),
                decoration: BoxDecoration(
                  color: _controlsConfiguration.controlBarColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    "${_betterPlayerController!.translations.controlsNextVideoIn} $time...",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildMuteButton(
    VideoPlayerController? controller,
  ) {
    return BetterPlayerMaterialClickableWidget(
      onTap: () {
        cancelAndRestartTimer();
        if (_latestValue!.volume == 0) {
          _betterPlayerController!.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller!.value.volume;
          _betterPlayerController!.setVolume(0.0);
        }
      },
      child: ClipRect(
        child: Container(
          height: _controlsConfiguration.controlBarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            (_latestValue != null && _latestValue!.volume > 0)
                ? _controlsConfiguration.muteIcon
                : _controlsConfiguration.unMuteIcon,
            color: _controlsConfiguration.iconsColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPause(VideoPlayerController controller) {
    return BetterPlayerMaterialClickableWidget(
      key: const Key("better_player_material_controls_play_pause_button"),
      onTap: _onPlayPause,
      child: Container(
        height: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Icon(
          controller.value.isPlaying
              ? _controlsConfiguration.pauseIcon
              : _controlsConfiguration.playIcon,
          color: _controlsConfiguration.iconsColor,
        ),
      ),
    );
  }

  Widget _buildPosition() {
    final position =
        _latestValue != null ? _latestValue!.position : Duration.zero;
    final duration = _latestValue != null && _latestValue!.duration != null
        ? _latestValue!.duration!
        : Duration.zero;

    return Padding(
      padding: _controlsConfiguration.enablePlayPause
          ? const EdgeInsets.only(right: 24)
          : const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Text(
            BetterPlayerUtils.formatDuration(position),
            style: TextStyle(
              fontSize: 10.0,
              color: _controlsConfiguration.textColor,
              decoration: TextDecoration.none,
            ),
          ),
          _buildProgressBar(),
          Text(
            BetterPlayerUtils.formatDuration(duration),
            style: TextStyle(
              fontSize: 10.0,
              color: _controlsConfiguration.textColor,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    changePlayerControlsNotVisible(false);
    _displayTapped = true;
  }

  Future<void> _initialize() async {
    _controller!.addListener(_updateState);

    _updateState();

    if ((_controller!.value.isPlaying) ||
        _betterPlayerController!.betterPlayerConfiguration.autoPlay) {
      _startHideTimer();
    }

    if (_controlsConfiguration.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        changePlayerControlsNotVisible(false);
      });
    }

    _controlsVisibilityStreamSubscription =
        _betterPlayerController!.controlsVisibilityStream.listen((state) {
      changePlayerControlsNotVisible(!state);
      if (!controlsNotVisible) {
        cancelAndRestartTimer();
      }
    });
  }

  void _onExpandCollapse() {
    if (widget.isPortrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ]);
    }
    changePlayerControlsNotVisible(true);
    _betterPlayerController!.toggleFullScreen(ontap: widget.onTap);
    _showAfterExpandCollapseTimer =
        Timer(_controlsConfiguration.controlsHideTime, () {
      setState(() {
        cancelAndRestartTimer();
      });
    });
  }

  void _onPlayPause() {
    bool isFinished = false;

    if (_latestValue?.position != null && _latestValue?.duration != null) {
      isFinished = _latestValue!.position >= _latestValue!.duration!;
    }

    if (_controller!.value.isPlaying) {
      changePlayerControlsNotVisible(false);
      _hideTimer?.cancel();
      _betterPlayerController!.pause();
    } else {
      cancelAndRestartTimer();

      if (!_controller!.value.initialized) {
      } else {
        if (isFinished) {
          _betterPlayerController!.seekTo(const Duration());
        }
        _betterPlayerController!.play();
        _betterPlayerController!.cancelNextVideoTimer();
      }
    }
  }

  void _startHideTimer() {
    if (_betterPlayerController!.controlsAlwaysVisible) {
      return;
    }
    _hideTimer = Timer(const Duration(milliseconds: 3000), () {
      changePlayerControlsNotVisible(true);
    });
  }

  void _updateState() {
    if (mounted) {
      if (!controlsNotVisible ||
          isVideoFinished(_controller!.value) ||
          _wasLoading ||
          isLoading(_controller!.value)) {
        setState(() {
          _latestValue = _controller!.value;
          if (isVideoFinished(_latestValue) &&
              _betterPlayerController?.isLiveStream() == false) {
            changePlayerControlsNotVisible(false);
          }
        });
      }
    }
  }

  Widget _buildProgressBar() {
    return Expanded(
      //flex: 40,
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: BetterPlayerMaterialVideoProgressBar(
          _controller,
          _betterPlayerController,
          onDragStart: () {
            _hideTimer?.cancel();
          },
          onDragEnd: () {
            _startHideTimer();
          },
          onTapDown: () {
            cancelAndRestartTimer();
          },
          colors: BetterPlayerProgressColors(
              playedColor: _controlsConfiguration.progressBarPlayedColor,
              handleColor: _controlsConfiguration.progressBarHandleColor,
              bufferedColor: _controlsConfiguration.progressBarBufferedColor,
              backgroundColor:
                  _controlsConfiguration.progressBarBackgroundColor),
        ),
      ),
    );
  }

  void _onPlayerHide() {
    _betterPlayerController!.toggleControlsVisibility(!controlsNotVisible);
    widget.onControlsVisibilityChanged(!controlsNotVisible);
  }

  Widget? _buildLoadingWidget() {
    if (_controlsConfiguration.loadingWidget != null) {
      return Container(
        color: _controlsConfiguration.controlBarColor,
        child: _controlsConfiguration.loadingWidget,
      );
    }

    return CircularProgressIndicator(
      valueColor:
          AlwaysStoppedAnimation<Color>(_controlsConfiguration.loadingColor),
    );
  }
}
