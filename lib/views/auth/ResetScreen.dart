import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shelter/Core/managers/NavgationManager.dart';
import 'package:shelter/generated/locale_keys.g.dart';
import 'package:shelter/style/AssetsKeys.dart';
import 'package:shelter/style/Style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shelter/views/common/CommonWidgets.dart';
import 'package:shelter/views/common/ImageLoader.dart';


//*************************************************************************************/
//**************************************ResetScreen************************************/
//*************************************************************************************/

final _auth = FirebaseAuth.instance;

class ResetScreen extends StatelessWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    final TextEditingController emailController = TextEditingController();

    // email field
    final emailField = FormBuilderTextField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return (LocaleKeys.enter_your_email.tr());
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return (LocaleKeys.enter_valid_email.tr());
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: Style.inputDecoration(context).copyWith(
        prefixIcon: Icon(Icons.mail),
        hintText: LocaleKeys.email.tr(),
      ),
      name: 'email',
    );

    final resetButton = CommonButton(
      text: LocaleKeys.send_request.tr(),
      onPressed: () {
        _auth.sendPasswordResetEmail(email: emailController.text);
        Fluttertoast.showToast(msg: LocaleKeys.email_sent.tr());
      },
    );

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Style.secondary),
            onPressed: () {
              navgationManager.pop();
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ImageLoader(
                        path: ImageAssets.logo,
                        fit: BoxFit.contain,
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(height: 10),
                      Text(
                        LocaleKeys.trouble_loggingIn.tr(),
                        style: Style.getFont(context).headline4,
                      ),
                      SizedBox(height: 10),
                      Text(
                        LocaleKeys.enter_email_to_reset.tr(),
                        style: Style.getFont(context).subtitle1,
                      ),
                      SizedBox(height: 45),
                      emailField,
                      SizedBox(height: 35),
                      resetButton,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
