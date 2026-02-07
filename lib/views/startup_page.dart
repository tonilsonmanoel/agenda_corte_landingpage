import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agendamento_barber/repository/estabelecimentoRepository.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  @override
  void initState() {
    super.initState();
    _checkHostAndNavigate();
  }

  Future<void> _checkHostAndNavigate() async {
    final uri = Uri.base;
    try {
      final repo = Estabelecimentorepository();

      final estabelecimento = await repo.getEstabelecimentoByUrl(uri.host);
      if (!mounted) return;

<<<<<<< HEAD
      if (estabelecimento != null &&
          estabelecimento.ativoLanding &&
          estabelecimento.siteManutencao == false) {
=======
      if (estabelecimento != null && estabelecimento.ativoLanding) {
>>>>>>> 239d25864a887bf664e2b0347b7de47912c0a8f3
        print('uri.path: ${uri.path}');

        GoRouter.of(context)
            .go('/', extra: {'estabelecimento': estabelecimento});
      } else if (estabelecimento != null &&
<<<<<<< HEAD
          (estabelecimento.ativoLanding == false ||
              estabelecimento.siteManutencao == true)) {
=======
          estabelecimento.ativoLanding == false) {
>>>>>>> 239d25864a887bf664e2b0347b7de47912c0a8f3
        GoRouter.of(context).go('/manutencao');
      } else {
        GoRouter.of(context).go('/barbearia-nao-encontrada');
      }
    } catch (e) {
      if (!mounted) return;
      GoRouter.of(context).go('/barbearia-nao-encontrada');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
