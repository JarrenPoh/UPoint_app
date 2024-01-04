import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:upoint/bloc/add_post_page_bloc.dart';
import 'package:upoint/globals/dimension.dart';
import 'package:upoint/globals/medium_text.dart';
import 'package:provider/provider.dart';
import 'package:upoint/models/post_model.dart';

class AddPicture extends StatefulWidget {
  final AddPostPageBloc bloc;
  final bool isEdit;
  const AddPicture({
    super.key,
    required this.bloc,
    required this.isEdit,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture>
    with AutomaticKeepAliveClientMixin {
  @override
  final bool wantKeepAlive = true;
  ImageProvider? _imageProvider;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _imageProvider = NetworkImage(
        Provider.of<AddPostPageBloc>(context, listen: false).cart.photos?.first,
      );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.bloc.addPictureNotifier.boolChange(true);
        widget.bloc.addInformNotifier.boolChange(true);
        widget.bloc.addOtherNotifier.boolChange(true);
      });
    }
  }

  @override
  void dispose() {
    widget.bloc.imgStreamController.close();
    super.dispose();
  }

  Future<List<AssetEntity>?> callPicker() {
    super.build(context);
    final theme = InstaAssetPicker.themeData(Theme.of(context).hintColor);
    Color color_onPrimary = Theme.of(context).colorScheme.onPrimary;
    Color color_title = Theme.of(context).colorScheme.primary;
    Color color_sub_title = Theme.of(context).colorScheme.secondary;
    Color color_scaffold = Theme.of(context).colorScheme.background;
    Color hintColor = Theme.of(context).hintColor;

    return InstaAssetPicker.pickAssets(
      context,
      title: '選取照片',
      maxAssets: widget.bloc.maxAssets,
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
        preferredSize: 1080,
        cropRatios: [16 / 9],
      ),
      onCompleted: (Stream<InstaAssetsExportDetails> stream) {
        stream.listen((event) {
          widget.bloc.imgStreamController.add(event);
          List _photos = [];
          print('1: ${event.croppedFiles.length}');
          for (var i in event.croppedFiles) {
            _photos.add(i.readAsBytes());
          }
          Provider.of<AddPostPageBloc>(context, listen: false).updateCart(
            PostModel(photos: _photos),
          );
        });
        widget.bloc.addPictureNotifier.boolChange(true);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Dimensions.height5 * 8),
          SizedBox(
            height: Dimensions.height5 * 47,
            child: StreamBuilder<InstaAssetsExportDetails>(
              stream: widget.bloc.imgStreamController.stream,
              builder: (context, snapshot) {
                widget.bloc.assetPics = snapshot.data?.croppedFiles ?? [];
                if (widget.bloc.assetPics.isNotEmpty) {
                  _imageProvider = FileImage(
                    widget.bloc.assetPics[0],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                          1,
                          (index) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await callPicker();
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: widget.bloc.assetPics.isNotEmpty ||
                                            widget.isEdit
                                        ? Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimensions.height2 * 6,
                                              ),
                                              image: DecorationImage(
                                                image: _imageProvider!,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : DottedBorder(
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(
                                              Dimensions.height2 * 6,
                                            ),
                                            dashPattern: [6, 5],
                                            color: Colors.grey,
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.grey,
                                                size: Dimensions.height5 * 7,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.width5 * 4),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.height5 * 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: Dimensions.width5 * 17,
                          child: MediumText(
                            color: Colors.grey,
                            size: Dimensions.height5 * 2.5,
                            text: widget.isEdit
                                ? '已選取 1/1'
                                : '已選取 ${widget.bloc.assetPics.length}/${widget.bloc.maxAssets}',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
