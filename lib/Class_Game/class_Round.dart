import 'class_Player.dart';

class Round
{
  List<Player> playersList = [];
  List<String> phrasesList = [];
  
  late int indexRound;
  late String theme,narrador;

  List<int> electionList = [];

  Round(List<Player> pl, int ir)
  {
    playersList = pl;
    indexRound = ir;
    theme = '';
    narrador = playersList[0].name;
  }

  void setTheme(String t)
  {
    theme = t;
  }

  void setPhrase(String p)
  {
    phrasesList.add(p);
  }

  void setPlayerselection(int ps)
  {
    electionList.add(ps);
  }

  void getPoints()
  {
    bool confirmed = false;
    int p = 0;

    for(int i = 0; i < electionList.length;i++)
    {
      if(electionList[i] == 0)
      {
        confirmed = true;
        p++;
      }

      if(p == playersList.length - 1)
      {
        confirmed = false;
      }

      for(int j = 1; j < playersList.length;j++)
      {
        if(electionList[i] == j && i != j-1)
        {
          playersList[j].points += 1;
        }
      }
    }

    if(confirmed)
    {  
      playersList[0].points += 2;
      for(int i = 0; i < electionList.length;i++)
      {
        if(electionList[i] == 0)
        {
          playersList[i+1].points += 3;
        }
      }
    }

    else
    {
      for(int i = 0; i < electionList.length;i++)
      {
          playersList[i+1].points += 2;
      }
    }
  }

  List<Player> getPlayerUpdate()
  {
    return playersList;
  }

  Map<String,dynamic> updateSavegame(savegamep)
  {
    savegamep['Ronda ${indexRound}'];
    savegamep['Ronda ${indexRound},Tema:'] =  theme;
    savegamep['Ronda ${indexRound},Narrador:'] = narrador;
    savegamep['Ronda ${indexRound},Jugadores:'] = playersList;
    savegamep['Ronda ${indexRound},Frases:'] = phrasesList;

    return savegamep;
  }

  int getHighpoint()
  {
    int p = 0;

    for(int i = 0; i < playersList.length;i++)
    {
      if(playersList[i].points > p)
      {
        p = playersList[i].points;
      }
    }

    return p;
  }

}