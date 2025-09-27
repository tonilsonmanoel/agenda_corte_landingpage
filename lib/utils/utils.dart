import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Utils {
  String getDataFormat(DateTime dia) {
    return DateFormat('dd/MM/yyyy').format(dia);
  }

  void inilizacaoDataFormat() async {
    await initializeDateFormatting('pt_BR', null);
  }

  String getDiaNomeFormat(DateTime dia) {
    inilizacaoDataFormat();
    String formattedDateName = DateFormat('EEEE', 'pt_BR').format(dia);
    String captalizadoDateName =
        formattedDateName[0].toUpperCase() + formattedDateName.substring(1);

    return captalizadoDateName;
  }

  String getDiaHorariosFormat(DateTime diaHora) {
    String horario = "${diaHora.hour}:${diaHora.minute}";
    return horario;
  }

  List<Map<String, dynamic>> getDiasDaSemanaMap() {
    List<String> diasDaSemana = [
      "Segunda-feira",
      "Terça-feira",
      "Quarta-feira",
      "Quinta-feira",
      "Sexta-feira",
      "Sábado",
      "Domingo",
    ];
    List<Map<String, dynamic>> jsonDiasDaSemana = List.generate(
        7,
        (index) => {
              "dia": diasDaSemana[index],
              "ativado": index < 5 ? true : false,
            });

    return jsonDiasDaSemana;
  }

  List<Map<String, dynamic>> completarDiasDaSemana(
      List<Map<String, dynamic>> diasParciais) {
    const diasSemana = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado',
      'Domingo',
    ];

    final mapaDias = {
      for (var dia in diasParciais) dia['dia']: dia['ativado'],
    };

    return [
      for (var dia in diasSemana)
        {'dia': dia, 'ativado': mapaDias[dia] ?? false}
    ];
  }

  List<Map<String, dynamic>> getAvailableTimes() {
    List<Map<String, dynamic>> times = [];
    DateTime startTime = DateTime(0, 0, 0, 5, 0);
    DateTime endTime = DateTime(0, 0, 0, 22, 0);

    while (startTime.isBefore(endTime)) {
      bool ativado = false;
      if (startTime.isAfter(DateTime(0, 0, 0, 7, 59)) &&
          startTime.isBefore(DateTime(0, 0, 0, 18, 1))) {
        ativado = true;
      }
      Map<String, dynamic> horario = {
        "hora": DateFormat.Hm().format(startTime),
        "ativado": ativado,
      };

      times.add(horario);
      startTime = startTime.add(Duration(minutes: 30));
    }

    return times;
  }

  List<String> listaHorariosCompleta() {
    List<String> times = [];
    DateTime startTime = DateTime(0, 0, 0, 0, 0);
    DateTime endTime = DateTime(0, 0, 0, 24, 0);

    while (startTime.isBefore(endTime)) {
      times.add(DateFormat.Hm().format(startTime));
      startTime = startTime.add(Duration(minutes: 10));
    }

    return times;
  }

  List<Map<String, dynamic>> completarHorarios(
      List<Map<String, dynamic>> horariosParciais) {
    var horarios = listaHorariosCompleta();
    final mapaDias = {
      for (var horario in horariosParciais) horario['hora']: horario['ativado'],
    };

    return [
      for (var horario in horarios)
        {'hora': horario, 'ativado': mapaDias[horario] ?? false}
    ];
  }

  String converterDoubleParaEuro(double valor) {
    final formatEuroPT = NumberFormat.simpleCurrency(
      locale: 'pt_PT',
      name: 'EUR',
    );
    return formatEuroPT.format(valor);
  }
}
