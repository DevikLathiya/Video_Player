import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:get/get.dart';
class SongsSelector extends StatelessWidget {
  final Playing? playing;
  final List<Audio> audios;
  final Function(Audio) onSelected;
  final Function(List<Audio>) onPlaylistSelected;

  const SongsSelector(
      {required this.playing,
      required this.audios,
      required this.onSelected,
      required this.onPlaylistSelected});

  Widget _image(Audio item) {
    if (item.metas.image == null) {
      return const SizedBox(height: 40, width: 40);
    }

    return item.metas.image?.type == ImageType.network
        ? CommonImage(
            imageUrl: item.metas.image!.path,
            height: 40,
            width: 40,
          )
        : Image.asset(
            item.metas.image!.path,
            height: 40,
            width: 40,
            fit: BoxFit.cover,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 1,
            child: InkWell(
              onTap: () {
                onPlaylistSelected(audios);
              },
              child:  Center(child: Text("All as playlist".tr)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, position) {
                final item = audios[position];
                final isPlaying = item.path == playing?.audio.assetAudioPath;
                return Container(
                  margin: const EdgeInsets.all(4),
                  child: ListTile(
                      leading: Material(
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: _image(item),
                      ),
                      title: Text(item.metas.title.toString(),
                          style: TextStyle(
                            color: isPlaying ? Colors.blue : Colors.black,
                          )),
                      onTap: () {
                        onSelected(item);
                      }),
                );
              },
              itemCount: audios.length,
            ),
          ),
        ],
      ),
    );
  }
}
