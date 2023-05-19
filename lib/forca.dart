import 'package:flutter/material.dart';
import 'dart:math';
import 'forca_canva.dart';

class ForcaApp extends StatelessWidget {
  const ForcaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jogo da Forca',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const ForcaPage(),
    );
  }
}

class ForcaPage extends StatefulWidget {
  const ForcaPage({Key? key}) : super(key: key);

  @override
  createState() => _ForcaPageState();
}

class _ForcaPageState extends State<ForcaPage>
    with SingleTickerProviderStateMixin {
  final List<String> palavras = [
    'Cachorro',
    'Feijoada',
    'Abacaxi',
    'Cerveja',
    'Escritorio',
    'Girassol',
    'Computador',
    'Biblioteca',
    'Cachorro',
    'Ventilador',
    'Sexta',
    'Estrela',
    'Chocolate',
    'Telefone',
    'Cenoura',
    'Bicicleta',
    'Avião',
    'Teclado',
    'Praia',
    'Churrasco',
    'Foguete',
    'Cinema',
    'Tigre',
    'Café',
  ];

  final List<String> dicas = [
    'Animal',
    'Comida',
    'Fruta',
    'Bebida',
    'Lugar de trabalho',
    'Flor',
    'Objeto eletrônico',
    'Livros',
    'Animal',
    'Objeto de casa',
    'Dia da semana',
    'Espaço',
    'Comida',
    'Comunicação',
    'Vegetal',
    'Transporte',
    'Transporte',
    'Objeto eletrônico',
    'Lugar',
    'Comida',
    'Espaço',
    'Lugar',
    'Animal',
    'Comida',
  ];

  String palavraSecreta = '';
  String dica = '';
  List<String> letrasEscolhidas = [];
  int erroCount = 0;
  bool mostrarDicas = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacityAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    iniciarJogo();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void iniciarJogo() {
    final random = Random();
    final index = random.nextInt(palavras.length);
    palavraSecreta = palavras[index].toUpperCase();
    dica = dicas[index];
    letrasEscolhidas.clear();
    erroCount = 0;
    mostrarDicas = false;
    _animationController.reset();
  }

  bool letraJaEscolhida(String letra) {
    return letrasEscolhidas.contains(letra);
  }

  bool letraExisteNaPalavra(String letra) {
    return palavraSecreta.contains(letra);
  }

  bool jogadorVenceu() {
    return palavraSecreta.split('').every(letrasEscolhidas.contains);
  }

  bool jogadorPerdeu() {
    return erroCount == 6;
  }

  void escolherLetra(String letra) {
    setState(() {
      letrasEscolhidas.add(letra);
      if (!letraExisteNaPalavra(letra)) {
        erroCount++;
        if (erroCount >= 4) {
          mostrarDicas = true;
          _animationController.forward();
        }
      }
    });
  }

  List<Widget> gerarBotoes() {
    return List.generate(26, (index) {
      final char = String.fromCharCode(index + 65);
      final bool acertou = letraJaEscolhida(char) && letraExisteNaPalavra(char);
      final bool errou = letraJaEscolhida(char) && !letraExisteNaPalavra(char);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        child: ElevatedButton(
          onPressed: letraJaEscolhida(char) ? null : () => escolherLetra(char),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: Text(
            char,
            style: TextStyle(
              fontSize: 16,
              color: acertou
                  ? Colors.black
                  : errou
                      ? Colors.red
                      : null,
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogo da Forca'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              painter: ForcaPainter(erroCount),
              size: const Size(200, 200),
            ),
            AnimatedOpacity(
              opacity: mostrarDicas ? _opacityAnimation.value : 0.0,
              duration: const Duration(milliseconds: 0),
              child: Text(
                'Dica: $dica',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final char in palavraSecreta.split(''))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      letraJaEscolhida(char) ? char : '_',
                      style: TextStyle(
                        fontSize: 24,
                        color: letrasEscolhidas.contains(char)
                            ? Colors.green
                            : null,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (jogadorPerdeu())
              Column(
                children: [
                  const Text(
                    'Você perdeu!',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Desculpe, mas a palavra secreta na verdade era "$palavraSecreta"',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            else if (jogadorVenceu())
              const Text(
                'Parabéns, você venceu!',
                style: TextStyle(fontSize: 20, color: Colors.green),
              )
            else
              Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: gerarBotoes(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Erros: $erroCount/6',
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  iniciarJogo();
                });
              },
              child: const Text('Novo Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ForcaApp(),
  ));
}
