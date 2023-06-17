class Player
{
  String name;
  int points = 0;

  Player(this.name);

  addPoints(int n)
  {
    this.points += n;
  }

  resetPoints()
  {
    this.points = 0;
  }

}

