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

  // Variable para controlar la visibilidad de la contraseña
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    //final loginForm = Provider.of<LoginFormProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 192, 131, 51),
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
                decoration: const BoxDecoration(
                  //todo: agregar una imagen
                ),
              ),
              Container(
                width: size.width * 0.80,
                height: size.height * 0.05,
                alignment: Alignment.center,
              ),
              TextField( //CAMPO DEL CORREO
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'ejemplo@email.com',
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField( //CAMPO DE LA CONTRASEÑA
                controller: _passwordController,
                obscureText: _obscurePassword, // Controla si la contraseña está oculta o visible
                decoration: InputDecoration(
                  hintText: '*****',
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
                        _obscurePassword = !_obscurePassword; // Alterna la visibilidad
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Olvidaste tu contraseña?',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
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
                  print('Botón iniciar sesión');
                  Navigator.pushNamed(context, 'login', arguments: '');
                },
                child: const Text(
                  'Ya tienes una cuenta? Iniciar sesión',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 244, 244),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
