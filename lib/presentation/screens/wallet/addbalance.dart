import 'package:anti_procastination/constants.dart';
import 'package:flutter/material.dart';

class AddBalanceScreen extends StatefulWidget {
  @override
  _AddBalanceScreenState createState() => _AddBalanceScreenState();
}

class _AddBalanceScreenState extends State<AddBalanceScreen> {
  TextEditingController amountController = TextEditingController();

  void addAmount(String amount) {
    double current = double.tryParse(amountController.text) ?? 0;
    setState(() {
      amountController.text = (current + double.parse(amount)).toString();
    });
  }

  void processPayment() {
    double amount = double.tryParse(amountController.text) ?? 0;
    if (amount > 0) {
      // Implement payment gateway logic here
      print("Processing Payment of \$${amountController.text}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add Balance",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input Field
            const Text("Enter Amount (\$)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Add Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["10", "25", "50", "100"].map((amount) {
                return ElevatedButton(
                  onPressed: () => addAmount(amount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(
                    "+\$$amount",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Payment Options
            // const Text(
            //   "Select Payment Method",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 18,
            //   ),
            // ),
            // const SizedBox(height: 10),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     paymentOption(Icons.account_balance_wallet, "Google Pay"),
            //     paymentOption(Icons.payment, "PayPal"),
            //     paymentOption(Icons.qr_code, "UPI"),
            //   ],
            // ),
            const SizedBox(height: 30),

            // Add Balance Button
            Center(
              child: Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: mainColor,
                        blurRadius: 4,
                      )
                    ]),
                child: Center(
                  child: Text(
                    "Add Balance",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget paymentOption(IconData icon, String label) {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         backgroundColor: Colors.deepPurple,
  //         radius: 25,
  //         child: Icon(icon, color: Colors.white, size: 30),
  //       ),
  //       const SizedBox(height: 5),
  //       Text(label, style: const TextStyle(fontSize: 14)),
  //     ],
  //   );
  // }
}
