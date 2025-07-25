import 'package:event_booking_app/app/views/pages/ticketpass/ticket_pass_detail.dart';
import 'package:flutter/material.dart';

class TicketPass extends StatelessWidget {
  const TicketPass({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Generate or fetch ticket number (hardcoded here as example)
        const ticketNumber = 'VIP-2024-000123';
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketPassDetail(ticketNumber: ticketNumber),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipPath(
          clipper: TicketClipper(),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF5669FF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Main content
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      // Left side - Event details
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'May Event September 2024 - VIP Ticket ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Location: Koh Pich Cityhall',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Start At: 15 May 2024 @ 18:00',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Perforation line
                      Container(
                        width: 2,
                        height: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: CustomPaint(
                          painter: DashedLinePainter(),
                        ),
                      ),
                      // Right side - VIP section
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            'Regular',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 8;
    double notchRadius = 12;
    double notchPosition = size.width * 0.72; // Position of the notch

    // Start from top-left with rounded corner
    path.moveTo(radius, 0);
    path.lineTo(notchPosition - notchRadius, 0);

    // Top notch (semicircle)
    path.arcToPoint(
      Offset(notchPosition + notchRadius, 0),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Continue to top-right with rounded corner
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
    );

    // Right side to bottom notch
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: Radius.circular(radius),
    );

    // Bottom side with notch
    path.lineTo(notchPosition + notchRadius, size.height);

    // Bottom notch (semicircle)
    path.arcToPoint(
      Offset(notchPosition - notchRadius, size.height),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Continue to bottom-left
    path.lineTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: Radius.circular(radius),
    );

    // Left side
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashHeight = 4;
    double dashSpace = 4;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(1, startY),
        Offset(1, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
