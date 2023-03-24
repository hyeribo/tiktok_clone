import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const InterestsScreen(),
          ),
          (route) {
            // return false 한 route만 삭제
            return false;
          },
        );
      }
    }
  }

  void _onScaffoldTap(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onScaffoldTap(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Log in'),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size36,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Gaps.v28,
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please write your email.";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _formData['email'] = newValue;
                      }
                    },
                  ),
                  Gaps.v16,
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please write your password.";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      if (newValue != null) {
                        _formData['password'] = newValue;
                      }
                    },
                  ),
                  Gaps.v28,
                  GestureDetector(
                    onTap: _onSubmitTap,
                    child: const FormButton(
                      disabled: false,
                      text: 'Log in',
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
