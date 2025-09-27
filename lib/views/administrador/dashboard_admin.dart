import 'package:agendamento_barber/models/Agendamento.dart';
import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/administrador/agendamentos_realizados.dart';
import 'package:agendamento_barber/views/administrador/detalhes_agendamento_admin.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin(
      {super.key,
      required this.profissional,
      required this.pc,
      required this.estabelecimento});

  final Profissional profissional;
  final PageController pc;
  final Estabelecimento estabelecimento;
  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  int? agendamentoHojeCount;
  int? agendamentoMesCount;
  final keyScafold = GlobalKey<ScaffoldState>();
  double? totalFaturamentoMes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarAgendamentosCount();
    carregarFaturamentoMes();
  }

  void carregarFaturamentoMes() async {
    Agendamentorepository()
        .totalFaturamentoMes(
      idProfissional: widget.profissional.uid!,
      idEstabelecimento: widget.estabelecimento.uid!,
      isAdmin: widget.profissional.perfil == "admin" ? true : false,
    )
        .then(
      (value) {
        setState(() {
          totalFaturamentoMes = value;
        });
      },
    );
  }

  void carregarAgendamentosCount() async {
    int agendamentoHoje = await Agendamentorepository().countAgendamentoDia(
      uidProfissional: widget.profissional.uid!,
      idEstabelecimento: widget.estabelecimento.uid!,
      isAdmin: widget.profissional.perfil == "admin" ? true : false,
    );
    int agendamentosMes = await Agendamentorepository().countAgendamentosMes(
      uidProfissional: widget.profissional.uid!,
      idEstabelecimento: widget.estabelecimento.uid!,
      isAdmin: widget.profissional.perfil == "admin" ? true : false,
    );
    setState(() {
      agendamentoHojeCount = agendamentoHoje;
      agendamentoMesCount = agendamentosMes;
    });
  }

  Widget agendamentosCard(
      {required double widthTela, required double heightTela}) {
    return FutureBuilder(
      future: Agendamentorepository().getAgendamentosProfissionalLimite(
        uidProfissional: widget.profissional.uid!,
        limite: 6,
        idEstabelecimento: widget.estabelecimento.uid!,
        isAdmin: widget.profissional.perfil == "admin" ? true : false,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widgetsdesign.carregamentoCircular();
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            children: [
              widgetsdesign.mensagempersonalizadaCenter(
                  paddingVertical: 40,
                  cor: Colors.white,
                  label: "Nenhum Agendamento\nEncontrado!"),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AgendamentosRealizados(
                            estabelecimento: widget.estabelecimento,
                            pc: widget.pc,
                            profissional: widget.profissional),
                      ));
                },
                label: Text(
                  "Ver Agendamentos Realizados",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                iconAlignment: IconAlignment.end,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                "Clique Para Ver Detalhes",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  width: widthTela * 0.90,
                  child: Wrap(
                    direction: Axis.vertical,
                    runAlignment: WrapAlignment.center,
                    children: List.generate(
                      snapshot.data!.length,
                      (index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetalhesAgendamentoAdmin(
                                        estabelecimento: widget.estabelecimento,
                                        agendamento: Agendamento(
                                            uidProfissional: snapshot
                                                .data![index].uidProfissional,
                                            data: snapshot.data![index].data,
                                            totalAgendamento: snapshot
                                                .data![index].totalAgendamento,
                                            horario:
                                                snapshot.data![index].horario,
                                            dateTimeAgenda: snapshot
                                                .data![index].dateTimeAgenda,
                                            servicos:
                                                snapshot.data![index].servicos,
                                            diaDaSemana: snapshot
                                                .data![index].diaDaSemana,
                                            confimado:
                                                snapshot.data![index].confimado,
                                            uid: snapshot.data![index].uid,
                                            concluido:
                                                snapshot.data![index].concluido,
                                            nomeCliente: snapshot
                                                .data![index].nomeCliente,
                                            nomeProfissional: snapshot
                                                .data![index].nomeProfissional,
                                            codeTelefoneCliente: snapshot
                                                .data![index]
                                                .codeTelefoneCliente,
                                            isoCodePhone: snapshot
                                                .data![index].isoCodePhone,
                                            idEstabelecimento: snapshot
                                                .data![index].idEstabelecimento,
                                            telefoneCliente: snapshot
                                                .data![index].telefoneCliente),
                                      ),
                                    )).then(
                                  (value) => setState(() {}),
                                );
                              },
                              child: widgetsdesign.cardMeuAgendamentoFoto(
                                  estabelecimento: widget.estabelecimento,
                                  idAgendamento: snapshot.data![index].uid!,
                                  data: snapshot.data![index].data,
                                  nomeProfissional:
                                      snapshot.data![index].nomeProfissional,
                                  diaDaSemana:
                                      snapshot.data![index].diaDaSemana,
                                  nome: snapshot.data![index].nomeCliente,
                                  codeTelefoneCliente:
                                      snapshot.data![index].codeTelefoneCliente,
                                  telefoneCliente:
                                      snapshot.data![index].telefoneCliente,
                                  nomeServico:
                                      snapshot.data![index].servicos[0].nome,
                                  valorServico: UtilBrasilFields.obterReal(
                                      snapshot.data![index].servicos[0].valor,
                                      decimal: 2,
                                      moeda: true),
                                  horario: snapshot.data![index].horario,
                                  heightFoto: heightTela * 0.1,
                                  urlFotoServico:
                                      snapshot.data![index].servicos[0].urlImg,
                                  width: widthTela * 0.90),
                            ),
                          ],
                        );
                      },
                    ),
                  )),
              SizedBox(
                height: 3,
              ),
              TextButton.icon(
                onPressed: () {
                  widget.pc.jumpToPage(3);
                },
                label: Text(
                  "Ver Agendamentos Realizados",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                iconAlignment: IconAlignment.end,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget cardsDashboard(
      {required double heightTela, required double widthTela}) {
    return Wrap(
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.spaceBetween,
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            shadowColor: Colors.grey,
            surfaceTintColor: Colors.white,
            child: Container(
              width: widthTela * 0.42,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.black, width: 1)),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              padding: EdgeInsets.symmetric(horizontal: 10),
              constraints: BoxConstraints(minHeight: heightTela * 0.127),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Agendamentos Hoje",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  agendamentoHojeCount != null
                      ? AutoSizeText(
                          "$agendamentoHojeCount",
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontSize: 39,
                              fontWeight: FontWeight.bold),
                        )
                      : CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          Card(
            color: Colors.white,
            elevation: 2,
            shadowColor: Colors.grey,
            surfaceTintColor: Colors.white,
            child: Container(
              width: widthTela * 0.42,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.black, width: 1)),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              constraints: BoxConstraints(minHeight: heightTela * 0.127),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Agendamentos Mês",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                  agendamentoMesCount != null
                      ? AutoSizeText(
                          "$agendamentoMesCount",
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                              color: Colors.grey.shade800,
                              fontSize: 39,
                              fontWeight: FontWeight.bold),
                        )
                      : CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;
    double heightTela = MediaQuery.of(context).size.height;
    return Scaffold(
      key: keyScafold,
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: widthTela * 0.05),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              widgetsdesign.cabecalhoComLabel(
                label: "Dashboard",
                context: context,
              ),
              SizedBox(
                height: 5,
              ),
              cardsDashboard(heightTela: heightTela, widthTela: widthTela),
              Card(
                color: Colors.white,
                child: Container(
                  width: widthTela * 0.85,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  constraints: BoxConstraints(minHeight: heightTela * 0.11),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total Faturamento no Mês",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                      totalFaturamentoMes != null
                          ? AutoSizeText(
                              UtilBrasilFields.obterReal(totalFaturamentoMes!,
                                  decimal: 2, moeda: true),
                              maxLines: 1,
                              maxFontSize: 45,
                              style: GoogleFonts.roboto(
                                  color: Colors.green.shade800,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            )
                          : CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Agenda:",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              agendamentosCard(widthTela: widthTela, heightTela: heightTela),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
