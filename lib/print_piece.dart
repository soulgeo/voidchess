import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrintPiece extends StatelessWidget {
  final String piece;    
  final String color;    
  final double? width;
  final double? height;
  final BoxFit? fit;

  const PrintPiece({
    super.key,
    required this.piece,
    required this.color,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  // Helper method to build the asset path
  String _getAssetPath() {
    // Map piece names to Lichess file naming convention
    final pieceMap = {
      'king': 'K',
      'queen': 'Q',
      'rook': 'R',
      'bishop': 'B',
      'knight': 'N',
      'pawn': 'P',
    };

    // Map color to Lichess prefix
    final colorPrefix = color.toLowerCase() == 'white' ? 'w' : 'b';
    
    // Get the piece letter, default to 'P' if not found
    final pieceLetter = pieceMap[piece.toLowerCase()] ?? 'P';
    
    // Build the path: assets/pieces/paper/wP.svg
    return '../assets/pieces/papercut/$colorPrefix$pieceLetter.svg';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _getAssetPath(),
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }
}