import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/myview/myimage.dart';

class DetailedViewScreen extends StatefulWidget {
  static const routeName = '/detailedViewScreen';
  @override
  State<StatefulWidget> createState() {
    return _DetailedViewState();
  }
}

class _DetailedViewState extends State<DetailedViewScreen> {
  _Controller con;
  User user;
  PhotoMemo onePhotoMemo;

  bool editMode = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    onePhotoMemo ??= args[Constant.ARG_ONE_PHOTOMEMO];
    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed view'),
        actions: [
          editMode
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: con.update,
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: con.edit,
                ),
        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .4,
                    child: con.photoFile == null
                        ? MyImage.network(
                            url: onePhotoMemo.photoURL,
                            context: context,
                          )
                        : Image.file(
                            con.photoFile,
                            fit: BoxFit.fill,
                          ),
                  ),
                  editMode
                      ? Positioned(
                          right: 0,
                          bottom: 21,
                          child: Container(
                            color: Colors.blue[500],
                            child: PopupMenuButton<String>(
                              onSelected: con.getPhoto,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: Constant.SRC_CAMERA,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.photo_camera,
                                        color: Colors.red,
                                      ),
                                      Text(Constant.SRC_CAMERA),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: Constant.SRC_GALLERY,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.photo_library,
                                        color: Colors.green,
                                      ),
                                      Text(Constant.SRC_GALLERY),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(height: 1),
                ],
              ),
              TextFormField(
                enabled: editMode,
                style: Theme.of(context).textTheme.headline6,
                decoration: InputDecoration(
                  hintText: 'Enter title',
                ),
                initialValue: onePhotoMemo.title,
                autocorrect: true,
                validator: PhotoMemo.validateTitle,
                onSaved: null,
              ),
              TextFormField(
                enabled: editMode,
                decoration: InputDecoration(
                  hintText: 'Enter memo',
                ),
                initialValue: onePhotoMemo.memo,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 6,
                validator: PhotoMemo.validateMemo,
                onSaved: null,
              ),
              TextFormField(
                enabled: editMode,
                decoration: InputDecoration(
                  hintText: 'Enter shared with (email list0',
                ),
                initialValue: onePhotoMemo.sharedWith.join('.'),
                autocorrect: true,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                validator: PhotoMemo.validateSharedWith,
                onSaved: null,
              ),
              SizedBox(
                height: 5,
              ),
              Constant.DEV
                  ? Text(
                      'Image Labels generated by ML',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : SizedBox(
                      height: 1,
                    ),
              Constant.DEV
                  ? Text(onePhotoMemo.imageLabels.join(' | '))
                  : SizedBox(
                      height: 1,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Controller {
  _DetailedViewState state;
  _Controller(this.state);
  File photoFile;

  void update() {
    state.render(() => state.editMode = false);
  }

  void edit() {
    state.render(() => state.editMode = true);
  }

  void getPhoto(String src) {}
}
