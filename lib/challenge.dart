import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:tuple/tuple.dart';
import 'word.dart';

class ChallengePage extends StatelessWidget {
  final List<Word> wordList;
  final Color color;
  final Tuple2 prefix;
  ChallengePage(this.wordList, this.color, this.prefix);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Challenge'),
        backgroundColor: this.color,
      ),
      body: ChallengeBody(wordList, color, prefix),
    );
  }
}

class ChallengeBody extends StatefulWidget {
  final List<Word> wordList;
  final Color accentColor;
  final Tuple2 prefix;
  ChallengeBody(this.wordList, this.accentColor, this.prefix);
  @override
  _ChallengeBodyState createState() =>
      _ChallengeBodyState(wordList, accentColor, prefix);
}

class _ChallengeBodyState extends State<ChallengeBody> {
  List messages = [
    'Right!',
    'Wrong!',
    'moving to the next word',
    'End of the Challenge',
  ];
  int i = 0;
  int attempt = 3;
  final List<Word> wordList;
  final Color accentColor;
  final Tuple2 prefix;
  _ChallengeBodyState(this.wordList, this.accentColor, this.prefix);
  String message = '';
  final TextEditingController textController = new TextEditingController();

  // related to playing audio files.
  AudioCache player;

  @override
  initState() {
    super.initState();
    player = AudioCache(prefix: this.prefix.item1);
  }

  @override
  void dispose() {
    player = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: body(i),
    );
  }

  List<Widget> body(int i) {
    return [
      Card(
        color: this.accentColor,
        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0.01, 1],
                  colors: [Colors.purple, Colors.deepOrange])),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                playButton(context),
                Text(
                  '${this.wordList[i].word}',
                  style: headinSyle,
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Meaning: ${this.wordList[i].meaning}',
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Usage: ${this.wordList[i].usage}',
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Phonetic: ${this.wordList[i].phonetic}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      Text('You Have $attempt attempt(s) left.'),
      Text(
        message,
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: inputWordForm(),
      ),
    ];
  }

  Form inputWordForm() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: textController,
            onFieldSubmitted: (value) {
              setState(() {
                bool move = false;
                bool stillPages = i < this.wordList.length - 1;
                bool lastPage = i == this.wordList.length - 1;
                if (this.wordList[i].word == value) {
                  move = true;
                  if (lastPage) {
                    // If we reached the last word
                    attempt = 0;
                    message = messages[3];
                  } else {
                    attempt = 3;
                    message = messages[0];
                  }
                } else {
                  attempt--;
                  message = messages[1];
                  if (attempt < 1) {
                    move = true;
                    if (i == this.wordList.length - 1) {
                      // If we reached the last word. The player lost the game
                      message = messages[3];
                      attempt = 0;
                    } else {
                      // otherwise, we move to the next word.
                      message = messages[2];
                      attempt = 3;
                    }
                  }
                }
                if (stillPages && move) {
                  i++;
                  textController.text = '';
                }
              });
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w900, color: this.accentColor),
              labelText: 'Spell it!',
              hintText: 'Just try!',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 20, 20, 20)),
            ),
          ),
        ],
      ),
    );
  }

  Widget playButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(
                top: 10, left: 10.0, right: 10.0, bottom: 10.0),
            child: Center(
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(1),
                onPressed: () {
                  player.play('sound_${prefix.item2}_$i.mp3', volume: 1);
                },
                child: Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: this.accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final headinSyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final infoDevider = Divider(
  color: Colors.black,
  thickness: 1.0,
);