import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cars = <Map<String, String>>[
      {
        'name': 'Car 1',
        'video':
            'https://www.facebook.com/groups/617288102469624/permalink/1602425257289232/',
        'description': 'This is the description for Car 1.'
      },
      {
        'name': 'Car 2',
        'image': 'https://via.placeholder.com/150',
        'description': 'This is the description for Car 2.'
      },
      {
        'name': 'Car 3',
        'image': 'https://via.placeholder.com/150',
        'description': 'This is the description for Car 3.'
      },
      // Add more cars as needed
    ];
    return MaterialApp(
      home: Scaffold(
          // appBar: AppBar(
          //   title: const Text('Flutter App'),
          // ),
          body: CustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Demo'),
            ),
          ),
          // SliverGrid(
          //   gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          //     maxCrossAxisExtent: 200.0,
          //     mainAxisSpacing: 10.0,
          //     crossAxisSpacing: 10.0,
          //     childAspectRatio: 4.0,
          //   ),
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       return Container(
          //         alignment: Alignment.center,
          //         color: Colors.teal[100 * (index % 9)],
          //         child: Text('Grid Item $index'),
          //       );
          //     },
          //     childCount: 11,
          //   ),
          // ),
          SliverFixedExtentList(
            itemExtent: 200.0,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var car = cars[index];
                return Container(
                  alignment: Alignment.center,
                  color: Colors.lightBlue[100 * (index % 9)],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(car['image']!, width: 100, height: 100),
                      Text(car['name']!, style: const TextStyle(fontSize: 20)),
                      Text(car['description']!),
                    ],
                  ),
                );
              },
              childCount: cars.length,
            ),
          ),
        ],
      )),
    );
  }
}
