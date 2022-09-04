import 'package:flutter/material.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/screens/login_screen.dart';
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
                child: ListView(
                  children: [
                    _textInput(
                        hint: "Corperate Email",
                        icon: Icons.email,
                        controller: _emailController),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
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
                                    btnText: "Send",
                                    onClick: _resetUserPassword,
                                  )
                                : CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _resetUserPassword() {
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
  }

  Widget _textInput({controller, hint, icon}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
