import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:tonic/tonic.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> notes = new List<String>();
  List<String> types = new List<String>();

  List<Note> inputs= new List<Note>();

  Note whole = new Note(16);
  Note half = new Note(8);
  Note quarter = new Note(4);
  Note eighth = new Note(2);
  Note sixteenth = new Note(1);
  //could potentially cause problems when we add pitch--every note of same length would have
  //the same pitch, since they're the same object

  @override
  initState() {
   FlutterMidi.unmute();
    rootBundle.load('assets/sounds/Steinway+Grand+Piano+ER3A.sf2').then((sf2) {
    FlutterMidi.prepare(sf2: sf2, name: "Piano.SF2");
    });
    super.initState();
  }

  double get keyWidth => 70 + (70 * _widthRatio);
  double _widthRatio = 0.0;
  bool _showLabels = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Side',
      theme: ThemeData.dark(),
      home: Scaffold(
          drawer: Drawer(
              child: SafeArea(
                  child: ListView(children: <Widget>[
                    Container(height: 20.0),
                    ListTile(title: Text("Change Width")),
                    Slider(
                        activeColor: Colors.redAccent,
                        inactiveColor: Colors.white,
                        min: 0.0,
                        max: 1.0,
                        value: _widthRatio,
                        onChanged: (double value) =>
                            setState(() => _widthRatio = value)),
                    Divider(),
                    ListTile(
                        title: Text("Show Labels"),
                        trailing: Switch(
                            value: _showLabels,
                            onChanged: (bool value) =>
                                setState(() => _showLabels = value))),
                    Divider(),
                  ]))),
          appBar: AppBar(title: Text("Music Side")),
          body: ListView.builder(
            itemCount: 7,
            controller: ScrollController(initialScrollOffset: 1500.0),
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              final int i = index * 12;
              return SafeArea(
                child: Stack(children: <Widget>[
                  Stack(children: <Widget>[
                    Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                      _buildKey(-2, false),
                      _buildKey(-3, false),
                      _buildKey(-4, false),
                      _buildKey(-5, false),
                      _buildKey(-6, false),
                      _buildKey(-7, false),
                      _buildKey(-9, false),
                      _buildKey(-10, false),
                    ]),

                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom:100.0,
                      top: 200.0,
                      child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        _buildKey(24 + i, false),
                        _buildKey(26 + i, false),
                        _buildKey(28 + i, false),
                        _buildKey(29 + i, false),
                        _buildKey(31 + i, false),
                        _buildKey(33 + i, false),
                        _buildKey(35 + i, false), //White keys made
                        _buildKey(0,false), //makes delete key
                      ])),
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 200.0,
                        top: 200.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(width: keyWidth * .5),//Spaces made
                              _buildKey(25 + i, true),
                              _buildKey(27 + i, true),
                              Container(width: keyWidth),
                              _buildKey(30 + i, true),
                              _buildKey(32 + i, true),
                              _buildKey(34 + i, true), //Black keys made
                              Container(width: keyWidth * 1.5),
                            ])),
                    /**Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 200.0,
                        top: 200.0,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(width: keyWidth * 7),//Spaces made
                              _buildKey(-1, false),
                            ])),*/
                    //Space Bar commented out for Zeu's plan
                  ]),
                  Text(_splitText(types)+"\n"+_splitText(notes),style:new TextStyle(color:Colors.deepOrange,fontSize: 25.0)),
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Icon((inputs.length >=1 ?(inputs[0]._getIcon()) : null)),
                    Icon((inputs.length >=2 ?(inputs[1]._getIcon()) : null)),
                    Icon((inputs.length >=3 ?(inputs[2]._getIcon()) : null)),
                    Icon((inputs.length >=4 ?(inputs[3]._getIcon()) : null)),

                    Icon((inputs.length >=5 ?(inputs[4]._getIcon()) : null)),
                    Icon((inputs.length >=6 ?(inputs[5]._getIcon()) : null)),
                    Icon((inputs.length >=7 ?(inputs[6]._getIcon()) : null)),
                    Icon((inputs.length >=8 ?(inputs[7]._getIcon()) : null)),
                  ]),

                ],)
              );
            },
          )),
    );
  }

  Widget _buildKey(int midi, bool accidental) {
   final pitchName = Pitch.fromMidiNumber(midi).toString();
   final String typeName = "1/" + pow(2,(-2-midi)).toString();
    final pianoKey = Stack(
      children: <Widget>[
        Semantics(
            button: true,
            hint: pitchName,
            child: Material(
                borderRadius: borderRadius,
                color: accidental ? Colors.black : (midi>0 ? Colors.white : (midi == 0 ? Colors.red : (midi>-10 ?Colors.blue : Colors.orange))),
                child: InkWell(
                  borderRadius: borderRadius,
                  highlightColor: midi>0 ? Colors.grey : (midi <= -1 && midi>-8 ? Colors.lightBlueAccent : Colors.redAccent),
                  onTap: () {
                    if(midi == 0){
                      _breakText(notes);
                      print(notes.toString());
                    }
                    else if(midi==-1){
                      _makeText(notes, "    ");
                      print(notes.toString());
                    }
                    else if(-9<midi && midi<-1){
                      //_makeText(types, typeName);
                      _checkAdd(inputs, new Note(midi));
                    }
                    else if(-9 == midi){
                      //switchToRests
                    }
                    else if(midi ==-10){
                      _breakNotes(inputs);
                    }
                    else{
                      _makeText(notes, pitchName);
                      print(notes.toString());}}, //Adds name to list
                  //onTapDown: (_) => print(notes.toString()), //print list
                ))),
        Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 20.0,
            child: midi>0
                ? Text(pitchName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: !accidental ? Colors.black : Colors.white))
                : (midi==0 || midi==-10 ? Icon(const IconData(57674, fontFamily: 'MaterialIcons', matchTextDirection: true))
                : (midi ==-1 ? Icon(const IconData(57942, fontFamily: 'MaterialIcons')) :
            Text(typeName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white))) )  ),
      ],
    );
    if (accidental) {
      return Container(
          width: keyWidth,
          margin: EdgeInsets.symmetric(horizontal: 2.0),
          padding: EdgeInsets.symmetric(horizontal: keyWidth * .1),//little borders
          child: Material(
              elevation: 6.0,
              borderRadius: borderRadius,
              shadowColor: Color(0x802196F3),
              child: pianoKey));
    }
    return Container(
        width: keyWidth,
        child: pianoKey,
        margin: EdgeInsets.symmetric(horizontal: 2.0));
  }

   _makeText(List<String> a,String b){
    setState(() {
      a.add(b);
    });
  }

  _breakText(List<String> a){
    setState((){
      if(a.length>0){
        a.removeLast();}
    });
  }


  String _splitText(List<String>a){
    String p = "";
    for(int i=0;i<a.length;i++){
      if(i%8 == 0){
        p=p+"\n";
      }
      p=p+a[i]+" ";

    }

    return p;
  }

  _checkAdd(List<Note> list, Note n){
    int sum = 0;
    for(int i = 0; i<list.length;i++ ){
      sum = sum + list[i]._getValue();
    }

    if(sum + n._getValue()>16){
        print("Error: too long for this bar");
        print(n._getValue());
    }
    else{
      setState(() {
        list.add(n);
      });
    }
  }

  _breakNotes(List<Note> a){
    setState((){
      if(a.length>0){
        a.removeLast();}
    });
  }

}

