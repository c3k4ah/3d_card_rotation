import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class CardView extends StatefulWidget {
  const CardView({super.key});

  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  // position initiale du container
  double x = 0;
  double y = 0;
  // definir une sensibilité pour la detection gestuelle
  double amplitude = 0.3;
  // definir une sensibilité pour le gyroscope
  double sensor = 0.2;

  @override
  void initState() {
    // ecouter les mouvements du smartphone et mettre a jour les valeurs de x et y
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        x += event.x * sensor;
        y -= event.y * sensor;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Transform(
            alignment: FractionalOffset.center,
            // appliquer la rotation sur le widget fils  (tealCard)
            transform: Matrix4.identity()
              ..rotateX(x)
              ..rotateY(y),
            child: GestureDetector(
              onPanUpdate: (details) {
                // ecoute les direction du doigt sur l'ecran et met a jour les valeurs de x et y
                if (y - details.delta.dx < 0) {
                  setState(() {
                    y = max(y - details.delta.dx / 100, -amplitude);
                  });
                } else {
                  setState(() {
                    y = min(y - details.delta.dx / 100, amplitude);
                  });
                }
                if (x + details.delta.dy < 0) {
                  setState(() {
                    x = max(x + details.delta.dy / 100, -amplitude);
                  });
                } else {
                  setState(() {
                    x = min(x + details.delta.dy / 100, amplitude);
                  });
                }
              },
              child: tealCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget tealCard() {
    return Container(
      height: 450,
      decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/card.png'),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              spreadRadius: 0,
              offset: Offset(y * 40, -x * 80),
            )
          ]),
    );
  }
}
