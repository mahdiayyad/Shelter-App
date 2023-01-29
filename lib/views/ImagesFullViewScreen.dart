import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageFullViewScreen extends HookWidget {
  const ImageFullViewScreen({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leadingWidth: 120,
      ),
      body: SizedBox(
          child: PhotoViewGallery.builder(
        pageController: pageController,

        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int i) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(url),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,

            // heroAttributes: PhotoViewHeroAttributes(tag: galleryItems[index].id),
          );
        },
        itemCount: 1,

        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null ? 0 : event.cumulativeBytesLoaded / 2,
            ),
          ),
        ),
        // backgroundDecoration: backgroundDecoration,
        // pageController: widget.pageController,
        // onPageChanged: onPageChanged,
      )),
    );
  }
}

// abstract class BlaState<T extends StatefulWidget>
//     extends State<T> with SingleTickerProviderStateMixin {
//   BlaState(this.pageController);
//   late final PageController pageController;

//   @override
//   void initState() {
//     super.initState();
//     pageController =
//         PageController();
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }
// }
// class Bla extends StatefulWidget {
//   @override
//   _BlaState createState() =>
//       _BlaState();
// }

// class _BlaState extends State<Bla> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(

//     );
//   }
// }
