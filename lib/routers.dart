import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/views/lading_page.dart';
import 'package:agendamento_barber/views/manutencao_page.dart';
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
        path: '/barbearia-nao-encontrada',
        builder: (context, state) => const StoreNotFound(),
      ),
      GoRoute(
        path: '/manutencao',
        builder: (context, state) => ManutencaoPage(),
      ),
    ],
  );
}
