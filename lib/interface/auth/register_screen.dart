import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_intermediate/core/models/user.dart';
import 'package:submission_intermediate/core/static/enum.dart';
import 'package:submission_intermediate/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function onGotoLogin;
  final Function onRegister;
  const RegisterScreen(
      {super.key, required this.onGotoLogin, required this.onRegister});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
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
    if (_nameController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _passwordController.text.isNotEmpty) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
    }
  }

  // Register Function
  _register() async {
    if (formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final userCredentials = User(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text);
      final authRead = context.read<AuthProvider>();

      final result = await authRead.register(userCredentials);
      final error = authRead.currentError;

      result == true
          ? widget.onRegister()
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
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 38),
                      ),
                    ]),
                    const SizedBox(height: 12),
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Full name.';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                hintText: 'Full name',
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
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
                                if (value.length < 8) {
                                  return 'Password must be 8 long characters.';
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
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: MaterialButton(
                                color: Colors.blue[500],
                                onPressed: () => _register(),
                                child: context
                                            .watch<AuthProvider>()
                                            .registerState ==
                                        AuthState.loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Register',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            )
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 22),
                        child: GestureDetector(
                            onTap: () => widget.onGotoLogin(),
                            child: const Text(
                              'Have account already? \nLogin here',
                              textAlign: TextAlign.center,
                            ))),
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
