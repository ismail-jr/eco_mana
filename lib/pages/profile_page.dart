import 'package:flutter/material.dart';
import '../widgets/chart_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1975D1);

    return Scaffold(
      backgroundColor: primaryBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryBlue,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: const [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: primaryBlue,
                      child: Icon(Icons.person, size: 55, color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Jibriel Ismail",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "jibrielismail@email.com",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const ChartSection(),
              const SizedBox(height: 30),

              _buildOptionCard(
                icon: Icons.settings,
                text: "Account Settings",
                onTap: () {},
              ),
              _buildOptionCard(
                icon: Icons.backup,
                text: "Backup & Restore",
                onTap: () {},
              ),
              _buildOptionCard(
                icon: Icons.logout,
                text: "Logout",
                iconColor: Colors.red,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Reusable Option Card
  Widget _buildOptionCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF1975D1),
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
