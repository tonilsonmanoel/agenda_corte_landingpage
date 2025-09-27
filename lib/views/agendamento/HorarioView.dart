import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/views/agendamento/ConfimaAgendamento.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HorarioView extends StatefulWidget {
  const HorarioView(
      {super.key,
      required this.dataSelecionada,
      required this.dataSelecionadaNome,
      required this.dateTimeSelecionado,
      required this.profissional,
      required this.servicos});

  final String dataSelecionada;
  final String dataSelecionadaNome;
  final DateTime dateTimeSelecionado;
  final List<Servico> servicos;
  final Profissional profissional;

  @override
  State<HorarioView> createState() => _HorarioViewState();
}

class _HorarioViewState extends State<HorarioView> {
  List<String> horarioOcupados = [];

  double totalAgendamento = 0;

  @override
  void initState() {
    super.initState();
    somarTotalAgendamento();
  }

  void somarTotalAgendamento() {
    for (var servico in widget.servicos) {
      totalAgendamento += servico.valor;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getHorariosDisponiveis(
      {required double widthTela,
      required List<String> listaHorariosProfissionais,
      required Widgetsdesign widgetsdesign,
      required List<String> horariosOcupado,
      required Profissional profissional}) {
    return SizedBox(
      width: widthTela,
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        children: List.generate(listaHorariosProfissionais.length, (index) {
          DateTime dateSelecionada = widget.dateTimeSelecionado;

          String horaLabel = listaHorariosProfissionais[index].substring(0, 2);

          String minutoLabel =
              listaHorariosProfissionais[index].substring(3, 5);

          DateTime dateTimeAgendamento = DateTime(
              dateSelecionada.year,
              dateSelecionada.month,
              dateSelecionada.day,
              int.parse(horaLabel),
              int.parse(minutoLabel));

          return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfimaAgendamento(
                          dataSelecionada: widget.dataSelecionada,
                          dataSelecionadaNome: widget.dataSelecionadaNome,
                          dateTimeSelecionado: dateTimeAgendamento,
                          horario: listaHorariosProfissionais[index],
                          totalAgendamento: totalAgendamento,
                          profissional: widget.profissional,
                          servicos: widget.servicos),
                    ));
              },
              child: Column(
                children: [
                  if (!horariosOcupado
                      .contains(listaHorariosProfissionais[index])) ...[
                    widgetsdesign.cardDataHorario(
                        titulo: listaHorariosProfissionais[index],
                        width: widthTela * 0.42)
                  ]
                ],
              ));
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;
    double heightTela = MediaQuery.of(context).size.height;
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
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Meu Agendamento",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: widgetsdesign.cardMeuAgendamento(
                          data: widget.dataSelecionada,
                          diaDaSemana: widget.dataSelecionadaNome,
                          nomeProfissional: widget.profissional.nome,
                          nomeServico: "${widget.servicos.length} Serviços",
                          valorServico: UtilBrasilFields.obterReal(
                              totalAgendamento,
                              moeda: true,
                              decimal: 2),
                          width: widthTela * 0.65),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Horários disponiveis:",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    FutureBuilder(
                      future: Agendamentorepository()
                          .buscarHorariosOcupadosRepository(
                              data: widget.dataSelecionada,
                              uidProfissional: widget.profissional.uid!),
                      builder: (context, snapshotHorarioOcupado) {
                        if (snapshotHorarioOcupado.hasData) {
                          return FutureBuilder(
                            future: Profissionalrepository()
                                .getHorariosProfissional(
                                    uidProfissional: widget.profissional.uid!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return widgetsdesign.carregamentoCircular(
                                    paddingVertical: heightTela * 0.07);
                              }
                              if (snapshot.hasData) {
                                return getHorariosDisponiveis(
                                  widthTela: widthTela * 0.92,
                                  listaHorariosProfissionais:
                                      snapshot.data ?? [],
                                  widgetsdesign: widgetsdesign,
                                  horariosOcupado:
                                      snapshotHorarioOcupado.data ?? [],
                                  profissional: widget.profissional,
                                );
                              }
                              return widgetsdesign.mensagemTentaMaisTarde(
                                  cor: Colors.white);
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
