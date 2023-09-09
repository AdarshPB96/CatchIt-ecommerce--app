import 'package:flutter/material.dart';

Container textFieldContainer({required String hintText}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.grey.withOpacity(0.4),
    ),
    child: TextField(
      decoration: InputDecoration(
          border: InputBorder.none,
          icon: const Icon(
            Icons.search,
          ),
          hintText: hintText),
    ),
  );
}

threeDTextbutton({required String text, Function()? onPress}) {
  return InkWell(
    onTap: onPress,
    child: Container(
      padding: const EdgeInsets.all(10), // Add padding to grow with the text
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
        color: Colors.grey,
        // backgroundBlendMode: BlendMode.color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(4, 4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
          // BoxShadow(
          //   color: Colors.white.withOpacity(0.5),
          //   offset: const Offset(-4, -4),
          //   blurRadius: 8,
          //   spreadRadius: 2,
          // ),
        ],
        // gradient: LinearGradient(
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        //   colors: [
        //     Colors.grey.shade300,
        //     Colors.grey.shade100,
        //   ],
        // ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
                fontSize: 17, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    ),
    
  );
}

Text homeHeadings({required String text}) {
  return Text(
    text,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  );
}
