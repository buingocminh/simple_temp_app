import 'package:http/http.dart';

class MockCase {
  final String name;
  final String description;
  final Future<Response?> callBack;
  MockCase({
    required this.name,
    required this.description,
    required this.callBack,
  });
}