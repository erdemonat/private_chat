import 'package:flutter/material.dart';

import 'package:privatechat/theme/constants.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isLogin;
  final bool isAuthenticating;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onToggleLoginMode;
  final VoidCallback onSubmit;
  final FormFieldSetter<String> onEmailSaved;
  final FormFieldSetter<String> onPasswordSaved;
  final FormFieldSetter<String> onConfirmPasswordSaved;
  final bool isObscureText;
  final VoidCallback toggleObscureText;
  final bool isObscureTextConfirm;
  final VoidCallback toggleObscureTextConfirm;

  const AuthForm({
    super.key,
    required this.formKey,
    required this.isLogin,
    required this.isAuthenticating,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onToggleLoginMode,
    required this.onSubmit,
    required this.onEmailSaved,
    required this.onPasswordSaved,
    required this.onConfirmPasswordSaved,
    required this.isObscureText,
    required this.toggleObscureText,
    required this.isObscureTextConfirm,
    required this.toggleObscureTextConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 32, left: 32),
            child: TextFormField(
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  decoration: TextDecoration.none),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              onSaved: onEmailSaved,
              decoration: kTextFormFieldDecoration(context)
                  .copyWith(labelText: "Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 32, left: 32, top: 10),
            child: TextFormField(
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  decoration: TextDecoration.none),
              controller: passwordController,
              obscureText: isObscureText,
              onSaved: onPasswordSaved,
              validator: (value) {
                if (value == null || value.trim().length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
              decoration: kTextFormFieldDecoration(context).copyWith(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    isObscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: toggleObscureText,
                ),
              ),
            ),
          ),
          if (!isLogin)
            Padding(
              padding: const EdgeInsets.only(right: 32, left: 32, top: 10),
              child: TextFormField(
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    decoration: TextDecoration.none),
                controller: confirmPasswordController,
                obscureText: isObscureTextConfirm,
                onSaved: onConfirmPasswordSaved,
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'The passwords must match.';
                  }
                  return null;
                },
                decoration: kTextFormFieldDecoration(context).copyWith(
                  labelText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscureTextConfirm
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: toggleObscureTextConfirm,
                  ),
                ),
              ),
            ),
          if (isAuthenticating)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          if (!isAuthenticating)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                onPressed: onSubmit,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                  elevation: WidgetStateProperty.all(0),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  isLogin ? 'Login' : 'Signup',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
              ),
            ),
          TextButton(
            onPressed: onToggleLoginMode,
            child: Text(
              isLogin ? 'Create an account' : 'Already have an account',
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
          ),
        ],
      ),
    );
  }
}
