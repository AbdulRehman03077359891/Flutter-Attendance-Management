import 'package:attendance_management_system/Screen/Admin/AttendancePages/create_student_report.dart';
import 'package:attendance_management_system/Screen/Admin/AttendancePages/student_attendance_page.dart';
import 'package:attendance_management_system/Screen/Admin/LeavesPage/view_previous_leaves.dart';
import 'package:attendance_management_system/Screen/Admin/AttendancePages/view_previous_reports.dart';
import 'package:attendance_management_system/Widget/e1_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentInfoChoose extends StatelessWidget {
  final String userUid, userName, userEmail, userProfilePic;
  final int userClass;
  final String startMonth;
  const StudentInfoChoose(
      {super.key, required this.userUid, required this.startMonth, required this.userName, required this.userEmail, required this.userProfilePic, required this.userClass});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.amber,
            ),
          ),
          centerTitle: true,
          title: const Text(
            "Students Data",
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              shadows: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              E1Button(
                              backColor: Colors.amber.shade400,
                              text: "Attendance Info",
                              textColor: Colors.white,
                              shadowColor: Colors.white,
                              elevation: 5,
                              onPressed: () {Get.to(StudentAttendancePage(userUid: userUid, startMonth: startMonth));},
                            ),
                            const SizedBox(height: 25,),
              E1Button(
                              backColor: Colors.amber.shade400,
                              text: "Create Attendance Report",
                              textColor: Colors.white,
                              shadowColor: Colors.white,
                              elevation: 5,
                              onPressed: () {Get.to(CreateAttendanceReportPage(userUid: userUid, userName: userName, userEmail: userEmail, userProfilePic: userProfilePic,userClass: userClass,));},
                            ),
                            const SizedBox(height: 25,),
              E1Button(
                              backColor: Colors.amber.shade400,
                              text: "View Attendance Reports",
                              textColor: Colors.white,
                              shadowColor: Colors.white,
                              elevation: 5,
                              onPressed: () {Get.to(ViewAttendanceReportsPage(userUid: userUid));},
                            ),
                            const SizedBox(height: 25,),
              E1Button(
                              backColor: Colors.amber.shade400,
                              text: "View Leave Requests",
                              textColor: Colors.white,
                              shadowColor: Colors.white,
                              elevation: 5,
                              onPressed: () {Get.to(ViewPreviousLeavesPage(userUid: userUid));},
                            ),
            ],
          ),
        ));
  }
}
