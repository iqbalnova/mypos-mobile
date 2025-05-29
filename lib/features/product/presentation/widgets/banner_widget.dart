import 'package:flutter/material.dart';
import '../../../core/common/data_constant.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final PageController _promotionController = PageController();
  int _currentPromoPage = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), _startAutoScroll);
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_promotionController.hasClients) {
        final nextPage = (_currentPromoPage + 1) % promotions.length;
        _promotionController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _promotionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Highlight',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Row(
                children: List.generate(
                  promotions.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPromoPage == index
                              ? Theme.of(context).colorScheme.onSurface
                              : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _promotionController,
            itemCount: promotions.length,
            onPageChanged: (index) {
              setState(() {
                _currentPromoPage = index;
              });
            },
            itemBuilder: (context, index) {
              final promo = promotions[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(promo['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
