# 🧮 Calculadora Stack

**Uma calculadora Flutter de alta precisão que utiliza estruturas de dados de Pilha para resolver expressões complexas.**

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

A **Calculadora Stack** foi desenvolvida para ser robusta e precisa. Diferente de calculadoras simples que processam número por número, este projeto utiliza o algoritmo de **Shunting Yard** para garantir que a precedência matemática (multiplicação antes da soma, parênteses primeiro, etc.) seja sempre respeitada.

---

## 🚀 Tecnologias e Ferramentas

* **Framework:** [Flutter](https://flutter.dev) (UI Cross-platform)
* **Linguagem:** [Dart](https://dart.dev)
* **Gerenciamento de Estado:** [Provider](https://pub.dev/packages/provider) (Arquitetura reativa)
* **Arquitetura:** MVVM (Model-View-ViewModel)
* **Processamento:** Expressões Regulares (RegExp) para tokenização avançada.

---

## 🧠 Arquitetura e Lógica

O projeto segue o padrão **MVVM**, garantindo que a lógica matemática esteja totalmente separada da interface visual.

### 1. O Motor de Cálculo (The Stack Engine)
O coração do projeto é a classe `Calculadora` no Model. Ela utiliza duas pilhas principais:
* **Pilha de Números (`List<double>`):** Armazena os operandos.
* **Pilha de Operadores (`List<String>`):** Armazena operadores e controla a precedência.

### 2. Algoritmo Shunting Yard
Implementamos uma versão adaptada do algoritmo de Edsger Dijkstra. Quando você digita uma expressão como `7 + 8 * 2`, o motor:
1. Identifica que o `*` tem maior precedência que o `+`.
2. Mantém o `7` e o `+` em espera.
3. Resolve `8 * 2` primeiro.
4. Soma o resultado ao `7`.



### 3. Interface Adaptativa
O visor foi projetado para nunca quebrar o layout:
* **Auto-Scaling:** A fonte diminui automaticamente conforme a expressão cresce.
* **Multi-line:** Suporta até 3 linhas de expressão antes de truncar.
* **Complexity Emojis:** Um toque de humor que muda o emoji baseado na quantidade de operadores:
    * `0-2` operadores: 😌 (Tranquilo)
    * `3-5` operadores: 🧐 (Interessante)
    * `>5` operadores: 🤯 (Ficou sério!)

---

## 🎨 Design System

* **Dark Mode:** Fundo em `#17181A`.
* **Destaques:** Operadores em Laranja vibrante e ações em tons de cinza escuro.
* **Tipografia:** Focada em legibilidade com pesos variados (Light para expressão, Bold para botões).

---

## 🛠️ Como rodar o projeto

1. **Clone o repositório:**
   ```bash
   git clone [https://github.com/fenilonilo/calculadora_fluter.git](https://github.com/fenilonilo/calculadora_fluter.git)


2. **Instale as dependências:**
   ```bash
   flutter pub get

3. **Gere os ícones e Splash Screen:**
   ```bash
   flutter pub run flutter_launcher_icons

4. **Execute o App:**
    ```bash
   flutter run
   
## Desenvolvido por Felipe 🚀