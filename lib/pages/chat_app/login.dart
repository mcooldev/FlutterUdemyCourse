import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginProvider(),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  // todo
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                icon: const Icon(
                  CupertinoIcons.house,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
          body: Consumer<LoginProvider>(
            builder: (_, prov, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 44),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Headline
                    const Icon(
                      CupertinoIcons.bubble_left_bubble_right_fill,
                      color: Colors.deepPurpleAccent,
                      size: 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Welcome Back !",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enter your email and password to login to your chat account.",
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium!.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 32),

                    /// Login Form here
                    Form(
                      key: prov.loginFormKey,
                      child: Column(
                        children: [
                          // Email Field
                          TextFormField(
                            controller: prov.emailController,
                            autocorrect: false,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.alternate_email_rounded,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Email',
                            ),
                            //
                            validator: (val) {
                              // todo: add email validator
                              if (val!.isEmpty || !val.contains('@')) {
                                return 'Email is required (Ex: example@xyz.com)';
                              }
                              return null;
                            },
                          ),
                          // Password Field
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: prov.pwdController,
                            autocorrect: false,
                            obscureText: prov.isVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_open_rounded),
                              suffixIcon: IconButton(
                                onPressed: prov.togglePasswordVisibility,
                                icon: prov.isVisible
                                    ? const Icon(CupertinoIcons.eye, color: Colors.deepPurpleAccent,)
                                    : const Icon(CupertinoIcons.eye_slash, color: Colors.deepPurpleAccent,),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Password',
                            ),
                            //
                            validator: (val) {
                              //todo: add password validator
                              if (val!.isEmpty || val.length < 6) {
                                return 'Password is required (At least 6 characters long)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),

                          /// Login Button
                          MaterialButton(
                            onPressed: () {
                              // todo: add logic to log in user
                              prov.login(context);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            color: Colors.deepPurpleAccent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 24,
                            ),
                            minWidth: double.infinity,
                            child: prov.isLoading
                                ? const CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.white,
                                  )
                                : Text(
                                    "Sign in now",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                          ),
                          const SizedBox(height: 32),

                          /// Don't have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/signup',
                                    (route) => false,
                                  );
                                },
                                child: Text(
                                  "Register now",
                                  style: Theme.of(context).textTheme.titleMedium!
                                      .copyWith(color: Colors.deepPurpleAccent),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          ///
                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: Colors.grey.shade300),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Text("OR"),
                              ),
                              Expanded(
                                child: Divider(color: Colors.grey.shade300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
