import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money_app/presentation/theme/app_colors.dart';
import 'package:send_money_app/presentation/utils/snackbar_utils.dart';
import '../cubit/auth/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          SnackBarUtils.showErrorMessage(message: state.message);
        }
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildLoginTitle(),
                const SizedBox(
                  height: 64.0,
                ),
                buildLoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginTitle() {
    return Column(
      children: [
        const Icon(
          Icons.account_balance_wallet_outlined,
          size: 75,
          color: AppColors.primary,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          "Send Money App",
          style: Theme.of(context).textTheme.headlineLarge,
        )
      ],
    );
  }

  Widget buildLoginForm() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person),
          ),
          validator: (value) => value!.isEmpty ? 'Please enter username' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) => value!.isEmpty ? 'Please enter password' : null,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AuthCubit>().login(
                    _usernameController.text,
                    _passwordController.text,
                  );
            }
          },
          child: const Text('Login'),
        ),
      ],
    );
  }
}
