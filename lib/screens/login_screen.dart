import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/create_user_screen.dart';
import 'package:traffic_police/screens/forgot_password.dart';
import 'package:traffic_police/screens/home_screen.dart';
import 'package:traffic_police/utils/fetch_police_data.dart';
import 'package:traffic_police/utils/text_form.dart';
import 'package:traffic_police/widgets/button_widget.dart';
import 'package:traffic_police/widgets/header_container.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FetchPoliceData _fetchPoliceData = new FetchPoliceData();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  bool obscureValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            HeaderContainer("Login"),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: ListView(
                  children: [
                    textInput(
                        hint: "Corperate Email",
                        icon: Icons.email,
                        controller: _emailController),
                    textInputPassword(
                        hint: "Password",
                        icon: Icons.lock,
                        controller: _passwordController,
                        suffixIcon: Icon(obscureValue
                            ? Icons.visibility
                            : Icons.visibility_off),
                        obscureValue: obscureValue,
                        onPressedSuffixIcon: () {
                          setState(() {
                            obscureValue = !obscureValue;
                          });
                        }),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ForgotPassword()))),
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Center(
                            child: isLoading == false
                                ? ButtonWidget(
                                    btnText: "LOGIN",
                                    onClick: _signUserIn,
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CreateUserScreen()))),
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signUserIn() {
    final police = Provider.of<Police>(context, listen: false);
    Police _police = police.policeData;
    setState(() {
      isLoading = true;
    });
    AuthClass()
        .signIN(_police, _emailController.text, _passwordController.text)
        .then((value) async {
      if (value['status']) {
        _fetchPoliceData.loadUserData(context);
        setState(() {
          isLoading = false;
        });
        return Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
      } else {
        setState(() {
          isLoading = false;
        });
        return ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value['message'])));
      }
    });
  }
}
