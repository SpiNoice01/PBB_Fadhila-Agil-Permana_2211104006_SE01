import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Formulir extends StatefulWidget {
  const Formulir({super.key});

  @override
  FormulirState createState() =>
      FormulirState(); // Change _FormulirState to FormulirState
}

class FormulirState extends State<Formulir> {
  // Change _FormulirState to FormulirState
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                style: GoogleFonts.comicNeue(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.red),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                style: GoogleFonts.comicNeue(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
