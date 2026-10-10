import 'package:flutter/material.dart';
import 'profile.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();

    username.text = "";
    password.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),

      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "Login",
                style: TextStyle(fontSize: 25),
              ),

              TextField(
                controller: username,
                decoration: const InputDecoration(
                  hintText: "Username",
                ),
              ),

              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  if (username.text == "Faizan" &&
                      password.text == "1234") {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Profile(),
                      ),
                    );
                  }
                },
                child: const Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
