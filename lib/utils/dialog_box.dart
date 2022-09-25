import 'package:flutter/material.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/screens/home_screen.dart';
import 'package:traffic_police/screens/login_screen.dart';

class DialogBox {
  bool _isLoading = false;

  Future showLogOutDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return _isLoading == false
            ? AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: Text('Logout Alert!!',
                    style: TextStyle(
                      fontFamily: 'NimbusSanL',
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                      fontSize: 20,
                    )),
                content: Builder(
                  builder: (context) {
                    // Get available height and width of the build area of this widget. Make a choice depending on the size.
                    var height = MediaQuery.of(context).size.height;
                    var width = MediaQuery.of(context).size.width;

                    return Container(
                        height: height / 4,
                        width: width,
                        child: Center(
                          child: Text("Are you sure you want to logout"),
                        ));
                  },
                ),
                actions: <Widget>[
                  OutlinedButton(
                    child: Text(
                      "No",
                      style: TextStyle(
                        fontFamily: 'NimbusSanL',
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen()));
                      
                    },
                  ),
                  OutlinedButton(
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        fontFamily: 'NimbusSanL',
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      _isLoading = true;
                      AuthClass().signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                      // _confirmBook(context, label);
                    },
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
