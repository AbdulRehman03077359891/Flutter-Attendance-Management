

import 'package:attendance_management_system/Controller/admin_controller.dart';
import 'package:attendance_management_system/Widget/e1_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateAttendanceReportPage extends StatefulWidget {
  final String userUid, userName, userEmail, userProfilePic;
  final int userClass;

  const CreateAttendanceReportPage(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.userProfilePic,
      required this.userClass});

  @override
  State<CreateAttendanceReportPage> createState() =>
      _CreateAttendanceReportPageState();
}

class _CreateAttendanceReportPageState
    extends State<CreateAttendanceReportPage> {
  final AdminController adminController = Get.put(AdminController());


  @override
  Widget build(BuildContext context) {
    return Obx( () {
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
              "Create Attendance Report",
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Date picker for 'From Date'
              Card(
                color: Colors.grey.shade900,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: const BorderSide(color: Color.fromARGB(136, 255, 193, 7)),
                ),
                elevation: 6,
                shadowColor: Colors.amber,
                margin: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text(
                    adminController.fromDate.value == null
                        ? "Select From Date"
                        : "From Date: ${DateFormat('dd-MM-yyyy').format(adminController.fromDate.value!)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: Colors.amber,
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.amber,
                              onPrimary: Colors.white,
                              surface: Colors.grey.shade900,
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: Colors.black,
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        adminController.fromDate.value = picked;
                      });
                    }
                  },
                ),
              ),
              // Date picker for 'To Date'
              Card(
                color: Colors.grey.shade900,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: const BorderSide(color: Color.fromARGB(136, 255, 193, 7)),
                ),
                elevation: 6,
                shadowColor: Colors.amber,
                margin: const EdgeInsets.all(16.0),
                child: ListTile(
                  title: Text(
                    adminController.toDate.value == null
                        ? "Select To Date"
                        : "To Date: ${DateFormat('dd-MM-yyyy').format(adminController.toDate.value!)}",
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: Colors.amber,
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: Colors.amber,
                              onPrimary: Colors.white,
                              surface: Colors.grey.shade900,
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: Colors.black,
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        adminController.toDate.value = picked;
                      });
                    }
                  },
                ),
              ),
              E1Button(
                backColor: Colors.amber.shade400,
                text: "Generate Report",
                textColor: Colors.white,
                shadowColor: Colors.white,
                elevation: 5,
                onPressed: () {
                  if (adminController.fromDate.value != null && adminController.toDate.value != null) {
                    adminController.createAttendanceReport(
                        widget.userUid,
                        widget.userName,
                        widget.userEmail,
                        widget.userProfilePic,
                        widget.userClass,
                        adminController.fromDate.value!,
                        adminController.toDate.value!);
                  }
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
