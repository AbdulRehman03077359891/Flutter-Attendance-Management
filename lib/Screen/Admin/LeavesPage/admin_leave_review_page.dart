import 'package:attendance_management_system/Controller/admin_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminLeaveReviewPage extends StatefulWidget {
  final String userUid, userName, userEmail, userProfilePic;

  const AdminLeaveReviewPage(
      {super.key,
      required this.userUid,
      required this.userName,
      required this.userEmail,
      required this.userProfilePic});

  @override
  State<AdminLeaveReviewPage> createState() => _AdminLeaveReviewPageState();
}

class _AdminLeaveReviewPageState extends State<AdminLeaveReviewPage> {
  final adminController = Get.put(AdminController());

  @override
  void initState() {
    super.initState();
    adminController
        .fetchAllLeaveRequests(); // Fetch leave requests on page load
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
        if (adminController.leaveRequests.isEmpty) {
          return const Center(child: Text('No leave requests available'));
        }

        return ListView.builder(
          itemCount: adminController.leaveRequests.length,
          itemBuilder: (context, index) {
            var leaveRequest = adminController.leaveRequests[index];

            return Column(
              children: [const SizedBox(height: 10,),
                Container(margin: const EdgeInsets.all(8),
                  decoration: ShapeDecoration(color: const Color.fromARGB(132, 33, 33, 33),
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              color: Color.fromARGB(82, 255, 193, 7), width: 2))),
                  child: ListTile(
                    title:
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                
                                Column(
                                  children: [
                                    Text('Name: ${leaveRequest.userName}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                    Text('Class: ${leaveRequest.userClass}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                  
                                  ],
                                ),
                                CircleAvatar(radius: 30,backgroundImage: CachedNetworkImageProvider(leaveRequest.userProfilePic),),
                              ],
                            ),
                            Text('Email: ${leaveRequest.userEmail}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                            Text('From  ${leaveRequest.fromDate}  to  ${leaveRequest.toDate}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                            const SizedBox(height: 10,)
                          ],
                        ),
                    subtitle: Column(
                      children: [
                        Text(
                            ' Request: ${leaveRequest.reason} ',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w400)),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          color: Colors.green,
                          onPressed: () {
                            adminController.approveLeaveRequest(
                              leaveRequest
                                  .userUid, // Use the userUid from the leave request
                              leaveRequest
                                  .requestId, // Use the requestId to identify the request
                              'Approved',
                              leaveRequest.fromDate,
                              leaveRequest.toDate,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          color: Colors.red,
                          onPressed: () {
                            adminController.approveLeaveRequest(
                              leaveRequest.userUid,
                              leaveRequest.requestId,
                              'Rejected',
                              leaveRequest.fromDate,
                              leaveRequest.toDate,
                            );
                          },
                        ),
                      ],
                    ),
                  
                      ],
                    ), // Display userUid
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
