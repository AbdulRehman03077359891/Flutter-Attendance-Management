import 'package:attendance_management_system/Controller/user_controller.dart';
import 'package:attendance_management_system/Widget/e1_button.dart';
import 'package:attendance_management_system/Widget/notification_message.dart';
import 'package:attendance_management_system/Widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaveRequestPage extends StatelessWidget {
  final String userUid, userName, userEmail, userProfilePic;
  final int userClass;

  const LeaveRequestPage(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.userProfilePic,
      required this.userClass});

  @override
  Widget build(BuildContext context) {
    var userController = Get.put(UserController());

    return Obx(() {
      return userController.isLoading.value
          ? const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.amber,
                ),
              ),
            )
          : Scaffold(
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
                  "Leave Request",
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      // From Date Picker
                      ListTile(
                        tileColor: Colors.grey.shade900,
                        title: Text(
                            userController.fromDate.value == null
                                ? 'Select From Date'
                                : 'From: ${DateFormat('dd-MM-yyyy').format(userController.fromDate.value!)}',
                            style: const TextStyle(color: Colors.white)),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: Colors.amber,
                        ),
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
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
                          if (selectedDate != null) {
                            userController.fromDate.value =
                                selectedDate; // Update selected from date
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // To Date Picker
                      ListTile(
                        tileColor: Colors.grey.shade900,
                        title: Text(
                            userController.toDate.value == null
                                ? 'Select To Date'
                                : 'To: ${DateFormat('dd-MM-yyyy').format(userController.toDate.value!)}',
                            style: const TextStyle(color: Colors.white)),
                        trailing: const Icon(
                          Icons.calendar_today,
                          color: Colors.amber,
                        ),
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
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
                          if (selectedDate != null) {
                            userController.toDate.value =
                                selectedDate; // Update selected to date
                          }
                        },
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      // Reason for leave
                      TextFieldWidget(
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return "Reason is required"; // Adjusted validation
                          }
                          return null;
                        },
                        lines: 10,
                        hintColor: Colors.white,
                        textColor: Colors.white,
                        controller: userController.reasonController,
                        keyboardType: TextInputType.text,
                        hintText: "Reason for Leave",
                        fillColor: const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: Colors.amber.shade400,
                        errorBorderColor: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      E1Button(
                        backColor: Colors.amber.shade400,
                        text: "Submit Leave Request",
                        textColor: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 5,
                        onPressed: userController.isLoading.value
                            ? null
                            : () async {
                                if (userController
                                    .reasonController.text.isNotEmpty) {
                                  // Submit leave request
                                  await userController.submitLeaveRequest(
                                      userUid,
                                      userName,
                                      userEmail,
                                      userProfilePic,
                                      userClass,
                                      userController.reasonController.text);
                                } else {
                                  ErrorMessage(
                                      'error', 'Please fill all fields');
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ),
            );
    });
  }
}
