/*
  Buatlah fungsi Dart yang menerima satu nilai integer sebagai parameter dan dapat mencari nilai tersebut dalam suatu List 2 dimensi bertipe integer berukuran 4, 
  yang isi masing-masing List-nya dengan perulangan:

  - baris 1 berisi 3 bilangan kelipatan 5 berurutan mulai dari 5
  - baris 2 berisi 4 bilangan genap berurutan mulai dari 2
  - baris 3 berisi 5 bilangan kuadrat dari bilangan asli mulai dari 1
  - baris 4 berisi 6 bilangan asli berurutan mulai dari 3

  Contoh output:
  Isi List:
  5 10 15
  2 4 6 8
  1 4 9 16 25
  3 4 5 6 7 8
  Bilangan yang dicari: 2
  2 berada di:
  baris 2 kolom 1
  Isi List:
  5 10 15
  2 4 6 8
  1 4 9 16 25
  3 4 5 6 7 8
  Bilangan yang dicari: 5
  5 berada di:
  baris 1 kolom 1
  baris 4 kolom 3*/

//==============================================================================
void main() {
  List<List<int>> list2D = [
    [5, 10, 15],
    [2, 4, 6, 8],
    [1, 4, 9, 16, 25],
    [3, 4, 5, 6, 7, 8]
  ];
  int cari = 2;
  bool found = false;
  for (int i = 0; i < list2D.length; i++) {
    for (int j = 0; j < list2D[i].length; j++) {
      if (list2D[i][j] == cari) {
        print('$cari berada di: baris ${i + 1} kolom ${j + 1}');
        found = true;
      }
    }
  }

  if (!found) {
    print('$cari tidak ditemukan');
  }
}
