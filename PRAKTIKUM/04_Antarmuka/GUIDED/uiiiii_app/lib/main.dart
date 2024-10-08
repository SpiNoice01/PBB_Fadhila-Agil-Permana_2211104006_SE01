import 'package:flutter/material.dart';

void main() {
  runApp(const NasiPadang());
}

class NasiPadang extends StatefulWidget {
  const NasiPadang({super.key});

  @override
  State<NasiPadang> createState() => _NasiPadangState();
}

class _NasiPadangState extends State<NasiPadang> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 14, 46, 223),
        title: const Text('Nasi Padang'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 251, 251),
        ),
      ),
      body: ListView(
        children: [
          Image.network(
            "https://singervehicledesign.com/wp-content/uploads/singer-turbo-porsche-911-front-view.jpg",
            height: 200,
          ),
          Container(
            padding: const EdgeInsets.all(80),
            color: const Color.fromARGB(255, 167, 78, 19),
            alignment: Alignment.center,
            child: const Text("He'd have you all unravel at the"),
          ),
          Container(
            padding: const EdgeInsets.all(80),
            color: const Color.fromARGB(255, 4, 196, 176),
            alignment: Alignment.center,
            child: const Text('Heed not the rabble'),
          ),
          Container(
            padding: const EdgeInsets.all(80),
            color: const Color.fromARGB(255, 143, 0, 238),
            alignment: Alignment.center,
            child: const Text('Sound of screams but the'),
          ),
          Container(
            padding: const EdgeInsets.all(80),
            color: const Color.fromARGB(255, 166, 38, 38),
            alignment: Alignment.center,
            child: const Text('Who scream'),
          ),
          Container(
            padding: const EdgeInsets.all(80),
            color: const Color.fromARGB(255, 15, 0, 150),
            alignment: Alignment.center,
            child: const Text('Revolution is coming...'),
          ),
          Container(
            padding: const EdgeInsets.all(80),
            color: const Color.fromARGB(255, 214, 250, 10),
            alignment: Alignment.center,
            child: const Text('Revolution, they...'),
          ),
        ],
      ),
    ));
  }
}

















/*
class NasiPadang extends StatefulWidget {
  const NasiPadang({super.key});

  @override
  State<NasiPadang> createState() => _NasiPadangState();
}

class _NasiPadangState extends State<NasiPadang> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 14, 46, 223),
          title: const Text('Nasi Padang'),
          titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 251, 251),
          ),
        ),
        body: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color.fromARGB(255, 167, 78, 19),
              alignment: Alignment.center,
              child: const Text("He'd have you all unravel at the"),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color.fromARGB(255, 4, 196, 176),
              alignment: Alignment.center,
              child: const Text('Heed not the rabble'),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color.fromARGB(255, 143, 0, 238),
              alignment: Alignment.center,
              child: const Text('Sound of screams but the'),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color.fromARGB(255, 166, 38, 38),
              alignment: Alignment.center,
              child: const Text('Who scream'),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color.fromARGB(255, 15, 0, 150),
              alignment: Alignment.center,
              child: const Text('Revolution is coming...'),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color.fromARGB(255, 214, 250, 10),
              alignment: Alignment.center,
              child: const Text('Revolution, they...'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

