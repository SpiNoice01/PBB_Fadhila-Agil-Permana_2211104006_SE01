void main() {
  int x = 5;
  String y = x > 10 ? "Greater than 10" : "Less than or equal to 10";
  print(y);

// =============================================================================
// Non nullable variable
  int a;
//print(a); " INI BAKALAN ERROR KARENA TIDAK TERDEFINISI ATAU KOSONG ATAU NULL"
//==============================================================================
// Kalau mau null
  int? b;
  print(b);
//================================================================================
// Nullable variable KHALENSKY
  String? c;
  print(c ?? "-");
  a = 10;
  print(a);

//================================================================================ Method / Function
// Method "tipe_Method nama_Method(parameter){
// proses
// return tipe Method

  
}
