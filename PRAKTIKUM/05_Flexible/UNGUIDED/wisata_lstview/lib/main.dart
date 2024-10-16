import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final wisata = <Map<String, String>>[
      {
        'name': 'Curug Jenggala',
        'image':
            'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/be/c9/84/curug-jenggala.jpg?w=1000&h=-1&s=1',
        'description':
            'Curug Jenggala mempunyai keunikan dibandingkan dengan curug pada umumnya, yaitu berupa sebagai curug tumpuan tempat pertemuaan Sungai Banjaran dan Sungai Mertelu. Artikel ini telah tayang di Kompas.com dengan judul "Curug Jenggala di Banyumas: Daya Tarik, Harga Tiket, dan Rute".'
      },
      {
        'name': 'Baturraden',
        'image':
            'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0c/e4/37/94/the-baturaden-fountain.jpg?w=800&h=-1&s=1',
        'description':
            'Salah satu tempat wisata yang menjadi idola dan wajib di kunjungi saat berada di Kabupaten Banyumas adalah Lokawisata Baturraden. Yap, obyek wisata yang berada di wilayah Kecamatan Baturraden, Kabupaten Banyumas dan memiliki fasilitas terlengkap ini tidak bisa dilewatkan untuk dikunjungi.'
      },
      {
        'name': 'Curug Bayan',
        'image':
            'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/c7/f6/a8/20160402-112856-largejpg.jpg?w=800&h=-1&s=1',
        'description':
            'Objek wisata berbentuk air terjun ini terletak di Dusun Ketenger, Kecamatan Baturraden, Kabupaten Banyumas, Jawa Tengah. Para pengunjung dapat menemui lokasi ini dengan mudah menggunakan bantuan Google Maps. artikel detikjateng, "Curug Bayan, Wisata Air Terjun Banyumas yang Indah dan Mudah Diakses".'
      },
      // Add more nyantuis as needed
    ];

    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Flutter App'),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  '2211104006, Fadhila Agil Permana',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: <Color>[
                          const Color.fromARGB(255, 38, 0, 255),
                          const Color.fromARGB(255, 140, 0, 255)
                        ],
                      ).createShader(
                          const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 400,
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var nyantui = wisata[index];
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        color: Colors.lightBlue[100 * (index % 20)],
                        child: Column(
                          children: [
                            Image.network(nyantui['image']!,
                                width: 200, height: 200),
                            Text(nyantui['name']!,
                                style: const TextStyle(fontSize: 20)),
                            Text(
                              nyantui['description']!,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      if (index <
                          wisata.length -
                              1) // Add a divider except for the last item
                        const Divider(
                          thickness: 5,
                          color: Colors.grey,
                        ),
                    ],
                  );
                },
                childCount: wisata.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
