import 'dart:io';

void main() {
  // Get user input and convert it to an integer
  print("Masukkan Nilai Anda :");
  int? nilai = int.tryParse(stdin.readLineSync() ?? '');

  if (nilai != null) {
    if (nilai >= 70) {
      print("Nilai A");
    } else if (nilai >= 40) {
      print("Nilai B");
    } else
      print("Nilai C");
  }
}
