import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/services/auth_services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Información del Usuario'),
        backgroundColor: const Color.fromARGB(253, 252, 147, 11),
      ),
      body: FutureBuilder<String>(
        future: authService.readToken(), // Lee el token
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al obtener datos del usuario'));
          }
          final token = snapshot.data;
          if (token == null || token.isEmpty) {
            return const Center(child: Text('No hay información del usuario disponible.'));
          }

          // Decodifica el token JWT para obtener email y NombreUsuario
          final decodedToken = JwtDecoder.decode(token);
          final email = decodedToken['email'] ?? 'Email no disponible';
          final nombreUsuario = decodedToken['NombreUsuario'] ?? 'Nombre no disponible';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Email: $email',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  'Nombre de usuario: $nombreUsuario',
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
