const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.markAbsentForNonLoggedUsers = functions.pubsub.schedule('every day 00:00').onRun(async (context) => {
    const now = new Date();
    const yesterday = new Date(now);
    yesterday.setDate(now.getDate() - 1);
    const yesterdayString = `${yesterday.getDate()}-${yesterday.getMonth() + 1}-${yesterday.getFullYear()}`;

    const usersSnapshot = await admin.firestore().collection('user').get();
    usersSnapshot.forEach(async (userDoc) => {
        const userId = userDoc.id;
        const attendanceDoc = await admin.firestore()
            .collection('attendance')
            .doc(userId)
            .collection('days')
            .doc(yesterdayString)
            .get();

        if (!attendanceDoc.exists) {
            // Mark as absent
            await admin.firestore()
                .collection('attendance')
                .doc(userId)
                .collection('days')
                .doc(yesterdayString)
                .set({
                    status: 'Absent',
                    timestamp: admin.firestore.FieldValue.serverTimestamp(),
                    userUid: userId,
                });
        }
    });
});
