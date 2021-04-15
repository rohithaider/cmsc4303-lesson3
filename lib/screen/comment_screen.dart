

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/comment.dart';
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
  bool _isCommentEditEnable = false;
  int _editCommentIndex = -1;

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
    print("main data: $commentList");
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
                      print("online data : ${commentList[index]["like"]}");
                      // newItem = {"email":commentList[index]["email"],"comment":commentList[index]["comment"],"like":commentList[index]};
                      var commentItem = Comment(
                          email:commentList[index]["email"],
                          comment: commentList[index]["comment"],
                          like:commentList[index]["like"]
                      );

                      print("comment json data : ${commentItem.toJson().toString()}");
                      return item(commentItem,index);
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


  void _editComment(String comment,index){


    setState(() {
      _isCommentEditEnable = true;
      commentController.text = comment;
      _editCommentIndex = index;
    });

    print("edit  for comment: ${commentController.text} and index $_editCommentIndex");


  }


  // Widget item(Map<String,String> item,int index){
  //   return Card(
  //     elevation: 7,
  //     child:InkWell(
  //       onLongPress:(){
  //
  //         _editComment(item["comment"],index);
  //       },
  //       child: Container(child: Column(
  //         children: [
  //           Container(
  //               margin: EdgeInsets.all(5),
  //               alignment: Alignment.bottomLeft,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Expanded(child: Text(item["comment"],style: TextStyle(fontSize: 18),)),
  //
  //                   IconButton(
  //                     alignment: Alignment.topRight,
  //                     icon: Icon(Icons.delete_forever),
  //                     color: Colors.red,
  //                     onPressed: (){
  //                       if(user.email==item["email"]){
  //                         deleteComment(index);
  //                       }
  //
  //                     },
  //                   )
  //                 ],
  //               )
  //           ),
  //           Container(
  //               margin: EdgeInsets.all(2),
  //               alignment: Alignment.bottomRight,
  //               child: Row(
  //                 children: [
  //                   Expanded(
  //                     child: Row(
  //                       children: [
  //                         IconButton(
  //                           alignment: Alignment.topRight,
  //                           icon: Icon(Icons.favorite),
  //                           color: Colors.red,
  //                           onPressed: (){
  //                             if(user.email==item["email"]){
  //                                 _likeComment(item, index);
  //                             }
  //
  //                           },
  //                         ),
  //
  //                         Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: Text("0"),
  //                         )
  //                       ],
  //                     ),
  //                   ),
  //                   Container(
  //                     margin: EdgeInsets.all(5.0),
  //                     child:user.email==item["email"]?Text("By You"):Text("By "+item["email"]) ,
  //                   )
  //
  //                 ],
  //               )
  //           )
  //         ],
  //       )),
  //     ),
  //   );
  // }
  Widget item(Comment item,int index){
    return Card(
      elevation: 7,
      child:InkWell(
        onLongPress:(){
          if(user.email==item.email){
            _editComment(item.comment,index);
          }

        },
        child: Container(child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item.comment,style: TextStyle(fontSize: 18),)),

                    IconButton(
                      alignment: Alignment.topRight,
                      icon: Icon(Icons.delete_forever),
                      color: Colors.red,
                      onPressed: (){
                        if(user.email==item.email){
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
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            alignment: Alignment.topRight,
                            icon: item.like.contains(user.email)?Icon(Icons.favorite):Icon(Icons.favorite_outline),
                            color: Colors.red,
                            onPressed: (){
                              // if(user.email==item.email){
                                  _likeComment(item, index);
                              // }

                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.like.length.toString()),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      child:user.email==item.email?Text("By You"):Text("By "+item.email) ,
                    )

                  ],
                )
            )
          ],
        )),
      ),
    );
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
  }


  void _likeComment(Comment item,int index) async{

      print("before like 1 ${item.toJson().toString()}");
      if(!item.like.contains(user.email)){
        print('true');
        item.like.add(user.email);
      }else{
        print(false);
        item.like.remove(user.email);
      }

      photoMemo.comment.removeAt(index);
      photoMemo.comment.insert(index,item.toJson());

      print("after like ${photoMemo.comment}");



    await FirebaseController.updateCommentMemo(photoMemo.docId, photoMemo);
    setState(() {
      commentList = photoMemo.comment;
      commentController.text = "";
    });

    // print("commentlist is give : $commentList");
    print(commentList);
  }

  void saveComment() async{
    String comment  = commentController.text;
    print("comment by user is : $comment");
    var commentobj = Comment(email: user.email,comment: comment);
    if(_isCommentEditEnable){
      photoMemo.comment.removeAt(_editCommentIndex);
      photoMemo.comment.insert(_editCommentIndex, commentobj.toJson());
      print("comment json object ${commentobj.toJson().toString()}");
    }else{
      photoMemo.comment.add(commentobj.toJson());
      print("comment json object ${commentobj.toJson().toString()}");
    }

    await FirebaseController.updateCommentMemo(photoMemo.docId, photoMemo);
    setState(() {
      commentList = photoMemo.comment;
      commentController.text = "";
    });
    _isCommentEditEnable = false;
  }


  void _updateComment(){

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
