import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: 225,
        child: DecoratedBox(
          position: DecorationPosition.background,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/toppage.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              SizedBox(
                width: 400, // make it take the full width
                height: 50, // specify the desired height
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        width: 2), // specify the outline color
                    borderRadius:
                        BorderRadius.circular(10), // match the border radius
                  ),
                  child: SearchBar(
                    hintText: "Search",
                    hintStyle: WidgetStateProperty.all(
                        const TextStyle(color: Colors.white)),
                    textStyle: WidgetStateProperty.all(
                        const TextStyle(color: Colors.white)),
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0x00000000)),
                    shape: WidgetStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Column(
                    children: [
                      Text(
                        'Selamat Datang, S',
                        style: TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 231, 231, 231)),
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      Text(
                        'Ini Aplikasi Ala2 buat latihan & Tugas Unguided.',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 231, 231, 231)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
} 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
          
//           title: const Text('My Page'),
//         ),
//         body: ListView.builder(
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];

//             return ListTile(
//               title: Text(product.nama),
//               subtitle: Text(product.deskripsi),
//               leading: Image.network(
//                 product.gambar,
//                 width: 70,
//                 height: 70,
//               ),
//               trailing: Text(product.harga.toString()),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => DetailPage(
//                       product: product,
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ));
//   }
// }

// class DetailPage extends StatelessWidget {
//   final Product product;

//   const DetailPage({required this.product, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product.nama),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(product.gambar, width: 100),
//             const SizedBox(height: 16),
//             Text(
//               product.nama,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Harga: ${product.harga}',
//               style: const TextStyle(fontSize: 20),
//             ),
//             const SizedBox(height: 8),
//             Text(product.deskripsi),
//           ],
//         ),
//       ),
//     );
//   }
// }
