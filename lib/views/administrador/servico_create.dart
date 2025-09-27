import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/repository/storage_service.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ServicoCreate extends StatefulWidget {
  const ServicoCreate(
      {super.key, required this.uidProfissional, required this.perfil});
  final int uidProfissional;
  final String perfil;
  @override
  State<ServicoCreate> createState() => _ServicoCreateState();
}

class _ServicoCreateState extends State<ServicoCreate> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  final keyForm = GlobalKey<FormState>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController valorControler = TextEditingController();
  String urlImg =
      "https://t4.ftcdn.net/jpg/06/71/92/37/360_F_671923740_x0zOL3OIuUAnSF6sr7PuznCI5bQFKhI0.jpg";
  Uint8List? imgMemoryPicked;
  bool ativo = true;
  bool ativoLanding = false;

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
                    hintText: "Informe o nome do serviço",
                    controller: nomeController),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Valor",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                widgetsdesign.textFildLabel(
                    hintText: "Informe seu valor",
                    textInputType: TextInputType.number,
                    inputFormatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: false, casasDecimais: 2)
                    ],
                    controller: valorControler),
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
                      value: ativo,
                      onChanged: (value) {
                        setState(() {
                          ativo = value;
                        });
                      },
                    ),
                  ],
                ),
                if (widget.perfil == "admin") ...[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mostrar na Landing Page",
                        style: GoogleFonts.roboto(
                            color: Colors.grey.shade200,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Switch(
                        value: ativoLanding,
                        onChanged: (value) {
                          setState(() {
                            ativoLanding = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
                SizedBox(
                  height: 15,
                ),
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
            EasyLoading.show(
              status: "Carregando...",
              dismissOnTap: false,
            );
            //upload img
            String fotoUploadurl = urlImg;
            if (imgMemoryPicked != null) {
              await StorageService()
                  .uploadImgStorage(imgMemory: imgMemoryPicked!)
                  .then(
                (value) {
                  fotoUploadurl = value ?? urlImg;
                },
              );
            }

            //

            Servico servico = Servico(
                nome: nomeController.text,
                valor: UtilBrasilFields.converterMoedaParaDouble(
                    valorControler.text),
                urlImg: fotoUploadurl,
                ativoLadingpage: ativoLanding,
                idProfissional: widget.uidProfissional,
                ativo: ativo);

            Servicorepository()
                .createServicoRepository(
                    servico: servico, uidProfissional: widget.uidProfissional)
                .then(
              (value) {
                Navigator.pop(context);
                EasyLoading.dismiss();
              },
            );

            // confirmação feita pelo barbeiro
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
              SizedBox(
                height: 10,
              ),
              widgetsdesign.getCabecalhoDesingTitulo(
                label: "Adicionar Serviço",
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
                                  urlImg,
                                  fit: BoxFit.cover,
                                )),
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
