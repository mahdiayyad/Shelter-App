import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shelter/style/AssetsKeys.dart';
import 'package:websafe_svg/websafe_svg.dart';

//*************************************************************************************/
//**************************************ImageLoader************************************/
//*************************************************************************************/

/// this is the image loader that takes the path of the image
class ImageLoader extends StatelessWidget {
  final String? path;
  final String? ph;
  final Color? color;
  final BoxFit? fit;
  final double? height;
  final double? width;
  const ImageLoader(
      {Key? key,
      required this.path,
      this.fit,
      this.height,
      this.width,
      this.ph,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (path?.isEmpty ?? true) {
      return Image.asset(
        ph ?? ImageAssets.placeholder,
        width: width,
        height: height,
        fit: fit,
      );
    }
    if (kIsWeb) {
      if (path!.contains('http')) {
        return Image.network(path!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, url, error) {
          return Image.asset(
            ph ?? ImageAssets.placeholder,
            width: width,
            height: height,
            fit: fit,
          );
        });
      } else if (path!.contains('image_picker')) {
        return Image.file(
          File(path!),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      } else if (path!.endsWith('svg')) {
        return WebsafeSvg.asset(
          path!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      } else {
        return Image.asset(
          path!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      }
    } else {
      if (path!.contains('http')) {
        return CachedNetworkImage(
            maxHeightDiskCache: 300,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            // httpHeaders: Session.getSessionHeaders(),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
                    child: SizedBox(
                  height: 30,
                  width: 30,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                )),
            errorWidget: (context, url, error) => Image.asset(
                  ph ?? ImageAssets.placeholder,
                  height: height,
                  width: width,
                  fit: fit,
                ),
            imageUrl: path!);
      } else if (path!.contains('/cache')) {
        return Image.file(
          File(path!),
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      } else if (path!.endsWith('svg')) {
        return WebsafeSvg.asset(
          path!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      } else {
        return Image.asset(
          path!,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
      }
    }
  }

  double? progress(int? totalSize, int downloaded) {
    // ignore: avoid_returning_null
    if (totalSize == null || downloaded > totalSize) return null;
    return downloaded / totalSize;
  }
}
