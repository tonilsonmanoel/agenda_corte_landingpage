import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/repository/estabelecimentoRepository.dart';
import 'package:agendamento_barber/repository/storage_service.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/views/administrador/login_administrador.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key, required this.estabelecimento});
  final Estabelecimento estabelecimento;
  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  final keyForm = GlobalKey<FormState>();
  Uint8List? imgMemoryPicked;
  Uint8List? imgMemorySobreNos;

  TextEditingController nomeController = TextEditingController();
  TextEditingController codeTelefoneController = TextEditingController();
  TextEditingController isoCodeTelefoneController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController enderecoControler = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController cepControler = TextEditingController();
  TextEditingController razaoSocialController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController sobreNosController = TextEditingController();
  TextEditingController horarioAtendimentoController = TextEditingController();
  TextEditingController urlIframeMapaController = TextEditingController();
  TextEditingController urlIBarbeariaController = TextEditingController();
  String urlLogo = "";
  String fileNameSobreNos = "Nenhuma imagem Selecionada";
  String sobreNosImgUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nomeController.text = widget.estabelecimento.nome;
    razaoSocialController.text = widget.estabelecimento.razaoSocial ?? "";
    cnpjController.text = widget.estabelecimento.cnpj ?? "";
    telefoneController.text = widget.estabelecimento.telefone;
    codeTelefoneController.text = widget.estabelecimento.codeTelefone;
    isoCodeTelefoneController.text = widget.estabelecimento.isoCodePhone;
    enderecoControler.text = widget.estabelecimento.endereco;
    complementoController.text = widget.estabelecimento.complemento;
    cepControler.text = widget.estabelecimento.cep;
    urlLogo = widget.estabelecimento.urlLogo;
    urlIBarbeariaController.text = widget.estabelecimento.urlBarbearia;
    sobreNosImgUrl = widget.estabelecimento.sobreNosImg ?? "";
    sobreNosController.text = widget.estabelecimento.sobreNos ?? "";
    horarioAtendimentoController.text =
        widget.estabelecimento.horarioFuncionamento ?? "";
    fileNameSobreNos = StorageService()
        .getPathUrl(publicUrl: widget.estabelecimento.sobreNosImg!);
    urlIframeMapaController.text = widget.estabelecimento.urlIframeMapa ?? "";
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
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nome Empresa",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          widgetsdesign.textFildLabel(
                              hintText: "Informe seu nome empresa",
                              controller: nomeController),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Razão Social",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          widgetsdesign.textFildLabel(
                              hintText: "Informe seu nome empresa",
                              controller: razaoSocialController),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Link da Barbearia",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: ResponsiveBreakpoints.of(context)
                              .largerOrEqualTo(TABLET)
                          ? 7
                          : 5,
                      child: widgetsdesign.textFildLabelUrlBarbearia(
                          hintText: "Digite link da barbearia",
                          inputFormatter: [
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[^\w\s]')),
                            FilteringTextInputFormatter.deny(
                                RegExp(r'[áéíóúâêîôûãõçÁÉÍÓÚÂÊÎÔÛÃÕÇ]')),
                          ],
                          controller: urlIBarbeariaController),
                    ),
                    Expanded(
                      flex: ResponsiveBreakpoints.of(context)
                              .largerOrEqualTo(TABLET)
                          ? 3
                          : 5,
                      child: Text(
                        ".barbeariaonline.com.br",
                        style: GoogleFonts.robotoCondensed(
                            color: Colors.white,
                            fontSize: ResponsiveBreakpoints.of(context)
                                    .largerOrEqualTo(TABLET)
                                ? 20
                                : 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CNPJ",
                      style: GoogleFonts.roboto(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    widgetsdesign.textFildCNPJ(
                        hintText: "",
                        inputFormatter: [
                          FilteringTextInputFormatter.digitsOnly,
                          CnpjInputFormatter()
                        ],
                        controller: cnpjController),
                  ],
                ),
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
                    searchText: "Pesquisar País",
                    initialCountryCode: isoCodeTelefoneController.text,
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
                      isoCodeTelefoneController.text = value.code;
                    },
                    onChanged: (phone) {
                      telefoneController.text = phone.number;
                      codeTelefoneController.text = phone.countryCode;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Endereço",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                widgetsdesign.textFildLabel(
                    hintText: "Informa seu endereço",
                    controller: enderecoControler),
                SizedBox(
                  height: 10,
                ),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Complemento",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          widgetsdesign.textFildLabel(
                              hintText: "Informa o complemento",
                              controller: complementoController),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CEP",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          widgetsdesign.textFildCep(
                              hintText: "Informa o CEP",
                              textInputType: TextInputType.number,
                              controller: cepControler),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Url Iframe Mapa Google",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                widgetsdesign.textFildLabelSemValidor(
                    hintText: "Url Iframe",
                    controller: urlIframeMapaController),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Configuração Landing Page",
                  style: GoogleFonts.robotoCondensed(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Sobre Nós",
                  style: GoogleFonts.roboto(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                widgetsdesign.textFildTextArea(
                    hintText: "", maxLines: 4, controller: sobreNosController),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Imagem Seção Sobre Nós",
                  style: GoogleFonts.roboto(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: ResponsiveBreakpoints.of(context).largerThan(MOBILE)
                      ? widthMedia * 0.5
                      : widthMedia * 0.85,
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ["jpg", "png"]);

                            if (result != null) {
                              String fileName = result.files.first.name;
                              setState(() {
                                imgMemorySobreNos = result.files.first.bytes;
                                fileNameSobreNos = fileName;
                              });
                            }
                          },
                          icon: Icon(Icons.image),
                          label: Text("Escolher Imagem")),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        fileNameSobreNos,
                        style: GoogleFonts.roboto(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Horário de Atendimento",
                  style: GoogleFonts.roboto(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                widgetsdesign.textFildTextArea(
                    hintText: "",
                    maxLines: 4,
                    controller: horarioAtendimentoController),
                SizedBox(
                  height: 5,
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
            EasyLoading.show(
              status: "Carregando...",
              dismissOnTap: false,
            );

            bool urlDisponivel = widget.estabelecimento.urlBarbearia ==
                    urlIBarbeariaController.text
                ? true
                : false;

            if (urlDisponivel == false) {
              urlDisponivel = await Estabelecimentorepository()
                  .verificarDisponibilidadeUrl(
                      urlBarbearia: urlIBarbeariaController.text);
            }

            if (urlLogo == "") {
              EasyLoading.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selecionar imagem logo")));
            } else if (fileNameSobreNos == "Nenhuma imagem Selecionada") {
              EasyLoading.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selecionar imagem seção Sobre Nós")));
            } else if (urlDisponivel == false) {
              EasyLoading.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "link da barbearia não está disponivel, digite outra link")));
            } else if (!keyForm.currentState!.validate()) {
              EasyLoading.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Verifique o formulario")));
            } else {
              //upload img
              String logoUploadurl = urlLogo;
              if (imgMemoryPicked != null) {
                await StorageService()
                    .uploadReplaceImgStorage(
                        imgMemory: imgMemoryPicked!,
                        publicUrl: widget.estabelecimento.urlLogo)
                    .then(
                  (value) {
                    logoUploadurl = value!;
                  },
                );
              }
              String imagePublicUrl = widget.estabelecimento.sobreNosImg!;
              if (imgMemorySobreNos != null) {
                await StorageService()
                    .uploadReplaceImgStorage(
                        imgMemory: imgMemorySobreNos!,
                        publicUrl: widget.estabelecimento.sobreNosImg!)
                    .then(
                  (value) {
                    imagePublicUrl = value!;
                  },
                );
              }

              //
              Estabelecimento estabelecimento = Estabelecimento(
                isoCodePhone: isoCodeTelefoneController.text,
                uid: widget.estabelecimento.uid,
                nome: nomeController.text,
                cnpj: cnpjController.text,
                urlLogo: logoUploadurl,
                horarioFuncionamento: horarioAtendimentoController.text,
                razaoSocial: razaoSocialController.text,
                sobreNos: sobreNosController.text,
                sobreNosImg: imagePublicUrl,
                telefone: telefoneController.text,
                codeTelefone: codeTelefoneController.text,
                telefoneWhatsapp: widget.estabelecimento.telefoneWhatsapp,
                codeTelefoneWhatsapp:
                    widget.estabelecimento.codeTelefoneWhatsapp,
                cep: cepControler.text,
                endereco: enderecoControler.text,
                complemento: complementoController.text,
                urlIframeMapa: urlIframeMapaController.text,
                urlBarbearia: urlIBarbeariaController.text.toLowerCase().trim(),
              );

              Estabelecimentorepository()
                  .updateEstabelecimentoRepository(
                      estabelecimento: estabelecimento,
                      uidEstabelecimento: estabelecimento.uid!)
                  .then((value) {
                EasyLoading.dismiss();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginAdministrador(
                        estabelecimento: estabelecimento,
                      ),
                    ));
              });
            }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthMedia * 0.04),
          child: Column(
            children: [
              widgetsdesign.cabecalhoConfiguracoes(
                label: "Configurações",
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
              Center(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: SizedBox(
                        height: 200,
                        width: 220,
                        child: imgMemoryPicked != null
                            ? Image.memory(
                                imgMemoryPicked!,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                urlLogo,
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
