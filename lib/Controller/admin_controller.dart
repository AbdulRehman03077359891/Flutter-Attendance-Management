import 'package:attendance_management_system/Helper/attendance_report.dart';
import 'package:attendance_management_system/Helper/leave_requests.dart';
import 'package:attendance_management_system/Widget/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<LeaveRequest> leaveRequests = RxList<LeaveRequest>();
  RxList<AttendanceReport> attendanceReport = RxList<AttendanceReport>();

  final fromDate = Rx<DateTime?>(null);
  final toDate = Rx<DateTime?>(null);

  RxMap<String, dynamic> reportData = <String, dynamic>{}.obs;

  setLoading(val) {
    isLoading.value = val;
  }

  // Fetch leave requests from Firestore in real-time
  void fetchAllLeaveRequests() {
    setLoading(true);
    try {
      // Listen to the real-time changes in the 'leaveRequests' collection where status is "Pending"
      FirebaseFirestore.instance
          .collection('leaveRequests')
          .where("status", isEqualTo: "Pending")
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((QuerySnapshot requestsSnapshot) {
        // Clear previous data to avoid duplicates
        leaveRequests.clear();

        // Add each leave request document to the leaveRequests list
        for (var requestDoc in requestsSnapshot.docs) {
          var data = requestDoc.data() as Map<String, dynamic>;

          leaveRequests.add(LeaveRequest(
            requestId: requestDoc.id,
            fromDate: data['fromDate'],
            toDate: data['toDate'],
            reason: data['reason'],
            status: data['status'],
            userUid: data['userUid'],
            userName: data['userName'],
            userEmail: data['userEmail'],
            userProfilePic: data['userProfilePic'],
            userClass: data['userClass'],
          ));
        }
      });
    } catch (e) {
      ErrorMessage('error', 'Error fetching leave requests: $e');
    } finally {
      setLoading(false);
    }
  }

  void fetchPreviousLeaveRequests(String userUid) {
    setLoading(true);
    try {
      // Listen to real-time changes in 'leaveRequests' collection where status is not "Pending" for a specific user
      FirebaseFirestore.instance
          .collection('leaveRequests')
          .where("userUid", isEqualTo: userUid)
          .where("status", isNotEqualTo: "Pending")
          .orderBy('timestamp', descending: false)
          .snapshots()
          .listen((QuerySnapshot requestsSnapshot) {
        // Clear previous data to avoid duplicates
        leaveRequests.clear();

        // Add each leave request document to the leaveRequests list
        for (var requestDoc in requestsSnapshot.docs) {
          var data = requestDoc.data() as Map<String, dynamic>;

          // Ensure data safety with null checks
          leaveRequests.add(LeaveRequest(
            requestId: requestDoc.id,
            fromDate: data['fromDate'], // Handle null Timestamp
            toDate: data['toDate'], // Handle null Timestamp
            reason: data['reason'] ??
                'No reason provided', // Default reason if missing
            status: data['status'] ?? 'Unknown',
            userUid: data['userUid'] ?? '',
            userName: data['userName'] ?? 'Unknown user',
            userEmail: data['userEmail'] ?? 'No email',
            userProfilePic:
                data['userProfilePic'] ?? '', // Optional field check
            userClass: data['userClass'],
          ));
        }
      });
    } catch (e) {
      ErrorMessage('error', 'Error fetching leave requests: $e');
    } finally {
      setLoading(false);
    }
  }

  // Update leave request status (Approve or Reject)
  Future<void> approveLeaveRequest(String userUid, String requestId,
      String status, String fromDate, String toDate) async {
    setLoading(true);
    try {
      // Update the leave request status in Firestore
      CollectionReference leaveRequests =
          FirebaseFirestore.instance.collection('leaveRequests');
      await leaveRequests.doc(requestId).update({
        'status': status,
      });

      // If status is "Approved", mark the date range as "Leave"
      if (status == 'Approved') {
        await markLeaveForDateRange(userUid, fromDate, toDate);
      }

      ErrorMessage('Success', 'Leave request $status successfully');
    } catch (e) {
      ErrorMessage('error', 'Error updating leave request: $e');
    } finally {
      setLoading(false);
    }
  }

  // Mark attendance as "Leave" for a date range
  Future<void> markLeaveForDateRange(
      String userUid, String fromDate, String toDate) async {
    setLoading(true);
    try {
      // Parse the fromDate and toDate
      DateTime startDate = DateFormat('dd-MM-yyyy').parse(fromDate);
      DateTime endDate = DateFormat('dd-MM-yyyy').parse(toDate);

      // Loop through each date in the range and mark attendance as "Leave"
      for (DateTime date = startDate;
          date.isBefore(endDate.add(const Duration(days: 1)));
          date = date.add(const Duration(days: 1))) {
        String formattedDate = DateFormat('dd-MM-yyyy').format(date);

        // Update Firestore with the "Leave" status
        CollectionReference attendanceRef =
            FirebaseFirestore.instance.collection('attendance');
        await attendanceRef
            .doc(userUid)
            .collection('days')
            .doc(formattedDate)
            .set({
          'userUid': userUid,
          'status': 'Leave',
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      ErrorMessage('error', 'Error marking leave for date range: $e');
    } finally {
      setLoading(false);
      ErrorMessage('Success', 'Marked leave from $fromDate to $toDate');
    }
  }

  // Function to update attendance
  Future<void> updateAttendance(String date, String status,
      BuildContext context, String userUid, preStatus) async {
    setLoading(true);
    try {
      // Show confirmation dialog before updating
      final shouldUpdate = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Update'),
          content: Text(
              'Are you sure you want to mark attendance as $status for $date?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm')),
          ],
        ),
      );

      if (shouldUpdate == true) {
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc(userUid)
            .collection('days')
            .doc(date)
            .set({'status': status, 'timestamp': FieldValue.serverTimestamp()},
                SetOptions(merge: true));

        preStatus[date] = status; // Update local data

        // Show success message
        Get.snackbar('Success', 'Attendance marked as $status for $date',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // Show error message
      Get.snackbar('Error', 'Failed to update attendance: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setLoading(false);
    }
  }

  Map<String, Map<String, String>> groupAttendanceByMonth(attendanceData) {
    final groupedData = <String, Map<String, String>>{};

    attendanceData.forEach((date, status) {
      final monthYear =
          DateFormat('MMMM yyyy').format(DateFormat('dd-MM-yyyy').parse(date));

      if (!groupedData.containsKey(monthYear)) {
        groupedData[monthYear] = {};
      }
      groupedData[monthYear]![date] = status;
    });

    return groupedData;
  }

  // Helper function to get the month index based on the name
  int _getMonthIndex(String month) {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ].indexOf(month);
  }

  // Initialize the monthly attendance based on the selected start month
  void initializeMonthlyAttendance(monthlyAttendance, startMonth) {
    DateTime now = DateTime.now();
    int monthIndex =
        _getMonthIndex(startMonth); // Get the index of the selected month

    for (int i = 0; i < 12; i++) {
      final year = now.year + (monthIndex + i) ~/ 12; // Adjust year
      final month = (monthIndex + i) % 12 + 1; // Wrap around months

      String monthYear = DateFormat('MMMM yyyy').format(DateTime(year, month));
      List<DateTime> daysInMonth = [];

      for (int j = 1; j <= DateTime(year, month + 1, 0).day; j++) {
        daysInMonth.add(DateTime(year, month, j)); // Add all days of the month
      }

      // Assign the days of the month to the corresponding month year
      monthlyAttendance[monthYear] = daysInMonth;
    }
  }

  void createAttendanceReport(String userUid, String userName, String userEmail,
      String userProfilePic, int userClass, DateTime from, DateTime to) async {
    setLoading(true);
    try {
      // Format the dates as "dd-MM-yyyy"
      String formattedFromDate = DateFormat('dd-MM-yyyy').format(from);
      String formattedToDate = DateFormat('dd-MM-yyyy').format(to);

      // Query attendance collection for the given user within the date range
      QuerySnapshot attendanceSnapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userUid)
          .collection('days')
          .where('timestamp', isGreaterThanOrEqualTo: from)
          .where('timestamp', isLessThanOrEqualTo: to)
          .get();

      // Calculate attendance summary
      int totalDays = 0;
      int present = 0, absent = 0, leave = 0;

      for (var doc in attendanceSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        switch (data['status']) {
          case 'Present':
            present++;
            break;
          case 'Absent':
            absent++;
            break;
          case 'Leave':
            leave++;
            break;
        }
        totalDays++;
      }

      // Calculate attendance percentage
      double attendancePercentage =
          totalDays > 0 ? (present / totalDays) * 100 : 0;

      // Assign grade based on attendance percentage
      String grade = _calculateGrade(attendancePercentage);

      // Save the report in Firestore with grade
      CollectionReference reportRef = FirebaseFirestore.instance
          .collection('attendanceReports')
          .doc(userUid)
          .collection("Reports");
      var reportKey = FirebaseDatabase.instance.ref('Reports').push().key;

      await reportRef.doc(reportKey).set({
        'reportKey': reportKey,
        'userUid': userUid,
        'fromDate': formattedFromDate, // Use formatted dates
        'toDate': formattedToDate, // Use formatted dates
        'totalDays': totalDays,
        'totalPresent': present,
        'totalAbsent': absent,
        'totalLeave': leave,
        'attendancePercentage': attendancePercentage,
        'grade': grade,
        'userName': userName,
        'userEmail': userEmail,
        'userProfilePic': userProfilePic,
        'userClass': userClass,
        'createdAt': FieldValue.serverTimestamp(),
      }).then((value) {
        fromDate.value = null;
        toDate.value = null;
      });

      ErrorMessage("Success", "Report generated successfully!");
    } catch (e) {
      ErrorMessage("error", "Error generating report");
    } finally {
      setLoading(false);
    }
  }

