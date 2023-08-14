class RefreshException implements Exception {

  RefreshException();

  @override
  String toString() {
    return "RefreshException need to refresh access token";
  }
}