const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();

//exports.senddevices = functions.firestore
//  .document("photoMemos/{id}")
//  .onCreate((snapshot) => {
//    const name = snapshot.get("createdBy");
//    const subject = snapshot.get("memo");
//    const token = snapshot.get("token");
////    const token = 'cwuNfVXWRXiBD5iaxGX2l-:APA91bHKaPlib8SGhlWRblqBoJJ4oSEX4nVEYxpI7wIrmGFhWQM7fwnTrNVTvLrRRq4Vx9XT73-ltYhSkxZGuMSpguF1SpDHr4p5oA-C7B0imytZN9F-XFWnZJrZUHAhArsgy2ZCvTmy';
//
//    const payload = {
//      notification: {
//        title: "from " + name,
//        body: "subject " + subject,
//        sound: "default",
//      },
//    };
//
//    return fcm.sendToDevice(token, payload);
//  });



  exports.sendNotification=functions.firestore.document("photoMemos/{id}")
      .onUpdate((change, context) => {
          const photoMemoDataBefore = change.before.data();
          const photoMemoData = change.after.data();
          var token  = photoMemoData.token;
          var subject = "nothing happed";
          var lastIndex = photoMemoData.comments.length-1;
          var sender = photoMemoData.comments[lastIndex]['email'];
          var comment = photoMemoData.comments[lastIndex]['comment'];

          if(photoMemoData.comments.length>photoMemoDataBefore.comments.length){
//            subject = "someone is commented on photo meme";
            subject = sender+": "+comment;
            console.log(subject);
          }else{
            return false;
          }


         const payload = {
             notification: {
                title: "PhotoMemos",
                body: subject,
             }
         };

         return fcm.sendToDevice(token,payload);

      });