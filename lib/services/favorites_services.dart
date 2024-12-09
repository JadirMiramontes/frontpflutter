import 'dart:convert';
import 'package:front/models/Favoritos.dart';
import 'package:http/http.dart' as http;

class FavoritesService {
  final String baseUrl = 'http://login2024jadirm.somee.com/api/Favoritos'; // URL del backend

  // Obtener los favoritos de un usuario
  Future<List<Favoritos>> getFavorites(String userEmail) async {
    final response = await http.get(Uri.parse('$baseUrl/$userEmail'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Favoritos.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  // Eliminar un favorito
  Future<void> removeFavorite(int favoriteId, String userEmail) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$favoriteId?email=$userEmail'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove favorite');
    }
  }
}
