import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/api_model.dart';

class ApiService {
  final String _baseUrl =
      'https://api.thecatapi.com/v1/images/search?limit=100&api_key=live_3zHCIfEgz2Xii5eSDEbBcVGEuJj2ecQr0ucAxdJwm5DTd4oEW2qRPnN0jI5Tfy0p';

  Future<List<Cat>> fetchCats() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      final filtered = jsonData
          .where(
            (cat) =>
                cat['breeds'] != null && (cat['breeds'] as List).isNotEmpty,
          )
          .toList();

      return filtered.map((cat) => Cat.fromJson(cat)).toList();
    } else {
      throw Exception('Failed to fetch cat data');
    }
  }
}
