import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../home/home_screen.dart';
import '../../common/extensions/string_extension.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const id = "LoginScreen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final Map<String,dynamic> _formData = {};

  Future _onLogin() async {
    if(_formKey.currentState?.validate() ?? false) {
      //TODO uncomment loader overlay when done mock to show loading
      
      // context.loaderOverlay.show();
      await context.read<AppState>().login(_formData).then(
        (value) {
          // context.loaderOverlay.hide();
          Navigator.of(context).pushNamed(HomeScreen.id);
        },
        onError: (object) {
          //TODO show error here
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "hello".tr()
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "email"
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "password"
                ),
              ),

              ElevatedButton(
                onPressed: _onLogin , 
                child: const Text(
                  "Login"
                )
              )


            ],
          ),
        ),
      ),
    );
  }
}