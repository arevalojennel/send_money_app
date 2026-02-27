import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:send_money_app/presentation/theme/app_colors.dart';
import '../cubit/send_money/send_money_cubit.dart';
import '../cubit/auth/auth_cubit.dart';

class SendMoneyScreen extends StatelessWidget {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SendMoneyScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logout();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendMoneyCubit, SendMoneyState>(
      listener: (context, state) {
        if (state is SendMoneySuccess) {
          _showBottomSheet(context, true, null);
        } else if (state is SendMoneyError) {
          _showBottomSheet(context, false, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Send Money'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₱',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    final amount = double.tryParse(value);
                    if (amount == null) {
                      return 'Please enter a valid number';
                    }
                    if (amount <= 0) {
                      return 'Amount must be greater than zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                BlocBuilder<SendMoneyCubit, SendMoneyState>(
                  builder: (context, state) {
                    if (state is SendMoneyLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final amount = double.parse(_amountController.text);
                          context.read<SendMoneyCubit>().submitAmount(amount);
                        }
                      },
                      child: const Text('Submit'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(
      BuildContext context, bool success, String? errorMessage) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? AppColors.primary : AppColors.error,
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              success ? 'Money sent successfully!' : errorMessage!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx); // close bottom sheet
                if (success) {
                  Navigator.pop(context); // go back to home
                } else {
                  context.read<SendMoneyCubit>().reset();
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
