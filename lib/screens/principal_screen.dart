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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(253, 252, 147, 11),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(),
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
                title: const Text('Notas'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Calendario'),
                onTap: () {
                  Navigator.pop(context);
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DigimonSearchScreen()),
            );
          },
          child: const Icon(Icons.search),
          backgroundColor: Color.fromARGB(253, 252, 147, 11),
        ),
      ),
    );
  }
}
