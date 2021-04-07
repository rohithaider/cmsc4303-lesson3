import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lesson3/controller/firebasecontroller.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/model/photomemo.dart';

class LikeScreen extends StatefulWidget {

  static const routeName = '/likeScreen';

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {

  List<dynamic> likeList = [];
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
    photoMemo ??= args[Constant.ARG_LIKE];
    user ??= args[Constant.ARG_USER];

    // photoMemo.like = [{"to@gmail.com"}];

    likeList = photoMemo.like;
    return Scaffold(
        appBar: AppBar(title: Text("Likes")),
        body: Stack(
          children: [
            Positioned(
              child: Container(
                margin: EdgeInsets.all(10),
                child: likeList.length==0?
                Center(
                  child: Text(
                    'No Likes ',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ):Container(
                  height: MediaQuery.of(context).size.height-100,
                  child: ListView.builder(
                    itemBuilder: (context,index){
                      return item(likeList[index]);
                    },
                    itemCount: likeList.length,

                  ),
                ),
              ),
            ),

            SizedBox(height: 150,),


          ],
        )
    );
  }


  Widget item(String item){
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
                  Expanded(child: Text(item,style: TextStyle(fontSize: 18),)),
                  // IconButton(
                  //   alignment: Alignment.topRight,
                  //   icon: Icon(Icons.delete_forever),
                  //   color: Colors.red,
                  //   onPressed: (){
                  //     if(user.email==item){
                  //       // deleteComment(index);
                  //     }
                  //
                  //   },
                  // )
                ],
              )
          ),
          // Container(
          //     margin: EdgeInsets.all(2),
          //     alignment: Alignment.bottomRight,
          //     child: user.email==item["email"]?Text("By You"):Text("By "+item["email"])
          // )
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
      likeList = photoMemo.like;
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