class Note {
  int value;
  IconData icon = IconData(0xe900, fontFamily: 'whole');
  int pseudoMidi;

  Note(num){
    if(num == -6){
      icon = IconData(0xe900, fontFamily: 'sixteenth');
      pseudoMidi = -6;
    }
    else if(num==-5){
      icon = IconData(0xe900, fontFamily: 'eighth');
      pseudoMidi = -5;
    }
    else if(num==-4){
      icon = IconData(0xe900, fontFamily: 'quarter');
      pseudoMidi = -4;
    }
    else if(num==-3){
      icon = IconData(0xe900, fontFamily: 'half');
      pseudoMidi = -3;
    }
    else if(num==-2){
      icon = IconData(0xe900, fontFamily: 'whole');
      pseudoMidi = -2;
    }
    else{
      icon = IconData(0xe900, fontFamily: 'sixteenth');
      pseudoMidi = -6;
    }
    value = pow(2,(6+pseudoMidi));
  }

  int _getValue(){
    return value;
  }

  IconData _getIcon(){
    return icon;
  }

  int _getPseudoMidi(){
    return pseudoMidi;
  }

}

const BorderRadiusGeometry borderRadius = BorderRadius.only(
    bottomLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0));

//https://docs.flutter.io/flutter/material/Icons-class.html

//https://flutterawesome.com/a-crossplatform-piano-made-with-flutter/