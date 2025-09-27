import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/app_config.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/agendamento/ProfissionalView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgendamentoView extends StatefulWidget {
  const AgendamentoView({super.key});

  @override
  State<AgendamentoView> createState() => _AgendamentoViewState();
}

// AssetImage("asset/fundo_recorte.png
class _AgendamentoViewState extends State<AgendamentoView> {
  TextEditingController dateController = TextEditingController();
  DateTime? dateSelecionada;
  Widgetsdesign widgetsdesign = Widgetsdesign();

  @override
  void initState() {
    super.initState();
  }

  List<DateTime> getNextDays(int days) {
    return List.generate(
        days, (index) => DateTime.now().add(Duration(days: index)));
  }

  Future<void> selectDate() async {
    List<DateTime?>? _picked =
        await widgetsdesign.selectDatePickedAgend(context: context);

    if (_picked != null) {
      String formattedDate = Utils().getDataFormat(_picked[0]!);

      String formattedDateName = Utils().getDiaNomeFormat(_picked[0]!);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfissionalView(
                dataSelecionada: formattedDate,
                dataSelecionadaNome: formattedDateName,
                dateTimeSelecionado: _picked[0]!),
          ));
      setState(() {
        dateController.text = Utils().getDataFormat(_picked[0]!);
        dateSelecionada = _picked[0]!;
      });
      print("data Selecionada: ${dateController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> nextDays = getNextDays(10);
    double widthTela = MediaQuery.of(context).size.width;
    Widgetsdesign widgetsdesign = Widgetsdesign();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: Stack(
        children: [
          // Imagem de fundo Tela
          Positioned(
            child: Image.asset(
              "asset/fundo_recorte_transparente_80.png", // Caminho da imagem na pasta assets
            ),
          ),

          //Fim Imagem de fundo Tela
          //
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthTela * 0.05),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widgetsdesign.getCabecalhoDesing(context: context),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Escolha a Data:",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Profissionalrepository().criarHorarios();
                        },
                        child: Text("Admmin")),
                    ElevatedButton(onPressed: () {}, child: Text("horario")),

                    SizedBox(
                      width: widthTela * 0.92,
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.spaceBetween,
                        children: List.generate(nextDays.length, (index) {
                          String formattedDate =
                              Utils().getDataFormat(nextDays[index]);

                          String formattedDateName =
                              Utils().getDiaNomeFormat(nextDays[index]);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfissionalView(
                                        dataSelecionada: formattedDate,
                                        dataSelecionadaNome: formattedDateName,
                                        dateTimeSelecionado: nextDays[index]),
                                  ));
                            },
                            child: widgetsdesign.cardData(
                                titulo: formattedDate,
                                subTitulo: formattedDateName,
                                width: widthTela * 0.41),
                          );
                        }),
                      ),
                    ),

                    //Botao escolher outra data
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: TextButton.icon(
                            onPressed: () {
                              selectDate();
                            },
                            icon: Icon(
                              Icons.calendar_month_sharp,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Escolher outra data",
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                    ),

                    //botao escolher outra data

                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final client = SupabaseClient(
                            AppConfig.apiBaseUrlSupabase,
                            AppConfig.apiKeyService,
                          );

                          final response = await client.auth.admin
                              .createUser(AdminUserAttributes(
                            email: 'novo2@email.com',
                            password: 'senhasegura123',
                          ));

                          if (response.user != null) {
                            print('Usuário criado: ${response.user!.id}');
                          } else {
                            print('Erro: ${response}');
                          }
                        },
                        child: Text("Usuario"))
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
