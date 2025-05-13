import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_4_geodesica/services/auth_service.dart';
import 'package:flutter_application_4_geodesica/presentation/providers/userProvider.dart';
import 'package:flutter_application_4_geodesica/presentation/screens/chatMain.dart';
import 'package:flutter_application_4_geodesica/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Sign in with Firebase
      final userCredential = await authService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      if (userCredential.user != null) {
        // Get user details from Firestore
        final userModel =
            await authService.getUserDetails(userCredential.user!.uid);

        if (userModel != null) {
          // Set the current user in the provider
          userProvider.setCurrentUser(userModel);

          // Navigate to the chat screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No se encontró ningún usuario con ese correo electrónico.';
          break;
        case 'wrong-password':
          message = 'Contraseña incorrecta para este usuario.';
          break;
        case 'invalid-email':
          message = 'El formato del correo electrónico no es válido.';
          break;
        case 'user-disabled':
          message = 'Este usuario ha sido deshabilitado.';
          break;
        default:
          message = 'Error al iniciar sesión: ${e.message}';
      }
      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inesperado: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _register() async {
    final result = await Navigator.pushNamed(context, '/register');
    // After registration, the user should be automatically logged in
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is already logged in
    final authService = Provider.of<AuthService>(context);
    if (authService.currentUser != null) {
      // If the user is already logged in, redirect to the chat screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Geodesic Sphere Logo
                Image.asset(
                  'assets/imagenes/Geodesica_Logo.png',
                  height: 180,
                  width: 180,
                ),
                SizedBox(height: 10),

                // App Name
                Text(
                  'Geodesica',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF59A897),
                  ),
                ),
                SizedBox(height: 30),

                // Login Container
                Container(
                  width: 330,
                  decoration: BoxDecoration(
                    color: Color(0xFF59A897),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70),
                    ),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Login Title
                      Text(
                        'Inicio de sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),

                      // Subtitle
                      Text(
                        'Inicie sesión para continuar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1D413E),
                        ),
                      ),
                      SizedBox(height: 32),

                      // Error message (if any)
                      if (_errorMessage != null)
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),

                      // Email Input
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'CORREO',
                          labelStyle: TextStyle(color: Color(0xFF1D413E)),
                          filled: true,
                          fillColor: Color.fromARGB(99, 148, 148, 148),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16),

                      // Password Input
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'CONTRASEÑA',
                          labelStyle: TextStyle(color: Color(0xFF1D413E)),
                          filled: true,
                          fillColor: Color.fromARGB(99, 148, 148, 148),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 24),

                      // Login Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    'INICIAR SESIÓN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      SizedBox(height: 16),

                      // Register Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              'REGISTRARSE',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 2,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
