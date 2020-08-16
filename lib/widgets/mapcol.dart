import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newnativeproject/map_tools/mapurltool.dart';
import 'package:flutter/material.dart';
import 'package:newnativeproject/pages/mapdisplay.dart';
import 'package:newnativeproject/model/placemodel.dart';
import 'package:location/location.dart';

class MapField extends StatefulWidget {
  Function mapData;
  MapField(this.mapData);

  @override
  _MapFieldState createState() => _MapFieldState();
}

class _MapFieldState extends State<MapField> {
  String _pickedMapUrl;
  PlaceCoordinates placeobject;
  bool _isLoading = false;
  void _maplatlongUrl(double latitude, double longitude) {
    var mapurl = LocationHelper.getLocationPreviewImage(
        latitude: latitude, longitude: longitude);
    if (mapurl != null) {
      setState(() {
        _isLoading = false;
        _pickedMapUrl = mapurl;
      });
      var coordinates = LatLng(latitude, longitude);
      widget.mapData(coordinates, mapurl);
    } else {
      return;
    }
  }

  Future<void> onCurrentLocation() async {
    setState(() {
      _isLoading = true;
    });
    var loc = await Location().getLocation();
    _maplatlongUrl(loc.latitude, loc.longitude);
  }

  Future<void> onMapOption() async {
    setState(() {
      _isLoading = true;
    });
    var loc = await Location().getLocation();
    placeobject =
        PlaceCoordinates(latitude: loc.latitude, longitude: loc.longitude);
    var onSelectedLatLong = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialLocation: placeobject,
          isSelecting: true,
        ),
      ),
    );
    if (onSelectedLatLong != null) {
      _maplatlongUrl(onSelectedLatLong.latitude, onSelectedLatLong.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 170.0,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.grey),
              ),
              child: _pickedMapUrl != null
                  ? Image.network(
                      _pickedMapUrl,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: Text('Choose Map Option!!'),
                    ),
            ),
            Visibility(
              visible: _isLoading,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: () => onCurrentLocation(),
              icon: Icon(
                Icons.location_on,
                color: Colors.indigo,
              ),
              label: Text(
                'Current Location',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
            FlatButton.icon(
              onPressed: () => onMapOption(),
              icon: Icon(
                Icons.map,
                color: Colors.indigo,
              ),
              label: Text(
                'Seacrh on map',
                style: TextStyle(color: Colors.indigo),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
