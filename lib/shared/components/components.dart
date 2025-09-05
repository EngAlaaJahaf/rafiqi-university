import 'package:flutter/material.dart';

Widget DefaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 10.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
    //<=-=-=-=-=-=-=-=--=-=-==-=-=-=>
//العناوين الرئيسية
    Widget HeaderText({required String text})=>
     Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    // color: Colors.grey[50],
    border: Border.all(
      color: Colors.blueAccent.withOpacity(0.3),
      width: 1.5,
    ),
    // gradient: LinearGradient(
    //   begin: Alignment.centerRight, // ✅ تدرج من اليمين
    //   end: Alignment.centerLeft,
      // colors: [Colors.blue[50]!, Colors.white],
    // ),
    boxShadow: [
      // BoxShadow(
      //   color: Colors.blueAccent.withOpacity(0.1),
      //   blurRadius: 8,
      //   offset: Offset(0, 2),
      // ),
    ],
  ),
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  alignment: Alignment.centerRight, // ✅ محاذاة المحتوى لليمين
  child: Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      // color: Colors.blue[900],
      fontFamily: 'Cairo', // خط عربي جميل
    ),
    textAlign: TextAlign.right,
    textDirection: TextDirection.rtl,
  ),
);


Widget containerCard({required String header, 
    String text ='',String text1 ='',
 String text4 = '' ,String footer = '', }){
return Container(
  decoration: BoxDecoration(
    // color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color.fromARGB(255, 15, 90, 218),
      width: 1.5,
    ),
    // boxShadow: [
    //   BoxShadow(
    //     // color: Colors.grey.withOpacity(0.2),
    //     blurRadius: 8,
    //     offset: Offset(0, 4),
    //   ),
    // ],
  ),
  padding: EdgeInsets.all(20),
  margin: EdgeInsets.all(16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.end, // ✅ محاذاة لليمين
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        header,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          // color: Colors.blue[900],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 15),
       Divider(color: const Color.fromARGB(255, 43, 53, 240), height: 1),
      SizedBox(height: 15),
      Text(
        text,
        style: TextStyle(
          fontSize: 16,
          // color: Colors.grey[800],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 10),
      Text(
        text1,
        style: TextStyle(
          fontSize: 16,
          // color: Colors.grey[800],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 10),
      Text(
        text4,
        style: TextStyle(
          fontSize: 16,
          // color: Colors.grey[800],
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      SizedBox(height: 15),
      Divider(color: const Color.fromARGB(255, 43, 53, 240), height: 1),
      SizedBox(height: 10),
      Text(
        footer,
        style: TextStyle(
          fontSize: 14,
          // color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
    ],
  ),
);
}



Widget cardCustom({required String header,required String body}){
return Card(
  elevation: 6,
  margin: EdgeInsets.all(16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    side: BorderSide(color: Colors.blueAccent, width: 1),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text(header, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(body),
      ],
    ),
  ),
);
}