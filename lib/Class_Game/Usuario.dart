class Usuario {
  late String name;
  late int points;
  late String icon;

  Usuario(String n,String i) {
    name = n;
    icon = i;
    points = 0;
  }

  void updatePoints(int p) {
    points += p;
  }

  void resetPoints() {
    points = 0;
  }
}
