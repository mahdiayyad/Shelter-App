import 'package:flutter/material.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/router/AppRouter.gr.dart';
import 'package:shelter/views/common/ImageLoader.dart';
//*************************************************************************************/
//**************************************profile_widget********************************/
//*************************************************************************************/

/// this will show the user how profile will look like
class ProfileWidget extends StatelessWidget {
  final String? imagePath;
  final bool isEdit;
  final VoidCallback onClicked;
  const ProfileWidget(
      {Key? key,
      required this.imagePath,
      this.isEdit = true,
      required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: isEdit ? buildEditIcon(color) : Container(),
          )
        ],
      ),
    );
  }

  /// this will take the image path and use it in the profile
  Widget buildImage() {
    final image = ImageLoader(
      path: imagePath,
      fit: BoxFit.cover,
      height: 128,
      width: 128,
    );

    return ClipOval(
      child: image,
    );
  }

  /// this is the edit icon in the profile image
  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: InkWell(
            onTap: () {
              navgationManager.navigatePush(EditAccountRoute());
            },
            child: Icon(
              Icons.edit,
              size: 20,
            ),
          ),
        ),
      );

  /// this will make a circle edit icon
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
