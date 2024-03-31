import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';

class ABTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? validationMsg,
      titleText,
      hintText,
      labelText,
      helperText,
      prefixText,
      suffixText;
  final Widget? prefix, suffix;
  final int? maxLength;
  final int? minLength;
  final Function()? onTap;
  final bool? isPassword, countryCodeEnabled, isEnabled;
  final bool? isSimpleField;
  final BorderRadius? borderRadius;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Function(String text)? onFieldSubmitted;
  final Function(String? val)? validator;
  final AutovalidateMode? autoValidator;
  final Function(String? val)? onChange;
  final bool isCustomInput;
  final bool enableInteractiveSelection;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? customInputFormatters;

  const ABTextInput(
      {Key? key,
      this.controller,
      this.validationMsg,
      this.validator,
      this.autoValidator,
      this.helperText,
      this.suffixText,
      this.prefixText,
      this.prefix,
      this.labelText,
      this.titleText,
      this.hintText,
      this.suffix,
      this.textInputType,
      this.isPassword,
      this.maxLength,
      this.onTap,
      this.countryCodeEnabled,
      this.borderRadius,
      this.isSimpleField,
      this.textInputAction,
      this.onFieldSubmitted,
      this.focusNode,
      this.isCustomInput = false,
      this.enableInteractiveSelection = true,
      this.textCapitalization,
      this.onChange,
      this.minLength,
      this.customInputFormatters,
      this.isEnabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
              left: MediaQuery.of(context).size.width * 0.072222,
              right: MediaQuery.of(context).size.width * 0.075
          ),
          alignment: Alignment.topLeft,
          child: Text(titleText!,
            style: TextStyle(
                fontFamily: Strings.robotoRegular,
                letterSpacing: 0.01,
                fontSize: 15.0,
                color:  Colors.grey),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 5),
          child: TextFormField(
            keyboardType: textInputType ?? TextInputType.text,
            inputFormatters: isCustomInput
                ? [FilteringTextInputFormatter.digitsOnly]
                : customInputFormatters,
            validator: (val) => validator != null ? validator!(val) : null,
            maxLength: maxLength,
            readOnly: isEnabled ?? false,
            obscureText: isPassword ?? false,
            controller: controller,
            onTap: onTap,
            decoration: InputDecoration(
              helperText: helperText,
              errorStyle: const TextStyle(fontSize: 12, height: 1.0),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xff515151),
                ),
                borderRadius: BorderRadius.circular(9),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: Strings.robotoMedium,
                fontSize: 14,
                color: const Color(0xff9aa4b0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              suffixIcon: suffix,
            ),
            autovalidateMode: autoValidator ?? AutovalidateMode.disabled,
            style: TextStyle(
              color: ThemeColor.bodyGrey,
              fontSize: 16.0,
              fontFamily: Strings.robotoMedium,
            ),
          ),
        ),
      ],
    );
  }
}
