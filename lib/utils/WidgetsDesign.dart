import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/repository/auth_service.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:agendamento_barber/utils/validation_mixins.dart';
import 'package:agendamento_barber/views/administrador/Configuracoes.dart';
import 'package:agendamento_barber/views/administrador/agendamentos_nao_concluido.dart';
import 'package:agendamento_barber/views/administrador/login_administrador.dart';
import 'package:agendamento_barber/views/agendamento/ConsultaAgendamento.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:url_launcher/url_launcher.dart';

class Widgetsdesign with ValidationMixins {
  // Cores Padrão de Design
  Color cinzaFundo = Color.fromARGB(255, 26, 26, 26);
  Color amareloColor = Color.fromARGB(255, 254, 205, 12);
  Color amareloSecudarioColor = Color.fromARGB(255, 125, 100, 0);

  Widget getCabecalhoDesing(
      {required BuildContext context, Widget? botao, Widget? buscar}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 43,
        ),
        buscar ??
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultaAgendamento(),
                          ));
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 38,
                    )),
              ],
            ),
        Text(
          "Olá,",
          style: GoogleFonts.roboto(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.normal),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2, color: Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            children: [
              Text(
                "SEJA BEM-VINDO",
                style: GoogleFonts.roboto(
                    color: Color.fromARGB(255, 254, 205, 12),
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // botao agendamento
        Center(
          child: botao ??
              buttonIcon(
                  label: "Consultar Agendamento",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultaAgendamento(),
                        ));
                  },
                  icon: Image.asset(
                    "asset/calender_consulta.png",
                    height: 25,
                    width: 25,
                  )),
        ),
        //fim botao agendamento
      ],
    );
  }

  Widget getCabecalhoDesingConsulta(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      FontWeight? fontWeight,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 75,
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget getCabecalhoDesingSobre(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      FontWeight? fontWeight,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 43,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsultaAgendamento(),
                      ));
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 38,
                )),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget getCabecalhoDetalhes(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      Widget? buscarWidget,
      bool searchCalender = false,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: paddingTop ?? 43,
        ),
        buscarWidget ??
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 32,
                    )),
              ],
            ),

        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
              searchCalender
                  ? IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month,
                        color: amareloColor,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // botao agendamento
        botaoWidget ??
            Center(
              child: buttonIcon(
                  label: "Consultar Agendamento",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultaAgendamento(),
                        ));
                  },
                  icon: Image.asset(
                    "asset/calender_consulta.png",
                    height: 25,
                    width: 25,
                  )),
            ),
        //fim botao agendamento
      ],
    );
  }

  Widget getCabecalhoDesingTitulo(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      Widget? buscarWidget,
      bool searchCalender = false,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: paddingTop ?? 43,
        ),
        buscarWidget ??
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 32,
                      )),
                ),
              ],
            ),

        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
              searchCalender
                  ? IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month,
                        color: amareloColor,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // botao agendamento
        botaoWidget ??
            Center(
              child: buttonIcon(
                  label: "Consultar Agendamento",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultaAgendamento(),
                        ));
                  },
                  icon: Image.asset(
                    "asset/calender_consulta.png",
                    height: 25,
                    width: 25,
                  )),
            ),
        //fim botao agendamento
      ],
    );
  }

  Widget getCabecalhoDesingConfirmaAgendamento(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      Widget? buscarWidget,
      bool searchCalender = false,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: paddingTop ?? 43,
        ),
        buscarWidget ??
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultaAgendamento(),
                          ));
                    },
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 38,
                    )),
              ],
            ),

        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
              searchCalender
                  ? IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month,
                        color: amareloColor,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // botao agendamento
        botaoWidget ??
            Center(
              child: buttonIcon(
                  label: "Consultar Agendamento",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultaAgendamento(),
                        ));
                  },
                  icon: Image.asset(
                    "asset/calender_consulta.png",
                    height: 25,
                    width: 25,
                  )),
            ),
        //fim botao agendamento
      ],
    );
  }

  Widget getCabecalhoAgenda(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      VoidCallback? calenderButtonFunction,
      bool menuLateralAtivado = true,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  label,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                      color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                      fontSize: sizeLabel ?? 26,
                      fontWeight: fontWeight ?? FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: calenderButtonFunction,
                icon: Icon(
                  Icons.calendar_month,
                  color: amareloColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget getCabecalhoAgendaVoltar(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      VoidCallback? calenderButtonFunction,
      bool menuLateralAtivado = true,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AutoSizeText(
                  label,
                  maxLines: 1,
                  style: GoogleFonts.roboto(
                      color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                      fontSize: sizeLabel ?? 26,
                      fontWeight: fontWeight ?? FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: calenderButtonFunction,
                icon: Icon(
                  Icons.calendar_month,
                  color: amareloColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Future<List<DateTime?>?> selectDatePickedAgend({
    required BuildContext context,
  }) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayHighlightColor: const Color.fromARGB(255, 194, 175, 3),
        dayTextStyle: const TextStyle(color: Colors.white),
        weekdayLabelTextStyle: const TextStyle(color: Colors.grey),
        controlsTextStyle: const TextStyle(color: Colors.white),
        yearTextStyle: const TextStyle(color: Colors.white),
        monthTextStyle: const TextStyle(color: Colors.white),
        firstDate: DateTime.now(),
        disabledDayTextStyle: const TextStyle(color: Colors.grey),
        disabledMonthTextStyle: const TextStyle(color: Colors.grey),
        selectedDayTextStyle: const TextStyle(color: Colors.black),
        lastMonthIcon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        nextMonthIcon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
      dialogSize: const Size(325, 400),
      value: [],
      dialogBackgroundColor: Color.fromARGB(255, 26, 26, 26),
      borderRadius: BorderRadius.circular(15),
    );

    return results;
  }

  Future<List<DateTime?>?> selectDatePicked({
    required BuildContext context,
  }) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        selectedDayHighlightColor: const Color.fromARGB(255, 194, 175, 3),
        dayTextStyle: const TextStyle(color: Colors.white),
        weekdayLabelTextStyle: const TextStyle(color: Colors.grey),
        controlsTextStyle: const TextStyle(color: Colors.white),
        yearTextStyle: const TextStyle(color: Colors.white),
        monthTextStyle: const TextStyle(color: Colors.white),
        disabledDayTextStyle: const TextStyle(color: Colors.grey),
        disabledMonthTextStyle: const TextStyle(color: Colors.grey),
        selectedDayTextStyle: const TextStyle(color: Colors.black),
        lastMonthIcon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        nextMonthIcon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
      dialogSize: const Size(325, 400),
      value: [],
      dialogBackgroundColor: Color.fromARGB(255, 26, 26, 26),
      borderRadius: BorderRadius.circular(15),
    );

    return results;
  }

  Future<List<DateTime?>?> selectDateRangerPicked(
      {required BuildContext context}) async {
    var results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        selectedDayHighlightColor: const Color.fromARGB(255, 194, 175, 3),
        dayTextStyle: const TextStyle(color: Colors.white),
        yearTextStyle: const TextStyle(color: Colors.white),
        monthTextStyle: const TextStyle(color: Colors.white),
        controlsTextStyle: const TextStyle(color: Colors.white),
        disabledMonthTextStyle: const TextStyle(color: Colors.grey),
        weekdayLabelTextStyle: const TextStyle(color: Colors.grey),
        lastMonthIcon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        nextMonthIcon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        disabledDayTextStyle: const TextStyle(color: Colors.grey),
        selectedDayTextStyle: const TextStyle(color: Colors.black),
      ),
      dialogSize: const Size(325, 400),
      value: [],
      dialogBackgroundColor: Color.fromARGB(255, 26, 26, 26),
      borderRadius: BorderRadius.circular(15),
    );

    return results;
  }

  Widget getCabecalhoHorarios(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      Widget? buscarWidget,
      String? labelButton,
      Icon? iconButton,
      required VoidCallback callback,
      bool searchCalender = false,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: paddingTop ?? 43,
        ),

        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: callback,
                icon: iconButton,
                label: Text(
                  labelButton ?? "",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // botao agendamento
        botaoWidget ??
            Center(
              child: buttonIcon(
                  label: "Consultar Agendamento",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultaAgendamento(),
                        ));
                  },
                  icon: Image.asset(
                    "asset/calender_consulta.png",
                    height: 25,
                    width: 25,
                  )),
            ),
        //fim botao agendamento
      ],
    );
  }

  Widget getCabecalhoHorariosDetalhes(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      Widget? buscarWidget,
      String? labelButton,
      Icon? iconButton,
      required VoidCallback callback,
      bool searchCalender = false,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: paddingTop ?? 43,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 32,
              )),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: callback,
                icon: iconButton,
                label: Text(
                  labelButton ?? "",
                  style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // botao agendamento
        botaoWidget ??
            Center(
              child: buttonIcon(
                  label: "Consultar Agendamento",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultaAgendamento(),
                        ));
                  },
                  icon: Image.asset(
                    "asset/calender_consulta.png",
                    height: 25,
                    width: 25,
                  )),
            ),
        //fim botao agendamento
      ],
    );
  }

  Widget cabecalhoConfiguracoes(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      double? paddingTop,
      FontWeight? fontWeight,
      Widget? botaoWidget,
      Widget? buscarWidget,
      bool searchCalender = false,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: paddingTop ?? 43,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 32,
              )),
        ),

        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
              searchCalender
                  ? IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month,
                        color: amareloColor,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // botao agendamento
        botaoWidget ??
            Center(
              child: buttonIcon(
                  label: "Consultar Agendamento",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultaAgendamento(),
                        ));
                  },
                  icon: Image.asset(
                    "asset/calender_consulta.png",
                    height: 25,
                    width: 25,
                  )),
            ),
        //fim botao agendamento
      ],
    );
  }

  Widget cabecalhoComLabel(
      {required String label,
      Color? colorborder,
      Color? colorLabel,
      double? sizeLabel,
      FontWeight? fontWeight,
      VoidCallback? onPressedMenu,
      required BuildContext context}) {
    //Cabeçalho app com linha amarela bottom
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 15,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
                size: 32,
              )),
        ),
        Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      width: 2.2,
                      color: colorborder ?? Color.fromARGB(255, 125, 100, 0)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.roboto(
                    color: colorLabel ?? Color.fromARGB(255, 254, 205, 12),
                    fontSize: sizeLabel ?? 26,
                    fontWeight: fontWeight ?? FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buttonIcon({
    required Widget icon,
    required String label,
    required VoidCallback onPressed,
    double? elevation,
    Color? surfaceTintColor,
    EdgeInsetsGeometry? padding,
    Color? shadowColor,
    Color? backgroundColor,
    Color? textColor,
    double? sizeText,
    FontWeight? fontWeight,
    Color? overlayColor,
  }) {
    return ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
            elevation: WidgetStatePropertyAll(elevation ?? 4),
            alignment: Alignment.center,
            overlayColor: WidgetStatePropertyAll(
                overlayColor ?? Color.fromARGB(255, 18, 18, 18)),
            surfaceTintColor: WidgetStatePropertyAll(
                surfaceTintColor ?? Color.fromARGB(255, 46, 46, 46)),
            padding: WidgetStatePropertyAll(
                padding ?? EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
            shadowColor: WidgetStatePropertyAll(
                shadowColor ?? const Color.fromARGB(255, 0, 0, 0)),
            backgroundColor: WidgetStatePropertyAll(
                backgroundColor ?? Color.fromARGB(255, 46, 46, 46))),
        icon: icon,
        label: Text(
          label,
          style: GoogleFonts.robotoCondensed(
              color: textColor ?? amareloColor,
              fontSize: sizeText ?? 18,
              fontWeight: fontWeight ?? FontWeight.w600),
        ));
    //Botao agendamento;
  }

  Widget cardData(
      {required String titulo,
      required String subTitulo,
      double? sizeTitulo,
      double? sizeSubTitulo,
      Color? tituloColor,
      Color? subTituloColor,
      double? elevation,
      Color? shadowColor,
      double? margin,
      double? width,
      double? height,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: shadowColor ?? Colors.black,
      surfaceTintColor: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: true,
      margin: EdgeInsets.all(margin ?? 5),
      child: Container(
        width: width ?? 180,
        height: height,
        padding:
            padding ?? EdgeInsets.only(top: 5, bottom: 10, left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: GoogleFonts.roboto(
                  color: tituloColor ?? Colors.white,
                  fontSize: sizeTitulo ?? 17,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              subTitulo,
              style: GoogleFonts.roboto(
                  color: subTituloColor ?? Colors.white,
                  fontSize: sizeSubTitulo ?? 17,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardDataHorario(
      {required String titulo,
      double? sizeTitulo,
      Color? tituloColor,
      double? elevation,
      Color? shadowColor,
      double? margin,
      double? width,
      double? height,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: shadowColor ?? Colors.black,
      surfaceTintColor: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: true,
      margin: EdgeInsets.all(margin ?? 5),
      child: Container(
        width: width ?? 180,
        height: height,
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.start,
          children: [
            Image.asset(
              "asset/cronometro_icon.png",
              height: 60,
              width: 60,
            ),
            Text(
              titulo,
              style: GoogleFonts.roboto(
                  color: tituloColor ?? Colors.white,
                  fontSize: sizeTitulo ?? 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardMeuAgendamento(
      {String? data,
      String? diaDaSemana,
      String? nomeProfissional,
      String? nomeServico,
      String? valorServico,
      String? horario,
      double? sizeTitulo,
      double? sizeSubTitulo,
      Color? tituloColor,
      Color? subTituloColor,
      double? elevation,
      Color? shadowColor,
      double? margin,
      double? width,
      double? height,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: shadowColor ?? Colors.black,
      surfaceTintColor: subTituloColor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: true,
      margin: EdgeInsets.all(margin ?? 5),
      child: Container(
        width: width ?? 200,
        height: height,
        child: Column(
          children: [
            Container(
              width: width ?? 200,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.spaceBetween,
                runAlignment: WrapAlignment.start,
                children: [
                  Text(
                    data ?? "",
                    style: GoogleFonts.roboto(
                        color: tituloColor ?? Colors.white,
                        fontSize: sizeTitulo ?? 15,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    diaDaSemana ?? "",
                    style: GoogleFonts.roboto(
                        color: subTituloColor ?? Colors.white,
                        fontSize: sizeSubTitulo ?? 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
                width: width ?? 200,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Wrap(
                        children: [
                          Text(
                            nomeProfissional ?? "",
                            style: GoogleFonts.roboto(
                                color: tituloColor ?? Colors.white,
                                fontSize: sizeTitulo ?? 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        children: [
                          Text(
                            horario ?? "",
                            style: GoogleFonts.roboto(
                                color: subTituloColor ?? Colors.white,
                                fontSize: sizeSubTitulo ?? 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Container(
                width: width ?? 200,
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Wrap(
                        children: [
                          Text(
                            nomeServico ?? "",
                            style: GoogleFonts.roboto(
                                color: tituloColor ?? Colors.white,
                                fontSize: sizeTitulo ?? 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        children: [
                          Text(
                            valorServico ?? "",
                            style: GoogleFonts.roboto(
                                color: subTituloColor ?? Colors.white,
                                fontSize: sizeSubTitulo ?? 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget cardMeuAgendamentoFoto(
      {String? data,
      String? diaDaSemana,
      String? nome,
      String? nomeServico,
      String? valorServico,
      String? urlFotoServico,
      String? horario,
      required int idAgendamento,
      String? nomeProfissional,
      required String codeTelefoneCliente,
      String? telefoneCliente,
      double? sizeTitulo,
      double? sizeSubTitulo,
      Color? tituloColor,
      Color? subTituloColor,
      double? elevation,
      required Estabelecimento estabelecimento,
      Color? shadowColor,
      double? margin,
      double? width,
      double? heightFoto,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: shadowColor ?? Colors.black,
      surfaceTintColor: subTituloColor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: true,
      child: Container(
        width: width ?? 200,
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        maxLines: 1,
                        data ?? "",
                        style: GoogleFonts.roboto(
                            color: tituloColor ?? Colors.white,
                            fontSize: sizeTitulo ?? 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        horario ?? "",
                        style: GoogleFonts.roboto(
                            color: subTituloColor ?? Colors.white,
                            fontSize: sizeSubTitulo ?? 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        nome ?? "",
                        style: GoogleFonts.roboto(
                            color: tituloColor ?? Colors.white,
                            fontSize: sizeTitulo ?? 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        nomeServico ?? "",
                        style: GoogleFonts.roboto(
                            color: tituloColor ?? Colors.white,
                            fontSize: sizeTitulo ?? 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        children: [
                          Text(
                            "$codeTelefoneCliente $telefoneCliente",
                            style: GoogleFonts.roboto(
                                color: tituloColor ?? Colors.white,
                                fontSize: sizeTitulo ?? 15,
                                fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                              onPressed: () async {
                                var servicos = await Servicorepository()
                                    .getServicosAgendamento(
                                        idAgendamento: idAgendamento);
                                String servicosUri = "";
                                double totalServico = 0;
                                for (var servico in servicos) {
                                  servicosUri +=
                                      "* ${servico.nome}...${Utils().converterDoubleParaEuro(servico.valor)}\n";
                                  totalServico += servico.valor;
                                }

                                String text =
                                    "Olá, $nome!\nAqui é da barbearia ${estabelecimento.nome}.\nSeu horário está confirmado para $data às $horario com o barbeiro $nomeProfissional.\nEndereço: ${estabelecimento.endereco}\nServiços: \n$servicosUri\nTotal: ${Utils().converterDoubleParaEuro(totalServico)}\nSe precisar reagendar ou cancelar, é só nos avisar.\nAté lá";
                                String enconded = Uri.encodeComponent(text);
                                final Uri _url = Uri.parse(
                                    'https://wa.me/${codeTelefoneCliente!.replaceAll("+", "")}${telefoneCliente}?text=$enconded');
                                if (!await launchUrl(_url)) {
                                  throw Exception('Could not launch $_url');
                                }
                              },
                              icon: Image.asset(
                                "asset/whatsapp.png",
                                height: 25,
                                width: 25,
                              )),
                        ],
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          urlFotoServico ?? "",
                          height: heightFoto ?? 150,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget cardMeuAgendamentoConsulta(
      {String? data,
      String? diaDaSemana,
      String? nome,
      String? nomeServico,
      String? valorServico,
      String? urlFotoServico,
      String? horario,
      double? sizeTitulo,
      double? sizeSubTitulo,
      Color? tituloColor,
      Color? subTituloColor,
      double? elevation,
      Color? shadowColor,
      double? margin,
      double? width,
      double? heightFoto,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: shadowColor ?? Colors.black,
      surfaceTintColor: subTituloColor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: true,
      child: Container(
        width: width ?? 200,
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        maxLines: 1,
                        data ?? "",
                        style: GoogleFonts.roboto(
                            color: tituloColor ?? Colors.white,
                            fontSize: sizeTitulo ?? 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$horario - $diaDaSemana",
                        style: GoogleFonts.roboto(
                            color: subTituloColor ?? Colors.white,
                            fontSize: sizeSubTitulo ?? 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        nome ?? "",
                        style: GoogleFonts.roboto(
                            color: tituloColor ?? Colors.white,
                            fontSize: sizeTitulo ?? 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        nomeServico ?? "",
                        style: GoogleFonts.roboto(
                            color: tituloColor ?? Colors.white,
                            fontSize: sizeTitulo ?? 15,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        valorServico ?? "",
                        style: GoogleFonts.roboto(
                            color: tituloColor ?? Colors.white,
                            fontSize: sizeTitulo ?? 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          urlFotoServico ?? "",
                          height: heightFoto ?? 150,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // Inicio Widgets Profissional
  Widget cardProfissional(
      {required String nomeProfissional,
      required String fotoPerfil,
      double? sizeTitulo,
      double? heightImg,
      double? widthImg,
      Color? tituloColor,
      double? elevation,
      bool selecionadoItem = false,
      Color? shadowColorSelecionado,
      Color? shadowColor,
      double? margin,
      double? width,
      double? height,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: selecionadoItem
          ? shadowColorSelecionado ?? amareloColor
          : shadowColor ?? Colors.black,
      surfaceTintColor: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: false,
      margin: EdgeInsets.all(margin ?? 5),
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: selecionadoItem
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: amareloColor)),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)))
            : null,
        width: width ?? 180,
        height: height,
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: SizedBox(
                height: heightImg ?? 150,
                width: widthImg ?? 180,
                child: Image.network(
                  fotoPerfil,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                nomeProfissional,
                style: GoogleFonts.roboto(
                    color: tituloColor ?? Colors.white,
                    fontSize: sizeTitulo ?? 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardProfissionalAdmin(
      {required String nomeProfissional,
      required String fotoPerfil,
      required VoidCallback onPressed,
      double? sizeTitulo,
      double? heightImg,
      double? widthImg,
      Color? tituloColor,
      double? elevation,
      bool selecionadoItem = false,
      Color? shadowColorSelecionado,
      Color? shadowColor,
      double? margin,
      double? width,
      double? height,
      bool editarAtivado = false,
      bool ativadoProfissinal = false,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
        elevation: elevation ?? 5,
        shadowColor: selecionadoItem
            ? shadowColorSelecionado ?? amareloColor
            : shadowColor ?? Colors.black,
        surfaceTintColor: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
        color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
        borderOnForeground: false,
        margin: EdgeInsets.all(margin ?? 5),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: selecionadoItem
                  ? BoxDecoration(
                      border: Border(bottom: BorderSide(color: amareloColor)),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)))
                  : null,
              width: width ?? 180,
              height: height,
              child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: SizedBox(
                      height: heightImg ?? 150,
                      width: widthImg ?? 180,
                      child: Image.network(
                        fotoPerfil,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      nomeProfissional,
                      style: GoogleFonts.roboto(
                          color: tituloColor ?? Colors.white,
                          fontSize: sizeTitulo ?? 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            if (editarAtivado) ...[
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: onPressed,
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.black45)),
                  )),
            ],
            Positioned(
                top: 10,
                left: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: ativadoProfissinal
                      ? Text(
                          "Ativado",
                          style: GoogleFonts.roboto(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Desativado",
                          style: GoogleFonts.roboto(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                )),
          ],
        ));
  }

  //Fim Widgets Profissional

  // Inicio Widgets Serviços
  Widget cardServico(
      {required String nomeServico,
      required String valor,
      required String urlImg,
      double? sizeTitulo,
      double? sizeTextValor,
      double? heightImg,
      double? widthImg,
      Color? tituloColor,
      double? elevation,
      bool selecionadoItem = false,
      Color? shadowColorSelecionado,
      Color? shadowColor,
      double? margin,
      double? width,
      double? height,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: selecionadoItem
          ? shadowColorSelecionado ?? amareloColor
          : shadowColor ?? Colors.black,
      surfaceTintColor: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: false,
      margin: EdgeInsets.all(margin ?? 5),
      child: Container(
        padding: EdgeInsets.only(bottom: 5),
        decoration: selecionadoItem
            ? BoxDecoration(
                border: Border(bottom: BorderSide(color: amareloColor)),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)))
            : null,
        width: width ?? 180,
        height: height,
        child: Wrap(
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: SizedBox(
                height: heightImg ?? 150,
                width: widthImg ?? 180,
                child: Image.network(
                  urlImg,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    child: AutoSizeText(
                      nomeServico,
                      minFontSize: 16,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          color: tituloColor ?? Colors.white,
                          fontSize: sizeTitulo ?? 12,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 2,
                left: 5,
                right: 5,
              ),
              child: Text(
                valor,
                style: GoogleFonts.roboto(
                    color: tituloColor ?? Colors.white,
                    fontSize: sizeTextValor ?? 16,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardServicoAdmin(
      {required String nomeServico,
      required String valor,
      required String urlImg,
      required VoidCallback onPressed,
      double? sizeTitulo,
      double? sizeTextValor,
      double? heightImg,
      double? widthImg,
      Color? tituloColor,
      double? elevation,
      bool selecionadoItem = false,
      Color? shadowColorSelecionado,
      Color? shadowColor,
      double? margin,
      double? width,
      double? height,
      bool editarAtivado = false,
      bool ativadoProfissinal = false,
      EdgeInsetsGeometry? padding,
      Color? backgroundcolor}) {
    return Card(
      elevation: elevation ?? 5,
      shadowColor: selecionadoItem
          ? shadowColorSelecionado ?? amareloColor
          : shadowColor ?? Colors.black,
      surfaceTintColor: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      color: backgroundcolor ?? Color.fromARGB(255, 40, 40, 40),
      borderOnForeground: false,
      margin: EdgeInsets.all(margin ?? 5),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 5),
            decoration: selecionadoItem
                ? BoxDecoration(
                    border: Border(bottom: BorderSide(color: amareloColor)),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)))
                : null,
            width: width ?? 180,
            height: height,
            child: Wrap(
              direction: Axis.horizontal,
              crossAxisAlignment: WrapCrossAlignment.center,
              runAlignment: WrapAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: SizedBox(
                    height: heightImg ?? 150,
                    width: widthImg ?? 180,
                    child: Image.network(
                      urlImg,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 5, right: 5),
                        child: AutoSizeText(
                          nomeServico,
                          minFontSize: 16,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              color: tituloColor ?? Colors.white,
                              fontSize: sizeTitulo ?? 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 2,
                    left: 5,
                    right: 5,
                  ),
                  child: Text(
                    valor,
                    style: GoogleFonts.roboto(
                        color: tituloColor ?? Colors.white,
                        fontSize: sizeTitulo ?? 18,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          if (editarAtivado) ...[
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: onPressed,
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black45)),
                )),
          ],
          Positioned(
              top: 10,
              left: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ativadoProfissinal
                    ? Text(
                        "Ativado",
                        style: GoogleFonts.roboto(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold),
                      )
                    : Text(
                        "Desativado",
                        style: GoogleFonts.roboto(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold),
                      ),
              )),
        ],
      ),
    );
  }

  //Fim Widgets Serviços

  Widget mensagemTentaMaisTarde({required Color cor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Center(
        child: Text(
          "Não foi possivel carregar\nTente novamente, mais tarde",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              color: cor, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }

  Widget mensagempersonalizadaCenter(
      {required Color cor,
      required String label,
      double? fontSize,
      double? paddingVertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 25),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              color: cor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 20),
        ),
      ),
    );
  }

  //
  // carregamento circular
  Widget carregamentoCircular({double? paddingVertical}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: paddingVertical ?? 150),
      child: Center(
        child: CircularProgressIndicator(
          color: amareloColor,
        ),
      ),
    );
  }

  //Fim carregamento circular

  // Inicio TextFilds
  Widget textFildCep({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    int? limiteCarac,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        validator: (value) => combine([
          () => isNotEmpty(value),
        ]),
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  Widget textFildCNPJ({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    int? limiteCarac,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  Widget textFildLabel({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    int? limiteCarac,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        validator: (value) => combine([
          () => isNotEmpty(value),
          if (limiteCarac != null) ...[
            () => limiteCaractere(value, limiteCarac),
          ]
        ]),
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  Widget textFildLabelUrlBarbearia({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    int? limiteCarac,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        validator: (value) => combine([
          () => isNotEmpty(value),
          if (limiteCarac != null) ...[
            () => limiteCaractere(value, limiteCarac),
          ]
        ]),
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        textAlign: TextAlign.end,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  Widget textFildLabelSemValidor({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    int? limiteCarac,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  Widget textFildTextArea({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    int? limiteCarac,
    required int maxLines,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        validator: (value) => combine([
          () => isNotEmpty(value),
          if (limiteCarac != null) ...[
            () => limiteCaractere(value, limiteCarac),
          ]
        ]),
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  Widget textFildSenha({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    int? limiteCarac,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    VoidCallback? functionObscure,
    VoidCallback? onSubmitted,
    bool? textObscure = true,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        validator: (value) => combine([
          () => isNotEmpty(value),
          if (limiteCarac != null) ...[
            () => limiteCaractere(value, limiteCarac),
          ],
          () => minimoCaractere(value, 8),
        ]),
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        obscureText: textObscure ?? true,
        onFieldSubmitted: (value) => onSubmitted,
        decoration: InputDecoration(
            hintStyle: GoogleFonts.roboto(),
            hintText: hintText,
            hoverColor: Colors.white,
            contentPadding: contentPadding ?? EdgeInsets.all(10),
            border: inputBorder ?? InputBorder.none,
            suffixIcon: IconButton(
                onPressed: functionObscure,
                icon: textObscure == true
                    ? Icon(
                        Icons.password,
                        color: Colors.black,
                      )
                    : Icon(
                        Icons.remove_red_eye,
                        color: Colors.black,
                      ))),
      ),
    );
  }

  Widget textFildEmail({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        validator: (value) => combine([
          () => isNotEmpty(value),
          () => emailValidation(value),
        ]),
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  Widget textFildTelefone({
    required String hintText,
    double? elevation,
    Color? shadowColor,
    Color? backgoundcolor,
    EdgeInsets? contentPadding,
    InputBorder? inputBorder,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatter,
    List<String? Function()>? validators,
    TextInputType? textInputType,
  }) {
    return Card(
      elevation: elevation ?? 6,
      borderOnForeground: true,
      surfaceTintColor: backgoundcolor ?? Colors.white,
      shadowColor: shadowColor ?? const Color.fromARGB(255, 90, 90, 90),
      color: backgoundcolor ?? Colors.white,
      child: TextFormField(
        controller: controller,
        validator: (value) => combine([
          () => isNotEmpty(value),
          () => limiteCaractere(value, 15),
        ]),
        inputFormatters: inputFormatter,
        keyboardType: textInputType,
        decoration: InputDecoration(
          hintStyle: GoogleFonts.roboto(),
          hintText: hintText,
          hoverColor: Colors.white,
          contentPadding: contentPadding ?? EdgeInsets.all(10),
          border: inputBorder ?? InputBorder.none,
        ),
      ),
    );
  }

  //Fim TextFild

  //Drawer Admin
  Widget adminDrawer({
    required double heightMedia,
    required double widthMedia,
    required BuildContext context,
    required Profissional profissional,
    required Estabelecimento estabelecimento,
  }) {
    return Drawer(
      backgroundColor: Color.fromARGB(255, 26, 26, 26),
      surfaceTintColor: Color.fromARGB(255, 26, 26, 26),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthMedia * 0.03),
        child: Column(
          children: [
            SizedBox(height: heightMedia * 0.06),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: amareloColor, width: 2))),
              child: Image.network(
                estabelecimento.urlLogo,
                height: heightMedia * 0.26,
                width: widthMedia,
                fit: BoxFit.scaleDown,
              ),
            ),
            //Menu de ListTile
            ListTile(
              leading: Icon(
                Icons.dashboard,
                color: amareloColor,
              ),
              title: Text(
                "Dashboard",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 22),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.view_stream,
                color: amareloColor,
              ),
              title: Text(
                "Agendamentos Não Concluído",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgendamentosNaoConcluido(
                        estabelecimento: estabelecimento,
                        profissional: profissional,
                      ),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: amareloColor,
              ),
              title: Text(
                "Configurações",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 22),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Configuracoes(
                        estabelecimento: estabelecimento,
                      ),
                    ));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: amareloColor,
              ),
              title: Text(
                "Sair",
                style: GoogleFonts.roboto(color: Colors.white, fontSize: 22),
              ),
              onTap: () async {
                await AuthService().limpaPeistencia();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginAdministrador(
                        estabelecimento: estabelecimento,
                      ),
                    ));
              },
            ),
            //Fim Menu de ListTile
          ],
        ),
      ),
    );
  }
  //Fim Drawer Admin
}
