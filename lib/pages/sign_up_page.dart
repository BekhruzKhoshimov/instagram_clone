import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/member_model.dart';
import 'package:instagram_clone/pages/sign_in_page.dart';
import 'package:instagram_clone/servis_pages/db_service.dart';
import '../servis_pages/auth_service.dart';
import '../servis_pages/utils_service.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  bool isLoading = false;

  void doSignUp() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();

    if(name.isEmpty || email.isEmpty || password.isEmpty || cPassword.isEmpty) return;

    if(password != cPassword) return;

    if (!Utils.emailValidate(email)) {
      Utils.fireToast("Yaroqsiz Email");
      return;
    }

    if (!Utils.passwordValidate(password)) {
      Utils.fireToast("Yaroqsiz Parol\nMinimal 8ta belgi");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      User? firebaseUser = await AuthService.signUpUser(email, password);
      if (firebaseUser != null) {
        Member member = Member(name, email,  password);
        await DataService.storeMember(member);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    }catch (e) {} finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(193, 53, 132, 1),
                      Color.fromRGBO(131, 58, 180, 1),
                    ],
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Instagram",
                          style: TextStyle(color: Colors.white, fontSize: 45, fontFamily: "billabong"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: TextField(
                            controller: nameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Fullname",
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 17, color: Colors.white54)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: TextField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Email",
                                border: InputBorder.none,
                                hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white54)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: TextField(
                            controller: passwordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Password",
                                border: InputBorder.none,
                                hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white54)),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 50,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7)),
                          child: TextField(
                            controller: cPasswordController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Confirm Password",
                                border: InputBorder.none,
                                hintStyle:
                                TextStyle(fontSize: 17, color: Colors.white54)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            height: 50,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(7)),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: doSignUp,
                              child: Text("Sign Up", style: TextStyle(color: Colors.white),),
                            )
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: TextStyle(color: Colors.white38),),
                        TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage()));
                          },
                          child: Text("Sign In", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 16),),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            (isLoading) ?
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey.withOpacity(.3),
              child: Center(
                child: CircularProgressIndicator(

                ),
              ),
            ) :
            SizedBox(),
          ],
        )
    );
  }
}
