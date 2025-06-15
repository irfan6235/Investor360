import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style/colors.dart';
import '../style/decoration.dart';
import '../style/text_style.dart';


class ButtonBody extends StatelessWidget {
  ButtonBody({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecoration(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.btnDecoration(NsdlInvestor360Colors.btnColorLightGrey),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyUpiTextSize extends StatelessWidget {
  ButtonBodyUpiTextSize({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.btnDecorationwithRadius(Colors.black),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.only(top: 10,bottom: 10),
          child: Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
            textScaleFactor: 0.9,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyUpi extends StatelessWidget {
  ButtonBodyUpi({required this.labelText,this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.btnDecorationwithRadius(Colors.black),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.only(top: 16,bottom: 16),
          child: Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}


class ButtonBodyOutlinedTextSize extends StatelessWidget {
  ButtonBodyOutlinedTextSize({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.primaryBorderDecoration(6),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.only(top: 15,bottom: 15),
          child: Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
            textScaleFactor: 0.9,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyOutlined extends StatelessWidget {
  ButtonBodyOutlined({this.labelText, this.onPressed,this.isFittedBox, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;
  bool? isFittedBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.primaryBorderDecoration(6),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.all(14),
          child: isFittedBox ?? false ? FittedBox(
            child: Text(
              labelText!,
              style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
              textAlign: TextAlign.center,
            ),
          ) :  Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class CardManagePopup extends StatelessWidget {
  CardManagePopup(
      {Key? key,
      this.labelText,
      this.onPressed,
      this.isDisable,
      this.textBlack})
      : super(key: key);

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(
              NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.primaryBorderDecoration(4),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          labelText!,
          style: (textBlack == true)
              ? NsdlInvestor360Textstyle.btnTextStylePrimary
              : NsdlInvestor360Textstyle.btnCardTextStyle,
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyApplication extends StatelessWidget {
  ButtonBodyApplication({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.primaryBorderDecoration(6),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.only(right: 4,left:1,top:8,bottom: 8),
          child: Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle1,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}




class ButtonBodyUpiTextMaxSize extends StatelessWidget {
  ButtonBodyUpiTextMaxSize({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.btnDecorationwithRadius(Colors.black),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.all(13),
          child: Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
            textScaleFactor: 0.78,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyOutlinedDialog extends StatelessWidget {
  ButtonBodyOutlinedDialog({
    this.labelText,
    this.onPressed,
    this.isDisable,
    this.textBlack,
    this.isTextFitted = false,
  });

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;
  bool isTextFitted;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(
              NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.primaryBorderDecoration(6),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.all(0),
          child: isTextFitted
              ? FittedBox(
                  child: Text(
                    labelText!,
                    style: (textBlack == true)
                        ? NsdlInvestor360Textstyle.btnTextStylePrimary
                        : NsdlInvestor360Textstyle.btnTextStyle,
                    textAlign: TextAlign.center,
                    textScaleFactor: 0.9,
                    maxLines: 1,
                  ),
                )
              : Text(
                  labelText!,
                  style: (textBlack == true)
                      ? NsdlInvestor360Textstyle.btnTextStylePrimary
                      : NsdlInvestor360Textstyle.btnTextStyle,
                  textAlign: TextAlign.center,
                  textScaleFactor: 0.9,
                  maxLines: 1,
                ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ChipButton extends StatelessWidget {
  String text;
  VoidCallback onTap;

  ChipButton({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(10, 28),
            elevation: 0,
            backgroundColor: NsdlInvestor360Colors.lightGrey4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0))),
        child: Text(text,
            style: TextStyle(
                fontSize: 10.0,
                fontFamily: GoogleFonts.lato().fontFamily,
                color: NsdlInvestor360Colors.textblack,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w900)));
  }
}

class ButtonBodyUpiTextSizeMin extends StatelessWidget {
  ButtonBodyUpiTextSizeMin({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.btnDecorationwithRadius(Colors.black),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            labelText!,
            style: (textBlack == true) ? NsdlInvestor360Textstyle.btnTextStylePrimary : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
            textScaleFactor: 0.8,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyLongTextUpi extends StatelessWidget {
  ButtonBodyLongTextUpi(
      {required this.labelText,
      this.onPressed,
      this.isDisable,
      this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(
              NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.primaryBorderDecoration(6),

      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Text(
            labelText!,
            style: (textBlack == true)
                ? NsdlInvestor360Textstyle.btnTextStylePrimary
                : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class CardButtonBodyUpi extends StatelessWidget {
  CardButtonBodyUpi(
      {required this.labelText,
        this.onPressed,
        this.isDisable,
        this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true)
          ? NsdlInvestor360Decorations.btnDecorationwithRadius(
          NsdlInvestor360Colors.btnDisable)
          : NsdlInvestor360Decorations.btnDecorationwithRadius(Colors.black),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          // padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: Text(
            labelText!,
            style: (textBlack == true)
                ? NsdlInvestor360Textstyle.btnTextStylePrimary
                : NsdlInvestor360Textstyle.btnTextStyle,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

/*
class ButtonBodyShadow extends StatelessWidget {
  ButtonBodyShadow(
      {this.labelText,
      this.onPressed,
      this.isDisable,
      this.textBlack,
      this.color = BharatNXTColors.btnColor,
      this.disableColor = BharatNXTColors.btnDisable});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;
  final Color color;
  final Color disableColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(3),
      decoration: (isDisable == true) ? BharatNXTDecoration.btnDecoration(disableColor) : BharatNXTDecoration.btnDecorationShadow(color),
      child: MaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            labelText!,
            style: (textBlack == true) ? BharatNXTTextstyle.btnTextStylePrimary : BharatNXTTextstyle.btnTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyBorder extends StatelessWidget {
  ButtonBodyBorder({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = true;
  bool? textBlack = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BharatNXTDecoration.blackBorderDecoration(10),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          labelText!,
          style: BharatNXTTextstyle.btnTextStylePrimary,
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class ButtonBodyCommSoon extends StatelessWidget {
  ButtonBodyCommSoon({this.labelText, this.onPressed, this.isDisable, this.textBlack});

  final String? labelText;
  final void Function()? onPressed;
  bool? isDisable = false;
  bool? textBlack = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BharatNXTDecoration.btnDecoration(BharatNXTColors.btnDisable),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        child: Text(
          labelText!,
          style: BharatNXTTextstyle.secondaryBtnText,
          textAlign: TextAlign.center,
        ),
        onPressed: onPressed,
      ),
    );
  }
}


class CustomButton extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? fontSize;
  final Color? textColor;
  final Color? buttonColor;

  const CustomButton(
      {required this.buttonText,
        required this.onTap,
        this.buttonWidth,
        this.buttonHeight,
        this.fontSize,
        this.textColor,
        this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonWidth ?? 200,
        padding: EdgeInsets.symmetric(vertical: 13, horizontal: 7),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BharatNXTColors.btnColor, width: 1.7),
            color: buttonColor ?? BharatNXTColors.btnColor),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: fontSize ?? 15,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  final String buttonText;
  final Function() onTap;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? fontSize;
  final Color? textColor;
  final Color? buttonColor;

  const CustomButtonWithIcon(
      {required this.buttonText,
        required this.onTap,
        this.buttonWidth,
        this.buttonHeight,
        this.fontSize,
        this.textColor,
        this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonWidth ?? 170,
        height: 40,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BharatNXTColors.btnColor, width: 1.7),
            color: buttonColor ?? BharatNXTColors.btnColor),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: 5,),
              Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: fontSize ?? 13,
                    fontWeight: FontWeight.w500,
                    color: textColor ?? Colors.white),
              ),
              SizedBox(width: 5,),
              Image.asset(
                'resources/assets/images/gen_challan.png',
                height: 13,
                width: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
