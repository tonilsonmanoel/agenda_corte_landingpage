import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/administrador/barbeiro_create.dart';
import 'package:agendamento_barber/views/administrador/barbeiro_editar.dart';
import 'package:agendamento_barber/views/administrador/servico_create.dart';
import 'package:agendamento_barber/views/administrador/servico_edit.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Administracao extends StatefulWidget {
  const Administracao(
      {super.key, required this.profissional, required this.estabelecimento});
  final Profissional profissional;
  final Estabelecimento estabelecimento;
  @override
  State<Administracao> createState() => _AdministracaoState();
}

class _AdministracaoState extends State<Administracao> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  Profissional? profissionalSelecionado;
  Servico? servicoSelecionado;
  int? indiceProfissionalAtual;
  List<Map<String, dynamic>> diasDaSemanalist = Utils().getDiasDaSemanaMap();
  List<bool> diasAtivados = List.generate(
    7,
    (index) => false,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget getProfissionaisDisponiveis(
      {required double widthTela, required double heightTela}) {
    return FutureBuilder(
      future: Profissionalrepository()
          .getTodosBarbeiros(idEstabecimento: widget.estabelecimento.uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widgetsdesign.carregamentoCircular(
              paddingVertical: heightTela * 0.07);
        }
        if (snapshot.data!.isEmpty) {
          return widgetsdesign.mensagempersonalizadaCenter(
              cor: Colors.white, label: "Nenhum Profissional Cadastrado");
        }

        if (snapshot.hasData) {
          return SizedBox(
            width: widthTela * 0.92,
            child: Column(
              children: [
                Center(
                  child: Wrap(
                      children: List.generate(
                    snapshot.data!.length,
                    (index) {
                      print(
                          " widget.profissional.perfil == ${widget.profissional.perfil}");
                      print(
                          "  widget.profissional.uid == ${widget.profissional.uid}");
                      print(
                          "  snapshot.data![index].uid == ${snapshot.data![index].uid}");
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            indiceProfissionalAtual = index;
                            profissionalSelecionado = Profissional(
                                nome: snapshot.data![index].nome,
                                email: snapshot.data![index].email,
                                telefone: snapshot.data![index].telefone,
                                codeTelefone:
                                    snapshot.data![index].codeTelefone,
                                uid: snapshot.data![index].uid,
                                perfil: snapshot.data![index].perfil,
                                telefoneWhatsapp:
                                    snapshot.data![index].telefoneWhatsapp,
                                codeTelefoneWhatsapp:
                                    snapshot.data![index].codeTelefoneWhatsapp,
                                fotoPerfil: snapshot.data![index].fotoPerfil,
                                idEstabelecimento:
                                    snapshot.data![index].idEstabelecimento,
                                horariosTrabalho:
                                    snapshot.data![index].horariosTrabalho,
                                isoCodePhone:
                                    snapshot.data![index].isoCodePhone,
                                isoCodePhoneWhatsapp:
                                    snapshot.data![index].isoCodePhoneWhatsapp,
                                diasTrabalho:
                                    snapshot.data![index].diasTrabalho,
                                status: snapshot.data![index].status);
                          });
                        },
                        child: Column(
                          children: [
                            widgetsdesign.cardProfissionalAdmin(
                              nomeProfissional: snapshot.data![index].nome,
                              width: ResponsiveBreakpoints.of(context)
                                      .largerOrEqualTo(DESKTOP)
                                  ? widthTela * 0.25
                                  : widthTela * 0.41,
                              widthImg: ResponsiveBreakpoints.of(context)
                                      .largerOrEqualTo(DESKTOP)
                                  ? widthTela * 0.25
                                  : widthTela * 0.41,
                              heightImg: ResponsiveBreakpoints.of(context)
                                      .largerOrEqualTo(DESKTOP)
                                  ? heightTela * 0.40
                                  : heightTela * 0.16,
                              ativadoProfissinal: snapshot.data![index].status,
                              selecionadoItem: indiceProfissionalAtual == index,
                              fotoPerfil: snapshot.data![index].fotoPerfil,
                              editarAtivado:
                                  widget.profissional.perfil == "admin" ||
                                      widget.profissional.uid ==
                                          snapshot.data![index].uid,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BarbeiroEditar(
                                        profissional: snapshot.data![index],
                                        estabelecimento: widget.estabelecimento,
                                      ),
                                    )).then(
                                  (value) => setState(() {}),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )),
                ),
                SizedBox(
                  height: 5,
                ),
                if (profissionalSelecionado != null &&
                    widget.profissional.perfil == "admin") ...[
                  widgetsdesign.buttonIcon(
                    icon: Icon(
                      Icons.person_add_alt_1_sharp,
                      color: Colors.yellow,
                      size: 30,
                    ),
                    label: "Adicionar Barbeiro",
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    onPressed: () {
                      if (snapshot.data!.length >= 10) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Limite Maximo de barbeiros atingido.")));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BarbeiroCreate(
                                estabelecimento: widget.estabelecimento,
                              ),
                            )).then(
                          (value) => setState(() {}),
                        );
                      }
                    },
                  ),
                ]
              ],
            ),
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
          return SizedBox(
            width: widthTela * 0.90,
            child: Center(
              child: Wrap(
                direction: Axis.horizontal,
                children: List.generate(snapshot.data!.length, (index) {
                  Servico servico = Servico(
                      nome: snapshot.data![index].nome,
                      valor: snapshot.data![index].valor,
                      urlImg: snapshot.data![index].urlImg,
                      uid: snapshot.data![index].uid,
                      idProfissional: snapshot.data![index].idProfissional,
                      ativoLadingpage: snapshot.data![index].ativoLadingpage,
                      ativo: snapshot.data![index].ativo);

                  return widgetsdesign.cardServicoAdmin(
                      nomeServico: servico.nome,
                      valor: UtilBrasilFields.obterReal(servico.valor,
                          decimal: 2, moeda: true),
                      heightImg: ResponsiveBreakpoints.of(context)
                              .largerOrEqualTo(DESKTOP)
                          ? heightTela * 0.30
                          : heightTela * 0.14,
                      width: ResponsiveBreakpoints.of(context)
                              .largerOrEqualTo(DESKTOP)
                          ? widthTela * 0.26
                          : widthTela * 0.41,
                      widthImg: ResponsiveBreakpoints.of(context)
                              .largerOrEqualTo(DESKTOP)
                          ? widthTela * 0.26
                          : widthTela * 0.41,
                      ativadoProfissinal: servico.ativo,
                      editarAtivado: widget.profissional.uid ==
                              profissionalSelecionado.uid ||
                          widget.profissional.perfil == "admin",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServicoEdit(
                                servico: servico,
                                perfil: widget.profissional.perfil,
                                uidProfissional: profissionalSelecionado.uid!,
                              ),
                            )).then(
                          (value) => setState(() {}),
                        );
                      },
                      urlImg: servico.urlImg);
                }),
              ),
            ),
          );
        }
        return widgetsdesign.mensagemTentaMaisTarde(cor: Colors.white);
      },
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
              widgetsdesign.getCabecalhoDesingTitulo(
                  label: "Administração",
                  buscarWidget: Container(),
                  botaoWidget: Container(),
                  colorLabel: widgetsdesign.amareloColor,
                  fontWeight: FontWeight.w700,
                  context: context,
                  paddingTop: 65),
              getProfissionaisDisponiveis(
                  widthTela: widthMedia, heightTela: heitghMedia),
              SizedBox(
                height: 10,
              ),
              if (indiceProfissionalAtual != null) ...[
                Text(
                  "Meus Serviços",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 5,
                ),
                getServicosProfissional(
                    widthTela: widthMedia,
                    heightTela: heitghMedia,
                    profissionalSelecionado: profissionalSelecionado!),
                SizedBox(
                  height: 10,
                ),
                if (profissionalSelecionado != null &&
                    (widget.profissional.uid == profissionalSelecionado!.uid ||
                        widget.profissional.perfil == "admin")) ...[
                  widgetsdesign.buttonIcon(
                    icon: Icon(
                      Icons.add,
                      color: Colors.yellow,
                      size: 30,
                    ),
                    label: "Adicionar Serviço",
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicoCreate(
                                perfil: widget.profissional.perfil,
                                uidProfissional: profissionalSelecionado!.uid!),
                          )).then((value) => setState(() {}));
                    },
                  ),
                ],
                SizedBox(
                  height: 10,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
