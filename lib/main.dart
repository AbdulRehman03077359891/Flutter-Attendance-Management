import 'package:attendance_management_system/splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await markAbsenceForLast15Days();
  runApp(const MyApp());
}
Future<void> markAbsenceForLast15Days() async {
  // Get the current date
  DateTime today = DateTime.now();

  // Fetch all users from the 'user' collection
  var usersSnapshot = await FirebaseFirestore.instance.collection('user').get();

  for (var userDoc in usersSnapshot.docs) {
    String userUid = userDoc.id; // Get the user ID

    // Loop through the last 15 days
    for (int i = 1; i < 3; i++) {
      DateTime dateToCheck = today.subtract(Duration(days: i));
      String formattedDate = DateFormat('dd-MM-yyyy').format(dateToCheck);

      // Reference to the attendance document for the day to check
      var attendanceRef = FirebaseFirestore.instance
          .collection('attendance')
          .doc(userUid)
          .collection('days')
          .doc(formattedDate);

      var snapshot = await attendanceRef.get();

      // If attendance for that day does not exist, mark it as "Absent"
      if (!snapshot.exists) {
        await attendanceRef.set({
          'status': 'Absent',
          'timestamp': FieldValue.serverTimestamp(),
          'userUid': userUid,
        });
      }
    }
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
