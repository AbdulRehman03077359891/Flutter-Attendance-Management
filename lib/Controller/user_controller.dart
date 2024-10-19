import 'dart:async';

import 'package:attendance_management_system/Widget/notification_message.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool hasMarkedToday = false.obs;

  RxMap<String, String> attendanceData =
      RxMap<String, String>(); // Store daily attendance
  RxInt totalPresent = 0.obs;
  RxInt totalAbsent = 0.obs;
  RxInt totalLeave = 0.obs;

  StreamSubscription?
      _attendanceSubscription; // To manage the real-time listener

  final TextEditingController reasonController = TextEditingController();
  final fromDate = Rx<DateTime?>(null);
  final toDate = Rx<DateTime?>(null);
  
  final leaveReq = <dynamic>[].obs;
  RxInt leaveReqCount = 0.obs;

  // Function to set loading status
  void setLoading(bool val) {
    isLoading.value = val;
  }

  // Check if the user has already marked attendance for today
  Future<void> checkAttendanceStatus(String userUid) async {
    try {
      setLoading(true);

      // Get today's date
      String today = DateFormat('dd-MM-yyyy').format(DateTime.now());

      // Reference to Firestore document for the user's attendance on today's date
      var attendanceRef = FirebaseFirestore.instance
          .collection('attendance')
          .doc(userUid)
          .collection('days')
          .doc(today);

      // Check if the document exists
      var snapshot = await attendanceRef.get();

      if (snapshot.exists) {
        // If the user has already marked attendance, update the observable
        hasMarkedToday.value = true;
      } else {
        // Automatically mark absent at midnight if attendance is not marked
        DateTime now = DateTime.now();
        DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
        Duration timeLeft = endOfDay.difference(now);

        // Delayed function to mark absent at the end of the day
        Future.delayed(timeLeft, () {
          if (!hasMarkedToday.value) {
            markAttendance("Absent", userUid);
          }
        });
      }
    } catch (e) {
      ErrorMessage("Error", "Error checking attendance status: $e");
    } finally {
      setLoading(false);
    }
  }

  // Mark attendance as "Present" or "Absent"
  Future<void> markAttendance(String status, String userUid) async {
    setLoading(true);
    try {
      // Get today's date
      String today = DateFormat('dd-MM-yyyy').format(DateTime.now());

      // Write attendance status to Firestore
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userUid)
          .collection('days')
          .doc(today)
          .set({
        'userUid': userUid,
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (status == "Present") {
        // Save the last marked date in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('lastMarkedDate', today);

        // Update observable to indicate attendance is marked
        hasMarkedToday.value = true;
      }
    } catch (e) {
      ErrorMessage("Error", "Error marking attendance: $e");
    } finally {
      setLoading(false);
    }
  }

  @override
  void onClose() {
    _attendanceSubscription
        ?.cancel(); // Cancel the listener when the controller is destroyed
    super.onClose();
  }

  // Fetch and listen to user's attendance for the entire year in real-time
  void listenToAnnualAttendance(String userUid) {
    // Start loading
    setLoading(true);

    // Set up a real-time listener for the attendance collection
    _attendanceSubscription = FirebaseFirestore.instance
        .collection('attendance')
        .doc(userUid)
        .collection('days')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      // Clear previous data to avoid duplicates
      attendanceData.clear();
      totalPresent.value = 0;
      totalAbsent.value = 0;
      totalLeave.value = 0;

      // Create a list to hold the attendance data for sorting
      List<Map<String, dynamic>> attendanceList = [];

      // Process the attendance documents in real-time
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String date = doc.id; // Document ID is the date
        String status = data['status'];

        // Store attendance status for each day
        attendanceList.add({
          'date': date,
          'status': status,
        });

        // Count Present, Absent, and Leave
        if (status == "Present") {
          totalPresent.value++;
        } else if (status == "Absent") {
          totalAbsent.value++;
        } else if (status == "Leave") {
          totalLeave.value++;
        }
      }
      // Sort the list by date (assumes date is in 'dd-MM-yyyy' format)
      attendanceList.sort((a, b) {
        DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['date']);
        DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['date']);
        return dateA.compareTo(dateB);
      });

      // Store the sorted data back into the observable
      for (var entry in attendanceList) {
        String date = entry['date'];
        String status = entry['status'];
        attendanceData[date] = status;
      }

      // Stop loading when data is updated
      setLoading(false);
    }, onError: (e) {
      setLoading(false);
      ErrorMessage('Error', 'Failed to listen to attendance: $e');
    });
  }

  Future<void> submitLeaveRequest(
      String userUid,
      String userName,
      String userEmail,
      String userProfilePic,
      int userClass,
      String reason) async {
    setLoading(true);
    try {
      // Ensure that the dates are set before proceeding
      if (fromDate.value == null || toDate.value == null) {
        ErrorMessage('Error', 'Please select both From and To dates.');
        return;
      }

      // Format the dates for Firestore
      String from = DateFormat('dd-MM-yyyy').format(fromDate.value!);
      String to = DateFormat('dd-MM-yyyy').format(toDate.value!);

      // Submit the leave request to Firestore
      CollectionReference leaveIns =
          FirebaseFirestore.instance.collection("leaveRequests");
      var leaveKey = FirebaseDatabase.instance.ref("leaveRequests").push().key;
      await leaveIns.doc(leaveKey).set({
        'userUid': userUid,
        'userName': userName,
        'userEmail': userEmail,
        'userProfilePic': userProfilePic,
        'userClass': userClass,
        'leaveKey': leaveKey,
        'fromDate': from,
        'toDate': to,
        'reason': reason,
        'status': 'Pending', // Admin will update the status later
        'timestamp': FieldValue.serverTimestamp(),
      }).then((value) {
        fromDate.value = null;
        toDate.value = null;
        reasonController.clear();
      });

      ErrorMessage('Success', 'Leave request submitted successfully');
    } catch (e) {
      ErrorMessage('Error', 'Failed to submit leave request: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
  fetchLeaves(userUid){
    FirebaseFirestore.instance
        .collection("leaveRequests")
        .where("userUid", isEqualTo: userUid)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
          leaveReq.clear();
          leaveReqCount.value = 0;
      for (var doc in snapshot.docs) {
        // print('${doc.id} => ${doc.data()}');
        leaveReq.add(doc.data());
        leaveReqCount.value = leaveReq.length;
      }
    });
  }
}
