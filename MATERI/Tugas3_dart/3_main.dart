/*
  Buatlah fungsi Dart yang menerima dua nilai integer positif 
  dan mengoutputkan nilai KPK (Kelipatan Persekutuan terKecil) dari dua bilangan tersebut
  Contoh output:
  Bilangan 1: 12
  Bilangan 2: 8
  KPK 12 dan 8 = 24*/

//==============================================================================
int kpk(int a, int b) {
  int result = (a > b) ? a : b;

  while (result % a != 0 || result % b != 0) {
    result++;
  }

  return result;
}

void main() {
  int a = 12;
  int b = 8;

  print('Bilangan 1: $a');
  print('Bilangan 2: $b');
  print('KPK $a dan $b = ${kpk(a, b)}');
}
