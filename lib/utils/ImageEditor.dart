import 'dart:io';
import 'dart:typed_data';

import 'package:citysight_editor/dto/ImageMeta.dart';
import 'package:citysight_editor/network/NetService.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:cropperx/cropperx.dart';

class ImageEditor {
  static crop(BuildContext context, TextEditingController controller,
      Uint8List image) async {
    await showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return ScaleTransition(scale: animation, child: child);
        },
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageCrop(
                  image: image,
                  controller: controller,
                  dialogContext: context,
                )
              ],
            ),
          );
        });
  }
}

class ImageCrop extends StatefulWidget {
  ImageCrop(
      {Key? key,
      required this.image,
      required this.controller,
      required this.dialogContext})
      : super(key: key);

  Uint8List image;
  final TextEditingController controller;
  final BuildContext dialogContext;

  @override
  State<ImageCrop> createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  final GlobalKey _cropperKeyS = GlobalKey(debugLabel: 'cropperKeyS');
  final GlobalKey _cropperKeyR = GlobalKey(debugLabel: 'cropperKeyR');

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _sourceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: 1600,
            height: 800,
            child: Material(
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade100, width: 8),
                    borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 10,
                        spreadRadius: 6,
                        color: Colors.black87,
                        inset: true,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Cropper(
                              cropperKey: _cropperKeyR, // Use your key here
                              zoomScale: 2.5,
                              aspectRatio: 4 / 7,
                              gridLineThickness: 1.0,
                              overlayType: OverlayType.rectangle,
                              image: Image.memory(widget.image),
                              onScaleStart: (details) {
                                // todo: define started action.
                              },
                              onScaleUpdate: (details) {
                                // todo: define updated action.
                              },
                              onScaleEnd: (details) {
                                // todo: define ended action.
                              },
                            ),
                          )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Cropper(
                              cropperKey: _cropperKeyS, // Use your key here
                              zoomScale: 2.5,
                              aspectRatio: 4 / 4,
                              gridLineThickness: 1.0,
                              overlayType: OverlayType.rectangle,
                              image: Image.memory(widget.image),
                              onScaleStart: (details) {
                                // todo: define started action.
                              },
                              onScaleUpdate: (details) {
                                // todo: define updated action.
                              },
                              onScaleEnd: (details) {
                                // todo: define ended action.
                              },
                            ),
                          )),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Название",
                                  focusColor:
                                      Theme.of(context).colorScheme.primary,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              TextField(
                                controller: _sourceController,
                                decoration: InputDecoration(
                                  labelText: "Источник",
                                  focusColor:
                                      Theme.of(context).colorScheme.primary,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const Divider(
                                height: 16,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    final square = await Cropper.crop(
                                      cropperKey: _cropperKeyS,
                                    );
                                    final rectangle = await Cropper.crop(
                                      cropperKey: _cropperKeyR,
                                    );

                                    if (square == null) return;
                                    if (rectangle == null) return;

                                    ImageMeta imageMeta = await uploadImage(
                                        square,
                                        rectangle,
                                        _nameController.text,
                                        _sourceController.text);
                                    if (imageMeta.id.isNotEmpty &&
                                        imageMeta.name.isNotEmpty) {
                                      widget.controller.text =
                                          "${imageMeta.name} (${imageMeta.id})";
                                      logger.d("Saved: ${imageMeta.name} (${imageMeta.id})");
                                      Navigator.pop(widget.dialogContext);
                                    }
                                  },
                                  child: const Text("Сохранить"))
                            ]),
                      )
                    ],
                  )),
            )));
  }
}
