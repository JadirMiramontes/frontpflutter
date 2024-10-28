import 'package:flutter/material.dart';
import 'package:front/providers/login_from_provider.dart';
import 'package:front/services/auth_services.dart';
import 'package:front/services/notifications_services.dart';
import 'package:provider/provider.dart';

//Verificar la conexion con github

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: ChangeNotifierProvider(
          create: (_) => LoginFormProvider(),
          child: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true; // Controla si la contraseña está oculta o visible

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Center(
      child: Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 125, 100, 216)
          ),
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
                  decoration: const BoxDecoration(
                    // Agregar imagen si es necesario
                  ),
                ),
                Container(
                  width: size.width * 0.80,
                  height: size.height * 0.05,
                  alignment: Alignment.center,
                ),
                TextFormField( //CAMPO DEL CORREO
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'ejemplo@cola.com',
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 255, 244, 244),
                    ),
                  ),
                  validator: (value) {
                    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regExp = RegExp(pattern);
                    return regExp.hasMatch(value ?? '') ? null : 'El valor ingresado no es un correo válido';
                  },
                ),
                TextFormField( //CAMPO DE LA CONTRASEÑA
                  autocorrect: false,
                  controller: _passwordController,
                  obscureText: _obscurePassword, // Control de visibilidad de la contraseña
                  decoration: InputDecoration(
                    hintText: '********',
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 253, 246, 246),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Color.fromARGB(255, 253, 246, 246),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword; // Alterna la visibilidad
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    return (value != null && value.length >= 8) ? null : 'La contraseña debe tener al menos 8 caracteres';
                  },
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
                  onPressed: loginForm.isLoading ? null : () async {
                    final authService = Provider.of<AuthServices>(context, listen: false);

                    final String? errorMessage = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (errorMessage == null) {
                      Navigator.pushReplacementNamed(context, 'home');
                    } else {
                      NotificationsServices.showSnackbar(errorMessage);
                      loginForm.isLoading = false;
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 181, 184, 187),
                    ),
                  ),
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 250, 253, 247),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 173, 171, 171),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, 'register', arguments: '');
                  },
                  child: const Text(
                    'Regístrate',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 96, 108, 93),
                    ),
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