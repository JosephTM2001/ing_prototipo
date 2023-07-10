class Player
{
  late String name;
  late int points;

  Player(String n)
  {
    name = n;
    points = 0;
  }

  void updatePoints(int p)
  {
    points += p;
  }

  void resetPoints()
  {
    points = 0;
  }

}