import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/myview/mydialog.dart';

class AddPhotoMemoScreen extends StatefulWidget {
  static const routeName = '/addPhotoMemoScreen';
  @override
  State<StatefulWidget> createState() {
    return _AddPhotoMemoState();
  }
}

enum SingingCharacter { Imagelabeler, TextRecognition }

class _AddPhotoMemoState extends State<AddPhotoMemoScreen> {
  _Controller con;
  User user;
  List<PhotoMemo> photoMemoList;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File photo;
  String progressMessage;
  SingingCharacter _character = SingingCharacter.Imagelabeler;
  String token;

  @override
  void initState() {
    super.initState();
    con = _Controller(this);
  }

  void render(fn) => setState(fn);
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    user ??= args[Constant.ARG_USER];
    photoMemoList ??= args[Constant.ARG_PHOTOMEMOLIST];
    token ??= args[Constant.ARG_TOKEN];
    return Scaffold(
      appBar: AppBar(
        title: Text('Add PhotoMemo'),
        actions: [IconButton(icon: Icon(Icons.check), onPressed: con.save)],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: photo == null
                          ? Icon(
                        Icons.photo_library,
                        size: 300,
                      )
                          : Image.file(
                        photo,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: Container(
                        color: Colors.blue[200],
                        child: PopupMenuButton<String>(
                          onSelected: con.getPhoto,
                          itemBuilder: (context) => <PopupMenuEntry<String>>[
                            PopupMenuItem(
                              value: Constant.SRC_CAMERA,
                              child: Row(
                                children: [
                                  Icon(Icons.photo_camera),
                                  Text(Constant.SRC_CAMERA),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: Constant.SRC_GALLERY,
                              child: Row(
                                children: [
                                  Icon(Icons.photo_album),
                                  Text(Constant.SRC_GALLERY),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                progressMessage == null
                    ? SizedBox(
                  height: 1,
                )
                    : Text(
                  progressMessage,
                  style: Theme.of(context).textTheme.headline6,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  autocorrect: true,
                  validator: PhotoMemo.validateMemo,
                  onSaved: con.saveTitle,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Memo',
                  ),
                  autocorrect: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  validator: PhotoMemo.validateMemo,
                  onSaved: con.saveMemo,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'SharedWith (comma seperated email list)',
                  ),
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 2,
                  validator: PhotoMemo.validateSharedWith,
                  onSaved: con.saveSharedWith,
                ),

                Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('ML Image Labeler (Default)'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.Imagelabeler,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                            print("ML type is $_character");
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('ML Image Text Recognition'),
                      leading: Radio<SingingCharacter>(
                        value: SingingCharacter.TextRecognition,
                        groupValue: _character,
                        onChanged: (SingingCharacter value) {
                          setState(() {
                            _character = value;
                            print("ML type is $_character");
                          });
                        },
                      ),
                    ),
                  ],
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _AddPhotoMemoState state;
  _Controller(this.state);
  PhotoMemo tempMemo = PhotoMemo();

  void save() async {
    if (!state.formKey.currentState.validate()) return;
    state.formKey.currentState.save();

    MyDialog.circularProgressStart(state.context);

    try {
      Map photoInfo = await FirebaseController.uploadPhotoFile(
        photo: state.photo,
        uid: state.user.uid,
        listener: (double progress) {
          state.render(() {
            if (progress == null)
              state.progressMessage = null;
            else {
              progress *= 100;
              state.progressMessage = 'Uploading: ' + progress.toStringAsFixed(1) + ' %';
            }
          });
        },
      );
      //image labels by ML
      state.render(() => state.progressMessage = 'ML Image Labeler Started!');

      List<dynamic> imageLabels;
      if(state._character==SingingCharacter.Imagelabeler){
        imageLabels = await FirebaseController.getImageLabels(photoFile: state.photo);
      }else{
        imageLabels = await FirebaseController.getImageLabelsByTxtRecognization(photoFile: state.photo);
      }
      // List<dynamic> imageLabels =
      //     await FirebaseController.getImageLabels(photoFile: state.photo);


      // List<dynamic> imageLabels =
      //     await FirebaseController.getImageLabelsByTxtRecognization(photoFile: state.photo);

      state.render(() => state.progressMessage = null);

      tempMemo.photoFileName = photoInfo[Constant.ARG_FILENAME];
      tempMemo.photoURL = photoInfo[Constant.ARG_DOWNLOADURL];
      tempMemo.timestamp = DateTime.now();
      tempMemo.createdBy = state.user.email;
      tempMemo.imageLabels = imageLabels;
      tempMemo.token = state.token;
      // tempMemo.comment = [{"email":"to@gmail.com","comment":"i love this memo"}];
      String docId = await FirebaseController.addPhotoMemo(tempMemo);
      tempMemo.docId = docId;

      state.photoMemoList.insert(0, tempMemo);

      MyDialog.circularProgressStop(state.context);

      Navigator.pop(state.context); //return to user home screen
    } catch (e) {
      MyDialog.circularProgressStop(state.context);
      MyDialog.info(
        context: state.context,
        title: 'Save photo memo error',
        content: '$e',
      );
    }
  }

  void getPhoto(String src) async {
    try {
      PickedFile _imageFile;
      var _picker = ImagePicker();
      if (src == Constant.SRC_CAMERA) {
        _imageFile = await _picker.getImage(source: ImageSource.camera);
      } else {
        _imageFile = await _picker.getImage(source: ImageSource.gallery);
      }
      if (_imageFile == null) return; //selection canceled
      state.render(() => state.photo = File(_imageFile.path));
    } catch (e) {
      MyDialog.info(
        context: state.context,
        title: 'Failed to get picture',
        content: '$e',
      );
    }
  }

  void saveTitle(String value) {
    tempMemo.title = value;
  }

  void saveMemo(String value) {
    tempMemo.memo = value;
  }

  void saveSharedWith(String value) {
    if (value.trim().length != 0) {
      tempMemo.sharedWith = value.split(RegExp('(,| )+')).map((e) => e.trim()).toList();
    }
  }
}
