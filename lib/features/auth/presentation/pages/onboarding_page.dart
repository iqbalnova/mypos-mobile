import 'package:flutter/material.dart';

import '../../../core/common/styles.dart';
import '../../../core/router/app_routes.dart';
import '../widgets/animated_arrow_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: Image.asset('assets/images/onboard.jpg', fit: BoxFit.cover),
          ),

          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(255, 255, 255, 0.9),
                  Color.fromRGBO(188, 202, 244, 0.7),
                  Color.fromRGBO(129, 156, 239, 0.5),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text.rich(
                        TextSpan(
                          text: 'Kasir Pintar, Bisnis Lancar! Yuk, Coba ',
                          style: AppTextStyle.headline2(
                            color: AppColors.darkGrey,
                          ),
                          children: [
                            TextSpan(
                              text: 'MASPOS',
                              style: AppTextStyle.headline2(
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  AnimatedArrowButton(
                    text: 'Yuk mulai cobain',
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
