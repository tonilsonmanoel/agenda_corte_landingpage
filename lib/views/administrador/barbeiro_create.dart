import 'dart:io';

import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/repository/storage_service.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'dart:typed_data';
import 'dart:html' as html;

class BarbeiroCreate extends StatefulWidget {
  const BarbeiroCreate({super.key, required this.estabelecimento});
  final Estabelecimento estabelecimento;
  @override
  State<BarbeiroCreate> createState() => _BarbeiroCreateState();
}

class _BarbeiroCreateState extends State<BarbeiroCreate> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  String dropdownvalue = 'admin';

  // List of items in our dropdown menu
  var items = ['admin', 'barbeiro'];

  Uint8List? imgMemoryPicked;
  final keyForm = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController codeTelefoneController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController codeTelefoneWhatsappControler = TextEditingController();
  TextEditingController isoCodeTelefoneControler = TextEditingController();
  TextEditingController isoCodeTelefoneWhatsappControler =
      TextEditingController();
  TextEditingController telefoneWhatsappControler = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  String fotoPerfil =
      "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png";

  bool status = true;
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
                      isoCodeTelefoneControler.text = phone.countryISOCode;
                      telefoneController.text = phone.number;
                      codeTelefoneController.text = phone.countryCode;
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
                      isoCodeTelefoneWhatsappControler.text =
                          phone.countryISOCode;
                      telefoneWhatsappControler.text = phone.number;
                      codeTelefoneWhatsappControler.text = phone.countryCode;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Senha Acesso",
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    widgetsdesign.textFildLabel(
                        hintText: "", controller: senhaController),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Perfil",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
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

    Widget buttonSalvar() {
      return ElevatedButton.icon(
          onPressed: () async {
            if (keyForm.currentState!.validate()) {
              EasyLoading.show(
                status: "Carregando...",
                dismissOnTap: false,
              );

              //upload img
              String fotoUploadurl = fotoPerfil;
              if (imgMemoryPicked != null) {
                await StorageService()
                    .uploadImgStorage(imgMemory: imgMemoryPicked!)
                    .then(
                  (value) {
                    fotoUploadurl = value ?? fotoPerfil;
                  },
                );
              }

              //
              List<Map<String, dynamic>> horarios = Utils().getAvailableTimes();
              List<Map<String, dynamic>> diasDaSemana =
                  Utils().getDiasDaSemanaMap();

              Profissional profissionalCreate = Profissional(
                  nome: nomeController.text,
                  email: emailControler.text,
                  telefone: telefoneController.text,
                  codeTelefone: codeTelefoneController.text,
                  codeTelefoneWhatsapp: codeTelefoneWhatsappControler.text,
                  telefoneWhatsapp: telefoneWhatsappControler.text,
                  fotoPerfil: fotoUploadurl,
                  horariosTrabalho: horarios,
                  isoCodePhone: isoCodeTelefoneControler.text,
                  isoCodePhoneWhatsapp: isoCodeTelefoneWhatsappControler.text,
                  perfil: dropdownvalue,
                  diasTrabalho: diasDaSemana,
                  idEstabelecimento: widget.estabelecimento.uid,
                  status: status);
              Profissionalrepository()
                  .createProfissionalRepository(
                      profissional: profissionalCreate,
                      senha: senhaController.text)
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

    Future<Uint8List> getFileBytes(XFile pickedFile) async {
      if (kIsWeb) {
        // Web: use o bytes já disponíveis ou FileReader
        if (pickedFile.readAsBytes() != null) return pickedFile.readAsBytes();

        // Alternativa com html.FileReader
        final htmlFile =
            html.File([pickedFile..readAsBytes()!], pickedFile.name);
        final reader = html.FileReader();
        reader.readAsArrayBuffer(htmlFile);
        await reader.onLoad.first;
        return reader.result as Uint8List;
      } else {
        // Mobile/Desktop
        return await File(pickedFile.path!).readAsBytes();
      }
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthMedia * 0.04),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              widgetsdesign.getCabecalhoDesingTitulo(
                label: "Adicionar Barbeiro",
                botaoWidget: Container(),
                buscarWidget: Container(),
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
                            final XFile pickedFile = XFile.fromData(
                              result.files.first.bytes!,
                              name: result.files.first.name,
                            );

                            final bytes = await getFileBytes(pickedFile);

                            setState(() {
                              imgMemoryPicked = bytes;
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
