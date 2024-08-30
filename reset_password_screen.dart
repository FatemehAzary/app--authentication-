import 'package:flutter/material.dart';
import 'package:play_meet/api/api_service.dart';
import 'package:play_meet/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreen();
}

class _ResetPasswordScreen extends State<ResetPasswordScreen> {
  ApiService apiService = ApiService();
  TextEditingController email = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirmation = TextEditingController();
  bool checkView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.android,
                  size: 150,
                  color: Colors.black,
                ),
                const SizedBox(height: 65),
                Text(
                  AppLocalizations.of(context)!.hello,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                checkView
                    ? sendEmail(title: AppLocalizations.of(context)!.hint)
                    : enterCode(title: AppLocalizations.of(context)!.enterCode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendEmail({required String title}) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 30),
        textField(
          controller: email,
          hintText: AppLocalizations.of(context)!.email,
          keyboardType: TextInputType.emailAddress,
        ),
        btn(
          title: AppLocalizations.of(context)!.sendmail,
          onTap: () async {
            dynamic response = await apiService.sendEmail(context: context, email: email.text);
            if (response == true) {
              setState(() {
                checkView = false;
              });
            }
          },
        ),
      ],
    );
  }

  enterCode({required String title}) {
    return Column(
      children: [
        Text(title),
        const SizedBox(
          height: 30,
        ),
        textField(controller: code, hintText: AppLocalizations.of(context)!.sendCode, keyboardType: TextInputType.text),
        textField(
          controller: password,
          hintText: AppLocalizations.of(context)!.newPassword,
          keyboardType: TextInputType.text,
        ),
        textField(
          controller: passwordConfirmation,
          hintText: AppLocalizations.of(context)!.confirmation,
          keyboardType: TextInputType.text,
        ),
        btn(
          title: AppLocalizations.of(context)!.sendmail,
          onTap: () async {
            dynamic response = await apiService.resetPassword(
              context: context,
              email: email.text,
              code: code.text,
              password: password.text,
              passwordConfirmation: passwordConfirmation.text,
            );
            if (response == true) {
              setState(() {
                Navigator.pushReplacementNamed(context, 'AuthenticationScreen');
              });
            }
          },
        ),
      ],
    );
  }

  textField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xff376AED),
            ),
          ),
          hintText: hintText,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }

  btn({required String title, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xff376AED),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
