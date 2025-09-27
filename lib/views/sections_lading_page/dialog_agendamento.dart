import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogAgendamento extends StatefulWidget {
  const DialogAgendamento(
      {super.key,
      required this.data,
      required this.dataDia,
      required this.dateTimeDia,
      required this.estabelecimento});
  final String data;
  final String dataDia;
  final DateTime dateTimeDia;
  final Estabelecimento estabelecimento;
  @override
  State<DialogAgendamento> createState() => _DialogAgendamentoState();
}

class _DialogAgendamentoState extends State<DialogAgendamento> {
  TextEditingController nomeClienteController = TextEditingController();
  TextEditingController sobrenomeClienteController = TextEditingController();
  TextEditingController telefoneClientecontroller = TextEditingController();
  TextEditingController codeTelefoneClientecontroller = TextEditingController();
  TextEditingController isoCodeTelefoneClientecontroller =
      TextEditingController();
  final keyForm = GlobalKey<FormState>();

  List<Servico> servicos = [];
  List<Servico> servicosSelecionados = [];
  List<bool> servicosBool = [];

  List<Profissional> equipe = [];
  String dropdownvalueEquipe = '';
  List<String> itemsEquipe = [];
  Profissional? profissionalSelecionado;

  String dropdownvalueHorario = '';
  List<String> horariosDisponiveisProfissional = [];

