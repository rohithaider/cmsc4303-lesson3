import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';
import 'package:lesson3/screen/comment_screen.dart';
import 'package:lesson3/screen/myview/myimage.dart';

class SharedWithScreen extends StatefulWidget {
  static const routeName = '/sharedWithScreen';
  @override
  State<StatefulWidget> createState() {
    return _SharedWithState();
  }
}

class _SharedWithState extends State<SharedWithScreen> {
  _Controller con;
  User user;
  List<PhotoMemo> photoMemoList;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Shared with me'),
      ),
      body: photoMemoList.length == 0
          ? Text(
              'No Photo memo shared with me',
              style: Theme.of(context).textTheme.headline5,
            )
          : ListView.builder(
              itemCount: photoMemoList.length,
              itemBuilder: (context, index) => Card(
                elevation: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: MediaQuery.of(context).size.height * .4,
                        child: MyImage.network(
                          url: photoMemoList[index].photoURL,
                          context: context,
                        ),
                      ),
                    ),
                    Text(
                      'Title: ${photoMemoList[index].title}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text('Memo: ${photoMemoList[index].memo}'),
                    Text(
                      'Created by: ${photoMemoList[index].createdBy}',
                    ),
                    Text(
                      'Updated at: ${photoMemoList[index].timestamp}',
                    ),
                    Text(
                      'Shared with: ${photoMemoList[index].sharedWith}',
                    ),
                    Container(
                      child: Row(
                        children: [

                          IconButton(icon: Icon(Icons.comment),onPressed: (){
                            goToCommentScreen(photoMemoList[index]);
                          }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }


  void goToCommentScreen(PhotoMemo photoMemo) async{
    // photoMemo.comment = [{"email":"to@gmail.com","comment":"bad image "}];
    // await FirebaseController.updateCommentMemo(photoMemo.docId, photoMemo);

    await Navigator.pushNamed(context, CommentScreen.routeName, arguments: {
      Constant.ARG_COMMENT: photoMemo,
      Constant.ARG_USER: user,
    });
  }
}

class _Controller {
  _SharedWithState state;
  _Controller(this.state);
}
