

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import '../model/photomemo.dart';

class CommentScreen extends StatefulWidget {

  static const routeName = '/commentScreen';

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {

  List<dynamic> commentList = [];
  PhotoMemo photoMemo;
  User user;
  final commentController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    Map args = ModalRoute.of(context).settings.arguments;
    photoMemo ??= args[Constant.ARG_COMMENT];
    user ??= args[Constant.ARG_USER];

    commentList = photoMemo.comment;
    return Scaffold(
        appBar: AppBar(title: Text("Comment")),
        body: Stack(
          children: [
            Positioned(
              child: Container(
                margin: EdgeInsets.all(10),
                child: commentList.length==0?
                Center(
                  child: Text(
                    'No Comment ',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ):Container(
                  height: MediaQuery.of(context).size.height-100,
                  child: ListView.builder(
                    itemBuilder: (context,index){
                      Map<String,String> newItem;
                      newItem = {"email":commentList[index]["email"],"comment":commentList[index]["comment"]};
                      return item(newItem,index);
                    },
                    itemCount: commentList.length,

                  ),
                ),
              ),
            ),

            SizedBox(height: 150,),
            Positioned(

                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Comment here "
                            ),
                            controller: commentController,
                            onChanged: (value){
                              print(value);
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: (){
                            if(commentController.text.isNotEmpty){
                              saveComment();
                            }

                          },
                        ),
                      ],
                    ),
                  ),
                )
            ),

            SizedBox(height: 150,),


          ],
        )
    );
  }


  Widget item(Map<String,String> item,int index){
    return Card(
      elevation: 7,
      child:Container(child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(5),
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(item["comment"],style: TextStyle(fontSize: 18),)),
                  IconButton(
                    alignment: Alignment.topRight,
                    icon: Icon(Icons.delete_forever),
                    color: Colors.red,
                    onPressed: (){
                      if(user.email==item["email"]){
                        deleteComment(index);
                      }

                    },
                  )
                ],
              )
          ),
          Container(
              margin: EdgeInsets.all(2),
              alignment: Alignment.bottomRight,
              child: user.email==item["email"]?Text("By You"):Text("By "+item["email"])
          )
        ],
      )),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }

  void saveComment() async{
    String comment  = commentController.text;
    print("comment by user is : $comment");
    // photoMemo.comment = [{"email":"to@gmail.com","comment":comment}];
    photoMemo.comment.add({"email":user.email,"comment":comment});
    await FirebaseController.updateCommentMemo(photoMemo.docId, photoMemo);
    setState(() {
      commentList = photoMemo.comment;
      commentController.text = "";
    });
  }

  void deleteComment(int index) async{
    // remvoe the item from the list and update doc
    photoMemo.comment.removeAt(index);
    await FirebaseController.deleteComment(photoMemo);
    setState(() {
      // photoMemo.comment;
    });


  }



}
