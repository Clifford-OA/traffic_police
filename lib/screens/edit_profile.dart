import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/utils/fetch_police_data.dart';
import 'package:traffic_police/utils/text_form.dart';
import 'package:traffic_police/widgets/rounded_button.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({Key? key}) : super(key: key);

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _checkPointController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  FetchPoliceData _fetchPoliceData = new FetchPoliceData();



  @override
  void initState() {
    final policeClass = Provider.of<Police>(context, listen: false);
    _nameController.text = policeClass.name;
    _checkPointController.text = policeClass.checkPoint;
    _addressController.text = policeClass.address;
    _emailController.text = policeClass.email;
    _telController.text = policeClass.tel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        elevation: 0.0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Container(
                //       padding: EdgeInsets.all(5.0),
                //       width: MediaQuery.of(context).size.width / 2,
                //       height: MediaQuery.of(context).size.width / 2,
                //       child: ClipRRect(
                //         borderRadius: BorderRadius.circular(100.0),
                //         child: _loadImage == false
                //             ? FadeInImage.assetNetwork(
                //                 placeholder: 'assets/no_picture.jpg',
                //                 image: image,
                //                 imageErrorBuilder:
                //                     (context, error, stackTrace) {
                //                   return Image.asset(
                //                     'assets/no_picture.jpg',
                //                   );
                //                 },
                //                 fit: BoxFit.cover,
                //               )
                //             : Center(
                //                 child: CircularProgressIndicator(),
                //               ),
                //       ),
                //     ),
                  
                //   ],
                // ),
                SizedBox(height: 50,),
                Container(
                  // height: 400,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textInput(
                          hint: "Name",
                          // initialValue: _name,
                          formatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z ]'))
                          ],
                          icon: Icons.person,
                          controller: _nameController),
                      textInput(
                          // initialValue: _checkPoint,
                          hint: "Check Point",
                          icon: Icons.check,
                          controller: _checkPointController),
                      // textInput(
                      //     hint: "Corperate email",
                      //     icon: Icons.email,
                      //     controller: _emailController),
                      textInput(
                          hint: "Tel",
                          // initialValue: _tel,
                          icon: Icons.phone,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: _telController),
                      textInput(
                          hint: "Address",
                          // initialValue: _address,
                          icon: Icons.home,
                          // formatters: [FilteringTextInputFormatter.digitsOnly],
                          controller: _addressController),
                          SizedBox(height: 100,),
                      RoundedButton(
                        buttonName: 'Update',
                        action: _validateAndUpdateUser,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: EdgeInsets.only(bottom: 270, left: 184),
            //   child: CircleAvatar(
            //     backgroundColor: Colors.black54,
            //     child: IconButton(
            //       icon: Icon(
            //         Icons.edit,
            //         color: Colors.white,
            //       ),
            //       onPressed: () {},
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  // validate and update police info
  void _validateAndUpdateUser() async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('police');
    final policeClass = Provider.of<Police>(context, listen: false);
    String tid = policeClass.tid;
    final errorResult = validateInputs();
    if (errorResult['status']) {
      await stylist.doc(tid).update({
        'name': _nameController.text,
        'checkPoint': _checkPointController.text,
        'tel': _telController.text,
        'address': _addressController.text,
      }).then((value) {
        _fetchPoliceData.loadUserData(context);
        // Navigator.push(context,
        //     MaterialPageRoute(builder: ((context) => ProfileScreen())));
        Navigator.pop(context);

        print('created successfully');
      }).catchError((error) {
        print("Failed to book: $error");
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
    } else if ((int.tryParse(_addressController.text) == null) &&
        (_addressController.text.length < 4)) {
      errorHandler['message'] =
          'address should not be less than 4 characters and should not be a number';
      return errorHandler;
    } else if (_nameController.text.length < 3) {
      errorHandler['message'] =
          'Name field should not be less than 3 characters';
      return errorHandler;
    } else if (_telController.text.trim().length != 10) {
      errorHandler['message'] = 'tel field should be only 10 integers';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }
}
