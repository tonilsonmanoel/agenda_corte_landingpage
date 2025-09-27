import 'package:agendamento_barber/models/Agendamento.dart';
import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/agendamentoRepository.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EditarAgendamento extends StatefulWidget {
  const EditarAgendamento(
      {super.key, required this.agendamento, required this.estabelecimento});
  final Estabelecimento estabelecimento;
  final Agendamento agendamento;
  @override
  _EditarAgendamentoState createState() => _EditarAgendamentoState();
}

class _EditarAgendamentoState extends State<EditarAgendamento> {
  Widgetsdesign widgetsdesign = Widgetsdesign();

  TextEditingController nomeClienteController = TextEditingController();
  TextEditingController sobrenomeClienteController = TextEditingController();
  TextEditingController telefoneClientecontroller = TextEditingController();
  TextEditingController codeTelefoneClientecontroller = TextEditingController();
  TextEditingController isoCodeTelefoneClientecontroller =
      TextEditingController();
  TextEditingController telefoneControllerCompleto = TextEditingController();
  String diaDaSemana = '';
  String data = '';
  DateTime? dateTimeDia;
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

    if (widget.agendamento.nomeCliente.contains(" ")) {
      List<String> nomeCompleto = widget.agendamento.nomeCliente.split(" ");
      nomeClienteController.text = nomeCompleto[0];
      sobrenomeClienteController.text = nomeCompleto.sublist(1).join(" ");
    } else {
      nomeClienteController.text = widget.agendamento.nomeCliente;
    }

    telefoneClientecontroller.text = widget.agendamento.telefoneCliente;
    codeTelefoneClientecontroller.text = widget.agendamento.codeTelefoneCliente;
    isoCodeTelefoneClientecontroller.text = widget.agendamento.isoCodePhone;

    telefoneControllerCompleto.text =
        "${widget.estabelecimento.codeTelefone}${widget.estabelecimento.telefone}";
    totalAgendamento = widget.agendamento.totalAgendamento;
    data = widget.agendamento.data;
    diaDaSemana = widget.agendamento.diaDaSemana;
    dateTimeDia = widget.agendamento.dateTimeAgenda;
    loadDadosProfissinalAgendamento();

