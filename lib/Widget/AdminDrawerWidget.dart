import 'package:attendance_management_system/Controller/AnimationController.dart';
import 'package:attendance_management_system/Controller/firebase_controller.dart';
import 'package:attendance_management_system/Screen/Admin/LeavesPage/admin_leave_review_page.dart';
import 'package:attendance_management_system/Screen/Admin/class_choosing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDrawerWidget extends StatefulWidget {
  final String adminUid,accountName, accountEmail, profilePicture;

  const AdminDrawerWidget({
    super.key,
    required this.adminUid,
    required this.accountName,
    required this.accountEmail,
    required this.profilePicture, 
  });

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  var fireController = Get.put(FireController());
  var animateController = Get.put(AnimateController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
      elevation: 50,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color.fromARGB(202, 255, 193, 7)),
            accountName: Text(
              widget.accountName,
              style: const TextStyle(shadows: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                  spreadRadius: 5,
                )
              ]),
            ), //const Text("UserName",style: TextStyle(color: Colors.white),),
            accountEmail: Text(
              widget.accountEmail,
              style: const TextStyle(shadows: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 5,
                  spreadRadius: 5,
                )
              ]),
            ), //const Text("user.name@email.com",style: TextStyle(color: Colors.white),),
            currentAccountPicture: GestureDetector(
              onTap: () {
                animateController.showSecondPage(
                    "Profile Picture",
                    widget.profilePicture 
                    ,
                    context);
              },
              child: Hero(
                tag: "Profile Picture",
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow:  [
                      BoxShadow(
                          color: Colors.grey.shade500,
                          blurRadius: 10,
                          spreadRadius: 1)
                    ],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(widget.profilePicture
                            ),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            tileColor: Colors.grey.shade900,
            leading: const Icon(
              Icons.contact_page,
              color: Colors.amber,
            ),
            title: const Text("Leaves Review",
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
            ),
            onTap: () {
              Get.to(AdminLeaveReviewPage(userUid: widget.adminUid, userName: widget.accountName, userEmail: widget.accountEmail, userProfilePic: widget.profilePicture));            },
          ),
          const SizedBox(height: 5,),
          ListTile(
            tileColor: Colors.grey.shade900,
            leading: const Icon(
              Icons.data_saver_off,
              color: Colors.amber,
            ),
            title: const Text("Students Data",
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
            ),
            onTap: () {
              Get.to(()=> ClassChoosingPage());
            },
          ),
          const SizedBox(height: 5,),
          ListTile(
            tileColor: Colors.grey.shade900,
            leading: const Icon(
              Icons.app_blocking,
              color: Colors.amber,
            ),
            title: const Text(
              "About",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 5,),
          ListTile(
            tileColor: Colors.grey.shade900,
            leading: const Icon(
              Icons.settings,
              color: Colors.amber,
            ),
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 5,),
          ListTile(
            tileColor: Colors.grey.shade900,
            leading: const Icon(
              Icons.logout,
              color: Colors.amber,
            ),
            title: const Text(
              "LogOut",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.amber,
            ),
            onTap: () {
              fireController.logOut();
            },
          ),
        ],
      ),
    );
  }
}
