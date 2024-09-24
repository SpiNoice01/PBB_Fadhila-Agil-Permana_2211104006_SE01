import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Align(
          alignment: Alignment.center,
          child: Text('Pertemuan Praktikum 2'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              color: Colors.red,
              padding: const EdgeInsets.all(10),
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 50),
              child: Container(
                color: Colors.yellow,
                height: 100,
              ),
            ),
            const Center(
              child: Text('Ini adalah widget center'),
            ),
            Row(
              children: const [
                Icon(Icons.add),
                SizedBox(width: 10),
                Text('Tambah widget'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
