import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Color(0xff686868),
  fontFamily: 'OpenSans',
  fontWeight: FontWeight.w700,
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
  fontSize: 16.0,
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFFffffff),
  borderRadius: BorderRadius.circular(0.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
