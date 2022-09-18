import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/login_screen.dart';
import 'package:traffic_police/utils/text_form.dart';
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
  TextEditingController _passwordConfController = TextEditingController();
  TextEditingController _telController = TextEditingController();

  bool isLoading = false;
  bool obscureValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            HeaderContainer(" Register "),
            Expanded(
              child: ListView(
                children: [
                  textInput(
                      hint: "Name",
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                      ],
                      icon: Icons.person,
                      controller: _nameController),
                  textInput(
                      hint: "Check Point",
                      icon: Icons.check,
                      controller: _checkPointController),
                  textInput(
                      hint: "Corperate email",
                      icon: Icons.email,
                      controller: _emailController),
                  textInput(
                      hint: "Tel",
                      icon: Icons.phone,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: _telController),
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
                  textInputPassword(
                      hint: "Confirm Password",
                      icon: Icons.lock,
                      controller: _passwordConfController,
                      suffixIcon: Icon(obscureValue
                          ? Icons.visibility
                          : Icons.visibility_off),
                      obscureValue: obscureValue,
                      onPressedSuffixIcon: () {
                        setState(() {
                          obscureValue = !obscureValue;
                        });
                      }),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 30.0,
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
                          style: TextStyle(fontSize: 20, color: Colors.blue),
                        ),
                      ),
                    ),
                  )
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

    final errorResult = validateInputs();
    if (errorResult['status']) {
      setState(() {
        isLoading = true;
      });

      AuthClass()
          .createAccount(
              _police, _emailController.text, _passwordController.text)
          .then((value) async {
        if (value['status']) {
          _police.checkPoint = _checkPointController.text;
          _police.tel = _telController.text;
          _police.name = _nameController.text;
          _police.email = _emailController.text;
          await _police.saveInfo();
          setState(() {
            isLoading = false;
          });
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorResult['message'])));
    }
  }

  validateInputs() {
    Map errorHandler = {'status': false, 'message': ''};
    if (_checkPointController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telController.text.isEmpty) {
      errorHandler['message'] = 'None of the field should be empty';
      return errorHandler;
    } else if (_checkPointController.text.length < 3) {
      errorHandler['message'] = 'check point should be less than 3 characters';
      return errorHandler;
    } else if (_nameController.text.length < 3) {
      errorHandler['message'] =
          'Name field should not be less than 3 characters';
      return errorHandler;
    } else if (_telController.text.trim().length != 10) {
      errorHandler['message'] = 'tel field should be only 10 integers';
      return errorHandler;
    } else if (_passwordController.text != _passwordConfController.text) {
      errorHandler['message'] = 'password and passwordConf must be equal';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }

}
