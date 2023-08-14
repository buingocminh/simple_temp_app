extension MapExtension on Map {
  Map<String,String> formatParam() {
    return map((key, value) {
      if(value is String && value.length > 100) {
        return MapEntry(key, value.substring(0,100));
      }
      return MapEntry(key, value);
    });
  }
}