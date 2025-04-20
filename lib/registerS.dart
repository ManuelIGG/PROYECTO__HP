import 'package:flutter/material.dart';
import 'authS.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController birthDateController = TextEditingController();
    TextEditingController documentController = TextEditingController();

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
                  TextField(
                    controller: birthDateController,
                    decoration: InputDecoration(
                      labelText: 'FECHA DE NACIMIENTO',
                      hintText: 'select (opcional)',
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
                    onPressed: () {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error'),
                              content: Text(
                                'Por favor, ingresa tu correo electrónico y contraseña.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cerrar'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        final result = {
                          'fullName': fullNameController.text,
                          'email': emailController.text,
                          'password': passwordController.text,
                          'birthDate': birthDateController.text,
                          'document': documentController.text,
                        };
                        Navigator.pop(context, result);
                      }
                    },
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
                    child: Text('REGISTRARSE'),
                  ),
                  SizedBox(height: 20),

                  // Enlace para iniciar sesión
                  GestureDetector(
                    onTap: () {
                      // Navigate to the login screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  AuthScreen(), // Replace with your actual login screen class name
                        ),
                      );
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
