import 'dart:convert';
import 'package:image_gallery/app_constants.dart';
import 'package:http/http.dart' as http;

class PixabayService {
  Future<List<dynamic>> fetchImages(int page) async {
    final response = await http.get(
      Uri.parse('${AppConstants.pixabayApi}?key=${AppConstants.pixabayApiKey}&image_type=photo&per_page=20&page=$page'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['hits'];
    } else {
      throw Exception('Failed to load images');
    }
  }
}
