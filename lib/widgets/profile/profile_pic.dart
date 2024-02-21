import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:upoint/firebase/firestore_methods.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:provider/provider.dart';

import '../../firebase/auth_methods.dart';
import '../../models/user_model.dart';
import '../../secret.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({
    super.key,
  });

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final StreamController<InstaAssetsExportDetails> imgStreamController =
      StreamController<InstaAssetsExportDetails>();

  @override
  void dispose() {
    imgStreamController.close();
    super.dispose();
  }

  uploadPic(pic) async {
    await FirestoreMethods().updatePic(
      pic,
      FirebaseAuth.instance.currentUser!.uid,
    );
    await Provider.of<AuthMethods>(context, listen: false).getUserDetails();
  }

  Future<List<AssetEntity>?> callPicker() {
    final theme = InstaAssetPicker.themeData(Theme.of(context).hintColor);
    Color color_onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color color_title = Theme.of(context).colorScheme.primary;
    Color color_sub_title = Theme.of(context).colorScheme.secondary;
    Color color_scaffold = Theme.of(context).colorScheme.background;
    Color hintColor = Theme.of(context).hintColor;

    return InstaAssetPicker.pickAssets(
      context,
      title: '選取照片',
      maxAssets: 1,
      pickerTheme: theme.copyWith(
        canvasColor: color_onPrimary,
        splashColor: color_sub_title,
        colorScheme: theme.colorScheme.copyWith(
          background: color_scaffold,
        ),
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: color_onPrimary,
          titleTextStyle:
              Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                    color: color_title,
                  ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: hintColor,
          ),
        ),
      ),
      cropDelegate: const InstaAssetCropDelegate(
        preferredSize: 600,
        cropRatios: [1 / 1],
      ),
      onCompleted: (Stream<InstaAssetsExportDetails> stream) {
        stream.listen((event) async {
          imgStreamController.add(event);
          List _photos = [];
          for (var i in event.croppedFiles) {
            _photos.add(await i.readAsBytes());
          }
          if (event.croppedFiles.length == 1) {
            uploadPic(_photos.first);
          }
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      child: GestureDetector(
        onTap: () async {
          if (FirebaseAuth.instance.currentUser != null) {
            await callPicker();
          }
        },
        child: Stack(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: Dimensions.width2 * 42,
                  height: Dimensions.width2 * 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
                Consumer<AuthMethods>(builder: (context, userNotifier, child) {
                  UserModel? user = userNotifier.user;
                  return ClipOval(
                    child: Image.network(
                      user?.pic ?? defaultUserPic,
                      width: Dimensions.width2 * 38,
                      height: Dimensions.width2 * 38,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: Dimensions.width2 * 44,
                          color: Colors.grey[600],
                        );
                      },
                    ),
                  );
                })
              ],
            ),
            if (FirebaseAuth.instance.currentUser != null)
              Positioned(
                right: Dimensions.width2 * 1,
                bottom: Dimensions.width2 * 1,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: Dimensions.width2 * 11,
                      height: Dimensions.width2 * 11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 3,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.edit,
                      size: Dimensions.width2 * 7,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
