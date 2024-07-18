const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = onDocumentCreated(
  "chats/{chatId}/messages/{messageId}",
  async (event) => {
    const snapshot = event.data;
    const context = event;
    const message = snapshot.data();
    const senderId = message.senderId;
    const receiverId = message.receiverId;
    const chatId = context.params.chatId;

    // Sohbet belgesini alın
    const chatRef = admin.firestore().collection("chats").doc(chatId);
    const chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      console.log("Chat not found!");
      return null;
    }

    const chat = chatDoc.data();
    const participants = chat.participants;

    // Kullanıcının UID'sini kontrol edin
    if (!participants.includes(senderId)) {
      console.log("User is not in chat participants.");
      return null;
    }

    // Bildirimi gönder
    const senderRef = admin.firestore().collection("users").doc(senderId);
    const senderDoc = await senderRef.get();

    if (!senderDoc.exists) {
      console.log("Sender not found!");
      return null;
    }

    const senderUser = senderDoc.data();
    const senderUsername = senderUser.username;

    // Alıcının cihaz token'ını alın
    const receiverRef = admin.firestore().collection("users").doc(receiverId);
    const receiverDoc = await receiverRef.get();

    if (!receiverDoc.exists) {
      console.log("Receiver not found!");
      return null;
    }

    const receiverUser = receiverDoc.data();
    const receiverToken = receiverUser.token;

    if (receiverToken) {
      const payload = {
        notification: {
          title: senderUsername,
          body: message.text,
          icon: "default",
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      return admin.messaging().sendToDevice(receiverToken, payload)
        .then((response) => {
          console.log("Notification sent successfully:", response);
        })
        .catch((error) => {
          console.log("Error sending notification:", error);
        });
    } else {
      console.log("No token for receiver.");
      return null;
    }
  },
);
