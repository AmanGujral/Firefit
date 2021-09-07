import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ClipPainter extends CustomClipper<Path>{
  @override
 
   Path getClip(Size size) {
      var height = size.height;
    var width = size.width;
    var path = new Path();

    path.lineTo(0, size.height );
    path.lineTo(size.width , height);
    path.lineTo(size.width , 0);
  
     /// [Top Left corner]
    // var secondControlPoint =  Offset(0  ,0);
    // var secondEndPoint = Offset(width * .62  , height *.1);
    // path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);



     /// [Left Middle]
    // var fifthControlPoint =  Offset(width * .13  ,height * .35);
    // var fiftEndPoint = Offset(  width * .53, height *9.2);
    // path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy, fiftEndPoint.dx, fiftEndPoint.dy);


     /// [Bottom Left corner]
    var thirdControlPoint =  Offset(-200  ,height);
    var thirdEndPoint = Offset(width , height  );
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);

   

    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

  
}