import 'dart:io';

class ListModel {
  String item;
  String message;
  File imagePath;
  int id;
  String address;
  String mapimageUrl;
  double latitude;
  double longitude;
  String datetime;

  ListModel(
      {this.item,
        this.message,
      this.imagePath,
      this.id,
      this.address,
      this.mapimageUrl,
      this.latitude,
      this.longitude,
      this.datetime});
  Map<String, dynamic> toMap() {
    return {
      'item':item,
      'message': message,
      'imagePath': imagePath.path,
      'address': address,
      'mapimageUrl': mapimageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'datetime': datetime,
    };
  }
}
