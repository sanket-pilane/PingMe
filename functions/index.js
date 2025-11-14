const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.sendNudgeNotification = functions.firestore
  .document("rooms/{roomId}/tasks/{taskId}")
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();

    // 1. Check if the 'needsNudge' flag changed from false to true
    if (before.needsNudge === false && after.needsNudge === true) {
      console.log(`Nudge detected for task: ${after.title}`);

      const assignedToUid = after.assignedToUid;
      if (!assignedToUid) {
        console.log("Task has no assigned user. Exiting.");
        return null;
      }

      // 2. Get the recipient's FCM token from the /users collection
      const userDoc = await db.collection("users").doc(assignedToUid).get();
      if (!userDoc.exists) {
        console.log(`User document ${assignedToUid} not found.`);
        return null;
      }

      const userData = userDoc.data();
      const fcmToken = userData.fcmToken;

      if (!fcmToken) {
        console.log("User has no FCM token. Exiting.");
        return null;
      }

      // 3. Construct the notification payload
      const payload = {
        notification: {
          title: "Urgent Reminder! 🚀",
          body: `${after.createdByName} nudged you about: ${after.title}`,
        },
        token: fcmToken,
      };

      // 4. Send the notification and reset the nudge flag
      try {
        await admin.messaging().send(payload);
        console.log("Notification sent successfully!");

        // Reset the flag immediately so the function doesn't run again
        // and so the next nudge can be sent.
        await change.after.ref.update({ needsNudge: false });
        console.log("Nudge flag reset.");
      } catch (error) {
        console.error("Error sending notification:", error);
      }
    }

    return null;
  });
