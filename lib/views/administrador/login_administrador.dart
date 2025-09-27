import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/repository/auth_service.dart';
import 'package:agendamento_barber/repository/estabelecimentoRepository.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/views/administrador/esqueceu_senha.dart';
import 'package:agendamento_barber/views/administrador/page_view_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoginAdministrador extends StatefulWidget {
  const LoginAdministrador({
    super.key,
    this.estabelecimento,
  });

  final Estabelecimento? estabelecimento;

  @override
  State<LoginAdministrador> createState() => _LoginAdministradorState();
}

class _LoginAdministradorState extends State<LoginAdministrador> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  final keyForm = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController senhacontroller = TextEditingController();
  bool textObscure = true;
  final authService = AuthService();

  Estabelecimento estabelecimento = Estabelecimento.vazio();

  @override
  void initState() {
    // TODO: implement initState

    estabelecimento = widget.estabelecimento ?? Estabelecimento.vazio();
    verificaLogado();
    super.initState();
  }

  void verificaLogado() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final int? idEstabelecimento = prefs.getInt("idEstabelecimento");
    if (estabelecimento.uid != idEstabelecimento) {
      prefs.clear();
    }

    if (prefs.getString("email") != null) {
      EasyLoading.show(
        dismissOnTap: false,
        status: "Carregando ...",
      );
      Profissionalrepository()
          .getLoginProfissional(
              email: prefs.getString("email")!,
              senha: prefs.getString("senha")!,
              idEstabelecimento: estabelecimento.uid!)
          .then((value) {
        if (value["mensagem"] == "Login realizado") {
          EasyLoading.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PageViewAdmin(
                    profissional: value["profissinalObjeto"],
                    pc: PageController(initialPage: 0),
                    estabelecimento: estabelecimento),
              ));
          EasyLoading.dismiss();
        } else {
          EasyLoading.dismiss();
        }
      });
    }
  }

  Widget formularioAgendamento() {
    return estabelecimento.nome == ""
        ? Shimmer(
            color: Colors.grey.shade600,
            enabled: true,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200),
              height: 300,
              width: 700,
            ))
        : Column(
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
                    widgetsdesign.textFildLabel(
                        hintText: "Informe seu email",
                        controller: emailController),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Senha",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    widgetsdesign.textFildSenha(
                        hintText: "Informa sua Senha",
                        textObscure: textObscure,
                        onSubmitted: () {
                          EasyLoading.show(
                            dismissOnTap: false,
                            status: "Carregando...",
                          );
                          if (!keyForm.currentState!.validate()) {
                            EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Campos invalidos!")));
                          } else {
                            Profissionalrepository()
                                .getLoginProfissional(
                                    email: emailController.text,
                                    senha: senhacontroller.text,
                                    idEstabelecimento: estabelecimento.uid!)
                                .then(
                              (value) {
                                if (value["mensagem"] == "Login realizado") {
                                  AuthService().loginPesitencia(
                                      email: emailController.text,
                                      senha: senhacontroller.text,
                                      idEstabelecimento: estabelecimento.uid!);
                                  print(
                                      "login perfil  ${value["profissinalObjeto"]["perfil"]}");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PageViewAdmin(
                                            profissional:
                                                value["profissinalObjeto"],
                                            pc: PageController(initialPage: 0),
                                            estabelecimento: estabelecimento),
                                      ));
                                  EasyLoading.dismiss();
                                } else {
                                  EasyLoading.dismiss();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Email ou Senha Incorretos")));
                                }
                              },
                            );
                            EasyLoading.dismiss();
                          }
                          EasyLoading.dismiss();
                        },
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
              Profissionalrepository()
                  .getLoginProfissional(
                      email: emailController.text,
                      senha: senhacontroller.text,
                      idEstabelecimento: estabelecimento.uid!)
                  .then(
                (value) {
                  if (value["mensagem"] == "Login realizado") {
                    AuthService().loginPesitencia(
                        email: emailController.text,
                        senha: senhacontroller.text,
                        idEstabelecimento: estabelecimento.uid!);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageViewAdmin(
                              profissional: value["profissinalObjeto"],
                              pc: PageController(initialPage: 0),
                              estabelecimento: estabelecimento),
                        ));
                    EasyLoading.dismiss();
                  } else {
                    EasyLoading.dismiss();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Email ou Senha Incorretos")));
                  }
                },
              );
              EasyLoading.dismiss();
            }
            EasyLoading.dismiss();
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
            "Acessar",
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
                    widgetsdesign.getCabecalhoDesing(
                      context: context,
                      botao: Container(),
                      buscar: Container(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Entre com seu Email e Senha\nde Administrador Cadastrado",
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Esqueceu a senha?",
                          style: GoogleFonts.robotoCondensed(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EsqueceuSenha(
                                      estabelecimento: estabelecimento,
                                    ),
                                  ));
                            },
                            child: Text(
                              "Clique Aqui",
                              style: GoogleFonts.roboto(
                                  color: widgetsdesign.amareloColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ]),
            ),
          ),
        ));
  }
}
