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

  // Método para eliminar un Digimon de favoritos
  Future<void> _removeFavorite(int favoriteId) async {
    try {
      await FavoritesService().removeFavorite(favoriteId, widget.userEmail);
      setState(() {
        // Actualizamos la lista de favoritos
        _favoritesFuture = FavoritesService().getFavorites(widget.userEmail);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Digimon eliminado de favoritos')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar favorito')));
    }
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
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _removeFavorite(favorite.id);  // Eliminar el favorito
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