    super.initState();
  }

  void loadDadosServicosAgendamento() async {
    var resultServico = await Servicorepository().getListaServicosRepository(
        uidProfissional: widget.agendamento.uidProfissional);

    List<bool> resultBools = List<bool>.filled(resultServico.length, false);
    for (var i = 0; i < resultServico.length; i++) {
      for (var agendamentoServico in widget.agendamento.servicos) {
        if (resultServico[i].uid == agendamentoServico.uid) {
          resultBools[i] = true;
          servicosSelecionados.add(resultServico[i]);
        }
      }
    }

    setState(() {
      servicosBool = resultBools;
      servicos = resultServico;
    });
  }

  void loadDadosProfissinalAgendamento() async {
    Profissional profissional = Profissional(
        uid: widget.agendamento.uidProfissional,
        nome: widget.agendamento.nomeProfissional,
        isoCodePhone: "",
        isoCodePhoneWhatsapp: "",
        email: "",
        telefone: "",
        telefoneWhatsapp: "",
        codeTelefone: "",
        codeTelefoneWhatsapp: "",
        fotoPerfil: "",
        horariosTrabalho: [],
        diasTrabalho: [],
        perfil: "",
        status: true);
    var equipeResult = await Profissionalrepository()
        .getFuncionariosDisponivelRepository(
            diaDaSemana: diaDaSemana,
            idEstabecimento: widget.estabelecimento.uid!);
    List<String> nomesProfissionais = [];
    for (var profissional in equipeResult) {
      nomesProfissionais.add(profissional.nome);
    }

    List<String> horariosDisponiveis = await Agendamentorepository()
        .buscarHorariosdisponiveisProfissional(
            data: data, uidProfissional: widget.agendamento.uidProfissional);

    setState(() {
      profissionalSelecionado = profissional;
      dropdownvalueEquipe = widget.agendamento.nomeProfissional;
      itemsEquipe = nomesProfissionais;
      equipe = equipeResult;
      horariosDisponiveis.insert(0, widget.agendamento.horario);
      horariosDisponiveisProfissional = horariosDisponiveis;
      dropdownvalueHorario = widget.agendamento.horario;
    });
    loadDadosServicosAgendamento();
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
            diaDaSemana: diaDaSemana,
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
        profissionaisDisponiveis = true;
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
            data: data, uidProfissional: profissional.uid!)
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
    EasyLoading.dismiss();

    DateTime dateSelecionada = dateTimeDia ?? DateTime.now();

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
        .updateAgendamentoRepository(
      nomeCliente:
          "${nomeClienteController.text} ${sobrenomeClienteController.text}",
      telefoneCliente: telefoneClientecontroller.text,
      codeTelefoneCliente: codeTelefoneClientecontroller.text,
      isoCodePhone: isoCodeTelefoneClientecontroller.text,
      uidProfissional: profissionalSelecionado!.uid!,
      nomeProfissional: profissionalSelecionado!.nome,
      dataString: data,
      diaDaSemana: diaDaSemana,
      horario: dropdownvalueHorario,
      totalAgendamento: totalAgendamento,
      dateTime: dateTimeAgendamento,
      servicos: idsServicos,
      confimado: widget.agendamento.confimado,
      idEstabelecimento: widget.agendamento.idEstabelecimento,
      concluido: widget.agendamento.concluido ?? false,
      uidAgendamento: widget.agendamento.uid!,
    )
        .then(
      (value) {
        EasyLoading.dismiss();

        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    Widget formularioAgendamento() {
      return Container(
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
          children: [
            Wrap(
              direction: Axis.horizontal,
              children: [
                Text(
                  "Data:  ",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
                Text(
                  "$data - $diaDaSemana",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Alterar Data:  ",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                IconButton(
                    onPressed: () => {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    Color.fromARGB(255, 30, 30, 30),
                                title: Text(
                                  "Selecione a data",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                content: SingleChildScrollView(
                                  child: SizedBox(
                                      height: 350,
                                      width: ResponsiveBreakpoints.of(context)
                                              .largerThan(MOBILE)
                                          ? widthMedia * 0.6
                                          : widthMedia * 0.85,
                                      child: calendarioWidget()),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Fechar',
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        },
                    icon: Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    )),
              ],
            ),

            if (profissionaisDisponiveis) ...[
              //Inicio Selecionar Profissional
              Text(
                "Selecione um profissional",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(
                height: 15,
              ),

              if (itemsEquipe.isNotEmpty) ...[
                Center(
                  child: Card(
                    elevation: 6,
                    borderOnForeground: true,
                    surfaceTintColor: Colors.white,
                    shadowColor: const Color.fromARGB(255, 90, 90, 90),
                    color: Colors.white,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),

              for (var i = 0; i < servicos.length; i++) ...[
                Card(
                  elevation: 6,
                  borderOnForeground: true,
                  surfaceTintColor: Colors.white,
                  shadowColor: const Color.fromARGB(255, 90, 90, 90),
                  color: Colors.white,
                  child: CheckboxListTile(
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
                ),
                SizedBox(
                  height: 3,
                ),
              ],
              Text(
                "Total: ${UtilBrasilFields.obterReal(totalAgendamento, decimal: 2, moeda: true)}",
                style: GoogleFonts.roboto(
                    color: Colors.white, fontWeight: FontWeight.w500),
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              if (horariosDisponiveisProfissional.isNotEmpty) ...[
                Center(
                  child: Card(
                    elevation: 6,
                    borderOnForeground: true,
                    surfaceTintColor: Colors.white,
                    shadowColor: const Color.fromARGB(255, 90, 90, 90),
                    color: Colors.white,
                    child: DropdownButton(
                      value: dropdownvalueHorario,
                      style: GoogleFonts.roboto(color: Colors.black),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      items:
                          horariosDisponiveisProfissional.map((String horario) {
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    Text(
                      "Nome",
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.w700),
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
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Widgetsdesign().textFildLabel(
                        hintText: "", controller: sobrenomeClienteController),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Telefone Whatsapp",
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Card(
                      elevation: 6,
                      borderOnForeground: true,
                      surfaceTintColor: Colors.white,
                      shadowColor: const Color.fromARGB(255, 90, 90, 90),
                      color: Colors.white,
                      child: IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Numero Telefone',
                        ),
                        initialCountryCode: widget.agendamento.isoCodePhone,
                        controller: telefoneClientecontroller,
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
                        onCountryChanged: (value) {
                          isoCodeTelefoneClientecontroller.text = value.code;
                        },
                        onChanged: (phone) {
                          telefoneClientecontroller.text = phone.number;
                          codeTelefoneClientecontroller.text =
                              phone.countryCode;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthMedia * 0.04),
          child: Column(
            children: [
              widgetsdesign.cabecalhoConfiguracoes(
                label: "Modificar Agendamento",
                botaoWidget: Container(),
                sizeLabel: 22,
                searchCalender: false,
                colorLabel: widgetsdesign.amareloColor,
                fontWeight: FontWeight.w700,
                context: context,
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                  elevation: 5,
                  shadowColor: Colors.black,
                  surfaceTintColor: Color.fromARGB(255, 40, 40, 40),
                  color: Color.fromARGB(255, 40, 40, 40),
                  borderOnForeground: true,
                  child: formularioAgendamento()),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  widgetsdesign.buttonIcon(
                      icon: Container(),
                      label: "Voltar",
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  ElevatedButton.icon(
                      onPressed: () async {
                        if (!keyForm.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Complete o formulário")));
                        } else if (profissionalSelecionado == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Profissional não selecionado")));
                        } else if (horariosDisponiveisProfissional.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Horário não selecionado")));
                        } else if (servicosSelecionados.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Selecione ao menos um serviço")));
                        } else if (profissionaisDisponiveis == false) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Nenhum profissional disponível para o dia selecionado")));
                        } else {
                          salvarAgendamento();
                        }
                      },
                      style: ButtonStyle(
                          elevation: WidgetStatePropertyAll(4),
                          alignment: Alignment.center,
                          overlayColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 18, 18, 18)),
                          surfaceTintColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 46, 46, 46)),
                          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10)),
                          shadowColor: WidgetStatePropertyAll(
                              const Color.fromARGB(255, 0, 0, 0)),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 46, 46, 46))),
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
                      ))
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendarioWidget() {
    return CalendarDatePicker2(
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayHighlightColor: const Color.fromARGB(255, 194, 175, 3),
        dayTextStyle: const TextStyle(color: Colors.white),
        weekdayLabelTextStyle: const TextStyle(color: Colors.grey),
        controlsTextStyle: const TextStyle(color: Colors.white),
        yearTextStyle: const TextStyle(color: Colors.white),
        monthTextStyle: const TextStyle(color: Colors.white),
        firstDate: DateTime.now(),
        disabledDayTextStyle: const TextStyle(color: Colors.grey),
        disabledMonthTextStyle: const TextStyle(color: Colors.grey),
        selectedDayTextStyle: const TextStyle(color: Colors.black),
        lastMonthIcon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        nextMonthIcon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
      value: [],
      onValueChanged: (value) {
        String formattedDate = Utils().getDataFormat(value[0]);

        String formattedDateNameDia = Utils().getDiaNomeFormat(value[0]);

        setState(() {
          data = formattedDate;
          diaDaSemana = formattedDateNameDia;
          dateTimeDia = value[0];
          servicosSelecionados = [];
          servicosBool = [];
          servicos = [];
          totalAgendamento = 0;
        });
        carregarEquipe();
        Navigator.of(context).pop();
      },
    );
  }
}
