import 'package:agendamento_barber/models/Agendamento.dart';
import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/administrador/editar_agendamento.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAgendamentoAdmin extends StatefulWidget {
  const DetalhesAgendamentoAdmin(
      {super.key, required this.agendamento, required this.estabelecimento});
  final Agendamento agendamento;
  final Estabelecimento estabelecimento;
  @override
  State<DetalhesAgendamentoAdmin> createState() =>
      _DetalhesAgendamentoAdminState();
}

class _DetalhesAgendamentoAdminState extends State<DetalhesAgendamentoAdmin> {
  Widgetsdesign widgetsdesign = Widgetsdesign();

  bool confimado = false;
  bool concluido = false;

  @override
  void initState() {
    super.initState();
    confimado = widget.agendamento.confimado;
    concluido = widget.agendamento.concluido ?? false;
  }

  Widget buttonSalvar() {
    return ElevatedButton.icon(
        onPressed: () async {
          EasyLoading.show(
            status: "Carregando...",
            dismissOnTap: false,
          );

          Agendamento agendamentoUpdate = Agendamento(
              uidProfissional: widget.agendamento.uidProfissional,
              codeTelefoneCliente: widget.agendamento.codeTelefoneCliente,
              data: widget.agendamento.data,
              horario: widget.agendamento.horario,
              totalAgendamento: widget.agendamento.totalAgendamento,
              dateTimeAgenda: widget.agendamento.dateTimeAgenda,
              servicos: widget.agendamento.servicos,
              diaDaSemana: widget.agendamento.diaDaSemana,
              confimado: confimado,
              nomeCliente: widget.agendamento.nomeCliente,
              nomeProfissional: widget.agendamento.nomeProfissional,
              concluido: concluido,
              uid: widget.agendamento.uid,
              idEstabelecimento: widget.agendamento.idEstabelecimento,
              isoCodePhone: widget.agendamento.isoCodePhone,
              telefoneCliente: widget.agendamento.telefoneCliente);

          Agendamentorepository()
              .updateStatusAgendamentoRepository(
                  concluido: concluido,
                  confimado: confimado,
                  uidAgendamento: widget.agendamento.uid!)
              .then(
            (value) {
              EasyLoading.dismiss();
              Navigator.pop(context);
            },
          );
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
          FontAwesomeIcons.save,
          size: 27,
          color: widgetsdesign.amareloColor,
        ),
        label: Text(
          "Salvar",
          style: GoogleFonts.robotoCondensed(
              color: widgetsdesign.amareloColor,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ));
  }

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
              widgetsdesign.getCabecalhoDetalhes(
                label: "Detalhes Agendamento",
                botaoWidget: Container(),
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
                surfaceTintColor: Color.fromARGB(255, 40, 40, 40),
                color: Color.fromARGB(255, 40, 40, 40),
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
                      Row(
                        children: [
                          Text(
                            "Telefone",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${widget.agendamento.codeTelefoneCliente} ${widget.agendamento.telefoneCliente}",
                            style: GoogleFonts.roboto(
                                color: Colors.grey.shade200,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              onPressed: () async {
                                var servicos = await Servicorepository()
                                    .getServicosAgendamento(
                                        idAgendamento: widget.agendamento.uid!);
                                String servicosUri = "";
                                double totalServico = 0;
                                for (var servico in servicos) {
                                  servicosUri +=
                                      "* ${servico.nome}...${UtilBrasilFields.obterReal(servico.valor, decimal: 2, moeda: true)}\n";
                                  totalServico += servico.valor;
                                }

                                String text =
                                    "Olá, ${widget.agendamento.nomeCliente}!\nAqui é da barbearia ${widget.estabelecimento.nome}.\nSeu horário está confirmado para ${widget.agendamento.data} às ${widget.agendamento.horario} com o barbeiro ${widget.agendamento.nomeProfissional}.\nEndereço: ${widget.estabelecimento.endereco}\nServiços: \n$servicosUri\nTotal: ${UtilBrasilFields.obterReal(totalServico, decimal: 2, moeda: true)}\nSe precisar reagendar ou cancelar, é só nos avisar.\nAté lá";
                                String enconded = Uri.encodeComponent(text);
                                final Uri _url = Uri.parse(
                                    'https://wa.me/${widget.agendamento.codeTelefoneCliente.replaceAll("+", "")}${widget.agendamento.telefoneCliente}?text=$enconded');
                                if (!await launchUrl(_url)) {
                                  throw Exception('Could not launch $_url');
                                }
                              },
                              icon: Image.asset(
                                "asset/whatsapp.png",
                                height: 25,
                                width: 25,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 15,
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
                        height: 10,
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
              SizedBox(
                width: widthMedia * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Confimado",
                      style: GoogleFonts.roboto(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: confimado,
                      onChanged: (value) {
                        setState(() {
                          confimado = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: widthMedia * 0.85,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Concluido",
                      style: GoogleFonts.roboto(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: concluido,
                      onChanged: (value) {
                        setState(() {
                          concluido = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widgetsdesign.buttonIcon(
                      icon: SizedBox(),
                      label: "Voltar",
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  widgetsdesign.buttonIcon(
                      icon: Icon(FontAwesomeIcons.pen,
                          size: 20, color: widgetsdesign.amareloColor),
                      label: "Editar",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarAgendamento(
                                  agendamento: widget.agendamento,
                                  estabelecimento: widget.estabelecimento),
                            ));
                      }),
                  buttonSalvar(),
                ],
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
