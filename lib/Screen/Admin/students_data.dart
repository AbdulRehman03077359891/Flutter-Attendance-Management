import 'package:attendance_management_system/Screen/Admin/student_info_choose.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class StudentsData extends StatefulWidget {
  final int userClass;
  const StudentsData({super.key, required this.userClass});

  @override
  State<StudentsData> createState() => _StudentsDataState();
}

class _StudentsDataState extends State<StudentsData> {
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
          "Students Data",
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('user')
            .where('userClass', isEqualTo: widget.userClass)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No students available'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              final studentData = doc.data() as Map<String, dynamic>;
              return Card(
                color: Colors.grey.shade900,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.amber)),
                child: ListTile(leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(studentData['userProfilePic'])),
                  title: Text(studentData[
                      'userName'],style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),), // Assuming student has a 'name' field
                  subtitle: Text('Class: ${studentData['userClass']}', style: const TextStyle(color: Colors.white),), // User ID for reference
                  onTap: () {
                    // Navigate to Attendance Management Page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentInfoChoose(
                          userUid: doc.id,
                          userName: studentData["userName"],
                          userEmail: studentData["userEmail"],
                          userProfilePic: studentData["userProfilePic"],
                          userClass: studentData["userClass"],
                          startMonth: 'September',
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
