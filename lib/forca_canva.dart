import 'package:flutter/material.dart';

class ForcaPainter extends CustomPainter {
  final int erroCount;

  ForcaPainter(this.erroCount);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Desenha a forca
    canvas.drawLine(
      Offset(40, size.height - 20),
      Offset(size.width - 40, size.height - 20),
      paint,
    );
    canvas.drawLine(
      Offset(40, size.height - 20),
      const Offset(40, 20),
      paint,
    );
    canvas.drawLine(
      const Offset(40, 20),
      Offset(size.width / 2, 20),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2, 20),
      Offset(size.width / 2, size.height * 0.2),
      paint,
    );

    if (erroCount > 0) {
      // Desenha a cabeça
      canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.3),
        20,
        paint,
      );
    }

    if (erroCount > 1) {
      // Desenha o corpo
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.3 + 20),
        Offset(size.width / 2, size.height * 0.6),
        paint,
      );
    }

    if (erroCount > 2) {
      // Desenha o braço esquerdo
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.4),
        Offset(size.width / 2 - 30, size.height * 0.45),
        paint,
      );
    }

    if (erroCount > 3) {
      // Desenha o braço direito
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.4),
        Offset(size.width / 2 + 30, size.height * 0.45),
        paint,
      );
    }

    if (erroCount > 4) {
      // Desenha a perna esquerda
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.6),
        Offset(size.width / 2 - 30, size.height * 0.75),
        paint,
      );
    }

    if (erroCount > 5) {
      // Desenha a perna direita
      canvas.drawLine(
        Offset(size.width / 2, size.height * 0.6),
        Offset(size.width / 2 + 30, size.height * 0.75),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
