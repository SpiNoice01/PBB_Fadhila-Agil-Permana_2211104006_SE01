double rerataIPKmahasiswa(List<double> ipk) =>
    ipk.reduce((a, b) => a + b) /
    ipk.length; //reduce adalah fungsi yang digunakan untuk menghitung jumlah elemen dalam list

void main() {
  print(rerataIPKmahasiswa([3.9, 3.88, 3.77, 3.55, 4.0])); //tipenya adalah list
}
