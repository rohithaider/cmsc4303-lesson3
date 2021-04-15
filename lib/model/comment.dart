

class Comment{

  String email;
  String comment;
  List<dynamic> like;

  // firebase docs ids
  static const EMAIL = 'email';
  static const COMMENT = 'comment';
  static const LIKE = 'like';

  Comment({this.email,this.comment,this.like}){
    this.like ??= [];
  }


  Map<String,dynamic> toJson(){
    return <String,dynamic>{
      EMAIL:this.email,
      COMMENT:this.comment,
      LIKE:this.like
    };
  }


  Comment fromJson(Map<String,dynamic> item){
    return Comment(
      email: item[EMAIL],
      comment: item[COMMENT],
      like: item[LIKE]
    );
  }

}