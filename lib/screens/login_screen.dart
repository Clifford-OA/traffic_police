import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/home_screen.dart';
import 'package:traffic_police/utils/fetch_police_data.dart';
// import 'package:traffic_police/screens/register_screen.dart';
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
                    _textInput(
                        hint: "Corperate Email",
                        icon: Icons.email,
                        controller: _emailController),
                    _textInput(
                        hint: "Password",
                        icon: Icons.vpn_key,
                        controller: _passwordController),
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
                                    btnText: "LOGIN",
                                    onClick: _signUserIn,
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
        return Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
