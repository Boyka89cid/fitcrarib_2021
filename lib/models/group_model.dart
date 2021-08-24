
import 'dart:convert';

//GroupModel groupModelFromMap(String str) => GroupModel.fromMap(json.decode(str));

//String groupModelToMap(GroupModel data) => json.encode(data.toMap());

class GroupModel {
  GroupModel({
    required this.groupId,
    required this.groupName,
    required this.members,
    required this.timeWhenCreated,
  });

  String groupId;
  String groupName;
  List<String> members;
  DateTime timeWhenCreated;

  factory GroupModel.fromMap(Map<String, dynamic> json) => GroupModel(
    groupId: json["groupId"],
    groupName: json["groupName"],
    members: List<String>.from(json["members"].map((x) => x)),
    timeWhenCreated: DateTime.parse(json["timeWhenCreated"]),
  );

  Map<String, dynamic> toMap() => {
    "groupId": groupId,
    "groupName": groupName,
    "members": List<dynamic>.from(members.map((x) => x)),
    "timeWhenCreated": timeWhenCreated.toIso8601String(),
  };
}
