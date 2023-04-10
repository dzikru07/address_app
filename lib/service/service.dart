import 'package:http/http.dart' as http;

class ApiService {
  final String _url = "dev.farizdotid.com";

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  Future getApiData(String path, var param) async {
    var _fullUrl = Uri.https(_url, path, param);
    return await http.get(_fullUrl, headers: _setHeaders());
  }
}
