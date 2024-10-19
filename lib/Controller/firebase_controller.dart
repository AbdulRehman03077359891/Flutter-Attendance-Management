// ignore_for_file: non_constant_identifier_names, file_names
// cupertino_icons: ^1.0.6
//   firebase_core: ^3.1.1
//   firebase_auth: ^5.1.1
//   firebase_storage: ^12.1.0
//   font_awesome_flutter: ^10.7.0
//   image_picker: ^1.1.2
//   cloud_firestore: ^5.0.2
//   firebase_database: ^11.0.2
//   get: ^4.6.6
//   shared_preferences: ^2.

import 'dart:io';

import 'package:attendance_management_system/Screen/Admin/admin_dashboard.dart';
import 'package:attendance_management_system/Screen/Auth/sign_in.dart';
import 'package:attendance_management_system/Screen/Users/user_dashboard.dart';
import 'package:attendance_management_system/Widget/notification_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class FireController extends GetxController {
  final RxBool isLoading = false.obs; // Updated to use RxBool
  final _uid = ''.obs;
  final imageLink = ''.obs;
  final Rxn<File> pickedImageFile =
      Rxn<File>(); // Updated to Rxn for nullable File
  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final usersListB = <dynamic>[].obs; // Changed to observable list
  final usersListN = <dynamic>[].obs;

  //Loading indicator ----------------------------------------------------
  setLoading(bool value) {
    isLoading.value = value; // Now updating via observable
  }

  //FireBase SignUp email/password---------------------------------------
  Future<UserCredential?> registerUser(
      String email,
      String password,
      String class_,
      BuildContext context,
      String userName,
      String userType) async {
    try {
      setLoading(true);
      final FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      _uid.value = user!.uid;
      imageStoreStorage(context, userName, email, password, userType, class_);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      if (e.code == 'weak-password') {
        ErrorMessage("error", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        ErrorMessage("error", "email already registered");
      }
    } catch (e) {
      setLoading(false);
      ErrorMessage("error", "Firebase ${e.toString()}");
    }
    return null;
  }

  //Storing Profile Image -----------------------------------------------
  Future<void> imageStoreStorage(BuildContext context, String userName,
      String email, String password, String userType, String class_) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("user/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value!);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageLink.value = downloadUrl;
      pickedImageFile.value = null;
      fireStoreDBase(context, userName, email, password, userType, class_);
    } catch (e) {
      setLoading(false);
      ErrorMessage("error", "ImageStorage ${e.toString()}");
    }
  }

  // Picking Image --------------------------------------------------------
  Future<void> pickImage(
      ImageSource source, ImagePicker picker, BuildContext context) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      pickedImageFile.value = File(pickedFile.path);
    }
    Navigator.pop(context);
  }

  Future<void> pickImage1(userUid, userName, userEmail, userClass, ImageSource source,
      ImagePicker picker) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      pickedImageFile.value = File(pickedFile.path);

      await storeImage(userUid, userName, userEmail, userClass);
    }
  }

//Storing Data --Firestore Database -------------------------------------
  fireStoreDBase(context, userName, email, password, userType, class_) async {
    try {
      var dBaseInstance = FirebaseFirestore.instance;
      CollectionReference dBaseRef = dBaseInstance.collection(userType);

      var userObj = {
        "userName": userName,
        "userEmail": email,
        "userPassword": password,
        "userProfilePic": imageLink.value,
        "userUid": _uid.value,
        "userType": userType,
        "userClass": int.parse(class_),
      };

      await dBaseRef.doc(_uid.value).set(userObj);

      ErrorMessage('Success', 'User Registered Successfully');

      setLoading(false);

      // Going to new page vvv
      Get.off(const SignInPage());
      //-------------------^^^
    } catch (e) {
      setLoading(false);
      ErrorMessage("error", "Database ${e.toString()}");
    }
  }

