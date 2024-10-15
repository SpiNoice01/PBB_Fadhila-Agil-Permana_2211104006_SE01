/*
  Buatlah fungsi Dart yang membuat suatu matriks AxB dengan A dan B sebagai parameter. 
  Isi tiap nilai matriks (bebas atau di-random), 
  lalu outputkan matriks tersebut dan matriks transpose-nya.

  Contoh output:
  Matriks AxB
  A: 3
  B: 2
  Isi matriks:
  1 2
  3 4
  5 6
  Hasil transpose:
  1 3 5
  2 4 6*/

// ================================================================================
void main() {
  int a = 3;
  int b = 2;
  List<List<int>> matriks =
      List.generate(a, (i) => List.generate(b, (j) => i * b + j + 1));
  print("Matriks $a x $b");
  print("Isi matriks:");
  for (var row in matriks) {
    print(row.join(" "));
  }
  print("Hasil transpose:");
  for (int i = 0; i < b; i++) {
    List<int> col = [];
    for (var row in matriks) {
      col.add(row[i]);
    }
    print(col.join(" "));
  }
}
