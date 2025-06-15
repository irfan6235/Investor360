// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'colors.dart';


class NsdlInvestor360Decorations {
  NsdlInvestor360Decorations._();

  static BoxDecoration btnDecoration(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color,
        ],
      ),
    );
  }

  static BoxDecoration btnDecorationwithRadius(Color color) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(4.0),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color,
        ],
      ),
    );
  }

  static btnDecorationFlat(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        // ignore: prefer_const_literals_to_create_immutables
        colors: [
          Color(0xff4c5ac1),
          Color(0xff313C8E),
        ],
      ),
    );
  }

  static BoxDecoration blackBorderDecoration(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      // color: Colors.white,
      border: Border(
        top: BorderSide(width: 1.0, color: Colors.grey),
        left: BorderSide(width: 1.0, color: Colors.grey),
        right: BorderSide(width: 1.0, color: Colors.grey),
        bottom: BorderSide(width: 1.0, color: Colors.grey),
      ),
    );
  }

  static BoxDecoration blackBorderDecorationC(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.black,
      border: Border(
        top: BorderSide(width: 1.0, color: Colors.grey),
        left: BorderSide(width: 1.0, color: Colors.grey),
        right: BorderSide(width: 1.0, color: Colors.grey),
        bottom: BorderSide(width: 1.0, color: Colors.grey),
      ),
    );
  }

  static BoxDecoration blackBorderDecorationP(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      // color: Colors.white,
      border: Border(
        top: BorderSide(width: 1.0, color: Colors.grey),
        left: BorderSide(width: 1.0, color: Colors.grey),
        right: BorderSide(width: 1.0, color: Colors.grey),
        bottom: BorderSide(width: 1.0, color: Colors.grey),
      ),
    );
  }

  static BoxDecoration primaryBorderDecoration(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(120),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border(
        top: BorderSide(width: 2.5, color: NsdlInvestor360Colors.themeOrange),
        left: BorderSide(width: 2.5, color: NsdlInvestor360Colors.themeOrange),
        right: BorderSide(width: 2.5, color: NsdlInvestor360Colors.themeOrange),
        bottom: BorderSide(width: 2.5, color: NsdlInvestor360Colors.themeOrange),
      ),
    );
  }

  static BoxDecoration primaryCardSuccessDecoration(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      border: Border(
        top: BorderSide(width: 1.0, color: NsdlInvestor360Colors.themeOrange),
        left: BorderSide(width: 1.0, color: NsdlInvestor360Colors.themeOrange),
        right: BorderSide(width: 1.0, color: NsdlInvestor360Colors.themeOrange),
        bottom: BorderSide(width: 1.0, color: NsdlInvestor360Colors.themeOrange),
      ),
    );
  }

  static BoxDecoration blueBorderDecoration(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      color: Colors.white,
      border: Border(
        top: BorderSide(width: 1.5, color: Colors.blue),
        left: BorderSide(width: 1.5, color: Colors.blue),
        right: BorderSide(width: 1.5, color: Colors.blue),
        bottom: BorderSide(width: 1.5, color: Colors.blue),
      ),
    );
  }

  static InputDecoration datePickerDecoration(String lableText) {
    return InputDecoration(
      labelText: lableText,
      prefixIcon: Padding(
        padding: EdgeInsets.all(13),
        child: Image.asset(
          'resources/assets.images/calendar.png',
          width: 13.0,
          height: 18,
        ),
      ),
      labelStyle: TextStyle(fontSize: 15.0),
      contentPadding: EdgeInsets.all(12),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.grey,
          )),
    );
  }
}
