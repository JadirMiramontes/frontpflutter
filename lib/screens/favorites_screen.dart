import 'package:flutter/material.dart';
import 'package:front/models/Favoritos.dart';
import 'package:front/services/favorites_services.dart';

class FavoritesScreen extends StatefulWidget {
  final String userEmail;

  FavoritesScreen({required this.userEmail, required List<Map<String, dynamic>> favoriteDigimons});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Favoritos>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    // Cargar los favoritos del usuario al inicio
    _favoritesFuture = FavoritesService().getFavorites(widget.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
      ),
      body: FutureBuilder<List<Favoritos>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tienes favoritos aún.'));
          }

          // Si hay datos, mostramos la lista
          List<Favoritos> favorites = snapshot.data!;

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];

              return ListTile(
                leading: Image.network(favorite.imageUrl),
                title: Text(favorite.nameD),
                subtitle: Text('Nivel: ${favorite.levelD}'),
              );
            },
          );
        },
      ),
    );
  }
}
