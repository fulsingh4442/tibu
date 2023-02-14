
import 'dart:typed_data';

import 'package:flutter/material.dart';

class UserProfilePic extends StatelessWidget {
  UserProfilePic(
      {Key key,
        this.url = '',
        this.width = 80,
        this.height = 80,
        this.isShowCameraButton = false,
        this.onCameraTap,
        this.onGalleryTap,
        this.borderRadius = 100,
        this.data
      })
      : super(key: key);
  final String url;
  final double width;
  final double height;
  final bool isShowCameraButton;
  final Function() onCameraTap;
  final Function() onGalleryTap;
  final double borderRadius;
  final Uint8List data;

  @override
  Widget build(BuildContext context) {
    return buildUserProfilePicContainer();
  }

  ///build the user profile pic.
  Widget buildUserProfilePicContainer() {
    return Container(
        padding: EdgeInsets.zero,
        width: width,
        height: height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          color: Colors.transparent
        ),
        child: Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.hardEdge,
          children: [
            buildUserProfilePic(data),
            Positioned(
              bottom: 0,
              right: 0,
              child: Visibility(
                  visible: isShowCameraButton, child: buildCameraButton()),
            )
          ],
        ));
  }

  ///build the user profile picture.
  Widget buildUserProfilePic(Uint8List data) {
    /*return CommonUtils.loadNetworkImage(imageUrl: url,placeholder: (context,url){
      return buildCircularProgressIndicator();
    },errorWidget: (context,url,other){
      return  Image.asset(
        IconConstants.dummyUser,
        fit: BoxFit.fill,
      );
    });*/
    if(data == null) {
      if (url != null && url.isNotEmpty) {
        return ClipOval(
          child: FadeInImage.assetNetwork(
            placeholder:
            'assets/images/placeholder2.gif',
            image: url,
            // fadeInDuration:
            //    const Duration(milliseconds: 500),
            fit: BoxFit.cover,
            alignment: Alignment.center,
            height: 80,
            width: 80,
          ),
        );
      }
      return ClipOval(
        child: Image.asset(
          "assets/images/profile_pic2.png",
          width: 80.0,
        )
      );
     // return Icon(Icons.supervised_user_circle,size: 100,);
    }
    return ClipOval(
      child: Image.memory(data,fit: BoxFit.cover),
    );
  }

  ///build the camera button.
  Widget buildCameraButton() {
    return  Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.only(bottom: 8,right: 8),
      padding: const EdgeInsets.all(5),
      decoration:  BoxDecoration(
          color: Colors.black.withOpacity(1), shape: BoxShape.circle),
      child:buildPopupMenuButton(),
    );
  }

  ///build the popup menu button.
  PopupMenuButton<dynamic> buildPopupMenuButton() {
    print("CLICKKKKKKKKKK");
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return [
          buildPopupMenuItem(
              icon:Icons.photo_camera_back, title: "Gallery", onTap: () {
            onGalleryTap();
          }),
          buildPopupMenuItem(
              icon:Icons.camera_alt_outlined, title: "Camera", onTap: () {
            onCameraTap();
          }),
        ];
      },
      offset: const Offset(0, 8),
      position: PopupMenuPosition.under,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      constraints: BoxConstraints.tight(const Size(150, 86)),
      padding: EdgeInsets.zero,
      child: Icon(Icons.camera,size: 80,),
    );
  }

  ///build the popup menu item.
  PopupMenuItem buildPopupMenuItem(
      {IconData icon,  String title, Function() onTap}) {
    return PopupMenuItem(
      height: 24,
      padding: const EdgeInsets.all(8),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(
            width: 16,
          ),
          Text(title)
        ],
      ),
    );
  }

  ///build the `CircularProgressIndicator`
  Widget buildCircularProgressIndicator() {
    return  const Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation(Colors.green),
        backgroundColor: Colors.deepOrange,
      ),
    );
  }
}
