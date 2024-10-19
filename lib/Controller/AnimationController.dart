import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimateController extends GetxController {
//Hero
  void showSecondPage(tag, image, BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false, // Make sure the background is not fully opaque
      pageBuilder: (BuildContext context, _, __) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.2), // Slightly dark background
          body:Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Center(
                      child: Hero(
                        tag: tag,
                        child: CachedNetworkImage(
                          imageUrl: image,
                        ),
                      )),
                ),
                Positioned(
                    top: 10,
                    right: 8,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        )))
              ],
            ));}));
  }
}
