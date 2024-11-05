import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            InkWell(
              onTap: () => _showAlertDialog(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://example.com/image.jpg'),
                    ),
                    SizedBox(width: 10), // Add spacing here instead of Divider
                    Text("Native App", style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
            ),
            const Divider(height: 20),
            InkWell(
              onTap: () => _showAlertDialog2(context),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://example.com/image.jpg'),
                    ),
                    SizedBox(width: 10), // Add spacing here instead of Divider
                    Text("Hybrid App", style: TextStyle(fontSize: 30)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//=================================================================================================DATA
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detail',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Native App',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              Text('Android, IOS, Web, JavaScript, Dart'),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialog2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Detail',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hybrid App',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              Text('????'),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
