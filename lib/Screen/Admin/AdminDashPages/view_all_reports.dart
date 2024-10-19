import 'package:attendance_management_system/Controller/admin_dashboard_controller.dart';
import 'package:attendance_management_system/Widget/e1_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewAllAttendanceReportsPage extends StatefulWidget {

  const ViewAllAttendanceReportsPage({super.key,});

  @override
  State<ViewAllAttendanceReportsPage> createState() =>
      _ViewAllAttendanceReportsPageState();
}

class _ViewAllAttendanceReportsPageState extends State<ViewAllAttendanceReportsPage> {
  final AdminDashController adminDashController = Get.put(AdminDashController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Attendance Reports",
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
      backgroundColor: Colors.black,
      body: Obx(
        () => adminDashController.report.isEmpty
            ? const Center(
                child: Text(
                  'No attendance reports available',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: adminDashController.report.length,
                itemBuilder: (context, index) {
                  adminDashController.report[index];
                  return Card(
                    color: Colors.grey.shade900,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(
                          color: Color.fromARGB(136, 255, 193, 7)),
                    ),
                    child: Stack(
                      children: [
                        ListTile(
                        
                          title: Text(
                            '${adminDashController.report[index]['userName']} (Class: ${adminDashController.report[index]['userClass']})',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: ${adminDashController.report[index]['userEmail']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Grade: ${adminDashController.report[index]['grade']}',
                                style: const TextStyle(color: Colors.amber),
                              ),
                              Text(
                                'Total Days: ${adminDashController.report[index]['totalDays']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Presents: ${adminDashController.report[index]['totalPresent']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Absences: ${adminDashController.report[index]['totalAbsent']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Leaves: ${adminDashController.report[index]['totalLeave']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Attendance: ${adminDashController.report[index]['attendancePercentage']}%',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'From: ${adminDashController.report[index]['fromDate']} To: ${adminDashController.report[index]['toDate']}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Created At : ${DateFormat('dd-MM-yyyy').format((adminDashController.report[index]['createdAt']).toDate())}',
                                style: const TextStyle(color: Color.fromARGB(158, 255, 255, 255)),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (value) {
                              if (value == 'Edit Grade') {
                                _editGradeDialog(adminDashController.report[index]);
                              } else if (value == 'Delete Report') {
                                _deleteReportDialog(adminDashController.report[index]['reportKey'], adminDashController.report[index]['userUid']);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem(
                                value: 'Edit Grade',
                                child: Text('Edit Grade'),
                              ),
                              const PopupMenuItem(
                                value: 'Delete Report',
                                child: Text('Delete Report'),
                              ),
                            ],
                          ),
                        ),
                        Positioned(top: 80,right: 80,child:  CircleAvatar(radius: 40,
                            backgroundImage: CachedNetworkImageProvider(adminDashController.report[index]['userProfilePic']),
                          ),)
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Function to display the edit grade dialog
  void _editGradeDialog(report) {
    TextEditingController gradeController =
        TextEditingController(text: report['grade']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Edit Grade', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: gradeController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Enter Grade',
              labelStyle: TextStyle(color: Colors.amber),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            E1Button(
              backColor: Colors.amber.shade400,
              text: 'Update',
              textColor: Colors.white,
              onPressed: () {
                adminDashController.updateStudentGrade(
                    report['reportKey'], gradeController.text, report['userUid']);
                Navigator.of(context).pop();
              },
            ),
            E1Button(
              backColor: Colors.red.shade400,
              text: 'Cancel',
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to display the delete report dialog
  void _deleteReportDialog(String reportKey, String userUid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text('Delete Report',
              style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to delete this report?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            E1Button(
              backColor: Colors.red.shade400,
              text: 'Delete',
              textColor: Colors.white,
              onPressed: () {
                adminDashController.deleteReport(reportKey, userUid);
                Navigator.of(context).pop();
              },
            ),
            E1Button(
              backColor: Colors.amber.shade400,
              text: 'Cancel',
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
