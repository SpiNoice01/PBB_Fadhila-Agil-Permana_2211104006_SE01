import 'package:flutter/material.dart';
import 'package:yup/models/product.dart';

class Product {
  final String gambar;
  final String nama;
  final String deskripsi;
  final double harga;

  Product({
    required this.gambar,
    required this.nama,
    required this.deskripsi,
    required this.harga,
  });
}

class CardItems extends StatelessWidget {
  final List<Product> products;

  const CardItems({super.key, required this.products, required Produk product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
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
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

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
            Image.network(
              product.gambar,
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 16),
            Text(
              product.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              product.deskripsi,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ${product.harga}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
