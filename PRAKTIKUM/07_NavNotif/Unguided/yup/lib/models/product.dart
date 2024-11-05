// ignore: file_names
class Product {
  final int id;
  final String nama;
  final double harga;
  final String gambar;
  final String deskripsi;

  Product({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.deskripsi,
  });

  // KONVERSI JSON KE PRODUK KITA
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      nama: json['nama'] as String,
      harga: json['harga'].toDouble(),
      gambar: json['gambar'] as String,
      deskripsi: json['deskripsi'] as String,
    );
  }

  // PRODUK KITA KE JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'gambar': gambar,
      'deskripsi': deskripsi
    };
  }
}
