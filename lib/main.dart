import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart'; import 'package:flutter/services.dart';
import 'dart:async';

void main() => runApp(TheApp());

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music',
     // home: RandomWords(),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <String>[];//<String>[];
  final _biggerFont = const TextStyle(fontSize: 24.0);

  @override
    Widget build(BuildContext context){
    return Scaffold(appBar: AppBar(title: Text("Music"),),body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    Note n = new Note("C",4);
    List<Note> bar = new List<Note>();
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20.0),
      crossAxisSpacing: 10.0,
      crossAxisCount: 32,
      children: <Widget>[
        Text(
          "\n |\n |\n |\nO"
        ),
        Text(
            "_"
        ),
        Text(
            "_\n |\n |\n |\nO"
        ),
        Text(
            "_\n_\n |\n |\n |\n |\nO"
        ),
      ],
    );
  }

  Widget _buildRow(String str){
    return ListTile(title: Text(str,style: _biggerFont),);
  }

}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class Note{
  String name = "C";
  double pitch = 261.63;
  int midiValue = 60;
  int octave = 4;
  double basePitch = 32.705;
  //Icon symbol = TODO: Add symbol
  //For MIDDLE C


  Note(String theName,int theOctave){
    name = theName;
    octave = theOctave;
    this.setNote(name,octave);
  }

  String generate(int a){
    return "";
  }
  String getName(){
    return name;
  }

  String setNote(String theName,int theOctave){
    name = theName;
    octave = theOctave;
    if(name == "C#"){
      basePitch = 34.65;
    }
    else if(name == "D"){
      basePitch = 36.71;
    }
    else if(name == "D#"){
      basePitch = 38.89;
    }
    else if(name == "E"){
      basePitch = 41.20;
    }
    else if(name == "F"){
      basePitch = 43.65;
    }
    else if(name == "F#"){
      basePitch = 46.25;
    }
    else if(name == "G"){
      basePitch = 49.00;
    }
   else  if(name == "G#"){
      basePitch = 51.91;
    }
    else if(name == "A"){
      basePitch = 55.00;
    }
    else if(name == "A#"){
      basePitch = 58.27;
    }
    else if(name == "B"){
      basePitch = 61.74;
    }
    else if(name == "_"){
      basePitch = 0.0;
    }

    pitch = basePitch/2.0*(2^theOctave);
  }

}

//https://flutter.dev/docs/get-started/codelab


class TextAndIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text and Icon Button'),
      ),
      body: Center(
        child: FlatButton.icon(
          color: Colors.blue, //`Icon` to display
          label: Text('A'), //`Text` to display
          onPressed: () {
            print('yay');
          },
        ),
      ),
    );
  }



}

