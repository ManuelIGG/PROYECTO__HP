import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_4_geodesica/services/auth_service.dart';
import 'package:flutter_application_4_geodesica/presentation/providers/userProvider.dart';
import 'package:flutter_application_4_geodesica/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController documentController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    documentController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        birthDateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _register() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, completa los campos obligatorios.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Create a UserModel from the form data
      final user = UserModel(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text, // This won't be stored
        birthDate: birthDateController.text.trim(),
        document: documentController.text.trim(),
      );

      // Register the user with Firebase
      final result = await authService.registerWithEmailAndPassword(
        user,
        passwordController.text,
      );

      if (result.user != null) {
        // Set the current user in the provider
        userProvider.setCurrentUser(user);

        // Return to the login screen (or you could navigate directly to the app)
        Navigator.pop(context, {
          'email': user.email,
          'password': passwordController.text,
        });
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'La contraseña proporcionada es demasiado débil.';
          break;
        case 'email-already-in-use':
          message = 'Ya existe una cuenta con este correo electrónico.';
          break;
        case 'invalid-email':
          message = 'El formato del correo electrónico no es válido.';
          break;
        default:
          message = 'Error en el registro: ${e.message}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2F1), // Light teal background
              Color(0xFFB2DFDB), // Darker teal background
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    'Crear una nueva cuenta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

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

                  // Nombre Completo
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'NOMBRE COMPLETO',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Email
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'EMAIL',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Contraseña
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'CONTRASEÑA',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Fecha de Nacimiento
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: birthDateController,
                        decoration: InputDecoration(
                          labelText: 'FECHA DE NACIMIENTO',
                          suffixIcon: Icon(Icons.calendar_today),
                          hintText: 'Seleccionar (opcional)',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                          hintStyle:
                              TextStyle(color: Colors.black45, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  // Documento
                  TextField(
                    controller: documentController,
                    decoration: InputDecoration(
                      labelText: 'DOCUMENTO',
                      hintText: '78569847 (opcional)',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                      hintStyle: TextStyle(color: Colors.black45, fontSize: 14),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Botón de Registro
                  ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text('REGISTRARSE'),
                  ),
                  SizedBox(height: 20),

                  // Enlace para iniciar sesión
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '¿Ya estás registrado? Inicia sesión aquí...',
                      style: TextStyle(
                        color: Colors.black87,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
