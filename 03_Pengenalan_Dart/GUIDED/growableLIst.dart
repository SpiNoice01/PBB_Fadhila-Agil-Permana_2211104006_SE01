void main() {
  // Membuat growable list (panjangnya bisa berubah)
  List<int> growableList = [];
  // Menambahkan elemen ke dalam list
  growableList.add(10);
  growableList.add(20);
  growableList.add(30);
  print(growableList); // Output: [10, 20, 30]
  // Menambahkan lebih banyak elemen
  growableList.add(40);
  growableList.add(50);
  print(growableList); // Output: [10, 20, 30, 40, 50]
  // Menghapus elemen dari list
  growableList.remove(20);
  print(growableList); // Output: [10, 30, 40, 50]
}
