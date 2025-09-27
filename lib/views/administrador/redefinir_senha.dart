import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/views/administrador/login_administrador.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class RedefinirSenha extends StatefulWidget {
  const RedefinirSenha(
      {super.key, required this.email, required this.estabelecimento});

  final Estabelecimento estabelecimento;
  final String email;
  @override
  State<RedefinirSenha> createState() => _RedefinirSenhaState();
}

class _RedefinirSenhaState extends State<RedefinirSenha> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  bool textObscure = true;

  final keyForm = GlobalKey<FormState>();
  TextEditingController tokemController = TextEditingController();
  TextEditingController senhacontroller = TextEditingController();
  TextEditingController confirmaSenhacontroller = TextEditingController();

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
                "Token",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              widgetsdesign.textFildLabel(
                  hintText: "Informe seu Token",
                  inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  controller: tokemController),
              SizedBox(
                height: 10,
              ),
              Text(
                "Nova Senha",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              widgetsdesign.textFildSenha(
                  hintText: "Informa a Nova Senha",
                  textObscure: textObscure,
                  functionObscure: () {
                    setState(() {
                      if (textObscure == true) {
                        textObscure = false;
                      } else {
                        textObscure = true;
                      }
                    });
                  },
                  controller: senhacontroller),
              SizedBox(
                height: 10,
              ),
              Text(
                "Confirma Senha",
                style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              widgetsdesign.textFildSenha(
                  hintText: "Confirme sua Senha",
                  textObscure: textObscure,
                  functionObscure: () {
                    setState(() {
                      if (textObscure == true) {
                        textObscure = false;
                      } else {
                        textObscure = true;
                      }
                    });
                  },
                  controller: confirmaSenhacontroller),
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
              if (senhacontroller.text == confirmaSenhacontroller.text) {
                var verificarToken = await Profissionalrepository()
                    .verificarTokenProfissional(
                        token: int.parse(tokemController.text),
                        email: widget.email);

                if (verificarToken['verificadoToken'] == true) {
                  EasyLoading.dismiss();
                  Profissionalrepository()
                      .atulizarSenhaProfissional(
                          senha: senhacontroller.text,
                          uidProfissional: verificarToken['id'],
                          idEstabelecimento: widget.estabelecimento.uid!,
                          email: widget.email)
                      .then(
                    (value) {
                      EasyLoading.dismiss();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginAdministrador(
                              estabelecimento: widget.estabelecimento,
                            ),
                          ));
                    },
                  );
                } else {
                  EasyLoading.dismiss();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Token invalido.")));
                  EasyLoading.dismiss();
                }

                EasyLoading.dismiss();
              } else {
                EasyLoading.dismiss();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("As senhas precisam ser iguais")));
              }
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
          icon: Icon(
            Icons.lock_reset,
            color: widgetsdesign.amareloColor,
            size: 28,
          ),
          label: Text(
            "Redefinir Senha",
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
                      label: "Redefinição de Senha",
                      botaoWidget: Container(),
                      buscarWidget: Container(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Informe o Tokem Recebido\nNo Seu Email",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
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
