import 'package:flutter/material.dart';
import 'package:front/services/auth_services.dart';
import 'package:front/services/favorite_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'favorites_screen.dart';  // Importa la pantalla de favoritos

class DigimonSearchScreen extends StatefulWidget {
  const DigimonSearchScreen({super.key});

  @override
  _DigimonSearchScreenState createState() => _DigimonSearchScreenState();
}

class _DigimonSearchScreenState extends State<DigimonSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final AuthServices authServices = AuthServices();

  List<String>? _digimonNames;
  List<String>? _digimonImages;
  List<String>? _digimonLevels;
  final List<String> _levels = ['Rookie', 'Champion', 'Ultimate', 'Mega'];
  String? _selectedLevel;

  List<Map<String, dynamic>> _favoriteDigimons = [];

  @override
  void initState() {
    super.initState();
  }

  // Método para alternar el estado de favorito
  void _toggleFavorite(Map<String, dynamic> digimon) async {
    final email = await authServices.readEmail();
    if (email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para agregar favoritos')),
      );
      return;
    }

    setState(() {
      final existingIndex = _favoriteDigimons.indexWhere(
        (fav) => fav['name'] == digimon['name'],
      );

      if (existingIndex != -1) {
        _favoriteDigimons.removeAt(existingIndex); // Eliminar de favoritos
        removeFavorite(digimon['name'], email); // Eliminar de la base de datos
      } else {
        _favoriteDigimons.add(digimon); // Agregar a favoritos
        addFavorite(digimon, email); // Guardar en base de datos
      }
    });
  }

  // Agregar favorito a la base de datos
  Future<void> addFavorite(Map<String, dynamic> digimon, String email) async {
    try {
      await FavoritesService().addFavorite(
        email,
        digimon['image'],
        digimon['name'],
        digimon['level'],
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digimon agregado a favoritos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar favorito: $e')),
      );
    }
  }

  // Eliminar favorito de la base de datos
  Future<void> removeFavorite(String digimonName, String email) async {
    try {
      final favoriteId = await FavoritesService().getFavoriteIdByName(digimonName, email);
      await FavoritesService().removeFavoriteById(favoriteId, email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digimon eliminado de favoritos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar favorito: $e')),
      );
    }
  }

  Future<void> _searchDigimonByName(String name) async {
    final response =
        await http.get(Uri.parse('https://digimon-api.vercel.app/api/digimon/name/$name'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          _digimonNames = [data[0]['name']];
          _digimonImages = [data[0]['img']];
          _digimonLevels = [data[0]['level']];
        });
      } else {
        _clearResults();
      }
    } else {
      throw Exception('Error al buscar el Digimon');
    }
  }

  Future<void> _searchDigimonByLevel(String level) async {
    final response =
        await http.get(Uri.parse('https://digimon-api.vercel.app/api/digimon/level/$level'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        setState(() {
          _digimonNames = data.map((d) => d['name'] as String).toList();
          _digimonImages = data.map((d) => d['img'] as String).toList();
          _digimonLevels = data.map((d) => d['level'] as String).toList();
        });
      } else {
        _clearResults();
      }
    } else {
      throw Exception('Error al buscar el Digimon');
    }
  }

  void _clearResults() {
    setState(() {
      _digimonNames = null;
      _digimonImages = null;
      _digimonLevels = null;
    });
  }

  void _clearFields() {
    _controller.clear();
    setState(() {
      _selectedLevel = null;
    });
    _clearResults();
  }

  void _search() {
    if (_controller.text.isNotEmpty) {
      _searchDigimonByName(_controller.text);
    } else if (_selectedLevel != null) {
      _searchDigimonByLevel(_selectedLevel!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Digimons'),
        backgroundColor: const Color.fromARGB(253, 252, 147, 11),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Busca tu Digimon favorito', style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Digimon',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Selecciona el nivel del Digimon:', style: TextStyle(fontSize: 20)),
              DropdownButton<String>(
                value: _selectedLevel,
                hint: const Text('Selecciona un nivel'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLevel = newValue;
                  });
                  _search();
                },
                items: _levels.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _search,
                child: const Text('Buscar'),
              ),
              const SizedBox(height: 20),
              _digimonNames == null || _digimonNames!.isEmpty
                  ? const Text('No se encontraron Digimons')
                  : Column(
                      children: List.generate(
                        _digimonNames!.length,
                        (index) {
                          final digimon = {
                            'name': _digimonNames![index],
                            'image': _digimonImages![index],
                            'level': _digimonLevels![index],
                          };
                          final isFavorite = _favoriteDigimons.any(
                            (fav) => fav['name'] == digimon['name'],
                          );
                          return ListTile(
                            title: Text(digimon['name'] ?? 'Nombre desconocido'),
                            subtitle: Text(digimon['level'] ?? 'Nivel desconocido'),
                            leading: Image.network(
                              digimon['image'] ?? 'https://via.placeholder.com/150',
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : null,
                              ),
                              onPressed: () {
                                _toggleFavorite(digimon);
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
