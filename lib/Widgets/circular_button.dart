import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double size;
  final double radius;
  final Color iconColor;
  final Color backGroundColor;

  const CircularButton(
      {this.onTap,
      this.icon,
      this.size,
      this.radius,
      this.iconColor,
      this.backGroundColor});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Container(
          height: radius != null ? radius : null,
          width: radius != null ? radius : null,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: backGroundColor != null
                  ? backGroundColor
                  : Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(
                radius != null ? radius : 50,
              )),
          child: Center(
            child: Icon(
              icon,
              size: size,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
