import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ContatoSection extends StatefulWidget {
  const ContatoSection({super.key, required this.estabelecimento});
  final Estabelecimento estabelecimento;

  @override
  State<ContatoSection> createState() => _ContatoSectionState();
}

class _ContatoSectionState extends State<ContatoSection> {
  @override
  Widget build(BuildContext context) {
    String telefone = "";
    if (widget.estabelecimento.telefone != "") {
      String phone = widget.estabelecimento.telefone;
      if (widget.estabelecimento.isoCodePhone == "BR") {
        phone = UtilBrasilFields.obterTelefone(widget.estabelecimento.telefone,
            ddd: true);
      }

      telefone = "${widget.estabelecimento.codeTelefone} $phone";
    }
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCardMobile(
                    title: 'FALE COM A GENTE',
                    children: [
                      AutoSizeText('Tel: $telefone',
                          textAlign: TextAlign.center),
                      Text('Email: ${widget.estabelecimento.email}',
                          textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(width: 32, height: 32),
                  _buildCardMobile(
                    title: 'NOSSO ENDEREÇO',
                    children: [
                      Text('${widget.estabelecimento.endereco} -',
                          textAlign: TextAlign.center),
                      Text('${widget.estabelecimento.complemento}',
                          textAlign: TextAlign.center),
                      Text('CEP: ${widget.estabelecimento.cep}',
                          textAlign: TextAlign.center),
                    ],
                  ),
                  const SizedBox(width: 32, height: 32),
                  _buildCardMobile(
                    title: 'HORÁRIO DE ATENDIMENTO',
                    children: [
                      Text('${widget.estabelecimento.horarioFuncionamento}',
                          textAlign: TextAlign.center),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCard(
                        title: 'FALE COM A GENTE',
                        children: [
                          AutoSizeText('Tel: $telefone',
                              textAlign: TextAlign.center),
                          Text('Email: ${widget.estabelecimento.email}',
                              textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(width: 32, height: 32),
                      _buildCard(
                        title: 'NOSSO ENDEREÇO',
                        children: [
                          Text('${widget.estabelecimento.endereco} -',
                              textAlign: TextAlign.center),
                          Text('${widget.estabelecimento.complemento}',
                              textAlign: TextAlign.center),
                          Text('CEP: ${widget.estabelecimento.cep}',
                              textAlign: TextAlign.center),
                        ],
                      ),
                      const SizedBox(width: 32, height: 32),
                      _buildCard(
                        title: 'HORÁRIO DE ATENDIMENTO',
                        children: [
                          Text(
                            '${widget.estabelecimento.horarioFuncionamento}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 35),
                    ],
                  ),
                ],
              ));
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AutoSizeText(title,
                minFontSize: 7,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                )),
            const SizedBox(height: 8),
            ...children.map((child) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: DefaultTextStyle(
                    style:
                        GoogleFonts.roboto(color: Colors.white, fontSize: 17),
                    child: child,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildCardMobile(
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(title,
              minFontSize: 7,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white,
              )),
          const SizedBox(height: 8),
          ...children.map((child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: DefaultTextStyle(
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 17),
                  child: child,
                ),
              )),
        ],
      ),
    );
  }
}
