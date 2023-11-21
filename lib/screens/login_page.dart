import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:proyecto_final/fire_functions.dart';
import '../widgets/widgets_ui.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController, passwordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xff4ECDC4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Email Field
            TextFieldLogin(
              labelText: 'Correo Electrónico',
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 16.0),

            // Password Field
            TextFieldLogin(
              labelText: 'Contraseña',
              keyboardType: TextInputType.text,
              isPassword: true,
            ),

            const SizedBox(height: 16.0),

            // Normal Login Button
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(const Color(0xffF7FFF7)),
              ),
              onPressed: () {
                // Implementa la lógica de inicio de sesión normal aquí
              },
              child: Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: const Color(0xff292F36),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // Google Sign-In Button
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(const Color(0xffF7FFF7)),
              ),
              onPressed: () {
                FirebaseService.signInWithGoogle(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Logo(Logos.google, size: 20),
                  const SizedBox(width: 8.0),
                  Text(
                    'Iniciar Sesión con Google',
                    style: TextStyle(
                      color: const Color(0xff292F36),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
