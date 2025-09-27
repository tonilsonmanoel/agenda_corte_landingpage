import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Rodape extends StatelessWidget {
  const Rodape({super.key, required this.estabelecimento});
  final Estabelecimento estabelecimento;

  @override
  Widget build(BuildContext context) {
    String cnpjTexto = "";
    if (estabelecimento.cnpj != null && estabelecimento.cnpj != "") {
      cnpjTexto = "- CNPJ: ${estabelecimento.cnpj}";
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      color: Color.fromRGBO(59, 25, 0, 1),
      child: Center(
        child: AutoSizeText(
          "Copyright ©2025 Todos os direitos reservados à ${estabelecimento.razaoSocial} ${cnpjTexto} | Site criado por TN Code",
          maxLines: 5,
          minFontSize: 10,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              fontWeight: FontWeight.w500, color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
