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
        backgroundColor: const Color.fromARGB(255, 132, 149, 245),
        title: const Text('Nasi Padang'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 255, 251, 251),
        ),
      ),
      // ================================================================================================================
      body: ListView(
        children: [
          Container(
            color: const Color.fromARGB(255, 152, 209, 99),
            // 1. ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
            child: Column(
              children: <Widget>[
                //===============================================================================================
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 14, 223, 136),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        spreadRadius: 1,
                        blurRadius: 25,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // ================================================================================================================
                      // JUDUL
                      Container(
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(62, 0, 0, 0),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, -45),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: const Text(
                          "Agro Wisata Germanggis",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Image.network(
                        // IMG
                        "https://dolanbanyumas.banyumaskab.go.id/assets/gambar_objek/agro-wisata-germanggis.jpg",
                        height: 200,
                      ),
                      Container(
                        // DESC
                        padding: const EdgeInsets.only(
                            left: 50, right: 50, top: 10, bottom: 25),
                        alignment: Alignment.center,
                        child: const Text(
                          "Germanggis adalah sebuah kawasan wisata alam berkonsep wisata fun education. Ditempat ini kita bisa menikmati alam bebas yang udaranya sangat sejuk namun juga bisa mengadakan camping ceria. Selain berwisata alam dan camping seru di camp area Germanggis, kita juga bisa menikmati pemandangan perbukitan dengan spot foto keceh yang kekinian ala-ala kaum milenial. Banyak pengunjung yang sengaja datang kesini tidak hanya untuk camping saja melainkan hanya ingin berfoto dispot hits yang selama ini para selebgram berfoto.",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      // ================================================================================================================
                      // 2. ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      // ================================================================================================================
                      // JUDUL
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 14, 223, 136),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(62, 0, 0, 0),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, -5),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: const Text(
                          "Judul",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Image.network(
                        // IMG
                        "https://singervehicledesign.com/wp-content/uploads/singer-turbo-porsche-911-front-view.jpg",
                        height: 200,
                      ),
                      Container(
                        // DESC
                        padding: const EdgeInsets.all(9),
                        alignment: Alignment.center,
                        child: const Text(
                          "Deskripsi",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      // ================================================================================================================
                      // 3. ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      // ================================================================================================================
                      // JUDUL
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 14, 223, 136),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(62, 0, 0, 0),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, -5),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: const Text(
                          "Judul",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Image.network(
                        // IMG
                        "https://singervehicledesign.com/wp-content/uploads/singer-turbo-porsche-911-front-view.jpg",
                        height: 200,
                      ),
                      Container(
                        // DESC
                        padding: const EdgeInsets.all(9),
                        alignment: Alignment.center,
                        child: const Text(
                          "Deskripsi",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      // ================================================================================================================
                      // 4. ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                      // ================================================================================================================
                      // JUDUL
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 14, 223, 136),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(62, 0, 0, 0),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, -5),
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: const Text(
                          "Judul",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      Image.network(
                        // IMG
                        "https://singervehicledesign.com/wp-content/uploads/singer-turbo-porsche-911-front-view.jpg",
                        height: 200,
                      ),
                      Container(
                        // DESC
                        padding: const EdgeInsets.all(9),
                        alignment: Alignment.center,
                        child: const Text(
                          "Deskripsi",
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
