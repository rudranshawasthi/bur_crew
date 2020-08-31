import 'package:bur_crew/models/appUser.dart';
import 'package:bur_crew/services/database.dart';
import 'package:bur_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:bur_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formkey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<appUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          UserData userData = snapshot.data;

          return Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                Text('Update your Brew Settings',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  initialValue: userData.name,
                  decoration: textInputDecoration,
                  validator: (val) => val.isEmpty ? 'Pleas enter name' : null,
                  onChanged: (val)=> setState(() => _currentName = val),
                ),
                SizedBox(height: 20,),
                // //Dropdown
                DropdownButtonFormField(
                  value: _currentSugars ?? userData.sugar ,
                  decoration: textInputDecoration,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() =>_currentSugars = val),
                ),
                //slider
                Slider(
                  min: 100,
                  max: 900,
                  divisions: 8,
                  activeColor: Colors.brown[_currentStrength ?? userData.strength],
                  inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  onChanged: (val) => setState(() =>_currentStrength = val.round()),
                ),
                RaisedButton(
                  color: Colors.pink[400],
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    print(_currentSugars ?? snapshot.data.sugar);
                    if(_formkey.currentState.validate()){
                      await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? snapshot.data.sugar,
                          _currentName ?? snapshot.data.name,
                          _currentStrength ?? snapshot.data.strength
                      );
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          );
        }
        else{
          return Loading();
        }
      }
    );
  }
}
