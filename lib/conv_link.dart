import 'package:google_geocoding/google_geocoding.dart';
import 'package:http/http.dart' as http;

String LatLng = '';

getGeometry(String gmapsURL) async {

  // Send HTTP request to expand URL
  final client = http.Client();
  final request = http.Request('GET', Uri.parse(gmapsURL))..followRedirects=false;
  final response = await client.send(request);

  String address = response.headers['location'].toString();

  //API call to get geocode
  try {
    String api_key = 'API_KEY';
    List<Component> components =[];
    final googleGeocoding = GoogleGeocoding(api_key);
    final response = await googleGeocoding.geocoding.get(address, components);

    var lat = response?.results![0].geometry?.viewport?.northeast?.lat;
    var lng = response?.results![0].geometry?.viewport?.northeast?.lng;
    LatLng = ('$lat,$lng').toString();

    var locationType = response?.results![0].geometry?.locationType.toString();

    if(locationType == "APPROXIMATE") {
      return locationType;
    }

    return LatLng;

  // Fall back on Regex otherwise
  } on RangeError {
    try {
      RegExp regExp = new RegExp(r"[-]?[\d]+[.][\d]*");
      List geocode = regExp.allMatches(address).map((m) => m.group(0)).toList();
      var lat = geocode[0];
      var lng = geocode[1];
      LatLng = ('$lat,$lng').toString();
      
      return LatLng;

    } catch (e) {
        return '';
    }
  }
}