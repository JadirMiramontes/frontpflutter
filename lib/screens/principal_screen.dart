import 'package:flutter/material.dart';
import 'package:front/screens/digimonsearch_screen.dart';
import 'package:front/services/auth_services.dart';
import 'package:provider/provider.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => _PrincipalScreenState();
}

class _PrincipalScreenState extends State<PrincipalScreen> {
  List<Map<String, String>> _favoriteDigimons = [];

  void _navigateToSearch() async {
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

  List<Map<String, String>> _removeDuplicates(List<Map<String, String>> favorites) {
    final seen = <String>{}; // Usamos un conjunto para rastrear los nombres vistos
    return favorites.where((digimon) {
      final isDuplicate = seen.contains(digimon['name']);
      seen.add(digimon['name']!); // Agregamos el nombre al conjunto
      return !isDuplicate; // Solo mantenemos los que no son duplicados
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Principal Screen',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pantalla Principal'),
          backgroundColor: const Color.fromARGB(253, 252, 147, 11),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_favoriteDigimons.isNotEmpty) ...[
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
                        return ListTile(
                          leading: Image.network(
                            digimon['img'] ?? '',
                            width: 50,
                            height: 50,
                          ),
                          title: Text(digimon['name'] ?? ''),
                          subtitle: Text(digimon['level'] ?? ''),
                        );
                      },
                    ),
                  ),
                ] else ...[
                  const Text(
                    'No hay Digimons favoritos seleccionados',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ],
            ),
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
                onTap: () {
                  Navigator.pushNamed(context, 'home', arguments: '');
                },
              ),
              ListTile(
                title: const Text('Perfil de Usuario'),
                onTap: () {
                  Navigator.pushNamed(context, 'userinfo', arguments: '');
                },
              ),
              ListTile(
                title: const Text('Cerrar sesión'),
                onTap: () async {
                  final authService = Provider.of<AuthServices>(context, listen: false);
                  await authService.logout();
                  final token = await authService.storage.read(key: "token");
                  
                  if (token == null) {
                    Navigator.pushReplacementNamed(context, 'login');
                  } else {
                    print('El token aún está presente.');
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _navigateToSearch,
          child: const Icon(Icons.search),
          backgroundColor: const Color.fromARGB(253, 252, 147, 11),
        ),
      ),
    );
  }
}
