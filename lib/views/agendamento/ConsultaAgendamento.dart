import 'package:agendamento_barber/models/Agendamento.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/utils/validation_mixins.dart';
import 'package:agendamento_barber/views/agendamento/detalhes_agendamento.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ConsultaAgendamento extends StatefulWidget {
  const ConsultaAgendamento({super.key});

  @override
  State<ConsultaAgendamento> createState() => _ConsultaAgendamentoState();
}

class _ConsultaAgendamentoState extends State<ConsultaAgendamento>
    with ValidationMixins {
  final keyForm = GlobalKey<FormState>();

  List<Agendamento> agendamentos = [];

  TextEditingController telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;
    double heightTela = MediaQuery.of(context).size.height;
    Widgetsdesign widgetsdesign = Widgetsdesign();

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
                  "Ex: 61983756651",
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

    Widget agendamentosCard() {
      return SizedBox(
          width: widthTela * 0.92,
          child: Column(
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
              Wrap(
                direction: Axis.vertical,
                runAlignment: WrapAlignment.center,
                children: List.generate(
                  agendamentos.length,
                  (index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalhesAgendamento(
                                      agendamento: agendamentos[index]),
                                ));
                          },
                          child: widgetsdesign.cardMeuAgendamentoConsulta(
                              data: agendamentos[index].data,
                              diaDaSemana: agendamentos[index].diaDaSemana,
                              nome: agendamentos[index].nomeProfissional,
                              nomeServico:
                                  '${agendamentos[index].servicos.length} Serviços',
                              valorServico: UtilBrasilFields.obterReal(
                                  agendamentos[index].totalAgendamento,
                                  decimal: 2,
                                  moeda: true),
                              horario: agendamentos[index].horario,
                              heightFoto: heightTela * 0.12,
                              urlFotoServico:
                                  agendamentos[index].servicos[0].urlImg,
                              width: widthTela * 0.90),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ));
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
                    widgetsdesign.getCabecalhoDesingConsulta(
                        label: "Consultar Agendamento",
                        colorLabel: Colors.white,
                        fontWeight: FontWeight.w400,
                        context: context,
                        colorborder: widgetsdesign.amareloSecudarioColor),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Digite o Nr do seu teledone cadastrado no\nagendamento para consulta sua reserva.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    formularioAgendamento(),
                    agendamentosCard(),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: widgetsdesign.buttonIcon(
                          padding: EdgeInsets.only(
                              left: 50, right: 50, top: 5, bottom: 5),
                          icon: Icon(
                            FontAwesomeIcons.search,
                            color: widgetsdesign.amareloColor,
                            size: 23,
                          ),
                          label: "Consultar",
                          onPressed: () async {
                            if (!keyForm.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('formulario Incompleto'),
                                ),
                              );
                            } else {
                              String telefoneFormatado = telefoneController.text
                                  .replaceAll(RegExp(r'[^\d]+'), '');
                              Agendamentorepository()
                                  .buscarAgendamentosRepository(
                                      idEstabelecimento: 1,
                                      telefoneCliente: telefoneFormatado)
                                  .then(
                                (List<Agendamento> agendamentosResultado) {
                                  setState(() {
                                    agendamentos = agendamentosResultado;
                                  });
                                },
                              );
                            }
                          }),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: widgetsdesign.buttonIcon(
                          padding: EdgeInsets.only(
                              left: 50, right: 50, top: 5, bottom: 5),
                          icon: Icon(
                            FontAwesomeIcons.close,
                            color: widgetsdesign.amareloColor,
                            size: 23,
                          ),
                          label: "Fechar",
                          onPressed: () {
                            Navigator.pop(context);
                          }),
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
