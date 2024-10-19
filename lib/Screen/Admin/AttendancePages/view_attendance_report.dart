import 'package:attendance_management_system/Controller/admin_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAttendanceReportPage extends StatefulWidget {
  final String reportId;
  final String userUid;

  const ViewAttendanceReportPage({
    super.key,
    required this.reportId,
    required this.userUid,
  });

  @override
  State<ViewAttendanceReportPage> createState() => _ViewAttendanceReportPageState();
}

class _ViewAttendanceReportPageState extends State<ViewAttendanceReportPage> {
  final AdminController adminController = Get.put(AdminController());
  @override
  void initState() {
    super.initState();
    adminController
        .fetchAttendanceReport(widget.userUid); // Fetch leave requests on page load
  }
  
  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.put(AdminController());
    adminController.fetchAttendanceReport(widget.reportId); // Fetch report data on build

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Report'),
      ),
      body: Obx(() {
        // Use Obx to listen to changes in reportData
        if (adminController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        var reportData = adminController.reportData;
        String grade = reportData['grade'] ?? 'N/A'; // Default to 'N/A' if grade is null
        double attendancePercentage = reportData['attendancePercentage'] ?? 0.0;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('From: ${reportData['fromDate']}'),
              Text('To: ${reportData['toDate']}'),
              Text('Total Present: ${reportData['totalPresent']}'),
              Text('Total Absent: ${reportData['totalAbsent']}'),
              Text('Total Leave: ${reportData['totalLeave']}'),
              Text('Attendance Percentage: $attendancePercentage%'),
              const SizedBox(height: 20),
              // Grade display and edit functionality
              Row(
                children: [
                  const Text('Grade: '),
                  DropdownButton<String>(
                    value: grade,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        // Update grade in Firestore
                        FirebaseFirestore.instance.collection('attendanceReports').doc(widget.reportId).update({
                          'grade': newValue,
                        });
                      }
                    },
                    items: ['A', 'B', 'C', 'D'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Confirm before deleting the report
                  bool confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Report'),
                        content: const Text('Are you sure you want to delete this report?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm) {
                    // Delete the report from Firestore
                    await FirebaseFirestore.instance.collection('attendanceReports').doc(widget.reportId).delete();
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete Report'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
