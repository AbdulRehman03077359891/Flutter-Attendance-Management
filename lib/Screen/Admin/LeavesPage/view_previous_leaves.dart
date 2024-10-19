import 'package:attendance_management_system/Controller/admin_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewPreviousLeavesPage extends StatefulWidget {
  final String userUid;

  const ViewPreviousLeavesPage({
    super.key,
    required this.userUid,
  });

  @override
  State<ViewPreviousLeavesPage> createState() => _ViewPreviousLeavesPageState();
}

class _ViewPreviousLeavesPageState extends State<ViewPreviousLeavesPage> {
  final _adminLeaveController = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
    _adminLeaveController.fetchPreviousLeaveRequests(
        widget.userUid); // Fetch leave requests on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.amber,
              )),
          title: const Text(
            'Review Leave Requests',
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
          )),
      body: Obx(() {
        if (_adminLeaveController.leaveRequests.isEmpty) {
          return const Center(child: Text('No leave requests available',style: TextStyle(color: Colors.white),));
        }

        return ListView.builder(
          itemCount: _adminLeaveController.leaveRequests.length,
          itemBuilder: (context, index) {
            var leaveRequest = _adminLeaveController.leaveRequests[index];

            return Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(
                      color: const Color.fromARGB(132, 33, 33, 33),
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color.fromARGB(82, 255, 193, 7),
                              width: 2))),
                  child: Stack(
                    children: [
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Name: ${leaveRequest.userName}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'Class: ${leaveRequest.userClass}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: CachedNetworkImageProvider(
                                      leaveRequest.userProfilePic),
                                ),
                              ],
                            ),
                            Text(
                              'Email: ${leaveRequest.userEmail}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'From  ${leaveRequest.fromDate}  to  ${leaveRequest.toDate}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            Text(' Request: ${leaveRequest.reason} ',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ), // Display userUid
                      ),
                      Positioned(
                          child: Center(
                            child: Text(
                                                    leaveRequest.status,
                                                    style: TextStyle(
                              color: leaveRequest.status == 'Rejected'
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              shadows: const [
                                BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 5,
                                    blurRadius: 5)
                              ]),
                                                  ),
                          ))
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
