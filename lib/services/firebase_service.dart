import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_final/screens/admin_page.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static String getCurrentUserId() {
    // Verifica si el usuario está autenticado
    User? user = FirebaseAuth.instance.currentUser;

    // Retorna el ID del usuario o una cadena vacía si no está autenticado
    return user?.uid ?? '';
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
  }
}
