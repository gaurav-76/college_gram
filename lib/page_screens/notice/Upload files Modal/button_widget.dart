import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ButtonTheme(
        //minWidth: 100.0,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            //primary: Color(0xFF54b435),
            primary: Color.fromRGBO(41, 49, 48, 1),
            minimumSize: Size.fromHeight(50),
          ),
          child: buildContent(),
          onPressed: onClicked,
        ),
      );

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ],
      );
}
