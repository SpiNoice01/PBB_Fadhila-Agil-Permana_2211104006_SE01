/*
Future<void> main() async {
  // Declare a variable without initialization
  String? name; // Use nullable type if you want to leave it uninitialized

  String name2 = "John"; // Initialize variable
  print(name2); // Print name2

  // Using other important data types: var and dynamic
  var nama3 = "John Denny"; // `var` infers the type from the value
  dynamic alamat = "Jl. Jalan"; // `dynamic` can hold any type

  // Differences between var and dynamic:
  // - var: A variable whose type is inferred at compile-time.
  // - dynamic: A variable whose type can change at runtime.

  // Example of changing dynamic variable
  alamat = 100; // Changing the type of 'alamat' is allowed
  print(nama3); // Print nama3
  print(alamat); // Print alamat
}
*/

/*
// List
void main() {
  List<dynamic> names = [
    'John',
    'Denny',
    'Sarah',
    100,
    ["John", "Denny", "Sarah"]
  ];
  //print(names);
  print(names[2]);
  print(names[4][1]);

  names.add("makan ," + " susu");
  print(names);
}
*/

/*
// Map
void main() {
  final studentData = <String, dynamic>{
    'name': 'John',
    'age': 20,
    'major': 'Computer Science',
  };

  final List<String> names = ['a', 'b', 'c'];
}
*/

/*
void main() {
  final List<Map<String, dynamic>> students = [
    {
      'name': 'John',
      'age': 20,
      'major': 'Computer Science',
    },
  ];
}
*/