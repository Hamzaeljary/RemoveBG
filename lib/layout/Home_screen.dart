import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Api/api_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _RBgState createState() => new _RBgState();
}

class _RBgState extends State<Home> {
  Uint8List? imageFile;

  String? imagePath;

  ScreenshotController controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.black,
          title: const Text('Remove Bg',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          actions: [
            IconButton(
              color: Colors.white,
                onPressed: () {
                  getImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.image)),
            IconButton(
                color: Colors.white,
                onPressed: () {
                  getImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt)),
            IconButton(
                color: Colors.white,
                onPressed: () async {
                  imageFile = await Api().removeBgApi(imagePath!);
                  setState(() {
                  });
                },
                icon: const Icon(Icons.delete)),
            IconButton(
                color: Colors.white,
                onPressed: () async {
                  saveImage();
                },
                icon: const Icon(Icons.save))
          ],

        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50,left: 10,right: 10),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (imageFile != null)
                        ? Screenshot(
                      controller: controller,
                      child:Image.memory(
                        imageFile!,
                      ),
                    )
                        : Container(
                      width: 300,
                      height: 300,
                      color: Colors.white,
                      child: const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ),

        ));

  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      imageFile = null;
      setState(() {});
    }
  }

  void saveImage() async {
    bool isGranted = await Permission.storage.status.isGranted;
    if (isGranted) {
      isGranted = await Permission.storage.request().isGranted;
    }
    if (isGranted) {
      String directory = (await getExternalStorageDirectory())!.path;
      String gnome =
          DateTime.now().microsecondsSinceEpoch.toString() + ".png";
      controller.captureAndSave(directory, fileName: gnome);
    }
  }
}
