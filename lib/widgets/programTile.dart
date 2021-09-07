import 'package:flutter/material.dart';
import 'package:myfitnessfire/models/new_program_model.dart';
import 'package:myfitnessfire/models/programs_model.dart';

class ProgramTile{
  Widget programTile(size, String url, NewProgramModel programModel){
    return GridTile(
      child: Container(
        width: size.width,
        height: 150,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: ClipRRect(
          child: GridTile(
            footer: Container(
              //height: 50,
              color: Colors.black.withOpacity(0.6),
              child: ListTile(
                title: Text(
                  programModel.programName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),subtitle: Text(
                  programModel.sellerName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                trailing: Text(
                  programModel.programDuration + " Days",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: Image.network(
              url,
              fit: BoxFit.cover,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}