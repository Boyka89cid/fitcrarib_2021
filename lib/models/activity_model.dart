class ActivityModel {
  var userId;
  var postId;
  var userPic;
  var userName;
  var message;
  var isLiked;
  var imageUrl;
  var isFavorite;
  var likesCount;
  var timestamp;

  ActivityModel({this.userId,this.postId,this.userPic, this.userName, this.message, this.isLiked,this.imageUrl,this.isFavorite,this.likesCount,this.timestamp});

  factory ActivityModel.fromJson(Map<dynamic, dynamic> parsedJson) {
    return ActivityModel(
        userId: parsedJson['userId'],
        postId: parsedJson['postId'],
        userPic: parsedJson['userPic'],
        userName: parsedJson['userName'],
        message: parsedJson['message'],
        isLiked: parsedJson['isLiked'],
        imageUrl: parsedJson['imageUrl'],
        isFavorite: parsedJson['isFavorite'],
        likesCount: parsedJson['likesCount'],
        timestamp: parsedJson['timestamp']
    );
  }

  setFavoriteValue() {
    if(isFavorite){
      isFavorite = false;
    }
    else{
      isFavorite = true;
    }

  }

  setLikedValue(){
    if(isLiked){
      isLiked = false;
    }
    else{
      isLiked = true;
    }
  }

  Map<String, dynamic> toJson() => {
    'userId' : userId,
    'postId' : postId,
    'userPic': userPic,
    'userName': userName,
    'message' : message,
    'isLiked' : isLiked,
    'imageUrl' : imageUrl,
    'isFavorite' : isFavorite,
    'likesCount' : likesCount,
    'timestamp' : timestamp
  };
}
