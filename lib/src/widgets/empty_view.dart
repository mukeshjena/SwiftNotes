import 'package:SwiftNotes/src/res/assets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: Lottie.asset(AnimationAssets.empty),
        ),
        Text(
          'Things look empty here, Tap + to start',
          style: GoogleFonts.poppins(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
