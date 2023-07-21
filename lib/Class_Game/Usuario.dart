class Usuario {
  late String name;
  late int points;

  Usuario(String n) {
    name = n;
    points = 0;
  }

  void updatePoints(int p) {
    points += p;
  }

  void resetPoints() {
    points = 0;
  }
}
