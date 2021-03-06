class PhotoMemo {
  String docId; //firestore auto generated id
  String createdBy;
  String title;
  String memo;
  String photoFileName; //stored at storage of firebase non text database
  String photoURL;
  DateTime timestamp;
  String token;
  List<dynamic> sharedWith; //list of email
  List<dynamic> imageLabels; //image identidfied my machine learning
  List<dynamic> comment;
  List<dynamic> like;


  // key for Firestore document
  static const TITLE = 'title';
  static const MEMO = 'memo';
  static const CREATED_BY = 'createdBy';
  static const PHOTO_URL = 'photoURL';
  static const PHOTO_FILENAME = 'photoFilename';
  static const TIMESTAMP = 'timestamp';
  static const SHARED_WITH = 'sharedWith';
  static const IMAGE_LABELS = 'imageLabels';
  static const COMMENT = 'comments';
  static const LIKE = 'likes';
  static const TOKEN = 'token';

  PhotoMemo({
    this.docId,
    this.createdBy,
    this.memo,
    this.photoFileName,
    this.photoURL,
    this.timestamp,
    this.title,
    this.sharedWith,
    this.imageLabels,
    this.comment,
    this.like,
    this.token
  }) {
    this.sharedWith ??= [];
    this.imageLabels ??= [];
    this.comment ??= [];
    this.like??=[];
  }

  PhotoMemo.clone(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.memo = p.memo;
    this.photoFileName = p.photoFileName;
    this.photoURL = p.photoURL;
    this.title = p.title;
    this.timestamp = p.timestamp;
    this.sharedWith = [];
    this.sharedWith.addAll(p.sharedWith); //deep copy
    this.imageLabels = [];
    this.imageLabels.addAll(p.imageLabels); //deep copy
    this.comment?.add(p.comment);
    this.like?.add(p.like);
    this.token = p.token;
  }
  void assign(PhotoMemo p) {
    this.docId = p.docId;
    this.createdBy = p.createdBy;
    this.memo = p.memo;
    this.photoFileName = p.photoFileName;
    this.photoURL = p.photoURL;
    this.title = p.title;
    this.timestamp = p.timestamp;
    this.sharedWith.clear();
    this.sharedWith = p.sharedWith;
    this.imageLabels.clear();
    this.imageLabels.addAll(p.imageLabels);
    this.comment = p.comment;
    this.like = p.like;
    this.token = p.token;
  }

//from dart object to firestore document
  Map<String, dynamic> serialize() {
    return <String, dynamic>{
      TITLE: this.title,
      CREATED_BY: this.createdBy,
      MEMO: this.memo,
      PHOTO_FILENAME: this.photoFileName,
      PHOTO_URL: this.photoURL,
      TIMESTAMP: this.timestamp,
      SHARED_WITH: this.sharedWith,
      IMAGE_LABELS: this.imageLabels,
      COMMENT: this.comment,
      LIKE:this.like,
      TOKEN:this.token,
    };
  }

  static PhotoMemo deserialize(Map<String, dynamic> doc, String docId) {
    return PhotoMemo(
      docId: docId,
      createdBy: doc[CREATED_BY],
      title: doc[TITLE],
      memo: doc[MEMO],
      photoFileName: doc[PHOTO_FILENAME],
      photoURL: doc[PHOTO_URL],
      sharedWith: doc[SHARED_WITH],
      imageLabels: doc[IMAGE_LABELS],
      timestamp: doc[TIMESTAMP] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(doc[TIMESTAMP].millisecondsSinceEpoch),
      comment: doc[COMMENT],
      like: doc[LIKE],
      token:doc[TOKEN],
    );
  }

  static String validateTitle(String value) {
    if (value == null || value.length < 3)
      return 'too short';
    else
      return null;
  }

  static String validateMemo(String value) {
    if (value == null || value.length < 5)
      return 'too short';
    else
      return null;
  }

  static String validateSharedWith(String value) {
    if (value == null || value.trim().length == 0) return null;

    List<String> emailList = value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    for (String email in emailList) {
      if (email.contains('@') && email.contains('.'))
        continue;
      else
        return 'Comma(,) or space seperated email list';
    }
    return null;
  }
}
