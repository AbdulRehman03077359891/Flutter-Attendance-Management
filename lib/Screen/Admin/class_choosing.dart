import 'package:attendance_management_system/Screen/Admin/students_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassChoosingPage extends StatelessWidget {
  ClassChoosingPage({super.key});

  final List<String> classes = [
    'Class 3',
    'Class 4',
    'Class 5',
    'Class 6',
    'Class 7',
    'Class 8',
    'Class 9',
    'Class 10',
    'Class 11',
    'Class 12'
  ]; 
 // List of available classes
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
            "Choose Class",
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.grey.shade900,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: const BorderSide(color: Colors.amber)),
                child: ListTile(
                  title: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        classes[index],
                        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.to(StudentsData(userClass: index+3));
                  },
                ),
              );
            },
          ),
        ));
  }
}
