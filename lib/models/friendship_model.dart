
import 'dart:convert';

Map<String, FriendshipModel> friendshipModelFromMap(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, FriendshipModel>(k, FriendshipModel.fromMap(v)));

String friendshipModelToMap(Map<String, FriendshipModel> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())));

class FriendshipModel
{
  String name;
  String profilePic;

  FriendshipModel({required this.name, required this.profilePic,});

  factory FriendshipModel.fromMap(Map<String, dynamic> json) => FriendshipModel(name: json["name"], profilePic: json["profilePic"],);

  Map<String, dynamic> toMap() =>
    {
      "name": name,
      "profilePic": profilePic
    };
}

// To parse this JSON data, do
//
//     final friendModel = friendModelFromMap(jsonString);

FriendModel friendModelFromMap(String str) => FriendModel.fromMap(json.decode(str));

String friendModelToMap(FriendModel data) => json.encode(data.toMap());

class FriendModel {
  FriendModel({required this.key,});

  Key key;

  factory FriendModel.fromMap(Map<String, dynamic> json) => FriendModel(
    key: Key.fromMap(json["key"]),
  );

  Map<String, dynamic> toMap() => {
    "key": key.toMap(),
  };
}

class Key {
  Key({
    required this.name,
    required this.profilePic,
  });

  String name;
  String profilePic;

  factory Key.fromMap(Map<String, dynamic> json) => Key(
    name: json["name"],
    profilePic: json["profilePic"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "profilePic": profilePic,
  };
}