  double totalAgendamento = 0;
  bool profissionaisDisponiveis = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarEquipe();
  }

  void carregarServicos({required Profissional profissional}) async {
    var resultServico = await Servicorepository()
        .getListaServicosRepository(uidProfissional: profissional.uid!);

    List<bool> resultBools = List<bool>.filled(resultServico.length, false);
    setState(() {
      servicosBool = resultBools;
      servicos = resultServico;
    });
  }

  void carregarEquipe() async {
    var equipeResult = await Profissionalrepository()
        .getFuncionariosDisponivelRepository(
            diaDaSemana: widget.dataDia,
            idEstabecimento: widget.estabelecimento.uid!);
    if (equipeResult.isEmpty) {
      setState(() {
        profissionaisDisponiveis = false;
      });
    } else {
      List<String> nomesProfissionais = [];
      for (var profissional in equipeResult) {
        nomesProfissionais.add(profissional.nome);
      }
      setState(() {
        dropdownvalueEquipe = nomesProfissionais[0];
        itemsEquipe = nomesProfissionais;
        equipe = equipeResult;
        profissionalSelecionado = equipeResult[0];
      });
      carregarServicos(profissional: equipeResult[0]);
      carregarHorarios(profissional: equipeResult[0]);
    }
  }

  void carregarHorarios({required Profissional profissional}) async {
    Agendamentorepository()
        .buscarHorariosdisponiveisProfissional(
            data: widget.data, uidProfissional: profissional.uid!)
        .then(
      (value) {
        setState(() {
          dropdownvalueHorario = value[0];
          horariosDisponiveisProfissional = value;
        });
      },
    );
  }

  void salvarAgendamento() async {
    EasyLoading.show(
      dismissOnTap: false,
      status: "Carregando...",
    );

    DateTime dateSelecionada = widget.dateTimeDia;

    String horaLabel = dropdownvalueHorario.substring(0, 2);

    String minutoLabel = dropdownvalueHorario.substring(3, 5);

    DateTime dateTimeAgendamento = DateTime(
        dateSelecionada.year,
        dateSelecionada.month,
        dateSelecionada.day,
        int.parse(horaLabel),
        int.parse(minutoLabel));

    List<int> idsServicos = [];
    for (var servico in servicosSelecionados) {
      idsServicos.add(servico.uid!);
    }
    await Agendamentorepository()
        .criarAgendamento(
            nomeCliente:
                "${nomeClienteController.text} ${sobrenomeClienteController.text}",
            telefoneCliente: telefoneClientecontroller.text,
            codeTelefoneCliente: codeTelefoneClientecontroller.text,
            uidProfissional: profissionalSelecionado!.uid!,
            nomeProfissional: profissionalSelecionado!.nome,
            dataString: widget.data,
            diaDaSemana: widget.dataDia,
            horario: dropdownvalueHorario,
            totalAgendamento: totalAgendamento,
            dateTime: dateTimeAgendamento,
            servicos: idsServicos,
            isoCodePhone: isoCodeTelefoneClientecontroller.text,
            idEstabelecimento: widget.estabelecimento.uid!,
            confimado: false)
        .then(
      (value) {
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Agendamento Realizado, Em breve entraremos em contato para confirmação.")));

        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.all(20),
      title: Text(
        "AGENDAMENTO",
        style: GoogleFonts.robotoCondensed(
            color: Colors.black, fontSize: 35, fontWeight: FontWeight.bold),
      ),
      children: [
        Wrap(
          direction: Axis.horizontal,
          children: [
            Text(
              "Data:  ",
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
            Text(
              "${widget.data} - ${widget.dataDia}",
              style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
          ],
        ),

        if (profissionaisDisponiveis) ...[
          //Inicio Selecionar Profissional
          Text(
            "Selecione um profissional",
            style: GoogleFonts.roboto(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 15,
          ),

          if (itemsEquipe.isNotEmpty) ...[
            Center(
              child: DropdownButton(
                value: dropdownvalueEquipe,
                style: GoogleFonts.roboto(color: Colors.black),
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                items: itemsEquipe.map((String item) {
                  return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                        ),
                      ));
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    for (var profissional in equipe) {
                      if (newValue == profissional.nome) {
                        carregarServicos(profissional: profissional);
                        carregarHorarios(profissional: profissional);
                        profissionalSelecionado = profissional;
                      }
                    }
                    setState(() {
                      dropdownvalueEquipe = newValue;
                      servicosSelecionados = [];
                      totalAgendamento = 0;
                    });
                  }
                },
              ),
            ),
          ] else ...[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
          //Fim Selecionar Profissional
          SizedBox(
            height: 15,
          ),
          //Inicio Serviços
          Text(
            "Selecione os serviços",
            style: GoogleFonts.roboto(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),

          for (var i = 0; i < servicos.length; i++) ...[
            CheckboxListTile(
              value: servicosBool[i],
              onChanged: (value) {
                if (value != null && value) {
                  setState(() {
                    servicosBool[i] = true;
                    servicosSelecionados.add(servicos[i]);
                    totalAgendamento += servicos[i].valor;
                  });
                } else {
                  setState(() {
                    servicosBool[i] = false;
                    servicosSelecionados.remove(servicos[i]);
                    totalAgendamento -= servicos[i].valor;
                  });
                }
              },
              title: Text(
                "${servicos[i].nome}....${UtilBrasilFields.obterReal(servicos[i].valor, decimal: 2, moeda: true)}",
                style: GoogleFonts.roboto(
                    color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 3,
            ),
          ],
          Text(
            "Total: ${UtilBrasilFields.obterReal(totalAgendamento, decimal: 2, moeda: true)}",
            style: GoogleFonts.roboto(
                color: Colors.black, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 3,
          ),

          SizedBox(
            height: 10,
          ),
          //Fim Serviços
          //Inicio Horarios
          Text(
            "Selecione o horário",
            style: GoogleFonts.roboto(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(
            height: 10,
          ),
          if (horariosDisponiveisProfissional.isNotEmpty) ...[
            Center(
              child: DropdownButton(
                value: dropdownvalueHorario,
                style: GoogleFonts.roboto(color: Colors.black),
                icon: const Icon(Icons.keyboard_arrow_down),
                isExpanded: true,
                items: horariosDisponiveisProfissional.map((String horario) {
                  return DropdownMenuItem(
                      value: horario,
                      child: Text(
                        horario,
                        style: GoogleFonts.roboto(
                          color: Colors.black,
                        ),
                      ));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalueHorario = newValue!;
                  });
                },
              ),
            ),
          ] else ...[
            Center(
              child: CircularProgressIndicator(),
            )
          ],

          //Fim selecionar Horarios
        ] else ...[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Nenhum profissional disponível para o dia selecionado",
                style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],

        //Inicio Dados Pessoais
        Form(
          key: keyForm,
          child: Center(
            child: Column(
              children: [
                Text(
                  "Dados Pessoais",
                  style: GoogleFonts.roboto(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                Text(
                  "Nome",
                  style: GoogleFonts.roboto(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Widgetsdesign().textFildLabel(
                  hintText: "",
                  controller: nomeClienteController,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Sobrenome",
                  style: GoogleFonts.roboto(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                Widgetsdesign().textFildLabel(
                    hintText: "", controller: sobrenomeClienteController),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Telefone Whatsapp",
                  style: GoogleFonts.roboto(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Numero Telefone',
                  ),
                  initialCountryCode: 'BR',
                  validator: (value) {
                    // Example: require a value
                    if (value == null || value.number.isEmpty) {
                      return 'Por favor insira um número de telefone';
                    }
                    if (value.isValidNumber() == false) {
                      return 'Por favor insira um número de telefone válido';
                    }
                    return null;
                  },
                  onChanged: (phone) {
                    isoCodeTelefoneClientecontroller.text =
                        phone.countryISOCode;
                    telefoneClientecontroller.text = phone.number;
                    codeTelefoneClientecontroller.text = phone.countryCode;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ))),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.red.shade700),
                            shadowColor:
                                WidgetStatePropertyAll(Colors.red.shade900),
                            elevation: WidgetStatePropertyAll(3),
                          ),
                          child: Text(
                            "Fechar",
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (!keyForm.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Complete o formulário")));
                            } else if (profissionalSelecionado == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Profissional não selecionado")));
                            } else if (profissionaisDisponiveis == false) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Nenhum profissional disponível para o dia selecionado")));
                            } else if (servicosSelecionados.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Selecione ao menos um serviço")));
                            } else if (horariosDisponiveisProfissional
                                .isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Horário não selecionado")));
                            } else {
                              salvarAgendamento();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                const Color.fromARGB(202, 240, 108, 0)),
                            shadowColor:
                                WidgetStatePropertyAll(Colors.yellow.shade800),
                            elevation: WidgetStatePropertyAll(3),
                          ),
                          child: Text(
                            "Agendar",
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
