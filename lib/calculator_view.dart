import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calculator_view_model.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({super.key});

  // Movi para cá para facilitar o acesso
  String _getComplexityEmoji(String expression) {
    final operators = RegExp(r'[+x÷\-]').allMatches(expression).length;
    if (operators == 0 && (expression == "0" || expression.isEmpty)) return "📱";
    if (operators <= 2) return "😌";
    if (operators <= 5) return "🧐";
    return "🤯";
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CalculatorViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      body: SafeArea(
        child: Column(
          children: [
            // --- SEÇÃO DO VISOR ---
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _getComplexityEmoji(viewModel.expression),
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 10),
                    Consumer<CalculatorViewModel>(
                      builder: (context, model, child) {
                        double fontSize = 54;
                        if (model.expression.length > 12) fontSize = 42;
                        if (model.expression.length > 18) fontSize = 32;
                        if (model.expression.length > 25) fontSize = 24;

                        return SizedBox(
                          width: double.infinity, // Força o texto a usar a largura toda da tela
                          child: Text(
                            model.expression,
                            textAlign: TextAlign.right,
                            maxLines: 3,
                            softWrap: true,
                            // Isso evita que o Flutter tente "economizar" espaço na quebra
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: fontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              height: 1.1,
                              fontFeatures: const [FontFeature.tabularFigures()], // Mantém números com a mesma largura
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      viewModel.previewResult,
                      style: const TextStyle(fontSize: 26, color: Colors.grey),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            // --- SEÇÃO DOS BOTÕES ---
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildRow(context, ['AC', '(', ')', '÷']),
                    _buildRow(context, ['7', '8', '9', 'x']),
                    _buildRow(context, ['4', '5', '6', '-']),
                    _buildRow(context, ['1', '2', '3', '+']),
                    _buildRow(context, ['0', '.', 'DEL', '=']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((text) => _CalculatorButton(text: text)).toList(),
      ),
    );
  }
}

class _CalculatorButton extends StatelessWidget {
  final String text;
  const _CalculatorButton({required this.text});

  @override
  Widget build(BuildContext context) {
    // Usamos read aqui pois não precisamos reconstruir o botão quando a expressão muda,
    // apenas disparar a ação no clique.
    final viewModel = context.read<CalculatorViewModel>();

    final isOperator = ['+', '-', 'x', '÷', '=', '(', ')'].contains(text);
    final isAction = ['AC', 'DEL'].contains(text);
    final isEqual = text == '=';

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (text == 'AC') viewModel.clear();
              else if (text == 'DEL') viewModel.delete();
              else if (text == '=') viewModel.calculate();
              else viewModel.addToken(text);
            },
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              decoration: BoxDecoration(
                color: isEqual
                    ? Colors.orangeAccent
                    : (isAction ? const Color(0xFF363636) : (isOperator ? const Color(0xFF2C2F33) : const Color(0xFF1E2023))),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isAction ? Colors.redAccent : (isEqual ? Colors.black : Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}