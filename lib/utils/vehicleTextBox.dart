

 import 'package:flutter/material.dart';

vehicleNumberformTextBox(validator, focus, keyboardType, controller,
      labelText, hintText, maxLenght, inputformatter) {
    return TextFormField(
      inputFormatters: inputformatter,
      validator: validator,
      focusNode: focus,
      maxLength: maxLenght,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      decoration: InputDecoration(
          counterText: '',
          border: const OutlineInputBorder(),
          labelText: labelText,
          hintText: hintText),
    );
  }