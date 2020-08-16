import 'package:intl/intl.dart';
import 'package:newnativeproject/pages/showlistpage.dart';
import 'package:toast/toast.dart';
import 'package:newnativeproject/databasemanager/dbmanager.dart';
import 'package:newnativeproject/map_tools/mapurltool.dart';
import 'package:newnativeproject/model/listdatamodel.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:newnativeproject/widgets/mapcol.dart';
import 'package:newnativeproject/widgets/imagecol.dart';

class AddItemPage extends StatefulWidget {
  static const String id = 'addpage';

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  DBmanager _dbAccess = DBmanager();
  File _imagedata;
  LatLng latlongData;
  String address;
  final _textController = TextEditingController();
  String mapdataUrl;
  ListModel listdata;
  void _setImageData(File imageFile) {
    _imagedata = imageFile;
    print(_imagedata);
  }

  void _setmapsData(LatLng latlong, String mapUrl) async {
    latlongData = latlong;
    mapdataUrl = mapUrl;
    address = await LocationHelper.getLocationAddress(
        latlongData.latitude, latlongData.longitude);
    print('$latlongData, $mapdataUrl and $address');
  }

  Future<void> _onWillPop() async {
    await Navigator.pushReplacementNamed(context, ShowListData.id);
  }

  void saveDataToDb() {
    if (_textController.text != null &&
        _imagedata != null &&
        address != null &&
        mapdataUrl != null &&
        latlongData != null) {
      if (_textController.text.length > 2) {
        var list = ListModel(
            message: _textController.text,
            imagePath: _imagedata,
            mapimageUrl: mapdataUrl,
            address: address,
            latitude: latlongData.latitude,
            longitude: latlongData.longitude,
            datetime:
                DateFormat('dd/MM/yyyy hh:mm a E').format(DateTime.now()));

        _dbAccess.insertData(list).then((value) {
          print('data Added SuccessFully at $value');
        });
        setState(() {
          _textController.clear();
          _imagedata = null;
          latlongData = null;
          address = null;
          mapdataUrl = null;
        });
        Navigator.pushReplacementNamed(context, ShowListData.id);
      } else {
        Toast.show('Message is too short.....', context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.black87,
            textColor: Colors.white70);
      }
    } else {
      Toast.show('The field is Required', context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white70);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Add your remainders'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _textController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          hintText: 'Remainder Message...',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Theme.of(context).primaryColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Imagefield(_setImageData),
                      SizedBox(
                        height: 8.0,
                      ),
                      MapField(_setmapsData),
                    ],
                  ),
                ),
              ),
              FlatButton.icon(
                onPressed: saveDataToDb,
                icon: Icon(Icons.check),
                label: Text('Add'),
                color: Colors.yellow,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
