import 'package:cots/modules/main/view/home_screen.dart';
import 'package:cots/modules/main/view/order_screen.dart';
import 'package:cots/modules/main/view/promos_screen.dart';
import 'package:cots/modules/main/view/chat_screen.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const PromosScreen(),
    const OrderScreen(),
    const ChatScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hide the back arrow
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search...',
              border: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(136, 203, 203, 203)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Color.fromARGB(
                        255, 103, 103, 103)), // Change to gray when focused
              ),
              hintStyle: TextStyle(color: Color.fromARGB(135, 102, 102, 102)),
              // Background color of the search field
            ),
            style: TextStyle(color: Color.fromARGB(255, 81, 81, 81)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 20),
            child: IconButton(
              icon: const Icon(
                Icons.person,
                color: Color.fromRGBO(0, 108, 2, 1),
                size: 40.0, // Increase the size of the icon
              ),
              onPressed: () {
                // Action for person icon
              },
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(
            0, 108, 2, 1), // Warna hijau pastel untuk item yang dipilih
        unselectedItemColor: const Color.fromRGBO(48, 176, 88,
            1), // Warna hijau pastel dengan opasitas untuk item yang tidak dipilih
        selectedLabelStyle: const TextStyle(
            color: Color.fromRGBO(
                0, 108, 2, 1)), // Warna teks untuk item yang dipilih
        unselectedLabelStyle: const TextStyle(
            color: Color.fromRGBO(
                48, 176, 88, 1)), // Warna teks untuk item yang tidak dipilih
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Promos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
