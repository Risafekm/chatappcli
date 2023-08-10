import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

containerDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.teal.shade300,
        ]),
  );
}

containerCardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.teal.shade300,
        ]),
  );
}

textInputDecoration(
    {required String hintText, required Icon prefixIcon, required suffixIcon}) {
  return InputDecoration(
    label: Text(
      hintText,
      style: const TextStyle(color: Colors.white),
    ),
    labelStyle: const TextStyle(color: Colors.white),
    // hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 192, 229, 230),
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
  );
}

textInputDecoration1({required String hintText, required Icon prefixIcon}) {
  return InputDecoration(
    label: Text(
      hintText,
      style: const TextStyle(color: Colors.white),
    ),
    labelStyle: const TextStyle(color: Colors.white),
    // hintText: hintText,
    prefixIcon: prefixIcon,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 192, 229, 230),
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
  );
}

formFieldStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}

headingCaptionStyle() {
  return GoogleFonts.lora(
      fontSize: 43,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(255, 236, 236, 236));
}

subHeadingCaption() {
  return GoogleFonts.lora(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: const Color.fromARGB(255, 255, 255, 255));
  // color: Color.fromARGB(255, 192, 229, 230));
}

elevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    elevation: 10,
    side: const BorderSide(
      width: 2,
      color: Color.fromARGB(31, 80, 64, 198),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
