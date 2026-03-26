import 'package:dio/dio.dart';

class ApiServices {
  Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://tatdataapi.io/api/v2/",
      headers: {
        "x-api-key": "8JgG7pxdS3YKzFqILCcyiRdNJTxusxYq",
        "Accept": "application/json",
        "Accept-Language": "th",
      },
    ),
  );

  Future<Map<String, dynamic>> getPlaces() async {
    try {
      final response = await dio.get('places');
      print('✅ API Response: ${response.statusCode}');
      return response.data;
    } catch (e) {
      print('❌ API Error: $e');
      throw Exception('Failed to load places: $e');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetail(String id) async {
    try {
      final response = await dio.get('places/$id');
      print('✅ Place Detail Response: ${response.statusCode}');
      return response.data;
    } catch (e) {
      print('❌ Place Detail Error: $e');
      throw Exception('Failed to load place detail: $e');
    }
  }

  Future<Map<String, dynamic>> searchPlaces(String query) async {
    try {
      final response = await dio.get(
        'places',
        queryParameters: {'keyword': query, 'numberOfResult': 10},
      );
      print('✅ Search Response: ${response.statusCode}');
      return response.data;
    } catch (e) {
      print('❌ Search Error: $e');
      throw Exception('Failed to search places: $e');
    }
  }
}
