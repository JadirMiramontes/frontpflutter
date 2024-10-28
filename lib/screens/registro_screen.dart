import 'package:flutter/material.dart';
import 'package:front/providers/login_from_provider.dart';
import 'package:front/services/auth_services.dart';
import 'package:front/services/notifications_services.dart';
import 'package:provider/provider.dart';

class RegistroScreen extends StatefulWidget {
  RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/img/registrofondo.jpg"), // Ruta de la imagen de fondo
            fit: BoxFit.cover, // Ajuste para cubrir toda la pantalla
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: size.width * 0.80,
                height: size.height * 0.17,
                alignment: Alignment.center,
              ),
              Container(
                width: size.width * 0.80,
                height: size.height * 0.05,
                alignment: Alignment.center,
              ),
              TextField( // Campo de correo electrónico
                controller: _emailController,
                style: const TextStyle(color: Colors.white), // Texto de color blanco
                decoration: const InputDecoration(
                  hintText: 'ejemplo@email.com',
                  hintStyle: TextStyle(color: Colors.white70), // Hint de color blanco tenue
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Borde de color blanco
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Borde de color blanco al enfocarse
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField( // Campo de contraseña
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.white), // Texto de color blanco
                decoration: InputDecoration(
                  hintText: '*****',
                  hintStyle: const TextStyle(color: Colors.white70), // Hint de color blanco tenue
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color.fromARGB(255, 255, 244, 244),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Borde de color blanco
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white), // Borde de color blanco al enfocarse
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: Color.fromARGB(255, 255, 244, 244)),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final authService = Provider.of<AuthServices>(context, listen: false);

                  final String? errorMessage = await authService.createUser(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (errorMessage == null) {
                    Navigator.pushReplacementNamed(context, 'login');
                  } else {
                    NotificationsServices.showSnackbar(errorMessage);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 181, 184, 187),
                  ),
                ),
                child: const Text(
                  'Registra tu usuario',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 250, 253, 247),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'login', arguments: '');
                },
                child: const Text(
                  '¿Ya tienes una cuenta? Iniciar sesión',
                  style: TextStyle(color: Color.fromARGB(255, 255, 244, 244)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
