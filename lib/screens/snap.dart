import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_register_ui/screens/preview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../constants.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../widgets/widget.dart';
import 'package:camera/camera.dart';

class Snap extends StatefulWidget {
  final int situation;
  final LatLng location;
  Snap({this.situation, this.location});
  @override
  _SnapState createState() => _SnapState();
}

class _SnapState extends State<Snap> {
  List<CameraDescription> cameras = [];
  bool isCameraInitialized = false;
  bool captured = false;
  bool _isRearCameraSelected = true;
  CameraController controller;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  FlashMode _currentFlashMode;
  String imagePath; 

  void onNewCameraSelected(CameraDescription cameraDescription) async {
      final previousCameraController = controller;
      // Instantiating the camera controller
      final CameraController cameraController = CameraController(
        cameraDescription,
        ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Dispose the previous controller
      await previousCameraController?.dispose();

      // Replace with the new controller
      if (mounted) {
         setState(() {
           controller = cameraController;
        });
      }

      // Update UI if controller updated
      cameraController.addListener(() {
        if (mounted) setState(() {});
      });

      // Initialize controller
      try {
        await cameraController.initialize();
      } on CameraException catch (e) {
        print('Error initializing camera: $e');
      }

      // Update the Boolean
      if (mounted) {
        setState(() {
           isCameraInitialized = controller.value.isInitialized;
        });
      }

      cameraController
          .getMaxZoomLevel()
          .then((value) => _maxAvailableZoom = value);

      cameraController
          .getMinZoomLevel()
          .then((value) => _minAvailableZoom = value);

      _currentFlashMode = controller.value.flashMode;    
   }

   Future<XFile> takePicture() async {
    final CameraController cameraController = controller;
    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    availableCameras().then((value){ 
        cameras = value;
        onNewCameraSelected(cameras[0]);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            captured = false;
            Navigator.pop(context);
          },
          icon: Image(
            width: 24,
            color: Colors.white,
            image: Svg('assets/images/back_arrow.svg'),
          ),
        ),
      ),
      body: SafeArea(
        //to make page scrollable
        child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isCameraInitialized ? 
                          AspectRatio(
                              aspectRatio: 1 / controller.value.aspectRatio,
                              child: !captured ? Stack(
                                children: [
                                  controller.buildPreview(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                            Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black87,
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      _currentZoomLevel.toStringAsFixed(1) +
                                                          'x',
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: RotatedBox(
                                                    quarterTurns: 3,
                                                    child: Slider(
                                                      value: _currentZoomLevel,
                                                      min: _minAvailableZoom,
                                                      max: _maxAvailableZoom,
                                                      activeColor: Colors.white,
                                                      inactiveColor: Colors.white30,
                                                      onChanged: (value) async {
                                                        setState(() {
                                                          _currentZoomLevel = value;
                                                        });
                                                        await controller.setZoomLevel(value);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          left: MediaQuery.of(context).size.width / 7,
                                          top: 10,
                                          child: InkWell(
                                            onTap: () async {
                                              setState(() {
                                                isCameraInitialized = false;
                                              });
                                              onNewCameraSelected(
                                                cameras[_isRearCameraSelected ? 1 : 0],
                                              );
                                              setState(() {
                                                _isRearCameraSelected = !_isRearCameraSelected;
                                              });
                                            },
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Icon(Icons.circle,color: Colors.black38,size: 60,),
                                                Icon(
                                                  _isRearCameraSelected ?
                                                  Icons.camera_rear : Icons.camera_front,
                                                  color: _currentFlashMode == FlashMode.always
                                                      ? Colors.amber
                                                      : Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                XFile rawImage = await takePicture();
                                                File imageFile = File(rawImage.path);
                                  
                                                int currentUnix = DateTime.now().millisecondsSinceEpoch;
                                                final directory = await getApplicationDocumentsDirectory();
                                                String fileFormat = imageFile.path.split('.').last;
                                                await imageFile.copy(
                                                  '${directory.path}/$currentUnix.$fileFormat',
                                                );
                                                imagePath = rawImage.path;
                                                captured = true;
                                              },
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(Icons.circle, color: Colors.white38, size: 80),
                                                  Icon(Icons.circle, color: Colors.white, size: 65),
                                                ]    
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )  
                                  )
                                ],
                              ): Image.file(
                                File(imagePath),
                            ),
                          ) : SizedBox(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: !captured ? Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _currentFlashMode = FlashMode.off;
                                        });
                                        await controller.setFlashMode(
                                          FlashMode.off,
                                        );
                                      },
                                      child: Icon(
                                        Icons.flash_off,
                                        color: _currentFlashMode == FlashMode.off
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _currentFlashMode = FlashMode.auto;
                                        });
                                        await controller.setFlashMode(
                                          FlashMode.auto,
                                        );
                                      },
                                      child: Icon(
                                        Icons.flash_auto,
                                        color: _currentFlashMode == FlashMode.auto
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _currentFlashMode = FlashMode.always;
                                        });
                                        await controller.setFlashMode(
                                          FlashMode.always,
                                        );
                                      },
                                      child: Icon(
                                        Icons.flash_on,
                                        color: _currentFlashMode == FlashMode.always
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        setState(() {
                                          _currentFlashMode = FlashMode.torch;
                                        });
                                        await controller.setFlashMode(
                                          FlashMode.torch,
                                        );
                                      },
                                      child: Icon(
                                        Icons.highlight,
                                        color: _currentFlashMode == FlashMode.torch
                                            ? Colors.amber
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ) : MyTextButton(
                                  buttonName: AppLocalizations.of(context).reportPreview,
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => Preview(situation: widget.situation, 
                                        location: widget.location, 
                                        snap: imagePath),
                                      ));
                                  }, 
                                  bgColor: Colors.white, 
                                  textColor: Colors.black),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
