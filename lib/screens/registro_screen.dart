import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front/services/auth_services.dart';
import 'package:front/services/notifications_services.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/img/registrofondo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ChangeNotifierProvider(
          create: (_) => AuthServices(),
          child: _RegisterForm(),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _obscurePassword = true;

  // Función para validar el correo electrónico
  String? _validateEmail(String value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Por favor ingrese un correo electrónico';
    } else if (!regex.hasMatch(value)) {
      return 'Por favor ingrese un correo electrónico válido';
    } else if (!value.endsWith('@gmail.com') && !value.endsWith('@yahoo.com')) {
      return 'El correo electrónico debe ser de dominio @gmail.com o @yahoo.com';
    }
    return null;
  }

  // Función para validar la contraseña
  String? _validatePassword(String value) {
    String pattern = r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) {
      return 'Por favor ingrese una contraseña';
    } else if (!regex.hasMatch(value)) {
      return 'Contraseña inválida: debe tener al menos 8 caracteres, incluir caracteres alfanuméricos y caracteres especiales';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthServices>(context, listen: false);

    return Center(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
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
                // Campo para Nombre de Usuario
                TextFormField(
                  controller: _userNameController,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Usuario123',
                    labelText: 'NOMBRE DE USUARIO',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 244, 244),
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color.fromARGB(251, 247, 22, 255), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Campo para Email
                TextFormField(
                  controller: _emailController,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'ejemplo@gmail.com',
                    labelText: 'CORREO ELECTRÓNICO',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 244, 244),
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color.fromARGB(251, 247, 22, 255), width: 2.0),
                    ),
                  ),
                  validator: (value) => _validateEmail(value!), // Validación del correo
                ),
                const SizedBox(height: 10),
                // Campo para Contraseña
                TextFormField(
                  controller: _passwordController,
                  autocorrect: false,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '********',
                    labelText: 'CONTRASEÑA',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 253, 246, 246),
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color.fromARGB(251, 247, 22, 255), width: 2.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: const Color.fromARGB(255, 253, 246, 246),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) => _validatePassword(value!), // Validación de la contraseña
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_emailController.text.isEmpty || _validateEmail(_emailController.text) != null) {
                      NotificationsServices.showSnackbar('El correo electrónico debe ser de dominio @gmail.com o @yahoo.com');
                      return;
                    }

                    if (_passwordController.text.isEmpty || _validatePassword(_passwordController.text) != null) {
                      NotificationsServices.showSnackbar('Contraseña inválida: debe tener al menos 8 caracteres, incluir caracteres alfanuméricos y caracteres especiales');
                      return;
                    }

                    try {
                      final errorMessage = await authService.createUser(
                        _emailController.text,
                        _passwordController.text,
                        _userNameController.text,
                      );

                      if (errorMessage == null) {
                        NotificationsServices.showSnackbar('Registro exitoso.');
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        NotificationsServices.showSnackbar(errorMessage);
                      }
                    } catch (e) {
                      // Capturar el error relacionado con el correo no válido
                      NotificationsServices.showSnackbar('El nombre de usuario o correo no es valido o se encuentra en uso');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(251, 247, 22, 255)),
                  ),
                  child: const Text(
                    'Registrarse',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 250, 253, 247),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Botón para navegar a la pantalla de login
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: const Text(
                    '¿Ya tienes una cuenta? Inicia sesión',
                    style: TextStyle(color: Color.fromARGB(255, 255, 244, 244)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
