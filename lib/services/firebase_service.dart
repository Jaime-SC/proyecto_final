import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_final/screens/admin_page.dart';
import 'package:uuid/uuid.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static String? _currentUserId; // Nuevo: Almacena el identificador único del usuario

  static String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      // Si no hay un usuario autenticado, utiliza el identificador único del usuario anónimo
      if (_currentUserId == null) {
        // Si el identificador aún no se ha generado, genera uno nuevo
        _currentUserId = 'anonymous_${Uuid().v4()}';
      }
      return _currentUserId!;
    }
  }

  static Future<String?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);

      // Navega a la página de inicio después de iniciar sesión
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );

      // Devuelve un valor String o null al final de la función
      return "Usuario autenticado"; // Puedes cambiar esto según tus necesidades
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _currentUserId = null; // Nuevo: Restablece el identificador único al cerrar sesión
  }
}