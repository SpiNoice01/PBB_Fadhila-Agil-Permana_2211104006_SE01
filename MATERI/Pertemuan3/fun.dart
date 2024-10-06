// simple function
void sayHello() {
  print('Hello');
}

// function with parameter
void sayHelloWithName(String name) {
  print('Hello $name');
}

// function with return value
int sum(int a, int b) {
  return a + b;
}

// function with optional parameter
void sayHelloWithOptionalName([String name = '']) {
  print('Hello$name');
}

// function with default parameter value
void sayHelloWithDefaultName([String name = 'John']) {
  print('Hello $name');
}

// function with named parameter
void sayHelloWithNameAndAge({String name, int age}) {
  print('Hello $name, you are $age years old');
}

// function with anonymous function
typedef MathFunction = int Function(int, int);

int executeMathFunction(MathFunction f, int a, int b) {
  return f(a, b);
}