// Grading system based on attendance percentage
  String _calculateGrade(double percentage) {
    if (percentage >= 90) {
      return 'A';
    } else if (percentage >= 75) {
      return 'B';
    } else if (percentage >= 50) {
      return 'C';
    } else {
      return 'D';
    }
  }

  Future<void> deleteReport(String reportKey) async {
    try {
      // Start the loading process
      setLoading(true);

      // Delete the report from Firestore
      await FirebaseFirestore.instance
          .collection('attendanceReports')
          .doc(reportKey)
          .delete();

      // Remove the report from the local list to update the UI immediately
      attendanceReport.removeWhere((report) => report.reportKey == reportKey);

      // Show a success message
      ErrorMessage(
        'Success',
        'Report deleted successfully!',
      );
    } catch (e) {
      // Handle error and show error message
      ErrorMessage(
        'error',
        'Failed to delete the report. Please try again.',
      );
    } finally {
      // Stop the loading process
      setLoading(false);
    }
  }

  Future<void> updateStudentGrade(
      String reportKey, String newGrade, String userUid) async {
    try {
      // Start the loading process
      setLoading(true);

      // Update the grade in the Firestore report document
      await FirebaseFirestore.instance
          .collection('attendanceReports')
          .doc(userUid)
          .collection('Reports')
          .doc(reportKey)
          .update({
        'grade': newGrade,
      });

      
      // Show a success message
      Get.snackbar(
        'Success',
        'Student grade updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle error and show error message
      Get.snackbar(
        'Error',
        'Failed to update the grade. Please try again $e.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Stop the loading process
      setLoading(false);
    }
  }

  Future<void> fetchAttendanceReport(String userUid) async {
    try {
      FirebaseFirestore.instance
          .collection('attendanceReports')
          .doc(userUid)
          .collection('Reports')
          .snapshots()
          .listen((QuerySnapshot reportsSnapshot) {
        // Clear previous data to avoid duplicates
        attendanceReport.clear();

        // Add each leave request document to the leaveRequests list
        for (var reportDoc in reportsSnapshot.docs) {
          var data = reportDoc.data() as Map<String, dynamic>;

          attendanceReport.add(AttendanceReport(
              reportKey: data['reportKey'],
              fromDate: data['fromDate'],
              toDate: data['toDate'],
              totalDays: data['totalDays'],
              totalPresent: data['totalPresent'],
              totalAbsent: data['totalAbsent'],
              totalLeave: data['totalLeave'],
              attendancePercentage: data['attendancePercentage'],
              grade: data['grade'],
              createdAt: data['createdAt'],
              userUid: data['userUid'],
              userName: data['userName'],
              userEmail: data['userEmail'],
              userProfilePic: data['userProfilePic'],
              userClass: data['userClass']));
        }
      });
    } catch (e) {
      // Handle error if needed
      // print("Error fetching report data: $e");
    } finally {
      setLoading(false);
    }
  }
}
