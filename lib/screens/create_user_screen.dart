import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/home_screen.dart';
import 'package:traffic_police/widgets/button_widget.dart';
import 'package:traffic_police/widgets/header_container.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _checkPointController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            HeaderContainer("Add Traffic Police User"),
            Expanded(
              child: ListView(
                children: [
                  _textInput(
                      hint: "Name",
                      icon: Icons.person,
                      controller: _nameController),
                  _textInput(
                      hint: "Check Point",
                      icon: Icons.check,
                      controller: _checkPointController),
                  _textInput(
                      hint: "Corperate email",
                      icon: Icons.email,
                      controller: _emailController),
                  _textInput(
                      hint: "Password",
                      icon: Icons.lock,
                      controller: _passwordController),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: Center(
                        child: isLoading == false
                            ? Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Center(
                                  child: ButtonWidget(
                                    btnText: "REGISTER",
                                    onClick: _validateAndSignUp,
                                  ),
                                ),
                              )
                            : CircularProgressIndicator(),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateAndSignUp() {
    final police = Provider.of<Police>(context, listen: false);
    Police _police = police.policeData;
    // final errorResult = validateName();
    // if (errorResult['status']) {
    setState(() {
      isLoading = true;
    });
    AuthClass()
        .createAccount(_police, _emailController.text, _passwordController.text)
        .then((value) async {
      if (value['status']) {
        _police.checkPoint = _checkPointController.text;
        _police.name = _nameController.text;
        _police.email = _emailController.text;
        await _police.saveInfo();
        // _loadUserData();
        setState(() {
          isLoading = false;
        });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'User with email address ${_emailController.text} is created successfully ')));
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(value['message'])));
      }
    });
    //   } else {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text(errorResult['message'])));
    //   }
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
