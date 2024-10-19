import 'package:attendance_management_system/Controller/admin_dashboard_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAllLeaves extends StatefulWidget {

  const ViewAllLeaves(
      {super.key,});

  @override
  State<ViewAllLeaves> createState() => _ViewAllLeavesState();
}

class _ViewAllLeavesState extends State<ViewAllLeaves> {
  final AdminDashController adminDashController = Get.put(AdminDashController());

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
        if (adminDashController.leaveReq.isEmpty) {
          return const Center(child: Text('No leave requests available',style: TextStyle(color: Colors.white),));
        }

        return ListView.builder(
          itemCount: adminDashController.leaveReq.length,
          itemBuilder: (context, index) {

            return Column(
              children: [const SizedBox(height: 10,),
                Stack(
                  children: [
                    Container(margin: const EdgeInsets.symmetric(horizontal: 8),
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
                                        Text('Name: ${adminDashController.leaveReq[index]['userName']}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                        Text('Class: ${adminDashController.leaveReq[index]['userClass']}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                      
                                      ],
                                    ),
                                    CircleAvatar(radius: 30,backgroundImage: CachedNetworkImageProvider(adminDashController.leaveReq[index]['userProfilePic']),),
                                  ],
                                ),
                                Text('Email: ${adminDashController.leaveReq[index]['userEmail']}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                Text('From  ${adminDashController.leaveReq[index]['fromDate']}  to  ${adminDashController.leaveReq[index]['toDate']}',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
                                const SizedBox(height: 10,)
                              ],
                            ),
                        subtitle: Column(
                          children: [
                            Text(
                                ' Request: ${adminDashController.leaveReq[index]['reason']} ',style:  const  TextStyle(color: Colors.white,fontWeight: FontWeight.w400)),
                         
                          ],
                        ), // Display userUid
                         ),
                    ),
                    Positioned(
                          child: Center(
                            child: Text(
                                                    adminDashController.leaveReq[index]['status'],
                                                    style: TextStyle(
                              color: adminDashController.leaveReq[index]['status'] == 'Rejected'
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
              ],
            );
          },
        );
      }),
    );
  }
}
