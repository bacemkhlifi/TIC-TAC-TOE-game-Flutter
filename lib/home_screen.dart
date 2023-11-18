import 'package:flutter/material.dart';
import 'package:ticktac/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  bool isSwitched = false;
  Game game = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:25.0),
            child: SwitchListTile.adaptive(
                title: const Text(
                  'Turn on/off two player',
                  style: TextStyle(color: Colors.white, fontSize: 26),
                ),
                value: isSwitched,
                onChanged: (bool newValue) {
                  setState(() {
                    isSwitched = newValue;
                  });
                }),
          ),
          //
          Text(
            "It's $activePlayer turn ",
            style: const TextStyle(color: Colors.white, fontSize: 52),
            textAlign: TextAlign.center,
          ),
          Expanded(
              child: GridView.count(
            padding: const EdgeInsets.all(16.0),
            crossAxisCount: 3,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            childAspectRatio: 1.0,
            children: List.generate(
                9,
                (index) => InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: gameOver ? null : () => _onTap(index),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).shadowColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            Player.playerX.contains(index)
                                ? "X"
                                : Player.playerO.contains(index)
                                    ? "O"
                                    : "",
                            style: TextStyle(
                                color: Player.playerX.contains(index)
                                    ? Colors.blue
                                    : Colors.pink,
                                fontSize: 52),
                          ),
                        ),
                      ),
                    )),
          )),

          Text(
            "$result",
            style: TextStyle(color: Colors.white, fontSize: 42),
            textAlign: TextAlign.center,
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                Player.playerX = [];
                Player.playerO = [];
                activePlayer = "X";
                gameOver = false;
                result = '';
                turn = 0;
              });
            },
            icon: const Icon(Icons.replay),
            label:  const Padding(
              padding:  EdgeInsets.symmetric(vertical:18.0,horizontal: 23),
              child:  Text("Repeat the game",style: TextStyle(fontSize: 16)),
            ),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).splashColor)),
          )
        ],
      )),
    );
  }

  _onTap(int index) async {
    if ((Player.playerO.isEmpty || !Player.playerO.contains(index)) &&
        (Player.playerX.isEmpty || !Player.playerX.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
      if(!isSwitched && !gameOver){
        await game.autoPlay(activePlayer);
        updateState();


      }

    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      turn ++;

      String winnerPlayer = game.checkWinner();
      if(winnerPlayer != ''){
        gameOver= true;
        result = '$winnerPlayer is the winner';
        }
      else if(!gameOver && turn == 9){
        result = "It's Draw !";
      }

    });
  }
}
