import 'package:attendance_management_system/Controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnnualAttendancePage extends StatefulWidget {
  final String userUid; // User's unique ID

  const AnnualAttendancePage({super.key, required this.userUid});

  @override
  State<AnnualAttendancePage> createState() => _AnnualAttendancePageState();
}

class _AnnualAttendancePageState extends State<AnnualAttendancePage> {
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();

    // Postpone the listener setup until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userController.listenToAnnualAttendance(widget.userUid);
    });
  }

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
          "Annual Attendance",
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
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userController.attendanceData.isEmpty) {
          return const Center(child: Text('No attendance data available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // DataTable to display each day's attendance
              Card(
                color: Colors.grey.shade900,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Attendance Summary',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                        'Total Present: ${userController.totalPresent}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text('Total Absent: ${userController.totalAbsent}',
                          style: const TextStyle(color: Colors.white)),
                      Text('Total Leave: ${userController.totalLeave}',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('Date (Day)',
                            style: TextStyle(color: Colors.white))),
                    DataColumn(
                        label: Text('Status',
                            style: TextStyle(color: Colors.white))),
                  ],
                  rows: userController.attendanceData.entries.map((entry) {
                    String date = entry.key;
                    String status = entry.value;

                    // Format the date to get the day name
                    DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
                    String dayName =
                        DateFormat('EEEE').format(parsedDate); // Get day name

                    // Determine if the day is a weekend (Saturday or Sunday)
                    String displayStatus =
                        (dayName == 'Saturday' || dayName == 'Sunday')
                            ? 'Holiday'
                            : status;

                    return DataRow(cells: [
                      DataCell(Text('$date ($dayName)',
                          style: const TextStyle(
                              color:
                                  Colors.white))), // Display date and day name
                      DataCell(Text(displayStatus,
                          style: const TextStyle(
                              color: Colors
                                  .white))), // Display attendance status or "Holiday"
                    ]);
                  }).toList(),
                ),
              ),

              const SizedBox(height: 20),

              // Summary of total attendance
            ],
          ),
        );
      }),
    );
  }
}
