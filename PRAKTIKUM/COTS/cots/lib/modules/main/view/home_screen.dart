import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Card(
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Saldo'),
                subtitle: Text('Rp 1.000.000'),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(8, (index) {
                return const Card(
                  child: Center(
                    child: Icon(Icons.shopping_cart),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Card(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: const Text('Full Width Card'),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(3, (index) {
                return Card(
                  child: Column(
                    children: [
                      Image.asset('lib/assets/${index + 1}.png'),
                      ListTile(
                        leading: const Icon(Icons.local_offer),
                        title: Text('Promo ${index + 1}'),
                        subtitle: Text('Detail promo ${index + 1}'),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
