import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/app_config.dart';
import 'package:agendamento_barber/views/administrador/redefinir_senha.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key, required this.estabelecimento});

  final Estabelecimento estabelecimento;
  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  bool textObscure = true;
  final keyForm = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

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
                  hintText: "Informe seu email", controller: emailController),
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

  void verificarEmail() async {
    await Profissionalrepository()
        .verificarEmailExistir(
            email: emailController.text,
            idEstabelecimento: widget.estabelecimento.uid!)
        .then(
      (value) {
        if (value["id"] != null) {
          enviarEmail(idProfissional: value['id']);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Email não encontrado.")));
        }
      },
    );
  }

  void enviarEmail({required int idProfissional}) async {
    final dio = Dio();
    dio.options.headers["accept"] = 'application/json';
    dio.options.headers["api-key"] = AppConfig.apiKeyBrevoEmail;
    dio.options.headers["content-type"] = 'application/json';

    final Random _random = Random();
    int codigo = _random.nextInt(999999) + 99999;

    await Profissionalrepository().updateTokenProfissional(
        token: codigo, uidProfissional: idProfissional);

    await dio.post('https://api.brevo.com/v3/smtp/email', data: {
      "sender": {
        "name": AppConfig.nomeExibicaoBrevo,
        "email": AppConfig.emailBrevo,
      },
      "to": [
        {"email": emailController.text, "name": "Email recuperação senha"}
      ],
      "subject": "Redefinição senha do ${widget.estabelecimento.nome}",
      "htmlContent":
          "<html><head></head><body><p>Redefinição senha do ${widget.estabelecimento.nome}</p>Seu Codigo é: ${codigo}.</p></body></html>"
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;

    Widget buttonLogin() {
      return ElevatedButton.icon(
          onPressed: () async {
            EasyLoading.show(
              dismissOnTap: false,
              status: "Carregando...",
            );
            if (!keyForm.currentState!.validate()) {
              EasyLoading.dismiss();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Campos invalidos!")));
            } else {
              verificarEmail();
              EasyLoading.dismiss();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RedefinirSenha(
                      email: emailController.text,
                      estabelecimento: widget.estabelecimento,
                    ),
                  ));
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
                  EdgeInsets.only(top: 8, bottom: 8, left: 50, right: 50)),
              shadowColor:
                  WidgetStatePropertyAll(const Color.fromARGB(255, 0, 0, 0)),
              backgroundColor:
                  WidgetStatePropertyAll(Color.fromARGB(255, 46, 46, 46))),
          icon: null,
          label: Text(
            "Confirma Email",
            style: GoogleFonts.robotoCondensed(
                color: widgetsdesign.amareloColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ));
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 19, 19, 19),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthTela * 0.05),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    widgetsdesign.getCabecalhoDesingTitulo(
                      context: context,
                      label: "Esqueceu a Senha?",
                      botaoWidget: Container(),
                      buscarWidget: Container(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Informe seu Email\nPara redefinir a senha",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    formularioAgendamento(),
                    SizedBox(
                      height: 30,
                    ),
                    Center(child: buttonLogin()),
                    SizedBox(
                      height: 15,
                    ),
                  ]),
            ),
          ),
        ));
  }
}
