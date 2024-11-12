import 'package:flutter/material.dart';
import 'package:yup/models/product.dart';
import 'package:yup/src/bottomnavbar.dart';
import 'package:yup/src/searchbar.dart';
import 'package:yup/src/titletext.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Produk> products = [
    Produk(
        id: 1,
        nama: 'Product 1',
        harga: 1000,
        gambar:
            'https://m.media-amazon.com/images/I/61CGHv6kmWL.AC_UF894,1000_QL80.jpg',
        deskripsi: 'Deskripsi produk 1'),
    Produk(
        id: 2,
        nama: 'Product 2',
        harga: 2000,
        gambar:
            'https://resource.logitech.com/w_1600,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/keyboards/mx-mechanical/gallery/mx-mechanical-keyboard-top-view-graphite-us.png?v=1',
        deskripsi: 'Deskripsi produk 2'),
    Produk(
        id: 3,
        nama: 'Product 3',
        harga: 3000,
        gambar:
            'https://resource.logitechg.com/w_386,ar_1.0,c_limit,f_auto,q_auto,dpr_2.0/d_transparent.gif/content/dam/gaming/en/products/g502x-plus/gallery/g502x-plus-gallery-1-black.png?v=1',
        deskripsi: 'Deskripsi produk 3'),
    Produk(
        id: 3,
        nama: 'Product 3',
        harga: 3000,
        gambar:
            'https://resource.logitechg.com/w_386,ar_1.0,c_limit,f_auto,q_auto,dpr_2.0/d_transparent.gif/content/dam/gaming/en/products/g502x-plus/gallery/g502x-plus-gallery-1-black.png?v=1',
        deskripsi: 'Deskripsi produk 3'),
    Produk(
        id: 3,
        nama: 'Product 3',
        harga: 3000,
        gambar:
            'https://resource.logitechg.com/w_386,ar_1.0,c_limit,f_auto,q_auto,dpr_2.0/d_transparent.gif/content/dam/gaming/en/products/g502x-plus/gallery/g502x-plus-gallery-1-black.png?v=1',
        deskripsi: 'Deskripsi produk 3'),
    Produk(
        id: 3,
        nama: 'Product 3',
        harga: 3000,
        gambar:
            'https://resource.logitechg.com/w_386,ar_1.0,c_limit,f_auto,q_auto,dpr_2.0/d_transparent.gif/content/dam/gaming/en/products/g502x-plus/gallery/g502x-plus-gallery-1-black.png?v=1',
        deskripsi: 'Deskripsi produk 3'),
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              width: 600,
              height: 225,
              child: DecoratedBox(
                position: DecorationPosition.background,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/toppage.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SearchBarOutline(),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    Judul(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Two items per row
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.75, // Adjust ratio to control card height
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              product.gambar,
                              height: 50,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.nama,
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.deskripsi,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(fontSize: 4, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Harga: ${product.harga}',
                            style: const TextStyle(
                                fontSize: 4,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueAccent),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      product: product,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('View'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const Bottomnabar(),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Produk product;

  const DetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.nama),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(product.gambar),
            Text(product.deskripsi),
            Text('Harga: ${product.harga}'),
          ],
        ),
      ),
    );
  }
}
