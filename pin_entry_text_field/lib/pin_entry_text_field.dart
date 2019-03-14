library pin_entry_text_field;

import 'package:flutter/material.dart';

class PinEntryTextField extends StatefulWidget {
  final int fields;
  final onSubmit;
  final fieldWidth;
  final fontSize;
  final isTextObscure;
  final inputStyle;
  final inputDecoration;
  final autoClearOnSubmit;
  final String otp;

  PinEntryTextField({
    Key key,
    this.fields: 4,
    this.onSubmit,
    this.fieldWidth: 40.0,
    this.fontSize: 20.0,
    this.isTextObscure: false,
    this.inputStyle,
    this.inputDecoration,
    this.autoClearOnSubmit = true,
    this.otp = "",
  })
      : assert(fields > 0),
        super(key: key);

  @override
  State createState() {
    return PinEntryTextFieldState();
  }
}

class PinEntryTextFieldState extends State<PinEntryTextField> {
  List<String> _pin;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();
    _pin = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
  }

  @override
  void dispose() {
//    _focusNodes.forEach((FocusNode f) => f.dispose());
    _textControllers.forEach((TextEditingController t) => t.dispose());
    super.dispose();
  }

  void clearTextFields() {
    FocusScope.of(context).requestFocus(_focusNodes[0]);
    _textControllers.forEach(
            (TextEditingController tEditController) => tEditController.clear());
    _pin.clear();
  }

  Widget buildTextField(int i, BuildContext context) {
    if(_focusNodes[i] == null) _focusNodes[i] = FocusNode();
    _textControllers[i] = TextEditingController();

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: widget.inputStyle,
        decoration: widget.inputDecoration,
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        onChanged: (str) {
          if (str.isEmpty) {
            _pin[i] = str;
            if (i != 0) {
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            }
          } else {
            _pin[i] = str;
            if (i + 1 != widget.fields) {
              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            } else {
              widget.onSubmit(_pin.join());
              if (widget.autoClearOnSubmit) {
                clearTextFields();
              } else {
                FocusScope.of(context).requestFocus(new FocusNode());
              }
            }
          }
        },
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    if (widget.otp != null && widget.otp.isNotEmpty) {
      List<String> chars = widget.otp.split("");
      for (var i = 0; i < chars.length; i++) {
        _textControllers[i].text = chars[i];
      }
    } else {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: textFields);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: generateTextFields(context),
    );
  }
}
