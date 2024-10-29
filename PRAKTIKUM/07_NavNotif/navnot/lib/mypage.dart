import 'package:flutter/material.dart';

import 'package:navnot/models/product.dart';

class MyPage extends StatelessWidget {
  MyPage({super.key});

  final List<Product> products = [
    Product(
        id: 1,
        nama: 'Product 1',
        harga: 1000,
        gambar:
            'https://m.media-amazon.com/images/I/61CGHv6kmWL.AC_UF894,1000_QL80.jpg',
        deskripsi: 'Deskripsi produk 1'),
    Product(
        id: 2,
        nama: 'Product 2',
        harga: 2000,
        gambar:
            'https://resource.logitech.com/w_1600,c_limit,q_auto,f_auto,dpr_1.0/d_transparent.gif/content/dam/logitech/en/products/keyboards/mx-mechanical/gallery/mx-mechanical-keyboard-top-view-graphite-us.png?v=1',
        deskripsi: 'Deskripsi produk 2'),
    Product(
        id: 3,
        nama: 'Product 3',
        harga: 3000,
        gambar:
            'https://resource.logitechg.com/w_386,ar_1.0,c_limit,f_auto,q_auto,dpr_2.0/d_transparent.gif/content/dam/gaming/en/products/g502x-plus/gallery/g502x-plus-gallery-1-black.png?v=1',
        deskripsi: 'Deskripsi produk 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Page'),
        ),
        body: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];

            return ListTile(
              title: Text(product.nama),
              subtitle: Text(product.deskripsi),
              leading: Image.network(
                product.gambar,
                width: 70,
                height: 70,
              ),
              trailing: Text(product.harga.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      product: product,
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.nama),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.gambar, width: 100),
            const SizedBox(height: 16),
            Text(
              product.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Harga: ${product.harga}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(product.deskripsi),
          ],
        ),
      ),
    );
  }
}
