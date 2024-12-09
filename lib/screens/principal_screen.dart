import 'package:flutter/material.dart';
import 'package:front/screens/digimonsearch_screen.dart';
import 'package:front/screens/favorites_screen.dart';
import 'package:front/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  List<Map<String, String>> _favoriteDigimons = [];
  String _userEmail = ""; // Para almacenar el correo del usuario autenticado.

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    final authService = Provider.of<AuthServices>(context, listen: false);
    final email = await authService.readEmail(); // Leer el correo del usuario autenticado.
    setState(() {
      _userEmail = email;
    });
  }

  void _navigateToSearch() async {
    // Esperar el resultado de la pantalla de búsqueda.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DigimonSearchScreen()),
    );

    if (result != null && result is List<Map<String, String>>) {
      setState(() {
        _favoriteDigimons = _removeDuplicates(result);
      });
    }
  }

  // Eliminar favoritos duplicados basados en el nombre.
  List<Map<String, String>> _removeDuplicates(List<Map<String, String>> favorites) {
    final seen = <String>{};
    return favorites.where((digimon) {
      final isDuplicate = seen.contains(digimon['name']);
      seen.add(digimon['name']!);
      return !isDuplicate;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        backgroundColor: const Color.fromARGB(253, 252, 147, 11),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              if (_userEmail.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesScreen(
                      userEmail: _userEmail,  // Pasa el email del usuario
                      favoriteDigimons: _favoriteDigimons,  // Pasa la lista de favoritos
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Debes iniciar sesión para ver tus favoritos')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _favoriteDigimons.isEmpty
            ? const Center(
                child: Text(
                  '',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Digimons Favoritos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _favoriteDigimons.length,
                      itemBuilder: (context, index) {
                        final digimon = _favoriteDigimons[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Image.network(
                              digimon['img'] ?? '',
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 50);
                              },
                            ),
                            title: Text(
                              digimon['name'] ?? '',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Nivel: ${digimon['level'] ?? 'Desconocido'}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(253, 252, 147, 11),
              ),
              child: Text('MENU'),
            ),
            ListTile(
              title: const Text('Inicio'),
              onTap: () async {
                await Navigator.pushNamed(context, 'home', arguments: '');
              },
            ),
            ListTile(
              title: const Text('Perfil de Usuario'),
              onTap: () async {
                await Navigator.pushNamed(context, 'userinfo', arguments: '');
              },
            ),
            ListTile(
              title: const Text('Cerrar sesión'),
              onTap: () async {
                final authService = Provider.of<AuthServices>(context, listen: false);
                await authService.logout();
                final token = await authService.storage.read(key: "token");

                if (token == null) {
                  await Navigator.pushReplacementNamed(context, 'login');
                } else {
                  print('El token aún está presente.');
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _navigateToSearch();
        },
        child: const Icon(Icons.search),
        backgroundColor: const Color.fromARGB(253, 252, 147, 11),
      ),
    );
  }
}
