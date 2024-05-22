import 'package:flutter/material.dart';

class HomePageProvider extends ChangeNotifier {
  bool isLoad = false;

  void onChangeLoad(bool isLoad) {
    this.isLoad = isLoad;
    notifyListeners();
  }

  double webProgress = 0;

  void onWebProgress(double webProgress) {
    this.webProgress = webProgress;
    notifyListeners();
  }

  List<Map> bookMarks = [];
  void addBookMark (Map bookMark){
    if(bookMarks == bookMark){

    }else{
      bookMarks.add(bookMark);
    }
    notifyListeners();
  }
  void deleteBookMark (index){
    bookMarks.removeAt(index);
    notifyListeners();
  }

  String? engine;
  void changeEngine (String value){
    engine = value;
    notifyListeners();
  }
}
