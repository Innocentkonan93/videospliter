import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:video_spliter/app/configs/app_colors.dart';

class PremiumSuccessView extends StatefulWidget {
  const PremiumSuccessView({super.key});

  @override
  State<PremiumSuccessView> createState() => _PremiumSuccessViewState();
}

class _PremiumSuccessViewState extends State<PremiumSuccessView> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.background,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Premium Icon
              Icon(
                Icons.workspace_premium_rounded,
                color: Colors.amber,
                size: 100,
              ),
              const SizedBox(height: 24),

              // Success Message
              Text(
                'Félicitations !'.tr,
                style: context.theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Vous avez débloqué Cutit Pro. Profitez d\'une expérience sans publicité et sans limite de temps et taille !'
                      .tr,
                  textAlign: TextAlign.center,
                  style: context.theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Continue Button
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Continuer'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          // Confetti Animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,

              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              createParticlePath: drawStar,
            ),
          ),
        ],
      ),
    );
  }

  /// A custom Path to paint stars for confetti.
  Path drawStar(Size size) {
    double vw = size.width / 2;
    double vh = size.height / 2;
    Path path = Path();
    path.moveTo(vw, 0);
    path.lineTo(vw * 1.3, vh * 0.7);
    path.lineTo(size.width, vh * 0.7);
    path.lineTo(vw * 1.5, vh * 1.2);
    path.lineTo(vw * 1.7, size.height);
    path.lineTo(vw, vh * 1.5);
    path.lineTo(vw * 0.3, size.height);
    path.lineTo(vw * 0.5, vh * 1.2);
    path.lineTo(0, vh * 0.7);
    path.lineTo(vw * 0.7, vh * 0.7);
    path.close();
    return path;
  }
}
