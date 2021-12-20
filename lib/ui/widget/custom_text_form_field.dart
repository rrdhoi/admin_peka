import 'package:flutter/material.dart';

import '../../common/styles.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final String errorText;
  final bool obscureText;
  final TextEditingController controller;

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.errorText,
    this.obscureText = false,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _onError = false;

  @override
  Widget build(BuildContext context) {
    var listHintText = widget.hintText.split(' ');
    bool _isDescription = listHintText[1] == 'deskripsi';
    bool _isNote = listHintText[1] == 'catatan';
    bool _isGreeting = listHintText[1] == 'ucapan';

    return Container(
      height: _isDescription || _isNote || _isGreeting ? 149.0 : 45.0,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: kGreyBgColor,
        borderRadius: BorderRadius.circular(defaultRadiusTextField),
      ),
      child: TextFormField(
        obscureText: widget.obscureText,
        controller: widget.controller,
        maxLines: _isDescription || _isNote || _isGreeting ? 6 : 1,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: greyHintTextStyle,
          suffixIcon: _onError
              ? const Icon(
                  Icons.info,
                  color: Colors.redAccent,
                )
              : null,
          border: InputBorder.none,
          errorStyle: const TextStyle(
            height: 0,
            color: Colors.transparent,
          ),
        ),
        style: blackTextStyle.copyWith(fontWeight: regular, fontSize: 14.0),
        validator: (value) {
          if (value == null || value.isEmpty) {
            setState(() {
              _onError = true;
            });
            return widget.errorText;
          }
          setState(() {
            _onError = false;
          });
          return null;
        },
      ),
    );
  }
}
