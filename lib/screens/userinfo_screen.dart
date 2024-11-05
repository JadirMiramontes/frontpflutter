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
      ),
      body: FutureBuilder<String>(
        future: authService.readToken(), // Aquí leemos el token
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al obtener datos del usuario'));
          }
          final token = snapshot.data;
          if (token == null || token.isEmpty) {
            return Center(child: Text('No hay información del usuario disponible.'));
          }

          // Decodificamos el token JWT para obtener el email
          final decodedToken = JwtDecoder.decode(token);
          final email = decodedToken['email'] ?? 'Email no disponible';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 24),
                ),
                // Puedes agregar más información si deseas
                const SizedBox(height: 20),
                const Text(
                  'Puedes agregar más información aquí.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
