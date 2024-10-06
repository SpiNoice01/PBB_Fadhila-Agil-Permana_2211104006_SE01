import 'dart:io';

void main() {

  print("Masukkan Nilai Anda :");
  int? nilai = int.tryParse(stdin.readLineSync() ?? '');

  if (nilai == null) {
    print("Input tidak valid");
  } else if (nilai % 2 == 0) {
    print("Nilai Genap");
  } else {
    print("Nilai Prima");
  }
}
