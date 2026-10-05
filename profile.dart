import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'Images/Profile Image.png',
                ),
              ),

              const SizedBox(height: 10),

              const Text("Faizan Malik"),
              const Text("Islamabad"),
              const Text("abc@gmail.com"),
            ],
          ),
        ),
      ),
    );
  }
}
