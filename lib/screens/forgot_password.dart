import 'package:flutter/material.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/screens/login_screen.dart';
import 'package:traffic_police/utils/text_form.dart';
import 'package:traffic_police/widgets/button_widget.dart';
import 'package:traffic_police/widgets/header_container.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            HeaderContainer("Reset Password"),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Center(
                  child: ListView(
                    children: [
                      textInput(
                          hint: "Corperate Email",
                          icon: Icons.email,
                          controller: _emailController),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30.0,
                        ),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Center(
                              child: isLoading == false
                                  ? ButtonWidget(
                                      btnText: "Send",
                                      onClick: _resetUserPassword,
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
                                    builder: ((context) => LoginScreen()))),
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _resetUserPassword() {
    final errorStatus = validateInputs();
    if (errorStatus['status']) {
      setState(() {
        isLoading = true;
      });
      AuthClass().resetPassword(_emailController.text).then((value) async {
        if (value['status']) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Please check your email to reset your password')));
          return Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()));
        } else {
          setState(() {
            isLoading = false;
          });
          return ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value['message'])));
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorStatus['message'])));
    }
  }

  validateInputs() {
    Map errorHandler = {'status': false, 'message': ''};
    if (_emailController.text.isEmpty ||
        _emailController.text.trim().length < 5) {
      errorHandler['message'] =
          'Please input a valid email';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }
}
