import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FilterChip(label: const Text("GoFood"), onSelected: (_) {}),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: "Status",
                  items: ["Status"]
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          // Transaction Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InkWell(
              onTap: () {},
              child: const Row(
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Transaksi Gopay", style: TextStyle(color: Colors.blue)),
                  Spacer(),
                  Icon(Icons.chevron_right, color: Colors.blue),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1),
          // List of Orders
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Example item count
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading:
                        const Icon(Icons.restaurant_menu, color: Colors.red),
                    title: const Text("Ayam Benjoss, kedungkandang"),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("3 item\n2 Paket Ayam Bakar Jumbo"),
                        Text(
                          "Makanan sudah diantar\n28 Des 11.36",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Rp. 58.800"),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                          ),
                          child: const Text(
                            "Pesan lagi",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
