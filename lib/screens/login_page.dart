import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_management_app/constant/color_const.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

const forgotPassword = SnackBar(
  backgroundColor: Colors.white,
  content: Text(
    'Please contact the IT Department of your school',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.black),
  ),
);

const noEmail = SnackBar(
  backgroundColor: Colors.white,
  content: Text(
    'The email you entered is not registered with us',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.red),
  ),
);

const wrongCredentials = SnackBar(
  backgroundColor: Colors.white,
  content: Text(
    'Incorrect Email or Password',
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.red),
  ),
);

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void login(String email, String password) async {
    setState(() {
      isLoading = true;
    });

    await FirebaseFirestore.instance
        .collection("students")
        .where("email", isEqualTo: emailController.text)
        .get()
        .then((studentValue) {
      if (studentValue.docs.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("students")
            .where("email", isEqualTo: emailController.text)
            .where("password", isEqualTo: passwordController.text)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            final box = Hive.box('auth');
            box.put('id', value.docs[0].id);
            box.put('type', 'student');
            box.put('email', emailController.text);
            box.put('password', passwordController.text);

            // Password is correct
            Navigator.pushReplacementNamed(context, 'newDashboard',
                arguments: value.docs[0].id);
          } else {
            setState(() {
              isLoading = false;
            });
            // Password is incorrect
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password is incorrect'),
              ),
            );
          }
        });
      } else {
        FirebaseFirestore.instance
            .collection("teachers")
            .where("email", isEqualTo: emailController.text)
            .get()
            .then((teacherValue) async {
          if (teacherValue.docs.isNotEmpty) {
            // Email and password belong to a user
            FirebaseFirestore.instance
                .collection("teachers")
                .where("email", isEqualTo: emailController.text)
                .where("password", isEqualTo: passwordController.text)
                .get()
                .then((value) {
              if (value.docs.isNotEmpty) {
                final box = Hive.box('auth');
                box.put('id', value.docs[0].id);
                box.put('type', 'teacher');
                box.put('email', emailController.text);
                box.put('password', passwordController.text);
                // Password is correct
                Navigator.pushReplacementNamed(context, 'teacherDashboard',
                    arguments: value.docs[0].id);
              } else {
                setState(() {
                  isLoading = false;
                });
                // Password is incorrect
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password is incorrect'),
                  ),
                );
              }
            });
          } else {
            final adminCollection =
                FirebaseFirestore.instance.collection("admins");
            final admins = await adminCollection.get();
            admins.docs.forEach((e) => print(e.data()));

            FirebaseFirestore.instance
                .collection("admins")
                .where("email", isEqualTo: emailController.text)
                .get()
                .then((adminValues) {
              if (adminValues.docs.isNotEmpty) {
                // Email and password belong to a superuser
                FirebaseFirestore.instance
                    .collection("admins")
                    .where("email", isEqualTo: emailController.text)
                    .where("password", isEqualTo: passwordController.text)
                    .get()
                    .then((value) {
                  if (value.docs.isNotEmpty) {
                    // Password is correct
                    final box = Hive.box('auth');
                    box.put('id', adminValues.docs[0].id);
                    box.put('type', 'admin');
                    box.put('email', emailController.text);
                    box.put('password', passwordController.text);
                    Navigator.pushReplacementNamed(context, 'adminDashboard',
                        arguments: value.docs[0].id);
                  } else {
                    setState(() {
                      isLoading = false;
                    });
                    // Password is incorrect
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password is incorrect'),
                      ),
                    );
                  }
                });
              } else {
                setState(() {
                  isLoading = false;
                });
                // Email not found in any collection
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Email not found'),
                  ),
                );
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width),
                        Container(
                          padding: const EdgeInsets.all(5),
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/logo.png"))),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width),
                        Form(
                          key: _formKey,
                          child: Column(children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
                                  right:
                                      MediaQuery.of(context).size.width * 0.02),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3)),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (value.length < 3) {
                                    return 'Email must be atleast 3 characters';
                                  }
                                  return null;
                                },
                                controller: emailController,
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Email",
                                  suffixIcon: const Icon(Icons.email),
                                ),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04),
                            Container(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05,
                                  right:
                                      MediaQuery.of(context).size.width * 0.02),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3)),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                obscureText: passwordVisible ? false : true,
                                decoration: InputDecoration(
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: "Password",
                                  suffixIcon: IconButton(
                                      icon: Icon(passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01),
                        Padding(
                          padding: EdgeInsets.only(right: 24),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please contact the admistration to reset your password.'),
                                  ),
                                );
                              },
                              child: Text("Forgot Password?"),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            fixedSize: const Size(210, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: AppColor.primary,
                          ),
                          child: const Text("Login",
                              style: TextStyle(fontSize: 21)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              login(emailController.text.toLowerCase(),
                                  passwordController.text);
                            }
                          },
                        ),
                      ]),
                ),
        ],
      ),
    );
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
}
