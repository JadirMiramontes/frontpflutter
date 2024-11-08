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
  final TextEditingController _nombreUsuarioController = TextEditingController(); // Agregado para el nombre de usuario
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/img/registrofondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder( // Envuelve en LayoutBuilder para controlar el espacio
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
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
                      // Campo de Nombre de Usuario
                      TextField(
                        controller: _nombreUsuarioController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Tu nombre de usuario',
                          hintStyle: const TextStyle(color: Colors.white70),
                          labelText: 'Nombre de Usuario',
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 255, 244, 244),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 206, 73, 211), width: 2.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Campo de correo electrónico
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'ejemplo@email.com',
                          hintStyle: const TextStyle(color: Colors.white70),
                          labelText: 'Email',
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 255, 244, 244),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 206, 73, 211), width: 2.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Campo de contraseña
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '*****',
                          hintStyle: const TextStyle(color: Colors.white70),
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 255, 244, 244),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility : Icons.visibility_off,
                              color: const Color.fromARGB(255, 255, 244, 255),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color.fromARGB(255, 206, 73, 211), width: 2.0),
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
                          backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 206, 73, 211)),
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
          },
        ),
      ),
    );
  }
}
