import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../style/text_style.dart';


class InputTextFieldMobileNumber extends StatelessWidget {
  InputTextFieldMobileNumber({
    this.controller,
    this.prefixIconUrl,
    this.labelText,
    this.hintText,
    this.maxLength,
    this.keyBoardType = TextInputType.text,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.obsecure = false,
    this.suffixWidget,
    this.autovalidate = false,
    this.enabled = true,
    this.inputFormatList,
    this.validator,
  });

  final TextEditingController? controller;
  final String? prefixIconUrl;
  final String? labelText;
  final String? hintText;
  final int? maxLength;
  final TextInputType? keyBoardType;
  void Function(String?)? onChanged;
  String Function(String?)? validator;
  final bool? readOnly;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final bool? obsecure;
  final Widget? suffixWidget;
  final bool? autovalidate;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatList;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        enabled: enabled,
        validator: validator,
        controller: controller,
        maxLength: maxLength,
        keyboardType: keyBoardType,
        onChanged: onChanged,
        readOnly: readOnly!,
        textCapitalization: textCapitalization!,
        maxLines: maxLines,
        obscureText: obsecure!,
        obscuringCharacter: "*",
        decoration: InputDecoration(
            hintStyle: NsdlInvestor360Textstyle.text_14grey,
            contentPadding: EdgeInsets.all(12),
            // prefixIcon: Padding(
            //   padding: EdgeInsets.only(left: 5, right: 13, top: 15),
            //   child: Text(
            //     "+91 ",
            //     style: BharatNXTTextstyle.text_14grey,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            suffixIcon: suffixWidget,
            counterText: "",
            labelText: labelText,
            hintText: hintText,
            labelStyle: NsdlInvestor360Textstyle.text_14grey,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: Colors.grey[700]!,
              ),
            ),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[700]!,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
        inputFormatters: inputFormatList,
      ),
    );
  }
}