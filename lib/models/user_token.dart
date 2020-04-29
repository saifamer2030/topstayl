

import 'package:firebase_database/firebase_database.dart';

class UserToken{

  String _id;
  String _token;

  UserToken(this._id,this._token);

  UserToken.map(dynamic obj){
    this._token = obj['Token'];
  }

  String get id => _id;
  String get token => _token;

  UserToken.fromSnapShot(DataSnapshot snapshot){
    _id = snapshot.key;
    _token = snapshot.value['Token'];

  }



}