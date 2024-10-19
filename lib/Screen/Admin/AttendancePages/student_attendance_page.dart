import 'package:attendance_management_system/Controller/admin_controller.dart';
import 'package:attendance_management_system/Controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StudentAttendancePage extends StatefulWidget {
  final String userUid;
  final String startMonth; // New parameter for the selected start month

  const StudentAttendancePage(
      {super.key, required this.userUid, required this.startMonth});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  final AdminController adminController = Get.put(
    AdminController(),
  );
  final UserController userController = Get.put(
    UserController(),
  );

  String? selectedStatus; // Holds the selected attendance status
  final Map<String, List<DateTime>> monthlyAttendance =
      {}; // Map to hold attendance grouped by month

  @override
  void initState() {
    super.initState();
    userController
        .listenToAnnualAttendance(widget.userUid); // Listen to attendance data
    adminController.initializeMonthlyAttendance(monthlyAttendance,
        widget.startMonth); // Initialize the monthly attendance
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
          "Manage Attendace",
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

        return SingleChildScrollView(
          child: Column(
            children: [
              // Attendance Summary
              Card(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Attendance Summary',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black,
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ])),
                      const SizedBox(height: 8),
                      Text('Total Present: ${userController.totalPresent}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                      Text('Total Absent: ${userController.totalAbsent}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                      Text('Total Leave: ${userController.totalLeave}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              // DataTable to show attendance
              ...monthlyAttendance.entries.map((entry) {
                String monthYear = entry.key; // e.g., "January 2024"
                List<DateTime> daysInMonth = entry.value;

                return Card(
                  color: Colors.grey.shade900,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(
                        color:  Color.fromARGB(136, 255, 193, 7)),
                  ),
                  elevation: 6,
                  shadowColor: Colors.amber,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Month Header
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(monthYear,
                              style: const TextStyle(
                                  color: Colors.amber,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ])),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 10,
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'Date',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              )),
                              DataColumn(
                                  label: Text(
                                'Day',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              )),
                              DataColumn(
                                  label: Text(
                                'Action',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15),
                              )),
                            ],
                            rows: daysInMonth.map((date) {
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(date);
                              String dayOfWeek = DateFormat('EEEE')
                                  .format(date); // Get the day of the week
                              String status = userController
                                      .attendanceData[formattedDate] ??
                                  "Not Attended";

                              return DataRow(cells: [
                                DataCell(Text(formattedDate,style: const TextStyle(color: Colors.white),)), // Display date
                                DataCell(Text(
                                    dayOfWeek,style: const TextStyle(color: Colors.white),)), // Display the day of the week (e.g., Sunday)
                                // DataCell(Text(status)), // Display attendance status
                                DataCell(
                                  DropdownButton<String>(
                                    value: status == "Not Attended"
                                        ? null
                                        : status, // Show null if not attended
                                    hint: const Text(
                                      'Not Attended',
                                      style: TextStyle(
                                          color: Colors
                                              .white), // Hint text in white
                                    ),
                                    dropdownColor: Colors
                                        .black, // Dropdown background color (optional, for contrast)
                                    onChanged: (String? newValue) {
                                      if (newValue != null) {
                                        adminController.updateAttendance(
                                          formattedDate,
                                          newValue,
                                          context,
                                          widget.userUid,
                                          userController.attendanceData,
                                        );
                                        setState(() {
                                          selectedStatus =
                                              null; // Reset the status after updating
                                        });
                                      }
                                    },
                                    style: const TextStyle(
                                        color: Colors
                                            .white), // Selected value text color in white
                                    items: <String>[
                                      'Present',
                                      'Absent',
                                      'Leave'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors
                                                  .white,fontWeight: FontWeight.w500,shadows: [BoxShadow(color: Colors.amber,spreadRadius: 5,blurRadius: 5)]), // Dropdown item text color in white
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              ]);
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
