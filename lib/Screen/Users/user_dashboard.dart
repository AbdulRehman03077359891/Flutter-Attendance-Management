import 'package:attendance_management_system/Controller/firebase_controller.dart';
import 'package:attendance_management_system/Controller/user_controller.dart';
import 'package:attendance_management_system/Screen/Users/leave_form.dart';
import 'package:attendance_management_system/Screen/Users/view_attendance.dart';
import 'package:attendance_management_system/Screen/Users/view_leaves.dart';
import 'package:attendance_management_system/Widget/e1_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserDashboard extends StatefulWidget {
  final String userUid, userName, userEmail, userProfilePic;
  final int userClass;
  const UserDashboard(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.userProfilePic, 
      required this.userClass});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  var authController = Get.put(FireController());
  var userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
    userController.checkAttendanceStatus(widget.userUid);
    });
  }

  //Profile Image
  final ImagePicker _picker = ImagePicker();

  // showing bottom sheet when tapped on profile pic
  showBottomSheet() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.grey.shade900,
            height: 60,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        authController.pickImage1(
                            widget.userUid,
                            widget.userName,
                            widget.userEmail,
                            widget.userClass,
                            ImageSource.camera,
                            _picker);
                        //pickImage(ImageSource.camera);
                      },
                      icon: CircleAvatar(
                        backgroundColor: Colors.amber.shade400,
                        child: const Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: () {
                      authController.pickImage1(widget.userUid, widget.userName,
                          widget.userEmail, widget.userClass, ImageSource.gallery, _picker);
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.amber.shade400,
                      child: const Icon(
                        Icons.photo,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return userController.isLoading.value
          ? const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              )))
          : Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "User Dashboard",
                  style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ]),
                ),
                backgroundColor: Colors.black,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage: CachedNetworkImageProvider(
                                widget.userProfilePic),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                  height: 35,
                                  decoration: const BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black38,
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                        )
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.amber),
                                  child: IconButton(
                                      onPressed: () {
                                        showBottomSheet();
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.white,
                                      ))))
                        ],
                      ),
                      E1Button(
                        disabledBackgroundColor: Colors.grey.shade900,
                        backColor: Colors.amber.shade400,
                        text: userController.hasMarkedToday.value
                            ? "Already Marked Attendance"
                            : "Mark Attendance",
                        textColor: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 5,
                        onPressed: userController.hasMarkedToday.value
                            ? null
                            : () => userController.markAttendance(
                                "Present", widget.userUid),
                      ),
                      E1Button(
                        backColor: Colors.amber.shade400,
                        text: "View Attendance",
                        textColor: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 5,
                        onPressed: () {
                          Get.to(()=> AnnualAttendancePage(userUid: widget.userUid));
                        },
                      ),
                      E1Button(
                        backColor: Colors.amber.shade400,
                        text: "Request Leave",
                        textColor: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 5,
                        onPressed: () {
                          Get.to(() =>  LeaveRequestPage(userUid: widget.userUid, userName: widget.userName, userEmail: widget.userEmail, userProfilePic: widget.userProfilePic, userClass: widget.userClass,));
                        },
                      ),
                      E1Button(
                        backColor: Colors.amber.shade400,
                        text: "View Leave Requests",
                        textColor: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 5,
                        onPressed: () {
                          Get.to(() =>  ViewLeaveRequests(userUid: widget.userUid));
                        },
                      ),
                      E1Button(
                        backColor: Colors.amber.shade400,
                        text: "Log out",
                        textColor: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 5,
                        onPressed: () {
                          authController.logOut();
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
