import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageFromUrl extends StatelessWidget {
  final String? imageUrl;

  const ImageFromUrl({this.imageUrl});

  @override
  Widget build(BuildContext context) {

    final themeColor = Theme.of(context).primaryColor;

    final isInvalidUrl =
        (imageUrl != null) ? imageUrl!.startsWith("http") : false;

    if (imageUrl == null || imageUrl == "" || !isInvalidUrl) {
      return const Icon(Icons.broken_image);
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            color: themeColor,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.broken_image),
        //これ要るみたい
        fit: BoxFit.cover,
      );
    }
  }
}
