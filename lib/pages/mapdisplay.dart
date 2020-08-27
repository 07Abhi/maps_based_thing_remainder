import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newnativeproject/model/placemodel.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  PlaceCoordinates initialLocation;
  final bool isSelecting;
  MapScreen(
      {this.initialLocation =
          const PlaceCoordinates(latitude: 26.3549, longitude: 75.8243),
      this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  bool showCheck = false;
  void setLocationMaker(LatLng location) {
    setState(() {
      showCheck = true;
      _pickedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select in map'),
        actions: [
          Visibility(
            visible: showCheck,
            child: IconButton(
              icon: Icon(
                Icons.check,
                size: 30.0,
              ),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            ),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 16,
          target: LatLng(widget.initialLocation.latitude,
              widget.initialLocation.longitude),
        ),
        onTap: widget.isSelecting ? setLocationMaker : null,
        markers: _pickedLocation == null
            ? null
            : {
                Marker(
                  markerId: MarkerId('M1'),
                  position: _pickedLocation,
                ),
              },
      ),
    );
  }
}
