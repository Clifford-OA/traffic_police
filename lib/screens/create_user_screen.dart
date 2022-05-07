import 'package:flutter/material.dart';
import 'package:traffic_police/widgets/button_widget.dart';
import 'package:traffic_police/widgets/header_container.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
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
                  _textInput(hint: "Fullname", icon: Icons.person),
                  _textInput(hint: "Email", icon: Icons.email),
                  _textInput(hint: "Phone Number", icon: Icons.call),
                  _textInput(hint: "Password", icon: Icons.vpn_key),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, ),
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Center(
                          child: ButtonWidget(
                            btnText: "REGISTER",
                            onClick: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
