import 'package:flutter/material.dart';
import 'package:front/services/auth_services.dart';
import 'package:front/services/notifications_services.dart';
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
          title: const Text('Login App')
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(

                ),
                ElevatedButton(
                  onPressed: () async {
                    final authService = Provider.of<AuthServices>(context, listen: false);

                    await authService.logout();

                    final token = await authService.storage.read(key: "token");
                    
                    if(token == null){
                      Navigator.pushReplacementNamed(context, 'login');
                    }
                    else {
                      // Si el token sigue presente (por algún motivo), podrías manejarlo aquí
                      print('El token aún está presente.');
                    }                
                    
                  }, 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 181, 184, 187)
                    )
                  ),
                  child: const Text(
                    'Cerrar sesion',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 250, 253, 247)
                    )
                  )
                ),
              ],
            )
          ),
        ),
        drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 248, 188, 58),
              ),
              child: Text('Opciones'),
            ),
            ListTile(
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushNamed(context, 'home', arguments: '');
                //Navigator.pop(context);
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
          ],
        ),
      ),
      ),
    );
  }
}