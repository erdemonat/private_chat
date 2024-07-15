const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.firestore
  .document("chats/{chatId}/messages/{messageId}")
  .onCreate((snapshot, context) => {
    const message = snapshot.data();
    const senderId = message.senderId;
    const userRef = admin.firestore().collection("users").doc(senderId);
    const senderUsername = userRef.username;


    const payload = {
      notification: {
        title: senderUsername,
        body: message.text,
        icon: "default",
        click_action: "FLUTTER_NOTIFICATION_CLICK",
      },
    };

    return admin.messaging().sendToTopic("messages", payload)
      .then((response) => {
        console.log("Notification sent successfully:", response);
      })
      .catch((error) => {
        console.log("Error sending notification:", error);
      });
  });
