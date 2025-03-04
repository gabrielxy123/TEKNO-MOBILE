import 'package:flutter/material.dart';

class CustomField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType textInputType;
  final double radius;

  const CustomField({super.key, required this.label, required this.controller, required this.isPassword, required this.textInputType, required this.radius,});

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool _obScureText = true;
  bool _isHovered = false;

 @override
  void initState() {
    super.initState();
    _obScureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() =>_isHovered = true),
      onExit: (_) => setState(() =>_isHovered = false),
      child: TextField(
        keyboardType: widget.textInputType,
        controller: widget.controller,
        obscureText: widget.isPassword ? _obScureText : false,
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(
              _obScureText ? Icons.visibility_off : Icons.visibility
            ), onPressed: () {
            setState(() {
              _obScureText = !_obScureText;
            });
          }, ) : null,        
        ),
      ),
    );
  }
}