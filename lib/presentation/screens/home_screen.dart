import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:send_money_app/constants/image_strings.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/home/home_cubit.dart';
import '../cubit/send_money/send_money_cubit.dart';
import '../cubit/transactions/transactions_cubit.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    context.read<AuthCubit>().logout();
    // Navigation will be handled by BlocListener below
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
        ),
        BlocListener<SendMoneyCubit, SendMoneyState>(
          listenWhen: (previous, current) => current is SendMoneySuccess,
          listener: (context, state) {
            context.read<TransactionsCubit>().loadTransactions();
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDashboardContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  // Main DashBoard
  Widget buildDashboardContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      // padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Subtle offset shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          // Softer, larger ambient shadow
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          buildIconShadow(),
          buildDashboardContent(context),
        ],
      ),
    );
  }

  Widget buildDashboardContent(BuildContext context) {
    return Column(
      children: [
        buildWalletBalance(),
        const Divider(
          color: AppColors.background,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildDashboardButtons(
                  () {
                    Navigator.pushNamed(context, '/send');
                  },
                  mSendBoxedIcon,
                  'Send Money',
                ),
                const VerticalDivider(
                  color: AppColors.background,
                  thickness: 1,
                  endIndent: 0,
                  indent: 0,
                ),
                buildDashboardButtons(
                  () {
                    Navigator.pushNamed(context, '/transactions');
                  },
                  mTransactionBoxedIcon,
                  'View Transactions',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIconShadow() {
    return Positioned(
      top: 0,
      right: 0,
      child: Opacity(
        opacity: 0.08,
        child: Icon(
          Icons.account_balance_wallet_outlined,
          size: 120,
          color: AppColors.background.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget buildWalletBalance() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wallet Balance: ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: AppColors.background,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return Text(
                          state.isBalanceHidden
                              ? '******'
                              : '₱${state.balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 30,
                            color: AppColors.background,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: Icon(
                            state.isBalanceHidden
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.background,
                          ),
                          onPressed: () => context
                              .read<HomeCubit>()
                              .toggleBalanceVisibility(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDashboardButtons(
    Function() onTap,
    String iconAsset,
    String title,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: SvgPicture.asset(iconAsset),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.background,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
