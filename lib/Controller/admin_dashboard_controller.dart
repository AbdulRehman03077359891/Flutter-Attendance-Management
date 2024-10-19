import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDashController extends GetxController {
  var usersMap = <Map<String, dynamic>>[].obs;
  var userCount = 0.obs;
  var report = <Map<String, dynamic>>[].obs;
  var reportCount = 0.obs;
  var leaveReq = <Map<String, dynamic>>[].obs;
  var leaveReqCount = 0.obs;

  // Function to get dashboard data
  void getDashBoardData() {
    fetchUsers();
    fetchLeaveRequests();
  }

  // Function to fetch all users from the 'user' collection
  void fetchUsers() {
    FirebaseFirestore.instance.collection("user").snapshots().listen((QuerySnapshot snapshot) async {
      usersMap.clear();
      userCount.value = 0;

      try {
        for (var doc in snapshot.docs) {
          usersMap.add(doc.data() as Map<String, dynamic>);
          userCount.value = usersMap.length;
        }

        // Once users are fetched, get the attendance reports for each user
        await fetchAttendanceReportsForUsers();
      } catch (e) {
        print("Error fetching users: $e");
      }
    });
  }

  // Function to fetch attendance reports for each user
  Future<void> fetchAttendanceReportsForUsers() async {
    report.clear();
    reportCount.value = 0;

    for (var user in usersMap) {
      String userUid = user['userUid'];
      FirebaseFirestore.instance
          .collection("attendanceReports")
          .doc(userUid)
          .collection('Reports')
          .snapshots()
          .listen((QuerySnapshot snapshot) {
        for (var doc in snapshot.docs) {
          report.add(doc.data() as Map<String, dynamic>);
          reportCount.value = report.length;
        }
      });
    }
  }

  // Function to fetch all leave requests
  void fetchLeaveRequests() {
    FirebaseFirestore.instance.collection("leaveRequests").snapshots().listen((QuerySnapshot snapshot) {
      leaveReq.clear();
      leaveReqCount.value = 0;

      for (var doc in snapshot.docs) {
        leaveReq.add(doc.data() as Map<String, dynamic>);
        leaveReqCount.value = leaveReq.length;
      }
    });
  }

  Future<void> deleteReport(String reportKey, String userUid) async {
    try {
      await FirebaseFirestore.instance
          .collection('attendanceReports').doc(userUid).collection('Reports')
          .doc(reportKey) // Update this if needed based on your structure
          .delete();
      Get.snackbar("Success", "Report deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete report");
    }
  }

  Future<void> updateStudentGrade(String reportKey, String newGrade, String userUid) async {
    try {
      await FirebaseFirestore.instance
          .collection('attendanceReports').doc(userUid).collection('Reports')
          .doc(reportKey) // Update this if needed based on your structure
          .update({'grade': newGrade});
      Get.snackbar("Success", "Grade updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update grade");
    }
  }
}
