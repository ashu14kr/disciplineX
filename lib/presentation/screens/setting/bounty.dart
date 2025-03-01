import 'package:anti_procastination/constants.dart';
import 'package:flutter/material.dart';

class BountyScreen extends StatelessWidget {
  const BountyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Leaderboard & Bounty",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bounty Section
            _buildBountyCard(),
            const SizedBox(height: 20),
            // Leaderboard Section
            Expanded(child: _buildLeaderboard()),
          ],
        ),
      ),
    );
  }

  Widget _buildBountyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(color: mainColor, blurRadius: 8, spreadRadius: 1),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Total Bounty Pool",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(
            "💰 \$1,250",
            style: TextStyle(
              fontSize: 28,
              color: Colors.lightGreenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(
            value: 0.7,
            color: Colors.lightGreenAccent,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          SizedBox(height: 10),
          Text("You are in the top 15%! Keep going to earn more!",
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    final List<Map<String, dynamic>> users = [
      {'name': '🔥 John Doe', 'streak': 30, 'earnings': 150},
      {'name': '🔥 Alice Smith', 'streak': 25, 'earnings': 120},
      {'name': '🔥 Bob Johnson', 'streak': 20, 'earnings': 90},
    ];

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.green,
                  blurRadius: 2,
                ),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.lightGreenAccent,
                child: Text(
                  "#${index + 1}",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                users[index]['name'],
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("Streak: ${users[index]['streak']} days",
                  style: const TextStyle(color: Colors.grey)),
              trailing: Text(
                "💰 \$${users[index]['earnings']}",
                style: const TextStyle(
                  color: Colors.lightGreen,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
