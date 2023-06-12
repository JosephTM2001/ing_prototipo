class Player
{
  String name;
  int points = 0;

  Player(this.name);

  AddPoints(int n)
  {
    this.points += n;
  }

  ResetPoints()
  {
    this.points = 0;
  }

}

