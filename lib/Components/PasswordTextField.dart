import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_course_design/Components/DefaultTextField.dart';

class _PasswordTextFieldBuild extends State<PasswordTextField> {
  bool displayText = true;
  final GlobalKey _formKey = GlobalKey<FormState>();
  String? text;
  // bool isErr = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: TextFormField(
          initialValue: text,
          obscureText: displayText,
          onTap: widget.onTap,
          onChanged: (newText) {
            widget.onChange.call(newText);
            text = newText;
          },
          onSaved: (newText) {
            text = newText!;
          },
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            labelText: widget.labelText,
            // errorText: widget.errorText,
            suffixIcon: IconButton(
              icon: Icon(
                displayText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  displayText = !displayText;
                });
              },
            ),
          ),
          validator: widget.validator,
        ));
  }

  _PasswordTextFieldBuild() : super();
}

class PasswordTextField extends StatefulWidget {
  String? labelText;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  void Function(String?) onChange;
  void Function()? onTap;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PasswordTextFieldBuild();
  }

  PasswordTextField(
      {super.key,
      required this.onChange,
      this.labelText,
      this.onTap,
      this.validator,
      this.inputFormatters});
}
