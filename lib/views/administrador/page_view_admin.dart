import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/views/administrador/administracao.dart';
import 'package:agendamento_barber/views/administrador/agenda_admin.dart';
import 'package:agendamento_barber/views/administrador/agendamentos_realizados.dart';
import 'package:agendamento_barber/views/administrador/dashboard_admin.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PageViewAdmin extends StatefulWidget {
  const PageViewAdmin(
      {super.key,
      required this.profissional,
      required this.pc,
      required this.estabelecimento});
  final Profissional profissional;
  final Estabelecimento estabelecimento;
  final PageController pc;

  @override
  State<PageViewAdmin> createState() => _PageViewAdminState();
}

class _PageViewAdminState extends State<PageViewAdmin> {
  int paginaATual = 0;
  late PageController pc;

  Profissional? profissional;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    profissional = widget.profissional;
    pc = PageController(initialPage: paginaATual);
    pc = PageController(initialPage: widget.pc.initialPage);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaATual = pagina;
    });
  }

  @override
  Widget build(BuildContext contextPageView) {
    Widgetsdesign widgetsdesign = Widgetsdesign();
    double widthTela = MediaQuery.of(contextPageView).size.width;
    double heightTela = MediaQuery.of(contextPageView).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: profissional == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PageView(
              controller: pc,
              onPageChanged: (pagina) {
                setPaginaAtual(pagina);
              },
              children: [
                DashboardAdmin(
                  profissional: profissional!,
                  pc: pc,
                  estabelecimento: widget.estabelecimento,
                ),
                AgendaAdmin(
                  profissional: profissional!,
                  pc: pc,
                  estabelecimento: widget.estabelecimento,
                ),
                Administracao(
                  profissional: profissional!,
                  estabelecimento: widget.estabelecimento,
                ),
                AgendamentosRealizados(
                  profissional: profissional!,
                  pc: pc,
                  estabelecimento: widget.estabelecimento,
                )
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaATual,
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        elevation: 5,
        selectedLabelStyle: GoogleFonts.roboto(
            color: widgetsdesign.amareloColor, fontWeight: FontWeight.bold),
        selectedItemColor: widgetsdesign.amareloColor,
        unselectedLabelStyle: GoogleFonts.roboto(
            color: Colors.white, fontWeight: FontWeight.normal),
        unselectedItemColor: Colors.white,
        onTap: (pagina) {
          pc.animateToPage(pagina,
              duration: Duration(milliseconds: 400), curve: Curves.ease);
        },
        type: BottomNavigationBarType.fixed,
        //Icon(Icons.content_cut_outlined)
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.scissors),
            label: 'Administração',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.checkCircle),
            label: 'Realizados',
          ),
        ],
      ),
      drawer: profissional == null
          ? null
          : widgetsdesign.adminDrawer(
              heightMedia: heightTela,
              widthMedia: widthTela,
              context: contextPageView,
              profissional: profissional!,
              estabelecimento: widget.estabelecimento),
    );
  }
}