//Auto LogIn preferences -------------------------------------------------
  setPreference(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("Login", true);
    prefs.setString("userType", userData["userType"]);
    prefs.setString("userEmail", userData["userEmail"]);
    prefs.setString("userProfilePic", userData["userProfilePic"]);
    prefs.setString("userUid", userData["userUid"]);
    userData["userType"] == "user"
        ? {
            prefs.setInt("userClass", userData["userClass"]),
            prefs.setString("userName", userData["userName"])
          }
        : prefs.setString("userName", userData["userName"]);
  }

  logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(const SignInPage());
  }

  Future<UserCredential?> logInUser(
      String email, String password, context, go) async {
      setLoading(true);
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      // Check if userCredential is null
      if (userCredential.user == null) {
        setLoading(false);
        ErrorMessage("error", "Login failed. UserCredential is null.");
        return null;
      }

      // Get the logged-in user
      final user = userCredential.user;
      if (user == null) {
        setLoading(false);
        ErrorMessage("error", "Login failed. User is null.");
        return null;
      }

      // Fetch user data from Firestore
      await fireBaseDataFetch(context, user, go);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Log the exception details
      setLoading(false);
      print('FirebaseAuthException code: ${e.code}, message: ${e.message}');

      // Handle specific FirebaseAuth exceptions
      if (e.code == 'wrong-password') {
        ErrorMessage('error', 'Incorrect password.');
      } else if (e.code == 'user-not-found') {
        ErrorMessage('error', 'No user found with this email.');
      } else if (e.code == 'user-disabled') {
        ErrorMessage('error', 'User account has been disabled.');
      } else if (e.code == 'invalid-email') {
        ErrorMessage('error', 'The email address is not valid.');
      } else {
        ErrorMessage("error", "FirebaseAuthException: ${e.message}");
      }
    } catch (e) {
      setLoading(false);
      ErrorMessage("error", "Error: ${e.toString()}");
    } finally {
      // Ensure loading is turned off
      setLoading(false);
    }
    return null;
  }

  Future<void> fireBaseDataFetch(
      BuildContext context,  user, String go) async {
    try {
      setLoading(true);
      FirebaseFirestore.instance
          .collection("user")
          .doc(go == "go" ? user: user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          var data = documentSnapshot.data() as Map<String, dynamic>;
          userData.value = data;
          setPreference(userData);
          setLoading(false);
          if (go == "go") {
            debugPrint(go);
          } else {
            Get.offAll(() => UserDashboard(
                  userUid: userData["userUid"],
                  userName: userData["userName"],
                  userEmail: userData["userEmail"],
                  userProfilePic: userData["userProfilePic"],
                  userClass: userData["userClass"],
                ));
          }
        } else {
          // Check in the admin collection
          FirebaseFirestore.instance
              .collection("admin")
              .doc(go == "go" ? user : user!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) async {
            if (documentSnapshot.exists) {
              var data = documentSnapshot.data() as Map<String, dynamic>;
              userData.value = data;
              setPreference(userData);
              setLoading(false);
              if (go == "go") {
                debugPrint(go);
              } else {
                Get.offAll(AdminDashboard(
                  adminUid: userData["userUid"],
                  adminName: userData["userName"],
                  adminEmail: userData["userEmail"],
                  adminProfilePic: userData["userProfilePic"],
                ));
              }
            } else {
              setLoading(false);
              ErrorMessage("error", "Document does not exist");
            }
          }).catchError((error) {
            setLoading(false);
            ErrorMessage("error", "Error fetching admin data: $error");
          });
        }
      }).catchError((error) {
        setLoading(false);
        ErrorMessage("error", "Error fetching user data: $error");
      });
    } catch (e) {
      setLoading(false);
      ErrorMessage("error", "Unexpected error: ${e.toString()}");
    }
  }

//Fetch AllBusinessUsers -------------------------------------------------
  getAllBusiUsers() async {
    CollectionReference users =
        FirebaseFirestore.instance.collection("BusinessUsers");
    await users.get().then((QuerySnapshot snapshot) => {
          snapshot.docs.forEach((doc) {
            // print('${doc.id} => ${doc.data()}');
            usersListB.add(doc.data());
          })
        });
  }

  getAllUsers() async {
    CollectionReference users = FirebaseFirestore.instance.collection("Users");
    await users.get().then((QuerySnapshot snapshot) => {
          snapshot.docs.forEach((doc) {
            // print('${doc.id} => ${doc.data()}');
            usersListN.add(doc.data());
          })
        });
  }

  updateUserData(userUid, userName, userEmail, userProfilePic, userClass) async {
    CollectionReference userInst =
        FirebaseFirestore.instance.collection("user");
    var doc = await userInst.doc(userUid).get();

    if (doc.exists) {
      await userInst.doc(userUid).update({
        "userProfilePic": userProfilePic,
      }).then((_) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("userProfilePic", userProfilePic);

        pickedImageFile.value = null;
        setLoading(false);
        ErrorMessage("Success", "Personal Data updated successfully");
        Get.offAll(UserDashboard(
          userUid: userUid,
          userName: userName,
          userEmail: userEmail,
          userProfilePic: userProfilePic,
          userClass: userClass,
        ));
      }).catchError((error) {
        setLoading(false);
        ErrorMessage("error", "Failed to update Personal Data: $error");
      });
    } else {
      setLoading(false);
      ErrorMessage("error", "Document not found");
    }
  }

  //Storing Profile Image -----------------------------------------------
  storeImage(userUid, userName, userEmail, userClass) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageRef =
          storage.ref().child("user/${pickedImageFile.value!.path}");
      UploadTask upLoad = storageRef.putFile(pickedImageFile.value as File);
      TaskSnapshot snapshot = await upLoad.whenComplete(() => ());
      String downloadUrl = await snapshot.ref.getDownloadURL();

      imageLink.value = downloadUrl;
      updateUserData(userUid, userName, userEmail, imageLink.value, userClass);
    } catch (e) {
      // ErrorMessage("error", "ImageStorage ${e.toString()}");
    }
  }

  void scheduleAbsenceCheck() {
  // Get the current time
  DateTime now = DateTime.now();
  
  // Calculate the next midnight time
  DateTime nextMidnight = DateTime(now.year, now.month, now.day + 1);

  // Calculate the initial delay until the next midnight
  Duration initialDelay = nextMidnight.difference(now);

  // Schedule the task to run at midnight every day
  Workmanager().registerPeriodicTask(
    "absenceTask",
    "markAbsenceIfNotPresent",
    frequency: const Duration(hours: 24),
    initialDelay: initialDelay,
  );
}

}
