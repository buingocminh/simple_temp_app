import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/app_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String id = "HomeScreen";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Selector<AppState,UserModel>(
          selector: (ctx,state) => state.currentUser,
          shouldRebuild:(previous, next) => true,
          builder: (context, value, _) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value.name
                  ),
                  Text(
                    value.email
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}