import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/home_page.dart';
import 'package:instagram_clone/pages/sign_up_page.dart';
import 'package:instagram_clone/servis_pages/auth_service.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void doSignIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      await AuthService.signInUser(email, password).then((value) => {
        if (value != null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())),
        }
      });
    } catch (e) {} finally{
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
                            onPressed: doSignIn,
                            child: Text("Sign In", style: TextStyle(color: Colors.white),),
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: TextStyle(color: Colors.white38),),
                      TextButton(
                        onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpPage()));
                        },
                        child: Text("Sign Up", style: TextStyle(color: Colors.white70, fontSize: 16),),
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
