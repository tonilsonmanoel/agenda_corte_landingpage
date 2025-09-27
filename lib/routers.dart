import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/views/administrador/login_administrador.dart';
import 'package:agendamento_barber/views/administrador/page_view_admin.dart';
import 'package:agendamento_barber/views/lading_page.dart';
import 'package:agendamento_barber/views/store_not_found.dart';
import 'package:agendamento_barber/views/sections_lading_page/set_up_landing_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:agendamento_barber/views/startup_page.dart';
import 'package:agendamento_barber/repository/estabelecimentoRepository.dart';

class AppRouter {
  GoRouter router = GoRouter(
    initialLocation: "/startup",
    routes: [
      GoRoute(
        path: '/startup',
        builder: (context, state) => const StartupPage(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) {
          // se for passado extra com estabelecimento, repassa para a LadingPage
          final data = state.extra as Map<String, dynamic>?;
          final estabelecimento =
              data != null ? data['estabelecimento'] as Estabelecimento? : null;
          return LadingPage(estabelecimento: estabelecimento);
        },
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) => SetUpLandingPage(),
      ),
      GoRoute(
        path: '/loja-nao-encontrada',
        builder: (context, state) => const StoreNotFound(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) {
          // if an estabelecimento was passed via state.extra reuse it,
          // otherwise AdminLoader will fetch by the current host.
          final data = state.extra as Map<String, dynamic>?;
          final estabelecimento =
              data != null ? data['estabelecimento'] as Estabelecimento? : null;
          return AdminLoader(estabelecimento: estabelecimento);
        },
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final estabelecimento = data['estabelecimento'] as Estabelecimento;
          final profissional = data['profissional'] as Profissional;
          return MaterialPage(
              key: state.pageKey,
              child: PageViewAdmin(
                estabelecimento: estabelecimento,
                pc: PageController(initialPage: 0),
                profissional: profissional,
              ));
        },
      ),
    ],
  );
}

class AdminLoader extends StatelessWidget {
  final Estabelecimento? estabelecimento;

  const AdminLoader({Key? key, this.estabelecimento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (estabelecimento != null) {
      return LoginAdministrador(estabelecimento: estabelecimento);
    }

    return FutureBuilder<Estabelecimento?>(
      future:
          Estabelecimentorepository().getEstabelecimentoByUrl(Uri.base.host),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          print('Estabecimenot ${snapshot.data!.nome}');
          return LoginAdministrador(estabelecimento: snapshot.data);
        }
        // not found or error
        return const StoreNotFound();
      },
    );
  }
}
