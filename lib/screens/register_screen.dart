import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:submission8/bloc/auth/auth_bloc.dart';
import 'package:submission8/bloc/auth/auth_event.dart';
import 'package:submission8/bloc/auth/auth_state.dart';
import 'package:submission8/widgets/custom_nav_bar.dart';
import 'package:submission8/widgets/custom_text.dart';
import 'package:submission8/widgets/screen_title.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStates.loading) {
          CircularProgressIndicator();
        }
        if (state.status == AuthStates.failure) {
          EasyLoading.showToast(state.error.toString());
        }
        if (state.status == AuthStates.success) {
          EasyLoading.dismiss();
          Navigator.pushNamed(context, '/note_screen');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNavBar(),
                SizedBox(height: 16),
                ScreenTitle(
                  title: 'Register',
                  subTitle: 'And start taking notes',
                ),
                SizedBox(height: 32),

                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomRegularText(text: 'Full Name'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hint: Text('Example: John Doe'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      CustomRegularText(text: 'Email Address'),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hint: Text('Example: johndoe@gmail.com'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address';
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),

                      CustomRegularText(text: 'Password'),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hint: Text('********'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      SizedBox(height: 22, width: 155),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF394675),
                                fixedSize: Size.fromHeight(46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    RegisterAuthEvent(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    ),
                                  );
                                  // Navigator.pushNamed(context, '/note_screen');
                                }
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  height: 52,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: CustomRegularText(
                      text: 'Already have an account? Login here',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
