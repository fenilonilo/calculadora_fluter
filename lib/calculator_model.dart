// calculator_model.dart

class Regras {
  static bool isNumero(String exp) {
    if (exp.isEmpty) return false;
    List<String> frag = exp.trim().split(RegExp(r'\s+'));
    String ult = frag.last;
    return RegExp(r'^-?\d+(\.\d+)?$').hasMatch(ult);
  }

  static String validarDelet(String exp) {
    if (exp.isEmpty || exp == "0") return "0";
    if (exp.endsWith(" ")) {
      exp = exp.substring(0, exp.length - 1);
    }
    String novo = exp.substring(0, exp.length - 1);
    return novo.isEmpty ? "0" : novo;
  }
}

class Calculadora {
  String expressaoNumericaDesordenada;
  String _resultadoExpressao = "";
  List<String> listaOperadores = [];
  List<double> listaNumeros = [];

  Calculadora(this.expressaoNumericaDesordenada) {
    // Padroniza os símbolos para o processamento interno
    expressaoNumericaDesordenada = expressaoNumericaDesordenada
        .replaceAll('x', '*')
        .replaceAll('÷', '/');
    _resumeExpressao();
    _resolveExpressao();
  }

  String get resultado => _resultadoExpressao;

  void _resumeExpressao() {
    List<String> fragmentada = expressaoNumericaDesordenada.trim().split(RegExp(r'\s+'));

    for (int i = 0; i < fragmentada.length; i++) {
      String op = fragmentada[i];
      if (op.isEmpty) continue;

      if (_isNumero(op)) {
        // Se for número (positivo ou negativo), vai direto para a pilha de números
        listaNumeros.add(double.parse(op));
      } else if (op == "(") {
        listaOperadores.add(op);
      } else if (op == ")") {
        // Resolve tudo o que está dentro do parêntese
        while (listaOperadores.isNotEmpty && listaOperadores.last != "(") {
          _resolverOperacaoSimples();
        }
        // Remove o parêntese de abertura da pilha
        if (listaOperadores.isNotEmpty && listaOperadores.last == "(") {
          listaOperadores.removeLast();
        }
      } else if (op == "+" || op == "-" || op == "*" || op == "/") {
        // Lógica Profissional de Precedência:
        // Antes de adicionar um operador novo, resolve os operadores anteriores
        // que têm precedência maior ou igual.
        while (listaOperadores.isNotEmpty &&
            _obterPrecedencia(listaOperadores.last) >= _obterPrecedencia(op)) {
          _resolverOperacaoSimples();
        }
        listaOperadores.add(op);
      }
    }
  }

  // Função que define a hierarquia da matemática
  int _obterPrecedencia(String operador) {
    if (operador == "*" || operador == "/") return 2; // Maior prioridade
    if (operador == "+" || operador == "-") return 1; // Menor prioridade
    return 0; // Parênteses ou desconhecido
  }

  void _resolverOperacaoSimples() {
    // Evita crash se a expressão estiver incompleta (ex: "8 + ")
    if (listaOperadores.isEmpty || listaNumeros.length < 2) return;

    String op = listaOperadores.removeLast();
    double numeroDireita = listaNumeros.removeLast();
    double numeroEsquerda = listaNumeros.removeLast();

    switch (op) {
      case "*":
        listaNumeros.add(numeroEsquerda * numeroDireita);
        break;
      case "/":
        if (numeroDireita == 0) throw Exception("Divisão por zero não é permitida");
        listaNumeros.add(numeroEsquerda / numeroDireita);
        break;
      case "+":
        listaNumeros.add(numeroEsquerda + numeroDireita);
        break;
      case "-":
        listaNumeros.add(numeroEsquerda - numeroDireita);
        break;
    }
  }

  void _resolveExpressao() {
    try {
      // Esvazia as pilhas resolvendo os operadores restantes
      while (listaOperadores.isNotEmpty && listaNumeros.length > 1) {
        _resolverOperacaoSimples();
      }

      if (listaNumeros.isNotEmpty) {
        double res = listaNumeros.last;
        // Formata o resultado: remove casas decimais inúteis (ex: 7.0 vira 7)
        if (res == res.truncateToDouble()) {
          _resultadoExpressao = res.toInt().toString();
        } else {
          // Mantém até 4 casas decimais para precisão
          _resultadoExpressao = res.toStringAsFixed(4)
              .replaceAll(RegExp(r'0*$'), '')
              .replaceAll(RegExp(r'\.$'), '');
        }
      }
    } catch (e) {
      _resultadoExpressao = "Erro";
    }
  }

  bool _isNumero(String s) => RegExp(r'^-?\d+(\.\d+)?$').hasMatch(s);
}