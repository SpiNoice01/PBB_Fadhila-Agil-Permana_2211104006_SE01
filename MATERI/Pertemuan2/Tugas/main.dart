void main() {
  List<Map<String, dynamic>> daftarMahasiswa = [
    {
      "nama": "John Doe",
      "ipk": 3.88,
      "isMarried": false,
    },
    {
      "nama": "Andi Doe",
      "ipk": 3.78,
      "isMarried": true,
    },
    {
      "nama": "Budi Doe",
      "ipk": 3.68,
      "isMarried": true,
    }
  ];

// Jawab =======================================================================
  //print(daftarMahasiswa);

// A. Menghitung rerata IPK
// Testing print(daftarMahasiswa[1]["ipk"]);
  var panjang = daftarMahasiswa.length;
  var ipk1 = daftarMahasiswa[0]["ipk"];
  var ipk2 = daftarMahasiswa[1]["ipk"];
  var ipk3 = daftarMahasiswa[2]["ipk"];
  var totalIPK = (ipk1 + ipk2 + ipk3);
  var rerataIPK = totalIPK / panjang;
  print("Rerata IPK: $rerataIPK");

// B. Menjumlahkan berapa banyak mahasiswa yang sudah menikah
  int jumlahNikah = 0;
  for (var mahasiswa in daftarMahasiswa) {
    if (mahasiswa["isMarried"] == true) {
      jumlahNikah++;
    }
  }
  print("Jumlah mahasiswa yang sudah menikah: $jumlahNikah");
}
// A. Menghitung rerata IPK
//   double totalIPK = 0;
//   for (var mahasiswa in daftarMahasiswa) {
//     totalIPK += mahasiswa["ipk"];
//     //print(mahasiswa);
//     //print("Total IPK:");
//   }

//   var rerataIPK = totalIPK / daftarMahasiswa.length;
//   print("Rerata IPK: $rerataIPK");

//   // B. Menjumlahkan berapa banyak mahasiswa yang sudah menikah
//   int jumlahMenikah = 0;
//   for (var mahasiswa in daftarMahasiswa) {
//     if (mahasiswa["isMarried"] == true) {
//       jumlahMenikah++;
//     }
//   }
//   print("Jumlah mahasiswa yang sudah menikah: $jumlahMenikah");
// }
