import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_intermediate/core/models/user.dart';
import 'package:submission_intermediate/core/static/enum.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  final Function onGotoRegister;
  final Function onLogin;
  const LoginScreen(
      {super.key, required this.onGotoRegister, required this.onLogin});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _onObsecure = true;

  // Obsecure Password TextField
  _toggleObsecure() {
    setState(() {
      _onObsecure = !_onObsecure;
    });
  }

  // Disposes all TextFields
  _disposeTextFields() {
    if (_emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty) {
      _emailController.dispose();
      _passwordController.dispose();
    }
  }

  // Login Function
  _login() async {
    if (formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final userCredential = User(
          email: _emailController.text, password: _passwordController.text);
      final authRead = context.read<AuthProvider>();
      final result = await authRead.login(userCredential);
      final error = authRead.currentError;
      result == true
          ? widget.onLogin()
          : scaffoldMessenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void dispose() {
    _disposeTextFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 90),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/illustration_login.png',
                      width: 330,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Row(children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 38),
                      ),
                    ]),
                    const SizedBox(height: 22),
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Email.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                hintText: 'Email',
                                prefixIcon: Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _onObsecure,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Password.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  hintText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                    onPressed: () => _toggleObsecure(),
                                    icon: _onObsecure
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                  )),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: MaterialButton(
                                  color: Colors.blue[500],
                                  onPressed: () => _login(),
                                  child: context
                                              .watch<AuthProvider>()
                                              .loginState ==
                                          AuthState.loading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text(
                                          'Login',
                                          style: TextStyle(color: Colors.white),
                                        )),
                            )
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 18),
                        child: const Text('OR')),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)))),
                        onPressed: () => widget.onGotoRegister(),
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
