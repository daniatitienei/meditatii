class City {
  final List orase;

  City({
    required this.orase,
  });

  factory City.fromJson(json) {
    return City(
      orase: json,
    );
  }
}
