import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/app_images.dart';

class CommonImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  const CommonImage({
    Key? key,
    required this.imageUrl,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: AppImages.placeholdersSlide,
      image: imageUrl,
      height: height,
      width: width,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/logo_new.png'),
    );
  }
}
