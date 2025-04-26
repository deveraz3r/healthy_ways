// const functions = require("firebase-functions");
// const admin = require("firebase-admin");
// admin.initializeApp();

// exports.processAppointments = functions.pubsub
//   .schedule("every 30 minutes")
//   .onRun(async (context) => {
//     const now = admin.firestore.Timestamp.now();

//     const appointmentsRef = admin.firestore().collection("appointments");
//     const snapshot = await appointmentsRef
//       .where("status", "in", ["upcoming", "inProgress"])
//       .get();

//     snapshot.forEach(async (doc) => {
//       const appointment = doc.data();
//       const appointmentTime = appointment.time.toDate();
//       const timeDiff = now.toDate() - appointmentTime;

//       if (appointment.status === "upcoming" && timeDiff > 30 * 60 * 1000) {
//         await doc.ref.update({ status: "missed" });
//       }

//       if (appointment.status === "inProgress" && timeDiff > 30 * 60 * 1000) {
//         await doc.ref.update({ status: "completed" });
//       }
//     });

//     console.log("Processed appointments successfully.");
//   });