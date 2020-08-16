import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newnativeproject/model/placemodel.dart';

class UserMapScreen extends StatefulWidget {
  PlaceCoordinates initialLocation;

  UserMapScreen({
    this.initialLocation =
        const PlaceCoordinates(latitude: 26.3549, longitude: 75.8243),
  });

  @override
  _UserMapScreenState createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  LatLng _pickedLocation;
  bool showCheck = false;
  @override
  void initState() {
    _pickedLocation = LatLng(
        widget.initialLocation.latitude, widget.initialLocation.longitude);
    super.initState();
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
        markers: {
          Marker(
            markerId: MarkerId('M1'),
            position: _pickedLocation,
          ),
        },
      ),
    );
  }
}
