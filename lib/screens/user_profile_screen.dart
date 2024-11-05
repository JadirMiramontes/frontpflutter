// user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:front/services/auth_services.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart'; // Asegúrate de importar el modelo

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthServices>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Usuario'),
        backgroundColor: Color.fromARGB(253, 252, 147, 11),
      ),
      body: FutureBuilder<UserModel?>(
        future: authService.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Error al cargar la información.'));
          } else {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${user.email}', style: TextStyle(fontSize: 20)),
                  // Puedes agregar más información del usuario aquí
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
