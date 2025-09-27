import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/views/agendamento/HorarioView.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfissionalView extends StatefulWidget {
  const ProfissionalView(
      {super.key,
      required this.dataSelecionada,
      required this.dataSelecionadaNome,
      required this.dateTimeSelecionado});
  final String dataSelecionada;
  final String dataSelecionadaNome;
  final DateTime dateTimeSelecionado;

  @override
  State<ProfissionalView> createState() => _ProfissionalViewState();
}

class _ProfissionalViewState extends State<ProfissionalView> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  int? indiceProfissionalAtual;
  Profissional? profissionalSelecionado;
  List<Map<String, dynamic>> servicosSelecionados = [];

  Widget getProfissionaisDisponiveis(
      {required double widthTela, required double heightTela}) {
    return FutureBuilder(
      future: Profissionalrepository().getFuncionariosDisponivelRepository(
          idEstabecimento: 1, diaDaSemana: widget.dataSelecionadaNome),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widgetsdesign.carregamentoCircular(
              paddingVertical: heightTela * 0.07);
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return widgetsdesign.mensagempersonalizadaCenter(
              cor: Colors.white,
              label: "Nenhum Profissional Disponivel\nPara Essa Data");
        }
        if (snapshot.hasData) {
          return SizedBox(
            width: widthTela * 0.92,
            child: Wrap(
                children: List.generate(
              snapshot.data!.length,
              (index) {
                bool diaAtivado = true;
                //Tratamento List<dynamic> do firebase

                var listaDiasTrabalhoDynamic =
                    snapshot.data![index].diasTrabalho as List<dynamic>;
                List<String> listaDiasTrabalho = List.generate(
                  listaDiasTrabalhoDynamic.length,
                  (i) {
                    return listaDiasTrabalhoDynamic[i]["dia"];
                  },
                );
                /*
                var listaHorariosDynamic =
                    snapshot.data![index]["horariosTrabalho"] as List<dynamic>;
                List<String> listaHorarios = List.generate(
                  listaHorariosDynamic.length,
                  (i) => listaHorariosDynamic[i],
                );
               */

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      indiceProfissionalAtual = index;
                      profissionalSelecionado = Profissional(
                          nome: snapshot.data![index].nome,
                          isoCodePhone: "",
                          isoCodePhoneWhatsapp: "",
                          codeTelefone: "",
                          codeTelefoneWhatsapp: "",
                          email: snapshot.data![index].email,
                          perfil: snapshot.data![index].perfil,
                          telefone: snapshot.data![index].telefone,
                          uid: snapshot.data![index].uid,
                          telefoneWhatsapp:
                              snapshot.data![index].telefoneWhatsapp,
                          fotoPerfil: snapshot.data![index].fotoPerfil,
                          horariosTrabalho:
                              snapshot.data![index].horariosTrabalho,
                          diasTrabalho: snapshot.data![index].diasTrabalho,
                          status: snapshot.data![index].status);
                    });
                  },
                  child: Column(
                    children: [
                      if (listaDiasTrabalho
                              .contains(widget.dataSelecionadaNome) &&
                          snapshot.data![index].status == true &&
                          diaAtivado == true) ...[
                        widgetsdesign.cardProfissional(
                            nomeProfissional: snapshot.data![index].nome,
                            width: widthTela * 0.41,
                            widthImg: widthTela * 0.41,
                            heightImg: heightTela * 0.16,
                            selecionadoItem: indiceProfissionalAtual == index,
                            fotoPerfil: snapshot.data![index].fotoPerfil),
                      ]
                    ],
                  ),
                );
              },
            )),
          );
        }
        return widgetsdesign.mensagemTentaMaisTarde(cor: Colors.white);
      },
    );
  }

  Widget getServicosProfissional(
      {required double widthTela,
      required double heightTela,
      required Profissional profissionalSelecionado}) {
    return FutureBuilder(
      future: Servicorepository().getListaServicosRepository(
          uidProfissional: profissionalSelecionado.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widgetsdesign.carregamentoCircular(
              paddingVertical: heightTela * 0.07);
        }
        if (snapshot.data!.isEmpty) {
          return widgetsdesign.mensagempersonalizadaCenter(
              cor: Colors.white, label: "Nenhum serviço disponível!");
        }
        if (snapshot.hasData) {
          return Column(
            children: [
              SizedBox(
                width: widthTela * 0.90,
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.spaceBetween,
                  children: List.generate(snapshot.data!.length, (index) {
                    Servico servico = Servico(
                        nome: snapshot.data![index].nome,
                        valor: snapshot.data![index].valor,
                        urlImg: snapshot.data![index].urlImg,
                        uid: snapshot.data![index].uid,
                        ativoLadingpage: snapshot.data![index].ativoLadingpage,
                        ativo: snapshot.data![index].ativo);

                    if (servico.ativo) {
                      servicosSelecionados
                          .add({"ativado": false, "servico": servico});
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (servicosSelecionados[index]["ativado"] ==
                                true) {
                              servicosSelecionados[index]["ativado"] = false;
                            } else {
                              servicosSelecionados[index]["ativado"] = true;
                            }
                          });

                          print("servico: ${servicosSelecionados[1]}");
                        },
                        child: widgetsdesign.cardServico(
                            nomeServico: servico.nome,
                            valor: UtilBrasilFields.obterReal(servico.valor,
                                moeda: true, decimal: 2),
                            heightImg: heightTela * 0.14,
                            width: widthTela * 0.40,
                            widthImg: widthTela,
                            selecionadoItem: servicosSelecionados[index]
                                ["ativado"],
                            urlImg: servico.urlImg),
                      );
                    }

                    return Container();
                  }),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buttonContinuar(servicosSelecionados: servicosSelecionados),
              SizedBox(
                height: 25,
              ),
            ],
          );
        }
        return widgetsdesign.mensagemTentaMaisTarde(cor: Colors.white);
      },
    );
  }

  Widget buttonContinuar(
      {required List<Map<String, dynamic>> servicosSelecionados}) {
    List<Servico> servicos = [];

    for (var servivo in servicosSelecionados) {
      if (servivo['ativado'] == true) {
        servicos.add(servivo['servico']);
      }
    }

    return ElevatedButton.icon(
        onPressed: () async {
          if (servicosSelecionados.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HorarioView(
                      dataSelecionada: widget.dataSelecionada,
                      dataSelecionadaNome: widget.dataSelecionadaNome,
                      dateTimeSelecionado: widget.dateTimeSelecionado,
                      profissional: profissionalSelecionado!,
                      servicos: servicos),
                ));
          } else {
            EasyLoading.showToast("Nenhum serviço selecionado!");
          }
        },
        style: ButtonStyle(
            elevation: WidgetStatePropertyAll(4),
            alignment: Alignment.center,
            overlayColor:
                WidgetStatePropertyAll(Color.fromARGB(255, 18, 18, 18)),
            surfaceTintColor:
                WidgetStatePropertyAll(Color.fromARGB(255, 46, 46, 46)),
            padding: WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
            shadowColor:
                WidgetStatePropertyAll(const Color.fromARGB(255, 0, 0, 0)),
            backgroundColor:
                WidgetStatePropertyAll(Color.fromARGB(255, 46, 46, 46))),
        label: Text(
          "Continuar",
          style: GoogleFonts.robotoCondensed(
              color: widgetsdesign.amareloColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;
    double heightTela = MediaQuery.of(context).size.height;

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
                          width: widthTela * 0.65),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      "Selecionar Profissional",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    getProfissionaisDisponiveis(
                        heightTela: heightTela, widthTela: widthTela),
                    SizedBox(
                      height: 15,
                    ),
                    if (indiceProfissionalAtual != null) ...[
                      Text(
                        "Serviços",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      getServicosProfissional(
                          widthTela: widthTela,
                          heightTela: heightTela,
                          profissionalSelecionado: profissionalSelecionado!),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
