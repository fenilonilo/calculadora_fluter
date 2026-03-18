// calculator_view_model.dart
import 'package:flutter/material.dart';
import 'calculator_model.dart';

class CalculatorViewModel extends ChangeNotifier {
  String _expression = "0";
  String _previewResult = "";

  String get expression => _expression;
  String get previewResult => _previewResult;

  void addToken(String token) {
    // Se for o primeiro caractere e for um sinal de menos, é um número negativo
    if (_expression == "0") {
      if (token == "-") {
        _expression = "-";
        notifyListeners();
        return;
      } else if (RegExp(r'[0-9(]').hasMatch(token)) {
        _expression = "";
      }
    }

    // Lógica de espaçamento para o split(" ") funcionar no Model
    if (['+', 'x', '÷', '(', ')'].contains(token)) {
      _expression += " $token ";
    } else if (token == "-") {
      // Verifica se o '-' é subtração ou sinal de número negativo
      // Se o último caractere for um operador ou parêntese aberto, o '-' não tem espaços (é sinal)
      if (_expression.endsWith(" ") || _expression.isEmpty || _expression.endsWith("(")) {
        _expression += "-";
      } else {
        _expression += " - ";
      }
    } else {
      _expression += token;
    }

    _calculatePreview();
    notifyListeners();
  }

  void delete() {
    _expression = Regras.validarDelet(_expression);
    _calculatePreview();
    notifyListeners();
  }

  void clear() {
    _expression = "0";
    _previewResult = "";
    notifyListeners();
  }

  void calculate() {
    if (_expression.isNotEmpty && _expression != "0") {
      Calculadora calc = Calculadora(_expression);
      _expression = calc.resultado;
      _previewResult = "";
      notifyListeners();
    }
  }

  void _calculatePreview() {
    if (_expression.isNotEmpty && _expression != "0") {
      Calculadora calc = Calculadora(_expression);
      _previewResult = calc.resultado;
    } else {
      _previewResult = "";
    }
  }
}