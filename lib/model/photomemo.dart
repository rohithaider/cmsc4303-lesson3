class PhotoMemo {
  String docId; //firestore auto generated id
  String createdBy;
  String title;
  String memo;
  String photoFileName; //stored at storage of firebase non text database
  String photoURL;
  DateTime timestamp;
  List<dynamic> sharedWith; //list of email
  List<dynamic> imageLabels; //image identidfied my machine learning

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
  }) {
    this.sharedWith ??= [];
    this.imageLabels ??= [];
  }
}
