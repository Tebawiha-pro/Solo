import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Choose Plan', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Unlock Solo Pro',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your angry boss, unlimited roast, no limits',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 30),

            _buildCard(
              context: context,
              title: 'Weekly',
              subtitle: 'Try it out',
              price: '₹599',
              period: '/week',
              amountDollar: '\$5.99',
              features: ['Unlimited Voice Chat', 'Moe Howard Style Roasts', 'No Ads', 'Clear History'],
              buttonText: 'Get Weekly - ₹599',
              url: 'https://rzp.io/rzp/Ce8qIlnf',
              isPopular: false,
              isBestValue: false,
            ),

            const SizedBox(height: 16),

            _buildCard(
              context: context,
              title: 'Monthly',
              subtitle: 'Most Popular',
              price: '₹1,899',
              period: '/month',
              amountDollar: '\$18.99',
              features: ['Everything in Weekly', 'Priority Voice Quality', 'Save 20% Monthly', 'Share Chats'],
              buttonText: 'Get Monthly - ₹1,899',
              url: 'https://rzp.io/rzp/M0aFQQgz',
              isPopular: true,
              isBestValue: false,
            ),

            const SizedBox(height: 16),

            _buildCard(
              context: context,
              title: 'Yearly',
              subtitle: 'Best Value',
              price: '₹17,999',
              period: '/year',
              amountDollar: '\$179.99',
              features: ['Everything in Monthly', '2 Months FREE', 'Best Price Ever', 'Early Access Features'],
              buttonText: 'Get Yearly - ₹17,999',
              url: 'https://rzp.io/rzp/FENBJb7v',
              isPopular: false,
              isBestValue: true,
            ),

            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Use same email as your app login when paying. Pro will activate automatically.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required String amountDollar,
    required List<String> features,
    required String buttonText,
    required String url,
    required bool isPopular,
    required bool isBestValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isPopular ? const Color(0xFF0F0F0F) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPopular ? Colors.black : const Color(0xFFE5E7EB),
          width: isPopular ? 2 : 1,
        ),
        boxShadow: [
          if (isPopular)
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10)),
          if (!isPopular)
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        children: [
          if (isPopular)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                child: const Text('MOST POPULAR', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black)),
              ),
            ),
          if (isBestValue)
            Positioned(
              top: 0,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                ),
                child: const Text('BEST VALUE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: isPopular ? Colors.white : Colors.black)),
                        Text(subtitle, style: TextStyle(fontSize: 12, color: isPopular ? Colors.white60 : Colors.grey)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(price, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: isPopular ? Colors.white : Colors.black)),
                            Text(period, style: TextStyle(fontSize: 13, color: isPopular ? Colors.white60 : Colors.grey)),
                          ],
                        ),
                        Text(amountDollar, style: TextStyle(fontSize: 11, color: isPopular ? Colors.white38 : Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isPopular ? Colors.white : const Color(0xFF8B5CF6).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check, size: 12, color: isPopular ? Colors.black : const Color(0xFF8B5CF6)),
                          ),
                          const SizedBox(width: 10),
                          Text(f, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isPopular ? Colors.white70 : Colors.black87)),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      final uri = Uri.parse(url);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular ? Colors.white : Colors.black,
                      foregroundColor: isPopular ? Colors.black : Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
