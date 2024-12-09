  import 'dart:convert';
  import 'package:front/models/Favoritos.dart';// Asegúrate de tener el modelo Favoritos en esta ruta
  import 'package:http/http.dart' as http;

  class FavoritesService {
    final String _baseUrl = 'http://login2024jadirm.somee.com/api/Favoritos';

    // Obtener favoritos
    Future<List<Favoritos>> getFavorites(String userEmail) async {
      final url = Uri.parse('$_baseUrl/$userEmail');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parseamos la respuesta para convertirla en una lista de objetos Favoritos
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => Favoritos.fromJson(item)).toList();
      } else {
        throw Exception('Error al obtener favoritos: ${response.body}');
      }
    }

    // Agregar favorito
    Future<void> addFavorite(String userEmail, String imageUrl, String name, String level) async {
      final body = jsonEncode({
        'UserEmail': userEmail,
        'ImageUrl': imageUrl,
        'NameD': name,
        'LevelD': level,
      });

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('El digimon ya se encuentra en favoritos');
      }
    }

    // Obtener el ID del Digimon por su nombre
    Future<int> getFavoriteIdByName(String digimonName, String userEmail) async {
      final url = Uri.parse('$_baseUrl/getIdByName?email=$userEmail&name=$digimonName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['id'];  // Asumiendo que el 'id' es el campo que contiene el ID del favorito
      } else {
        throw Exception('Error al obtener el ID del Digimon: ${response.body}');
      }
    }

    // Eliminar favorito por ID
    Future<void> removeFavoriteById(int favoriteId, String userEmail) async {
      final url = Uri.parse('$_baseUrl/$favoriteId?email=$userEmail');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar favorito: ${response.body}');
      }
    }
  }
