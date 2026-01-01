import 'dart:convert';

import 'package:quotes_app_bloc/src/feature/quotes/model/quote_model.dart';
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
}
