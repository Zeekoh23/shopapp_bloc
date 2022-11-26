import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/auth_screen.dart';

import '../models/http_exception.dart';
import '../models/auth.dart';
import '../helpers/api/auth_api.dart';
import '../bloc/bloc_exports.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
    required this.authApi,
  }) : super(key: key);
  final AuthApi authApi;

  @override
  _AuthCardState createState() => _AuthCardState(authApi);
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final AuthApi authApi;
  _AuthCardState(this.authApi);

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'passwordConfirm': ''
  };

  var _isLoading = false;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _passwordConfirmController = TextEditingController();
  AnimationController? _controller;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _controller!.dispose();

    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller!.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller!.reverse();
    }
  }

  void _authPost() {
    if (_authMode == AuthMode.Login) {
      BlocProvider.of<SignupLoginBloc>(context).add(
        LoginPost(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } else {
      BlocProvider.of<SignupLoginBloc>(context).add(
        SignupPost(
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirm: _passwordConfirmController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return BlocListener<SignupLoginBloc, SignupLoginState>(
      listener: (context, state) {
        if (state is SignupLoginFailure) {
          _showErrorDialog(state.error);
        }
      },
      child: BlocBuilder<SignupLoginBloc, SignupLoginState>(
        builder: (context, state) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: _authMode == AuthMode.Signup ? 320 : 260,
              constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.Signup ? 320 : 260),
              width: deviceSize.width * 0.75,
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'E-Mail'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          value = value.toString();
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                      TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          textInputAction: _authMode == AuthMode.Login
                              ? TextInputAction.done
                              : TextInputAction.next,
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            value = value.toString();
                            if (value.isEmpty || value.length < 5) {
                              return 'Password is too short!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _authData['password'] = value!;
                          },
                          onFieldSubmitted: (_) {
                            if (_authMode == AuthMode.Login) {
                              // _submit();
                              _authPost();
                            }
                          }),
                      AnimatedContainer(
                        constraints: BoxConstraints(
                          minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                          maxHeight: _authMode == AuthMode.Signup ? 160 : 0,
                        ),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                        child: FadeTransition(
                          opacity: _opacityAnimation!,
                          child: SlideTransition(
                            position: _slideAnimation!,
                            child: TextFormField(
                                enabled: _authMode == AuthMode.Signup,
                                decoration: const InputDecoration(
                                    labelText: 'Confirm Password'),
                                obscureText: true,
                                controller: _passwordConfirmController,
                                textInputAction: TextInputAction.done,
                                validator: _authMode == AuthMode.Signup
                                    ? (value) {
                                        value = value.toString();
                                        if (value != _passwordController.text) {
                                          return 'Passwords do not match!';
                                        }
                                        if (value.isEmpty || value.length < 5) {
                                          return 'Password is too short!';
                                        }
                                        return null;
                                      }
                                    : null,
                                onSaved: (value) {
                                  _authData['passwordConfirm'] = value!;
                                },
                                onFieldSubmitted: (_) {
                                  // _submit();
                                  //_loginPost();
                                }),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      if (state is SignupLoginLoading) ...[
                        const CircularProgressIndicator(),
                      ] else ...[
                        MaterialButton(
                          onPressed: _authPost,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button!.color,
                          child: Text(
                            _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                          ),
                        ),
                      ],
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 4,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: _switchAuthMode,
                        child: Text(
                            '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
