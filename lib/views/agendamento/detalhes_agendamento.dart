import 'package:agendamento_barber/models/Agendamento.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetalhesAgendamento extends StatefulWidget {
  const DetalhesAgendamento({super.key, required this.agendamento});
  final Agendamento agendamento;

  @override
  State<DetalhesAgendamento> createState() => _DetalhesAgendamentoState();
}

class _DetalhesAgendamentoState extends State<DetalhesAgendamento> {
  Widgetsdesign widgetsdesign = Widgetsdesign();

  Widget servicoContainer({required Servico servico}) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.white,
        width: 1,
      ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AutoSizeText(
              servico.nome,
              maxLines: 2,
              style: GoogleFonts.roboto(
                  color: Colors.grey.shade100,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            UtilBrasilFields.obterReal(servico.valor, decimal: 2, moeda: true),
            style: GoogleFonts.roboto(
                color: Colors.grey.shade100,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
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
              SizedBox(
                height: 15,
              ),
              widgetsdesign.getCabecalhoDesingTitulo(
                label: "Detalhes Agendamento",
                botaoWidget: Container(),
                buscarWidget: Container(),
                colorLabel: Colors.white,
                fontWeight: FontWeight.w400,
                context: context,
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.agendamento.servicos[0].urlImg,
                    fit: BoxFit.cover,
                    height: heitghMedia * 0.25,
                    width: widthMedia * 0.75,
                  )),
              SizedBox(
                height: 25,
              ),
              Card(
                elevation: 5,
                shadowColor: Colors.black,
                surfaceTintColor: Color.fromARGB(255, 46, 46, 46),
                color: Color.fromARGB(255, 46, 46, 46),
                borderOnForeground: true,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade800,
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  width: widthMedia * 0.85,
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Cliente",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.agendamento.nomeCliente,
                        style: GoogleFonts.roboto(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Telefone",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        UtilBrasilFields.obterTelefone(
                            widget.agendamento.telefoneCliente,
                            ddd: true,
                            mascara: true),
                        style: GoogleFonts.roboto(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Serviços",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      for (var servico in widget.agendamento.servicos) ...[
                        servicoContainer(servico: servico),
                        SizedBox(height: 10),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "Total",
                              maxLines: 2,
                              style: GoogleFonts.roboto(
                                  color: Colors.grey.shade100,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            UtilBrasilFields.obterReal(
                                widget.agendamento.totalAgendamento,
                                decimal: 2,
                                moeda: true),
                            style: GoogleFonts.roboto(
                                color: Colors.grey.shade100,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Barbeiro",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.agendamento.nomeProfissional,
                        style: GoogleFonts.roboto(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Dia da Semana",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.agendamento.diaDaSemana,
                        style: GoogleFonts.roboto(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Data e Hora Agendada",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${widget.agendamento.data}  ${widget.agendamento.horario}",
                        style: GoogleFonts.roboto(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Status do Agendamento",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      widget.agendamento.confimado
                          ? Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  "Confirmado",
                                  style: GoogleFonts.roboto(
                                      color: Colors.grey.shade200,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.green.shade800,
                                )
                              ],
                            )
                          : Wrap(
                              direction: Axis.horizontal,
                              children: [
                                Text(
                                  "Não confirmado",
                                  style: GoogleFonts.roboto(
                                      color: Colors.grey.shade200,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: widgetsdesign.buttonIcon(
                    padding:
                        EdgeInsets.only(left: 50, right: 50, top: 5, bottom: 5),
                    icon: Container(),
                    label: "Voltar",
                    fontWeight: FontWeight.w600,
                    sizeText: 23,
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
