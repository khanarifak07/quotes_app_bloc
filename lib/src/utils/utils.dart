import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_app_bloc/src/model/quote_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  Utils._(); //prevents instance creation
  static late SharedPreferences _sharedPreferences;

  static final String _savedQuotes = 'savedQuotes';

  static Future<void> initSF() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  //save quotes
  static Future<void> saveQuotes(List<QuoteModel> quotes) async {
    //List<Model> --> List<String>
    List<String> quotesString = quotes
        .map((e) => jsonEncode(e.toJson()))
        .toList();
    await _sharedPreferences.setStringList(_savedQuotes, quotesString);
  }

  //
  static List<QuoteModel> getSavedQuotes() {
    List<String>? jsonString = _sharedPreferences.getStringList(_savedQuotes);
    if (jsonString == null) return [];
    //List<String> --> List<Model>
    return jsonString.map((e) => QuoteModel.formJson(jsonDecode(e))).toList();
  }

  //share quotes
  static void shareQuote(GlobalKey key) async {
    //wait till the frame is fully painted
    await WidgetsBinding.instance.endOfFrame;
    //find the widget to take a picture of by globalkey
    final boundry =
        key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    //take the screenshot of the widget
    final image = await boundry.toImage(pixelRatio: 3.0);
    //turn the image into pnyByte
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    //get the rawData form the image
    final pngByte = byteData!.buffer.asUint8List();
    //find the place to save the image
    final directory = await getTemporaryDirectory();
    //decide the filapath
    final filePath = '${directory.path}/quotes.png';
    //save the file
    final file = File(filePath);
    file.writeAsBytes(pngByte);
    //share the image
    SharePlus.instance.share(
      ShareParams(files: [XFile(filePath)], text: 'Check out this quote !!'),
    );
  }
}
