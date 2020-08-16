import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class Imagefield extends StatefulWidget {
  Function imagePathSetter;
  Imagefield(this.imagePathSetter);
  @override
  _ImagefieldState createState() => _ImagefieldState();
}

class _ImagefieldState extends State<Imagefield> {
  File _pickedImage;
  void showUserChoice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Choose Option'),
        children: [
          SimpleDialogOption(
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                onGalleryOption();
              },
              child: Text('Gallery'),
              color: Colors.yellow,
            ),
          ),
          SimpleDialogOption(
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCameraOption();
              },
              child: Text('Camera'),
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onGalleryOption() async {
    var picture = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 600.0,
      maxWidth: 600.0,
    );
    if (picture != null) {
      setState(() {
        _pickedImage = File(picture.path);
      });
      final imgDir = await syspath.getApplicationDocumentsDirectory();
      final imgBasename = path.basename(_pickedImage.path);
      final finalPath = await _pickedImage.copy('${imgDir.path}/$imgBasename');
      widget.imagePathSetter(finalPath);
    } else {
      return;
    }
  }

  Future<void> onCameraOption() async {
    var picture = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxHeight: 600.0,
      maxWidth: 600.0,
    );
    if (picture != null) {
      setState(() {
        _pickedImage = File(picture.path);
      });
      final imgDir = await syspath.getApplicationDocumentsDirectory();
      final imgBasename = path.basename(_pickedImage.path);
      final finalPath = await _pickedImage.copy('${imgDir.path}/$imgBasename');
      widget.imagePathSetter(finalPath);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: 120.0,
          width: 140.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
          child: _pickedImage != null
              ? Image.file(
                  _pickedImage,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                )
              : Text(
                  'No Preview Available',
                  textAlign: TextAlign.center,
                ),
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: FlatButton.icon(
            onPressed: () => showUserChoice(context),
            icon: Icon(
              Icons.camera,
              color: Colors.blue,
            ),
            label: Text(
              'Submit',
              style: TextStyle(color: Colors.blue),
            ),
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }
}
