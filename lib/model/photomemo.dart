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
