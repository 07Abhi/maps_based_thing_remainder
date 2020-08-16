import 'dart:convert' as json;
import 'package:http/http.dart' as http;

const GOOGLE_API_KEY = 'Google API key';

class LocationHelper {
  static String getLocationPreviewImage({double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getLocationAddress(double lat, double long) async {
    var url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$GOOGLE_API_KEY';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = json.jsonDecode(response.body);
      var address = jsonData['results'][0]['formatted_address'];
      return address;
    } else {
      return 'No address found';
    }
  }
}