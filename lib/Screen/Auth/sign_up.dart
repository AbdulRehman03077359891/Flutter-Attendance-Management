
import 'package:attendance_management_system/Controller/firebase_controller.dart';
import 'package:attendance_management_system/Screen/Auth/sign_in.dart';
import 'package:attendance_management_system/Widget/choose_class.dart';
import 'package:attendance_management_system/Widget/e1_button.dart';
import 'package:attendance_management_system/Widget/notification_message.dart';
import 'package:attendance_management_system/Widget/text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  final String userType;
   const SignUpPage({super.key, required this.userType});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _class = TextEditingController();
  
  String? _selectedClass;


  bool _checkBoxVal = false;
  bool _buttonStatus = false;

  //Profile Image
  final ImagePicker _picker = ImagePicker();

  //Password Settings
  var _checkCapital = false;
  var _checkSmall = false;
  var _checkNumbers = false;
  var _checkSpecial = false;

  bool _hidePassword = true;
  var _passwordIcon = FontAwesomeIcons.eyeSlash;

  // is Form Filled
  final GlobalKey<FormState> _goodToGo = GlobalKey<FormState>();

  //FireController
  final _fireController = Get.put(FireController());

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
                        _fireController.pickImage(
                          ImageSource.camera,
                          _picker,
                          context
                        );
                        //pickImage(ImageSource.camera);
                      },
                      icon:  CircleAvatar(
                        backgroundColor: Colors.amber.shade400,
                        child: const Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      )),
                  IconButton(
                    onPressed: () {
                      _fireController.pickImage(
                        ImageSource.gallery,
                        _picker,
                        context
                      );
                    },
                    icon:  CircleAvatar(
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
    return Obx( () {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Padding(
              padding:  const EdgeInsets.all(10.0),
              child: Form(
                key: _goodToGo,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        "Create your new account.",
                        style: TextStyle(
                            color: Colors.amber.shade400,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                       const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "create an account to start looking for food you like.",
                                style: TextStyle(color: Colors.white),
                                softWrap: true,
                                overflow: TextOverflow.fade,
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                child: _fireController.pickedImageFile.value == null
                                    ?  const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: AssetImage(
                                            "assets/images/profilePlaceHolder.jpeg"),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(
                                            _fireController.pickedImageFile.value!)),
                              ),
                              Positioned(
                                  bottom: 1,
                                  right: 1,
                                  child: CircleAvatar(
                                    radius: 18,
                                    child: IconButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.grey.shade900)),
                                        onPressed: () {
                                          showBottomSheet();
                                        },
                                        icon:  Icon(
                                          Icons.add_a_photo,
                                          color:
                                              Colors.amber.shade400,
                                          size: 20,
                                        )),
                                  ))
                            ],
                          ),
                          TextFieldWidget(
                            textColor: Colors.white,
                            labelText: "User Name",
                            textCapitalization: TextCapitalization.sentences,
                            labelColor: Colors.amber.shade400,
                            width: MediaQuery.of(context).size.width * .65,
                            validate: (value) {
                              if (!value!.startsWith(RegExp(r'[A-Z][a-z]'))) {
                                return "Start with Capital letter";
                              } else if (value.isEmpty) {
                                return "username required";
                              } else {
                                return null;
                              }
                            },
                            keyboardType: TextInputType.name,
                            controller: _userName,
                            hintColor: Colors.white,
                            hintText: "Enter your username",
                            prefixIcon:  Icon(
                              Icons.person,
                              color: Colors.amber.shade400,
                            ),
                            fillColor:  const Color.fromARGB(31, 255, 255, 255),
                            focusBorderColor:
                                Colors.amber.shade400,
                            errorBorderColor: Colors.red,
                          ),
                        ],
                      ),
                       const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        hintColor: Colors.white,
                        textColor: Colors.white,
                        labelText: "Email Address",
                        labelColor: Colors.amber.shade400,
                        validate: (value) {
                          if (!value!.endsWith("@gmail.com")) {
                            return "Invalid email";
                          } else if (value.isEmpty) {
                            return "email required";
                          } else {
                            return null;
                          }
                        },
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        hintText: "Enter your email",
                        prefixIcon:  Icon(
                          Icons.email,
                          color: Colors.amber.shade400,
                        ),
                        fillColor:  const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: Colors.amber.shade400,
                        errorBorderColor: Colors.red,
                      ),
                       const SizedBox(
                        height: 20,
                      ),
                      TextFieldWidget(
                        hintColor: Colors.white,
                        textColor: Colors.white,
                        validate: (value) {
                          for (var i = 0; i < value!.length; i++) {
                            debugPrint(value[i]);
                            if (value.codeUnitAt(i) >= 65 &&
                                value.codeUnitAt(i) <= 90) {
                              _checkCapital = true;
                            }
                            if (value.codeUnitAt(i) >= 97 &&
                                value.codeUnitAt(i) <= 122) {
                              _checkSmall = true;
                            }
                            if (value.codeUnitAt(i) >= 48 &&
                                value.codeUnitAt(i) <= 57) {
                              _checkNumbers = true;
                            }
                            if (value.codeUnitAt(i) >= 33 &&
                                    value.codeUnitAt(i) <= 47 ||
                                value.codeUnitAt(i) >= 58 &&
                                    value.codeUnitAt(i) <= 64) {
                              _checkSpecial = true;
                            }
                          }
                          if (value.isEmpty) {
                            return "Password Required";
                          } //else if(passwordRules.hasMatch(value)){
                          // return "Invalid password" ;}
                          else if (!_checkCapital) {
                            return "Capital Letter Required";
                          } else if (!_checkSmall) {
                            return "Small Letter Required";
                          } else if (!_checkNumbers) {
                            return "Number Required";
                          } else if (!_checkSpecial) {
                            return "Special Character Required";
                          } else if (value.length < 8) {
                            return "Atleast 8 characters Required";
                          } else {
                            return null;
                          }
                        },
                        keyboardType: TextInputType.visiblePassword,
                        labelColor: Colors.amber.shade400,
                        labelText: "Password",
                        hidePassword: _hidePassword,
                        controller: _password,
                        hintText: "Enter your password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _hidePassword = !_hidePassword;
                            if (_passwordIcon == FontAwesomeIcons.eyeSlash) {
                              _passwordIcon = FontAwesomeIcons.eye;
                            } else {
                              _passwordIcon = FontAwesomeIcons.eyeSlash;
                            }
                            setState(() {});
                          },
                          child: Icon(_passwordIcon),
                        ),
                        prefixIcon:  Icon(
                          Icons.lock,
                          color: Colors.amber.shade400,
                        ),
                        fillColor:  const Color.fromARGB(31, 255, 255, 255),
                        focusBorderColor: Colors.amber.shade400,
                        errorBorderColor: Colors.red,
                        suffixIconColor: Colors.amber.shade400,
                      ),
                       const SizedBox(
                        height: 20,
                      ),
                      ChooseClass(
                        dropdownBackgroundColor: Colors.grey.shade900,
                        dropdownTextColor: Colors.white,
                        prefixIcon:  Icon(Icons.class_,color: Colors.amber.shade400,),
                        controller: _class,
                        selectedClass: _selectedClass,
                        onChange: (value) {
                          setState(() {
                            _selectedClass = value;
                            _class.text = value!;
                          });
                        },
                        width: MediaQuery.of(context).size.width,
                        fillColor:  const Color.fromARGB(31, 255, 255, 255),
                        labelColor: Colors.amber.shade400,
                        focusBorderColor: Colors.amber.shade400,
                        errorBorderColor: Colors.red,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              activeColor: Colors.amber.shade400,
                              value: _checkBoxVal,
                              onChanged: (bool? value) {
                                setState(() {
                                  _checkBoxVal = value!;
                                  _buttonStatus = !_buttonStatus;
                                });
                              }),
                          Flexible(
                            child: RichText(
                                text: TextSpan(children: [
                               const TextSpan(
                                  text: "I Agree with ",
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(
                                  text: "Terms and Service ",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                  style:  TextStyle(
                                    color: Colors.amber.shade400,
                                  )),
                               const TextSpan(
                                  text: "and ",
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(
                                  text: "Privacy Policy",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {},
                                  style:  TextStyle(
                                    color: Colors.amber.shade400,
                                    overflow: TextOverflow.visible,
                                  ))
                            ])),
                          ),
                        ],
                      ),
                      _fireController.isLoading.value
                          ?  CircularProgressIndicator(
                              color: Colors.amber.shade400,
                            )
                          : E1Button(
                            disabledBackgroundColor: Colors.grey.shade900,
                              backColor: Colors.amber.shade400,
                              text: "Sign Up",
                              textColor: Colors.white,
                              shadowColor: Colors.white,
                              elevation: 10,
                              onPressed: _buttonStatus
                                  ? () {
                                      if (_goodToGo.currentState!.validate()) {
                                        if (_fireController.pickedImageFile.value !=
                                            null) {
                                          _fireController.registerUser(
                                              _email.text,
                                              _password.text,
                                              _class.text,
                                              context,
                                              _userName.text,
                                              widget.userType,);
                                        } else {
                                          ErrorMessage('error',
                                              'Profile Image Required');
                                        }
                                      }
                                    }
                                  : null,
                            ),
                       const SizedBox(
                        height: 10,
                      ),
                       const Row(
                        children: [
                          Expanded(
                              child: Divider(
                            thickness: 1,
                          )),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              " Or signin with ",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 1,
                          ))
                        ],
                      ),
                       const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image:  const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/google.png"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image:  const DecorationImage(
                                      image: AssetImage(
                                          "assets/images/facebook.jpg"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image:  const DecorationImage(
                                      image:
                                          AssetImage("assets/images/apple.png"),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ],
                      ),
                       const SizedBox(
                        height: 20,
                      ),
                      RichText(
                          text: TextSpan(
                        children: [
                           const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                              text: "Sign In",
                              style:  TextStyle(
                                  color: Colors.amber.shade400,
                                  fontWeight: FontWeight.w500),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.off( const SignInPage());
                                })
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
