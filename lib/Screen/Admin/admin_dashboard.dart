import 'package:attendance_management_system/Controller/admin_dashboard_controller.dart';
import 'package:attendance_management_system/Screen/Admin/AdminDashPages/view_all_leaves.dart';
import 'package:attendance_management_system/Screen/Admin/AdminDashPages/view_all_reports.dart';
import 'package:attendance_management_system/Screen/Admin/AdminDashPages/view_all_users.dart';
import 'package:attendance_management_system/Widget/AdminDrawerWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatefulWidget {
  final String adminUid, adminName, adminEmail, adminProfilePic;

  const AdminDashboard({
    Key? key,
    required this.adminUid,
    required this.adminName,
    required this.adminEmail,
    required this.adminProfilePic,
  }) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AdminDashController adminDashController = Get.put(AdminDashController());

  @override
  void initState() {
    super.initState();
    getDashBoardData();
  }

  void getDashBoardData() {
    adminDashController.getDashBoardData(); // Ensure this function is defined in your controller
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Admin Dashboard",
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
        foregroundColor: Colors.amber,
        backgroundColor: Colors.black,
      ),drawer: AdminDrawerWidget(
        accountName: widget.adminName,
        accountEmail: widget.adminEmail,
        profilePicture: widget.adminProfilePic,
        adminUid: widget.adminUid,
      ),
      body: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                     
                      GestureDetector(
                        onTap: () {
                          Get.to(ViewAllUsers());
                        },
                        child: Card(
                          color: Colors.grey.shade900,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side:
                      const BorderSide(color:  Color.fromARGB(136, 255, 193, 7)),
                ),
                elevation: 6,
                shadowColor: Colors.amber,
                margin: const EdgeInsets.all(16.0),
                
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Total Users: ${adminDashController.userCount.value}', // Assuming userCount is an RxInt
                              style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500,shadows: [BoxShadow(color: Colors.amber,spreadRadius: 5,blurRadius: 5)]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: (){
                          Get.to(const ViewAllLeaves());
                        },
                        child: Card(
                          color: Colors.grey.shade900,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side:
                      const BorderSide(color:  Color.fromARGB(136, 255, 193, 7)),
                ),
                elevation: 6,
                shadowColor: Colors.amber,
                margin: const EdgeInsets.all(16.0),
                
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Total Leave Requests: ${adminDashController.leaveReqCount.value}', // Assuming userCount is an RxInt
                              style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500,shadows: [BoxShadow(color: Colors.amber,spreadRadius: 5,blurRadius: 5)]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: (){
                          Get.to(const ViewAllAttendanceReportsPage());
                        },
                        child: Card(
                          color: Colors.grey.shade900,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side:
                      const BorderSide(color:  Color.fromARGB(136, 255, 193, 7)),
                ),
                elevation: 6,
                shadowColor: Colors.amber,
                margin: const EdgeInsets.all(16.0),
                
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Total Attendance Reports: ${adminDashController.reportCount.value}', // Assuming userCount is an RxInt
                              style: const TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.w500,shadows: [BoxShadow(color: Colors.amber,spreadRadius: 5,blurRadius: 5)]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
