class PostComments {
  var postId;
  var postUserId;
  List<Comments>? comments;

  PostComments({this.postId,this.postUserId,this.comments});

  PostComments.fromJson(Map<dynamic, dynamic> json)
  {
    postId = json["postId"];
    postUserId = json["postUserId"];
    if (json['comments'] != null) {
      comments =List<Comments>.filled(10, new Comments.fromJson(json),growable: true); //edited
      json['comments'].forEach((v)
      {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  var commentMessage;
  var senderPic;
  var timestamp;
  var senderName;
  var senderId;


  Comments({this.commentMessage, this.senderPic,this.timestamp,this.senderName,this.senderId});

  Comments.fromJson(Map<dynamic, dynamic> json) {
    commentMessage = json['commentMessage'];
    senderPic = json['senderPic'];
    timestamp = json['timestamp'];
    senderName = json['senderName'];
    senderId = json['senderId'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['commentMessage'] = this.commentMessage;
    data['senderPic'] = this.senderPic;
    data['timestamp'] = this.timestamp;
    data['senderName'] = this.senderName;
    data['senderId'] = this.senderId;
    return data;
  }
}