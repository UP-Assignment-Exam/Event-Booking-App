import 'package:event_booking_app/app/views/pages/payments/payment_method.dart';
import 'package:flutter/material.dart';
import 'payment_method.dart'; // make sure this import path is correct relative to your project

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  PaymentMethod? selectedMethod; // for selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A43EC),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF5669FF),
              borderRadius: BorderRadius.circular(28),
            ),
            width: double.infinity,
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.music_note, color: Colors.white, size: 70),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'JULY 20 | Local Concert',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Valid until 21/07/2025',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '\$10.00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            alignment: Alignment.topLeft,
            child: const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              color: const Color(0xFF5669FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: selectedMethod?.iconBackgroundColor ??
                          Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedMethod != null
                        ? _buildSelectedMethodIcon(selectedMethod!)
                        : Icon(
                            Icons.payment,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                  title: Text(
                    selectedMethod?.name ?? 'Select Payment Method',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.white, size: 34),
                  onTap: () async {
                    try {
                      // Navigate and await for payment selection result
                      final method = await Navigator.push<PaymentMethod>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PaymentMethodPage(selected: selectedMethod),
                        ),
                      );
                      if (method != null) {
                        setState(() {
                          selectedMethod = method;
                        });
                      }
                    } catch (e) {
                      print('Error navigating to payment method: $e');
                      // Show error snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error loading payment methods'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const Divider(height: 1, color: Colors.white24),
                ListTile(
                  leading: const Icon(Icons.card_giftcard,
                      color: Colors.white, size: 34),
                  title: const Text(
                    'Apply Promo Code',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: Colors.white, size: 34),
                  onTap: () {
                    // Implement promo code
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Promo code feature coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                const Text(
                  'USD ',
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
                const Text(
                  '\$10.40',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedMethod == null
                        ? Colors.grey
                        : const Color(0xFF5669FF),
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text(
                    'CONFIRM & PAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: selectedMethod == null
                      ? null // Disabled if no method
                      : () {
                          // Handle actual payment
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Payment processing...'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMethodIcon(PaymentMethod method) {
    // Create custom icons for the selected payment method
    Widget iconWidget;

    switch (method.name) {
      case "ABA PAY":
        iconWidget = const Text(
          'ABA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
        break;
      case "Credit / Debit Card":
        iconWidget = const Icon(
          Icons.credit_card,
          color: Colors.white,
          size: 18,
        );
        break;
      case "Wing Bank & KHQR":
        iconWidget = const Text(
          'Wing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
        break;
      case "TrueMoney Wallet":
        iconWidget = const Text(
          'W',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        );
        break;
      case "ACLEDA Mobile":
        iconWidget = const Icon(
          Icons.trending_up,
          color: Colors.white,
          size: 18,
        );
        break;
      case "Phillip Bank":
        iconWidget = const Text(
          'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
          textAlign: TextAlign.center,
        );
        break;
      default:
        iconWidget = Icon(
          method.icon,
          color: Colors.white,
          size: 18,
        );
    }

    return Image.asset(
      method.pngAsset,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return iconWidget;
      },
    );
  }
}
