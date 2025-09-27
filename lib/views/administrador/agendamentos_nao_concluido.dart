import 'package:agendamento_barber/models/Agendamento.dart';
import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/administrador/detalhes_agendamento_admin.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class AgendamentosNaoConcluido extends StatefulWidget {
  const AgendamentosNaoConcluido(
      {super.key, required this.profissional, required this.estabelecimento});
  final Profissional profissional;
  final Estabelecimento estabelecimento;
  @override
  State<AgendamentosNaoConcluido> createState() =>
      _AgendamentosNaoConcluidoState();
}

class _AgendamentosNaoConcluidoState extends State<AgendamentosNaoConcluido> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  TextEditingController searchController = TextEditingController();
  bool searchAtivado = false;
  List<DateTime?>? pickedDates;

  void selecionarDatas() async {
    var datasSelecionadas =
        await widgetsdesign.selectDateRangerPicked(context: context);
    if (datasSelecionadas != null) {
      setState(() {
        pickedDates = datasSelecionadas;
      });
    }
  }

  Widget agendamentosCard(
      {required double widthTela, required double heightTela}) {
    return FutureBuilder(
      future: pickedDates != null
          ? Agendamentorepository().getAgendamentosNaoConcluidosDate(
              uidProfissional: widget.profissional.uid!,
              idEstabelecimento: widget.estabelecimento.uid!,
              isAdmin: widget.profissional.perfil == "admin" ? true : false,
              datasSelecionadas: pickedDates)
          : Agendamentorepository().getAgendamentosNaoConcluidos(
              idEstabelecimento: widget.estabelecimento.uid!,
              isAdmin: widget.profissional.perfil == "admin" ? true : false,
              uidProfissional: widget.profissional.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widgetsdesign.carregamentoCircular();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return widgetsdesign.mensagempersonalizadaCenter(
              paddingVertical: 100,
              cor: Colors.white,
              label: "Nenhum Agendamento\nEncontrado!");
        }
        if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                "Total Agendamentos: ${snapshot.data!.length}",
                style: GoogleFonts.roboto(color: Colors.white),
              ),
              SizedBox(
                height: 5,
              ),
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
                            if (snapshot.data![index].nomeCliente
                                .toLowerCase()
                                .contains(
                                    searchController.text.toLowerCase())) ...[
                              Slidable(
                                endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      CustomSlidableAction(
                                          onPressed: (context) async {
                                            Agendamentorepository()
                                                .deleteAgendamentoRepository(
                                                    uidAgendamento: snapshot
                                                        .data![index].uid!)
                                                .then(
                                              (value) {
                                                setState(() {});
                                              },
                                            );
                                            setState(() {});
                                          },
                                          autoClose: true,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          backgroundColor: Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 40,
                                              ),
                                              Text(
                                                "Deletar",
                                                style: GoogleFonts.roboto(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          )),
                                    ]),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetalhesAgendamentoAdmin(
                                            estabelecimento:
                                                widget.estabelecimento,
                                            agendamento: Agendamento(
                                                concluido: snapshot
                                                    .data![index].concluido,
                                                uid: snapshot.data![index].uid,
                                                totalAgendamento: snapshot
                                                    .data![index]
                                                    .totalAgendamento,
                                                uidProfissional: snapshot
                                                    .data![index]
                                                    .uidProfissional,
                                                data:
                                                    snapshot.data![index].data,
                                                horario: snapshot
                                                    .data![index].horario,
                                                dateTimeAgenda: snapshot
                                                    .data![index]
                                                    .dateTimeAgenda,
                                                servicos: snapshot
                                                    .data![index].servicos,
                                                diaDaSemana: snapshot
                                                    .data![index].diaDaSemana,
                                                confimado: snapshot
                                                    .data![index].confimado,
                                                nomeCliente: snapshot
                                                    .data![index].nomeCliente,
                                                nomeProfissional: snapshot
                                                    .data![index]
                                                    .nomeProfissional,
                                                codeTelefoneCliente: snapshot
                                                    .data![index]
                                                    .codeTelefoneCliente,
                                                isoCodePhone: snapshot
                                                    .data![index].isoCodePhone,
                                                idEstabelecimento: snapshot
                                                    .data![index]
                                                    .idEstabelecimento,
                                                telefoneCliente: snapshot
                                                    .data![index]
                                                    .telefoneCliente),
                                          ),
                                        )).then(
                                      (value) => setState(() {}),
                                    );
                                  },
                                  child: widgetsdesign.cardMeuAgendamentoFoto(
                                      estabelecimento: widget.estabelecimento,
                                      data: snapshot.data![index].data,
                                      nomeProfissional: snapshot
                                          .data![index].nomeProfissional,
                                      idAgendamento: snapshot.data![index].uid!,
                                      diaDaSemana:
                                          snapshot.data![index].diaDaSemana,
                                      nome: snapshot.data![index].nomeCliente,
                                      telefoneCliente:
                                          snapshot.data![index].telefoneCliente,
                                      codeTelefoneCliente: snapshot
                                          .data![index].codeTelefoneCliente,
                                      nomeServico: snapshot
                                                  .data![index].concluido ==
                                              true
                                          ? snapshot
                                              .data![index].servicos[0].nome
                                          : "${snapshot.data![index].servicos[0].nome} - Serviço Não Concluido",
                                      valorServico: UtilBrasilFields.obterReal(
                                          snapshot
                                              .data![index].servicos[0].valor,
                                          decimal: 2,
                                          moeda: true),
                                      horario: snapshot.data![index].horario,
                                      heightFoto: heightTela * 0.13,
                                      urlFotoServico: snapshot
                                          .data![index].servicos[0].urlImg,
                                      width: widthTela * 0.90),
                                ),
                              ),
                            ]
                          ],
                        );
                      },
                    ),
                  )),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget searchBar() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 32,
                      )),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (searchAtivado) {
                          searchAtivado = false;
                        } else {
                          searchAtivado = true;
                        }
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 38,
                    )),
              ],
            ),
            if (searchAtivado == true) ...[
              Card(
                color: Colors.white,
                shadowColor: Colors.black,
                surfaceTintColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextField(
                    controller: searchController,
                    onSubmitted: (value) {
                      setState(() {
                        if (searchAtivado) {
                          searchAtivado = false;
                        } else {
                          searchAtivado = true;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10),
                      hintText: "Busca pelo nome do cliente",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (searchAtivado) {
                                searchAtivado = false;
                                searchController.text = "";
                              } else {
                                searchAtivado = true;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          )),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heitghMedia = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthMedia * 0.04),
          child: Column(
            children: [
              searchBar(),
              widgetsdesign.getCabecalhoAgendaVoltar(
                label: "Agendamento Não Concluído",
                colorLabel: widgetsdesign.amareloColor,
                fontWeight: FontWeight.w700,
                context: context,
                menuLateralAtivado: false,
                calenderButtonFunction: selecionarDatas,
              ),
              agendamentosCard(widthTela: widthMedia, heightTela: heitghMedia),
            ],
          ),
        ),
      ),
    );
  }
}
