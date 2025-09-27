import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/repository/storage_service.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/views/administrador/barbeiro_horarios.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class BarbeiroEditar extends StatefulWidget {
  const BarbeiroEditar(
      {super.key, required this.profissional, required this.estabelecimento});
  final Profissional profissional;
  final Estabelecimento estabelecimento;
  @override
  State<BarbeiroEditar> createState() => _BarbeiroEditarState();
}

class _BarbeiroEditarState extends State<BarbeiroEditar> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  Uint8List? imgMemoryPicked;
  final keyForm = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController codeTelefoneController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController telefoneCompletoController = TextEditingController();
  TextEditingController codeTelefoneWhatsappControler = TextEditingController();
  TextEditingController telefoneWhatsappControler = TextEditingController();
  TextEditingController telefoneWhatsappCompletoControler =
      TextEditingController();
  TextEditingController isoCodeTelefoneControler = TextEditingController();
  TextEditingController isoCodeTelefoneWhatsappControler =
      TextEditingController();
  String fotoPerfil = "";
  bool status = true;
  List<Map<String, dynamic>> diasdaSemanaJson = [];

  String dropdownvalue = 'admin';

  // List of items in our dropdown menu
  var items = ['admin', 'barbeiro'];

  void carregarDados() {
    setState(() {
      diasdaSemanaJson =
          Utils().completarDiasDaSemana(widget.profissional.diasTrabalho);
      fotoPerfil = widget.profissional.fotoPerfil;
      nomeController.text = widget.profissional.nome;
      dropdownvalue = widget.profissional.perfil;
      emailControler.text = widget.profissional.email;
      codeTelefoneController.text = widget.profissional.codeTelefone;
      telefoneController.text = widget.profissional.telefone;
      codeTelefoneWhatsappControler.text =
          widget.profissional.codeTelefoneWhatsapp;
      isoCodeTelefoneControler.text = widget.profissional.isoCodePhone;
      isoCodeTelefoneWhatsappControler.text =
          widget.profissional.isoCodePhoneWhatsapp;
      telefoneWhatsappControler.text = widget.profissional.telefoneWhatsapp;

      status = widget.profissional.status;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    carregarDados();
  }

  Widget diasDaSemana() {
    return Column(
      children: List.generate(diasdaSemanaJson.length, (index) {
        return ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Checkbox(
            value: diasdaSemanaJson[index]["ativado"],
            onChanged: (value) {
              setState(() {
                diasdaSemanaJson[index]["ativado"] = value!;
              });
            },
          ),
          title: Text(
            diasdaSemanaJson[index]["dia"],
            style: TextStyle(color: Colors.white),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;

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
                  "Nome",
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
                  "Email",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                widgetsdesign.textFildEmail(
                    hintText: "Informe seu email", controller: emailControler),
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
                Card(
                  elevation: 6,
                  borderOnForeground: true,
                  surfaceTintColor: Colors.white,
                  shadowColor: const Color.fromARGB(255, 90, 90, 90),
                  color: Colors.white,
                  child: IntlPhoneField(
                    controller: telefoneController,
                    decoration: InputDecoration(
                      labelText: 'Numero Telefone',
                    ),
                    initialCountryCode: isoCodeTelefoneControler.text,
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
                      isoCodeTelefoneControler.text = value.code;
                    },
                    onChanged: (phone) {
                      telefoneController.text = phone.number;
                      telefoneCompletoController.text = phone.countryCode;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Telefone Whatsapp",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  elevation: 6,
                  borderOnForeground: true,
                  surfaceTintColor: Colors.white,
                  shadowColor: const Color.fromARGB(255, 90, 90, 90),
                  color: Colors.white,
                  child: IntlPhoneField(
                    controller: telefoneWhatsappControler,
                    decoration: InputDecoration(
                      labelText: 'Numero Telefone',
                    ),
                    initialCountryCode: isoCodeTelefoneWhatsappControler.text,
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
                      isoCodeTelefoneWhatsappControler.text = value.code;
                    },
                    onChanged: (phone) {
                      telefoneWhatsappControler.text = phone.number;
                      codeTelefoneWhatsappControler.text = phone.countryCode;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: DropdownButton(
                      value: dropdownvalue,
                      style: GoogleFonts.roboto(color: Colors.black),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      dropdownColor: Colors.grey.shade300,
                      items: items.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: Text(
                              items,
                              style: GoogleFonts.roboto(
                                color: Colors.black,
                              ),
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ativado",
                      style: GoogleFonts.roboto(
                          color: Colors.grey.shade200,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: status,
                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
          Container(),
        ],
      );
    }

    void alertDiadogExcluiur({required int uidProfissional}) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            actionsAlignment: MainAxisAlignment.center,
            title: Text(
              "Tem Certeza? ",
              style: GoogleFonts.roboto(),
            ),
            content: Text(
                "Atenção os agendamentos e serviços do ${nomeController.text} serão deletados.\nNão será possivel desfazer essa ação.",
                style: GoogleFonts.roboto(fontSize: 18)),
            actions: [
              widgetsdesign.buttonIcon(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                label: "Voltar",
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              widgetsdesign.buttonIcon(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: "Excluir",
                onPressed: () {
                  Profissionalrepository()
                      .deleteProfissionalRepository(
                          uidProfissional: uidProfissional)
                      .then(
                    (value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    }

    Widget buttonSalvar() {
      return ElevatedButton.icon(
          onPressed: () async {
            if (keyForm.currentState!.validate()) {
              EasyLoading.show(
                status: "Carregando...",
                dismissOnTap: false,
              );

              //upload replace img
              String fotoUploadurl = fotoPerfil;
              if (imgMemoryPicked != null) {
                await StorageService()
                    .uploadReplaceImgStorage(
                        imgMemory: imgMemoryPicked!,
                        publicUrl: widget.profissional.fotoPerfil)
                    .then(
                  (value) {
                    fotoUploadurl = value ?? fotoPerfil;
                  },
                );
              }

              //

              String telefoneFormatado = telefoneController.text;
              String telefoneWhatsappFormatado = telefoneWhatsappControler.text;

              print("isocode:${isoCodeTelefoneControler.text}");
              print("isocode Whta:${isoCodeTelefoneWhatsappControler.text}");
              Profissional profissionalUpdate = Profissional(
                  nome: nomeController.text,
                  email: emailControler.text,
                  telefone: telefoneFormatado,
                  codeTelefone: codeTelefoneController.text,
                  telefoneWhatsapp: telefoneWhatsappFormatado,
                  codeTelefoneWhatsapp: codeTelefoneWhatsappControler.text,
                  fotoPerfil: fotoUploadurl,
                  isoCodePhone: isoCodeTelefoneControler.text,
                  isoCodePhoneWhatsapp: isoCodeTelefoneWhatsappControler.text,
                  perfil: dropdownvalue,
                  horariosTrabalho: widget.profissional.horariosTrabalho,
                  diasTrabalho: diasdaSemanaJson,
                  idEstabelecimento: widget.estabelecimento.uid,
                  status: status);
              Profissionalrepository()
                  .updateProfissionalRepository(
                      profissional: profissionalUpdate,
                      uidProfissional: widget.profissional.uid!)
                  .then(
                (value) {
                  EasyLoading.dismiss();
                  Navigator.pop(context);
                },
              );
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

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthMedia * 0.04),
          child: Column(
            children: [
              widgetsdesign.getCabecalhoDesingTitulo(
                label: "Detalhes Barbeiro",
                botaoWidget: Container(),
                paddingTop: 20,
                buscarWidget: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          alertDiadogExcluiur(
                            uidProfissional: widget.profissional.uid!,
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ))),
                sizeLabel: 22,
                searchCalender: false,
                colorLabel: widgetsdesign.amareloColor,
                fontWeight: FontWeight.w700,
                context: context,
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        height: ResponsiveBreakpoints.of(context)
                                .largerOrEqualTo(TABLET)
                            ? widthMedia * 0.23
                            : widthMedia * 0.55,
                        width: ResponsiveBreakpoints.of(context)
                                .largerOrEqualTo(TABLET)
                            ? widthMedia * 0.23
                            : widthMedia * 0.55,
                        child: imgMemoryPicked != null
                            ? Image.memory(
                                imgMemoryPicked!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                fotoPerfil,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: IconButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ["jpg", "png"]);

                          if (result != null) {
                            setState(() {
                              imgMemoryPicked = result.files.first.bytes;
                            });
                          }
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.white54)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              formularioAgendamento(),
              widgetsdesign.getCabecalhoDesingTitulo(
                label: "Dias da Semana",
                botaoWidget: Container(),
                colorLabel: widgetsdesign.amareloColor,
                fontWeight: FontWeight.w700,
                paddingTop: 0,
                sizeLabel: 20,
                buscarWidget: Container(),
                context: context,
              ),
              diasDaSemana(),
              widgetsdesign.getCabecalhoHorarios(
                label: "Horários",
                botaoWidget: Container(),
                colorLabel: widgetsdesign.amareloColor,
                fontWeight: FontWeight.w700,
                paddingTop: 0,
                sizeLabel: 20,
                buscarWidget: Container(),
                labelButton: "Ver Horários",
                callback: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BarbeiroHorarios(profissional: widget.profissional),
                      )).then(
                    (value) => setState(() {}),
                  );
                },
                context: context,
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
                  buttonSalvar(),
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
}
