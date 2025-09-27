import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/Homepage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfimaAgendamento extends StatefulWidget {
  const ConfimaAgendamento(
      {super.key,
      required this.dataSelecionada,
      required this.dataSelecionadaNome,
      required this.dateTimeSelecionado,
      required this.horario,
      required this.profissional,
      required this.totalAgendamento,
      required this.servicos});

  final String dataSelecionada;
  final String dataSelecionadaNome;
  final DateTime dateTimeSelecionado;
  final List<Servico> servicos;
  final Profissional profissional;
  final double totalAgendamento;
  final String horario;

  @override
  State<ConfimaAgendamento> createState() => _ConfimaAgendamentoState();
}

class _ConfimaAgendamentoState extends State<ConfimaAgendamento> {
  final keyForm = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;
    Widgetsdesign widgetsdesign = Widgetsdesign();

    Widget buttonAgendamento() {
      return ElevatedButton.icon(
          onPressed: () {
            if (keyForm.currentState!.validate()) {
              EasyLoading.show(
                status: "Carregando...",
                dismissOnTap: false,
              );
              List<int> idsServicos = [];
              for (var servico in widget.servicos) {
                idsServicos.add(servico.uid!);
              }

              String telefoneFormatado =
                  telefoneController.text.replaceAll(RegExp(r'[^\d]+'), '');

              Agendamentorepository()
                  .criarAgendamento(
                      nomeCliente: nomeController.text,
                      telefoneCliente: telefoneFormatado,
                      codeTelefoneCliente: "",
                      uidProfissional: widget.profissional.uid!,
                      isoCodePhone: telefoneFormatado,
                      nomeProfissional: widget.profissional.nome,
                      dataString: widget.dataSelecionada,
                      diaDaSemana: widget.dataSelecionadaNome,
                      horario: widget.horario,
                      totalAgendamento: widget.totalAgendamento,
                      servicos: idsServicos,
                      dateTime: widget.dateTimeSelecionado,
                      idEstabelecimento: 0,
                      confimado: false)
                  .then(
                (value) {
                  EasyLoading.showSuccess("Agendamento Realizado\nCom Sucesso",
                      duration: Duration(seconds: 2));
                  EasyLoading.dismiss();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Homepage(),
                      ));
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Confira os campos do formulario")));
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
          icon: Icon(
            FontAwesomeIcons.check,
            size: 27,
            color: widgetsdesign.amareloColor,
          ),
          label: Text(
            "Confirma Agendamento",
            style: GoogleFonts.robotoCondensed(
                color: widgetsdesign.amareloColor,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          ));
    }

    Widget formularioAgendamento() {
      return Column(
        children: [
          Form(
            key: keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Digite seu Nome",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                widgetsdesign.textFildLabel(
                    hintText: "Informe seu nome", controller: nomeController),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Telefone com DDD",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                widgetsdesign.textFildTelefone(
                    hintText: "Informa seu telefone",
                    textInputType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    controller: telefoneController),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(),
        ],
      );
    }

    Widget servicoContainer({required Servico servico}) {
      return Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white, width: 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AutoSizeText(
                servico.nome,
                maxLines: 2,
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              UtilBrasilFields.obterReal(servico.valor,
                  decimal: 2, moeda: true),
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

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
                    widgetsdesign.getCabecalhoDesingConfirmaAgendamento(
                        label: "Confirmar Agendamento",
                        colorLabel: Colors.white,
                        context: context,
                        fontWeight: FontWeight.w300,
                        colorborder: Colors.white),
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
                              widget.totalAgendamento,
                              decimal: 2,
                              moeda: true),
                          horario: widget.horario,
                          width: widthTela * 0.65),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Serviços:",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    for (var servico in widget.servicos) ...[
                      servicoContainer(servico: servico),
                      SizedBox(height: 10),
                    ],
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Informações Pessoais:",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    formularioAgendamento(),
                    SizedBox(
                      height: 10,
                    ),
                    Center(child: buttonAgendamento()),
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
