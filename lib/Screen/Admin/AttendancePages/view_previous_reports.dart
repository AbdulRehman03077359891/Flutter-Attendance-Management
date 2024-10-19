import 'package:attendance_management_system/Controller/admin_controller.dart';
import 'package:attendance_management_system/Helper/attendance_report.dart';
import 'package:attendance_management_system/Widget/e1_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewAttendanceReportsPage extends StatefulWidget {
  final String userUid;

  const ViewAttendanceReportsPage({super.key, required this.userUid});

  @override
  State<ViewAttendanceReportsPage> createState() =>
      _ViewAttendanceReportsPageState();
}

class _ViewAttendanceReportsPageState extends State<ViewAttendanceReportsPage> {
  final AdminController adminController = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
    adminController.fetchAttendanceReport(widget.userUid);
  });}

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
        () => adminController.attendanceReport.isEmpty
            ? const Center(
                child: Text(
                  'No attendance reports available',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: adminController.attendanceReport.length,
                itemBuilder: (context, index) {
                  var report = adminController.attendanceReport[index];
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
                            '${report.userName} (Class: ${report.userClass})',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email: ${report.userEmail}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Grade: ${report.grade}',
                                style: const TextStyle(color: Colors.amber),
                              ),
                              Text(
                                'Total Days: ${report.totalDays}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Presents: ${report.totalPresent}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Absences: ${report.totalAbsent}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Total Leaves: ${report.totalLeave}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Attendance: ${report.attendancePercentage}%',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'From: ${report.fromDate} To: ${report.toDate}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Created At : ${DateFormat('dd-MM-yyyy').format((report.createdAt).toDate())}',
                                style: const TextStyle(color: Color.fromARGB(158, 255, 255, 255)),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onSelected: (value) {
                              if (value == 'Edit Grade') {
                                _editGradeDialog(report);
                              } else if (value == 'Delete Report') {
                                _deleteReportDialog(report.reportKey);
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
                            backgroundImage: CachedNetworkImageProvider(report.userProfilePic),
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
  void _editGradeDialog(AttendanceReport report) {
    TextEditingController gradeController =
        TextEditingController(text: report.grade);
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
                adminController.updateStudentGrade(
                    report.reportKey, gradeController.text,report.userUid);
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
  void _deleteReportDialog(String reportKey) {
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
                adminController.deleteReport(reportKey);
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
