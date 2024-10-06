import 'dart:io';

void main() {
  print('Masukkan nilai n: ');
  String? input = stdin.readLineSync();

  if (input != null) {
    try {
      int n = int.parse(input);
      if (n > 0) {
        for (int i = 0; i < n; i++) {
          var stars = '';
          for (int j = (n - i); j > 1; j--) {
            if (j > 0) {
              stars += ' ';
            }
          }
          for (int j = 0; j <= i; j++) {
            if (j >= 0) {
              stars += '* ';
            }
          }
          if (stars != null) {
            print(stars);
          }
        }
      } else {
        print('Nilai n harus lebih besar dari 0');
      }
    } catch (e) {
      print('Input tidak valid. Silakan masukkan nilai integer');
    }
  } else {
    print('Input tidak valid');
  }
}
