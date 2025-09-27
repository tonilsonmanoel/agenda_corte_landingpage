import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/views/Sobre.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int paginaATual = 0;
  late PageController pc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pc = PageController(initialPage: paginaATual);
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaATual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widgetsdesign widgetsdesign = Widgetsdesign();

    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: (pagina) {
          setPaginaAtual(pagina);
        },
        children: [
          Sobre(),
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
        //Icon(Icons.content_cut_outlined)
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Agendamento',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.scissors),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }
}
