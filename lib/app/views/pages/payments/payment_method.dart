import 'package:flutter/material.dart';

// Payment Method model
class PaymentMethod {
  final String name;
  final String subtitle;
  final String pngAsset;
  final IconData icon;
  final Color iconBackgroundColor;
  
  PaymentMethod({
    required this.name,
    required this.subtitle,
    required this.pngAsset,
    required this.icon,
    required this.iconBackgroundColor,
  });
}

// List of payment methods matching the design
final List<PaymentMethod> paymentMethods = [
  PaymentMethod(
    name: "ABA PAY",
    subtitle: "Tap to pay with ABA Mobile",
    pngAsset: "assets/icons/aba-logo.png",
    icon: Icons.account_balance,
    iconBackgroundColor: Color(0xFF0077BE),
  ),
  PaymentMethod(
    name: "Credit / Debit Card",
    subtitle: "Visa, Mastercard, UnionPay, JCB",
    pngAsset: "assets/icons/visa-mastercard-logo.png",
    icon: Icons.credit_card,
    iconBackgroundColor: Color(0xFF1E88E5),
  ),
  PaymentMethod(
    name: "Wing Bank & KHQR",
    subtitle: "Tap to pay with Wing Bank or Scan KHQR",
    pngAsset: "assets/icons/wing-logo.png",
    icon: Icons.account_balance_wallet,
    iconBackgroundColor: Color(0xFF8BC34A),
  ),
  
  PaymentMethod(
    name: "ACLEDA Mobile",
    subtitle: "Tap to pay with ACLEDA Mobile",
    pngAsset: "assets/icons/acleda-logo.png",
    icon: Icons.account_balance,
    iconBackgroundColor: Color(0xFFFFB300),
  ),
  
];

class PaymentMethodPage extends StatelessWidget {
  final PaymentMethod? selected;
  const PaymentMethodPage({Key? key, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3A59), // Dark blue background
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3A59),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Payment Method',
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Online Payment Option',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: paymentMethods.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                final isSelected = selected?.name == method.name;
                
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, method);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A4A6B), // Slightly lighter blue
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected 
                          ? Border.all(color: const Color(0xFF5669FF), width: 2)
                          : null,
                    ),
                    child: Row(
                      children: [
                        // Payment method icon/logo
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: method.iconBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _buildPaymentIcon(method),
                        ),
                        const SizedBox(width: 16),
                        // Payment method details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                method.subtitle,
                                style: const TextStyle(
                                  color: Color(0xFFB0BEC5),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Selection indicator
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF5669FF),
                            size: 24,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom indicator (like in the image)
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: Container(
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentIcon(PaymentMethod method) {
    // Create custom icons for each payment method based on the design
    Widget iconWidget;
    
    switch (method.name) {
      case "ABA PAY":
        iconWidget = Container(
          padding: const EdgeInsets.all(8),
          child: const Text(
            'ABA\nPAY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      case "Credit / Debit Card":
        iconWidget = const Icon(
          Icons.credit_card,
          color: Colors.white,
          size: 24,
        );
        break;
      case "Wing Bank & KHQR":
        iconWidget = Container(
          padding: const EdgeInsets.all(8),
          child: const Text(
            'Wing\nBank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 7,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      case "TrueMoney Wallet":
        iconWidget = Container(
          padding: const EdgeInsets.all(8),
          child: const Text(
            'W',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      case "ACLEDA Mobile":
        iconWidget = Container(
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.trending_up,
            color: Colors.white,
            size: 24,
          ),
        );
        break;
      case "Phillip Bank":
        iconWidget = Container(
          padding: const EdgeInsets.all(6),
          child: const Text(
            'P',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
            textAlign: TextAlign.center,
          ),
        );
        break;
      default:
        iconWidget = Icon(
          method.icon,
          color: Colors.white,
          size: 24,
        );
    }

    // Try to load the image asset first, fallback to custom icon if it fails
    return Image.asset(
      method.pngAsset,
      width: 32,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to custom icon if image fails to load
        return iconWidget;
      },
    );
  }
}