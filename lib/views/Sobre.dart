import 'package:agendamento_barber/repository/estabelecimentoRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    double widthTela = MediaQuery.of(context).size.width;
    double heightTela = MediaQuery.of(context).size.height;
    Widgetsdesign widgetsdesign = Widgetsdesign();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      body: Stack(
        children: [
          // Imagem de fundo Tela
          Positioned(
            child: Image.asset(
              "asset/fundo_recorte_transparente_80.png", // Caminho da imagem na pasta assets
            ),
          ),

          //Fim Imagem de fundo Tela
          //
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: widthTela * 0.05),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widgetsdesign.getCabecalhoDesingSobre(
                        label: "Sobre",
                        colorLabel: Colors.white,
                        fontWeight: FontWeight.w400,
                        context: context,
                        colorborder: widgetsdesign.amareloSecudarioColor),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                      future: Estabelecimentorepository()
                          .getEstabelecimentoRepository(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: heightTela * 0.7,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    "Endereço do estabelecimento:",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text.rich(
                                  textAlign: TextAlign.center,
                                  TextSpan(
                                      text: "${snapshot.data!.endereco}\n",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(text: "Complemento:"),
                                        TextSpan(
                                          text:
                                              " ${snapshot.data!.complemento}\n",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        TextSpan(text: "CEP:"),
                                        TextSpan(
                                          text:
                                              " ${UtilBrasilFields.obterCep(snapshot.data!.cep, ponto: false)}",
                                          style: GoogleFonts.roboto(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ])),

                              //Fale Conosco
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Center(
                                  child: Text(
                                    "Fale Conosco:",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                        color: widgetsdesign.amareloColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),

                              //Button Icon Telefone
                              widgetsdesign.buttonIcon(
                                  icon: Icon(
                                    FontAwesomeIcons.phone,
                                    color: widgetsdesign.amareloColor,
                                  ),
                                  padding: EdgeInsets.only(
                                      left: 50, right: 50, top: 5, bottom: 5),
                                  label: UtilBrasilFields.obterTelefone(
                                      snapshot.data!.telefone,
                                      ddd: true,
                                      mascara: true),
                                  onPressed: () {
                                    launchUrl(Uri(
                                        scheme: "tel",
                                        path: snapshot.data!.telefone));
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              widgetsdesign.buttonIcon(
                                  icon: Image.asset(
                                    "asset/whatsapp-logo.png",
                                    width: widthTela * 0.08,
                                    height: widthTela * 0.08,
                                  ),
                                  textColor: Colors.green.shade700,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 40, right: 40, top: 5, bottom: 5),
                                  label: "Fale pelo Whatsapp",
                                  onPressed: () async {
                                    String urlFinal =
                                        "https://wa.me/55${snapshot.data!.telefone}?text=${Uri.encodeComponent("Olá! 👋 Seja bem-vindo à ${snapshot.data!.nome}. Como podemos te ajudar hoje? Escreva sua mensagem abaixa: ")}";

                                    launchUrl(Uri.parse(urlFinal)).onError(
                                      (error, stackTrace) {
                                        print("Url is not valid!");
                                        return false;
                                      },
                                    );
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              TextButton.icon(
                                  onPressed: () {},
                                  icon: Image.asset(
                                    "asset/lock-icon.png",
                                    width: widthTela * 0.09,
                                    height: widthTela * 0.11,
                                  ),
                                  label: Text(
                                    "Acesso Restrito",
                                    style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600),
                                  )),

                              SizedBox(
                                height: 25,
                              ),
                              //Rodape Pagina Sobre
                              Text(
                                "Todos os direitos reservados - 2025\nDesenvolvimento Tony Dev\nVersão: 1.0",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
