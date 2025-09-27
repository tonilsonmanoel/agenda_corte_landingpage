import 'package:agendamento_barber/models/Agendamento.dart';
import 'package:agendamento_barber/models/Servico.dart';
import 'package:agendamento_barber/repository/servicoRepository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Agendamentorepository {
  //var db = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<void> criarAgendamento(
      {required String nomeCliente,
      required String telefoneCliente,
      required String codeTelefoneCliente,
      required int uidProfissional,
      required String nomeProfissional,
      required String dataString,
      required String diaDaSemana,
      required String horario,
      required double totalAgendamento,
      required DateTime dateTime,
      required List<int> servicos,
      required bool confimado,
      required String isoCodePhone,
      required int idEstabelecimento}) async {
    final agendamentoJson = {
      "nomecliente": nomeCliente,
      "telefonecliente": telefoneCliente,
      "code_telefone": codeTelefoneCliente,
      "idprofissional": uidProfissional,
      "diadasemana": diaDaSemana,
      "horario": horario,
      "datetime": dateTime.toIso8601String(),
      "confimado": confimado,
      "concluido": false,
      "totalagendamento": totalAgendamento,
      "nomeprofissional": nomeProfissional,
      "data": dataString,
      "iso_code_phone": isoCodePhone,
      "idestabelecimento": idEstabelecimento
    };

    // await db.collection("agendamento").add(agendamentoJson);
    final agendamentoId = await supabase
        .from("agendamentos")
        .insert(agendamentoJson)
        .select("id")
        .single();
    inseriAgendamentoServico(
        servicosId: servicos, agendamentoId: agendamentoId["id"]);
  }

  Future<void> inseriAgendamentoServico(
      {required List<int> servicosId, required int agendamentoId}) async {
    List<Map<String, int>> listaJson = [];
    for (var servico in servicosId) {
      listaJson.add({
        "id_agendamento": agendamentoId,
        "id_servico": servico,
      });
    }

    await supabase.from("agendamentos_servicos").insert(listaJson);
  }

  Future<void> updateAgendamentoServico(
      {required List<int> servicosId, required int agendamentoId}) async {
    List<Map<String, int>> listaJson = [];
    for (var servico in servicosId) {
      listaJson.add({
        "id_agendamento": agendamentoId,
        "id_servico": servico,
      });
    }

    await supabase
        .from("agendamentos_servicos")
        .delete()
        .eq("id_agendamento", agendamentoId);
    await supabase.from("agendamentos_servicos").insert(listaJson);
  }

  Future<List<Agendamento>> getAgendamentosProfissionalRepository(
      {required int uidProfissional,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    DateTime dateTimeNow = DateTime.now();
    DateTime data = DateTime(
      dateTimeNow.year,
      dateTimeNow.month,
      dateTimeNow.day,
    );

    var documentos = [];
    if (isAdmin) {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("concluido", false)
          .eq("idestabelecimento", idEstabelecimento)
          .gte(
              "datetime", data.subtract(Duration(seconds: 1)).toIso8601String())
          .order("datetime");
    } else {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idprofissional", uidProfissional)
          .eq("idestabelecimento", idEstabelecimento)
          .eq("concluido", false)
          .gte(
              "datetime", data.subtract(Duration(seconds: 1)).toIso8601String())
          .order("datetime");
    }

    List<Agendamento> agentes = [];
    for (var i = 0; i < documentos.length; i++) {
      try {
        final data = documentos[i]["datetime"];

        DateTime date = DateTime.parse(data);
        var servicosResult = await Servicorepository()
            .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

        List<Servico> servicos = [];

        for (var s in servicosResult) {
          servicos.add(Servico(
              nome: s.nome,
              valor: s.valor,
              urlImg: s.urlImg,
              ativo: s.ativo,
              ativoLadingpage: s.ativoLadingpage,
              idProfissional: s.idProfissional,
              uid: s.uid));
        }

        Agendamento agendamento = Agendamento(
            uid: documentos[i]["id"],
            uidProfissional: documentos[i]["idprofissional"],
            data: documentos[i]["data"],
            horario: documentos[i]["horario"],
            dateTimeAgenda: date,
            diaDaSemana: documentos[i]["diadasemana"],
            concluido: documentos[i]["concluido"],
            confimado: documentos[i]["confimado"],
            nomeCliente: documentos[i]["nomecliente"],
            totalAgendamento: documentos[i]["totalagendamento"],
            nomeProfissional: documentos[i]["nomeprofissional"],
            telefoneCliente: documentos[i]["telefonecliente"],
            codeTelefoneCliente: documentos[i]["code_telefone"],
            isoCodePhone: documentos[i]["iso_code_phone"],
            idEstabelecimento: documentos[i]["idestabelecimento"],
            servicos: servicos);

        agentes.add(agendamento);
      } catch (e) {
        print("Erro ao processar documento $i: ${e.toString()}");
      }
    }

    return agentes;
  }

  Future<List<Agendamento>> getAgendamentosProfissionalDateRepository(
      {required int uidProfissional,
      List<DateTime?>? datasSelecionadas,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    var documentos = [];

    if (datasSelecionadas!.length == 2) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[1]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[1]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("idprofissional", uidProfissional)
            .eq("concluido", false)
            .order("datetime");
      }
    }
    if (datasSelecionadas.length == 1) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[0]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[0]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("idprofissional", uidProfissional)
            .eq("concluido", false)
            .order("datetime");
      }
    }

    if (datasSelecionadas[0] == null) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .eq("concluido", false)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .eq("idprofissional", uidProfissional)
            .eq("concluido", false)
            .order("datetime");
      }
    }

    List<Agendamento> agentes = [];
    for (var i = 0; i < documentos.length; i++) {
      try {
        final data = documentos[i]["datetime"];

        DateTime date = DateTime.parse(data);
        var servicosResult = await Servicorepository()
            .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

        List<Servico> servicos = [];

        for (var s in servicosResult) {
          servicos.add(Servico(
              nome: s.nome,
              valor: s.valor,
              urlImg: s.urlImg,
              ativo: s.ativo,
              ativoLadingpage: s.ativoLadingpage,
              idProfissional: s.idProfissional,
              uid: s.uid));
        }

        Agendamento agendamento = Agendamento(
            uid: documentos[i]["id"],
            uidProfissional: documentos[i]["idprofissional"],
            data: documentos[i]["data"],
            horario: documentos[i]["horario"],
            dateTimeAgenda: date,
            diaDaSemana: documentos[i]["diadasemana"],
            concluido: documentos[i]["concluido"],
            confimado: documentos[i]["confimado"],
            nomeCliente: documentos[i]["nomecliente"],
            totalAgendamento: documentos[i]["totalagendamento"],
            nomeProfissional: documentos[i]["nomeprofissional"],
            telefoneCliente: documentos[i]["telefonecliente"],
            codeTelefoneCliente: documentos[i]["code_telefone"],
            isoCodePhone: documentos[i]["iso_code_phone"],
            idEstabelecimento: documentos[i]["idestabelecimento"],
            servicos: servicos);

        agentes.add(agendamento);
      } catch (e) {
        print("Erro ao processar documento $i: $e");
      }
    }

    return agentes;
  }

  Future<List<Agendamento>> getAgendamentosRealizadosProfissional(
      {required int uidProfissional,
      String? buscar = "",
      required bool isAdmin,
      required int idEstabelecimento}) async {
    var documentos = [];

    if (isAdmin) {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .eq("concluido", true)
          .ilike("nomecliente", '%%')
          .order("datetime");
    } else {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .eq("idprofissional", uidProfissional)
          .eq("concluido", true)
          .ilike("nomecliente", '%%')
          .order("datetime");
    }

    List<Agendamento> agentes = [];
    for (var i = 0; i < documentos.length; i++) {
      try {
        final data = documentos[i]["datetime"];

        DateTime date = DateTime.parse(data);

        var servicosResult = await Servicorepository()
            .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

        List<Servico> servicos = [];

        for (var s in servicosResult) {
          servicos.add(Servico(
              nome: s.nome,
              valor: s.valor,
              urlImg: s.urlImg,
              ativo: s.ativo,
              ativoLadingpage: s.ativoLadingpage,
              idProfissional: s.idProfissional,
              uid: s.uid));
        }

        Agendamento agendamento = Agendamento(
            uid: documentos[i]["id"],
            uidProfissional: documentos[i]["idprofissional"],
            data: documentos[i]["data"],
            horario: documentos[i]["horario"],
            dateTimeAgenda: date,
            diaDaSemana: documentos[i]["diadasemana"],
            concluido: documentos[i]["concluido"],
            confimado: documentos[i]["confimado"],
            nomeCliente: documentos[i]["nomecliente"],
            totalAgendamento: documentos[i]["totalagendamento"],
            nomeProfissional: documentos[i]["nomeprofissional"],
            telefoneCliente: documentos[i]["telefonecliente"],
            codeTelefoneCliente: documentos[i]["code_telefone"],
            isoCodePhone: documentos[i]["iso_code_phone"],
            idEstabelecimento: documentos[i]["idestabelecimento"],
            servicos: servicos);

        agentes.add(agendamento);
      } catch (e) {
        print("Erro ao processar documento $i: $e");
      }
    }

    return agentes;
  }

  Future<List<Agendamento>> getAgendamentosRealizadosDateProfissional(
      {required int uidProfissional,
      List<DateTime?>? datasSelecionadas,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    var documentos = [];

    if (datasSelecionadas!.length == 2) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[1]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("concluido", true)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[1]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("idprofissional", uidProfissional)
            .eq("concluido", true)
            .order("datetime");
      }
    }
    if (datasSelecionadas.length == 1) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[0]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("concluido", true)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[0]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("idprofissional", uidProfissional)
            .eq("concluido", true)
            .order("datetime");
      }
    }

    if (datasSelecionadas[0] == null) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .eq("concluido", true)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .eq("idprofissional", uidProfissional)
            .eq("concluido", true)
            .order("datetime");
      }
    }

    List<Agendamento> agentes = [];
    for (var i = 0; i < documentos.length; i++) {
      try {
        final data = documentos[i]["datetime"];

        DateTime date = DateTime.parse(data);
        var servicosResult = await Servicorepository()
            .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

        List<Servico> servicos = [];

        for (var s in servicosResult) {
          servicos.add(Servico(
              nome: s.nome,
              valor: s.valor,
              urlImg: s.urlImg,
              ativo: s.ativo,
              ativoLadingpage: s.ativoLadingpage,
              idProfissional: s.idProfissional,
              uid: s.uid));
        }

        Agendamento agendamento = Agendamento(
            uid: documentos[i]["id"],
            uidProfissional: documentos[i]["idprofissional"],
            data: documentos[i]["data"],
            horario: documentos[i]["horario"],
            dateTimeAgenda: date,
            diaDaSemana: documentos[i]["diadasemana"],
            concluido: documentos[i]["concluido"],
            confimado: documentos[i]["confimado"],
            nomeCliente: documentos[i]["nomecliente"],
            totalAgendamento: documentos[i]["totalagendamento"],
            nomeProfissional: documentos[i]["nomeprofissional"],
            telefoneCliente: documentos[i]["telefonecliente"],
            codeTelefoneCliente: documentos[i]["code_telefone"],
            isoCodePhone: documentos[i]["iso_code_phone"],
            idEstabelecimento: documentos[i]["idestabelecimento"],
            servicos: servicos);

        agentes.add(agendamento);
      } catch (e) {
        print("Erro ao processar documento $i: $e");
      }
    }

    return agentes;
  }

  Future<List<Agendamento>> getAgendamentosNaoConcluidos(
      {required int uidProfissional,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    var documentos = [];
    if (isAdmin) {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .lte("datetime",
              DateTime.now().add(Duration(days: 1)).toIso8601String())
          .eq("concluido", false)
          .order("datetime");
    } else {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .eq("idprofissional", uidProfissional)
          .lte("datetime",
              DateTime.now().add(Duration(days: 1)).toIso8601String())
          .eq("concluido", false)
          .order("datetime");
    }

    List<Agendamento> agentes = [];
    for (var i = 0; i < documentos.length; i++) {
      try {
        final data = documentos[i]["datetime"];

        DateTime date = DateTime.parse(data);
        var servicosResult = await Servicorepository()
            .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

        List<Servico> servicos = [];

        for (var s in servicosResult) {
          servicos.add(Servico(
              nome: s.nome,
              valor: s.valor,
              urlImg: s.urlImg,
              ativo: s.ativo,
              ativoLadingpage: s.ativoLadingpage,
              idProfissional: s.idProfissional,
              uid: s.uid));
        }

        Agendamento agendamento = Agendamento(
            uid: documentos[i]["id"],
            uidProfissional: documentos[i]["idprofissional"],
            data: documentos[i]["data"],
            horario: documentos[i]["horario"],
            dateTimeAgenda: date,
            diaDaSemana: documentos[i]["diadasemana"],
            concluido: documentos[i]["concluido"],
            confimado: documentos[i]["confimado"],
            nomeCliente: documentos[i]["nomecliente"],
            totalAgendamento: documentos[i]["totalagendamento"],
            nomeProfissional: documentos[i]["nomeprofissional"],
            telefoneCliente: documentos[i]["telefonecliente"],
            codeTelefoneCliente: documentos[i]["code_telefone"],
            isoCodePhone: documentos[i]["iso_code_phone"],
            idEstabelecimento: documentos[i]["idestabelecimento"],
            servicos: servicos);

        agentes.add(agendamento);
      } catch (e) {
        print("Erro ao processar documento $i: $e");
      }
    }

    return agentes;
  }

  Future<List<Agendamento>> getAgendamentosNaoConcluidosDate(
      {required int uidProfissional,
      List<DateTime?>? datasSelecionadas,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    var documentos = [];

    if (datasSelecionadas!.length == 2) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .lte("datetime",
                DateTime.now().add(Duration(days: 1)).toIso8601String())
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[1]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .eq("idprofissional", uidProfissional)
            .lte("datetime",
                DateTime.now().add(Duration(days: 1)).toIso8601String())
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .lte(
                'datetime',
                datasSelecionadas[1]!
                    .add(Duration(hours: 23, minutes: 59, seconds: 59))
                    .toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      }
    }
    if (datasSelecionadas.length == 1) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .lte("datetime",
                DateTime.now().add(Duration(days: 1)).toIso8601String())
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .eq("idprofissional", uidProfissional)
            .lte("datetime",
                DateTime.now().add(Duration(days: 1)).toIso8601String())
            .gte('datetime', datasSelecionadas[0]!.toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      }
    }

    if (datasSelecionadas[0] == null) {
      if (isAdmin) {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .lte("datetime",
                DateTime.now().add(Duration(days: 1)).toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      } else {
        documentos = await supabase
            .from("agendamentos")
            .select()
            .eq("idestabelecimento", idEstabelecimento)
            .eq("idprofissional", uidProfissional)
            .lte("datetime",
                DateTime.now().add(Duration(days: 1)).toIso8601String())
            .eq("concluido", false)
            .order("datetime");
      }
    }

    List<Agendamento> agentes = [];
    for (var i = 0; i < documentos.length; i++) {
      try {
        final data = documentos[i]["datetime"];

        DateTime date = DateTime.parse(data);
        var servicosResult = await Servicorepository()
            .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

        List<Servico> servicos = [];

        for (var s in servicosResult) {
          servicos.add(Servico(
              nome: s.nome,
              valor: s.valor,
              urlImg: s.urlImg,
              ativo: s.ativo,
              ativoLadingpage: s.ativoLadingpage,
              idProfissional: s.idProfissional,
              uid: s.uid));
        }

        Agendamento agendamento = Agendamento(
            uid: documentos[i]["id"],
            uidProfissional: documentos[i]["idprofissional"],
            data: documentos[i]["data"],
            horario: documentos[i]["horario"],
            dateTimeAgenda: date,
            diaDaSemana: documentos[i]["diadasemana"],
            concluido: documentos[i]["concluido"],
            confimado: documentos[i]["confimado"],
            nomeCliente: documentos[i]["nomecliente"],
            totalAgendamento: documentos[i]["totalagendamento"],
            nomeProfissional: documentos[i]["nomeprofissional"],
            telefoneCliente: documentos[i]["telefonecliente"],
            codeTelefoneCliente: documentos[i]["code_telefone"],
            isoCodePhone: documentos[i]["iso_code_phone"],
            idEstabelecimento: documentos[i]["idestabelecimento"],
            servicos: servicos);

        agentes.add(agendamento);
      } catch (e) {
        print("Erro ao processar documento $i: $e");
      }
    }
    return agentes;
  }

  Future<List<Agendamento>> getAgendamentosProfissionalLimite(
      {required int uidProfissional,
      required int limite,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    DateTime dateTimeNow = DateTime.now();
    DateTime data = DateTime(
      dateTimeNow.year,
      dateTimeNow.month,
      dateTimeNow.day,
    );

    var documentos = [];
    print("idEstabelecimento : ${idEstabelecimento}");

    if (isAdmin) {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .gte("datetime", data.toIso8601String())
          .eq("concluido", false)
          .limit(limite)
          .order("datetime", ascending: true);
    } else {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .eq("idprofissional", uidProfissional)
          .gte("datetime", data.toIso8601String())
          .eq("concluido", false)
          .limit(limite)
          .order("datetime", ascending: true);
    }

    List<Agendamento> agentes = [];

    for (var i = 0; i < documentos.length; i++) {
      try {
        print('documentos ${documentos.length}');
        final data = documentos[i]["datetime"];

        DateTime date = DateTime.parse(data);

        var servicosResult = await Servicorepository()
            .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

        List<Servico> servicos = [];

        for (var s in servicosResult) {
          servicos.add(Servico(
              nome: s.nome,
              valor: s.valor,
              urlImg: s.urlImg,
              ativo: s.ativo,
              ativoLadingpage: s.ativoLadingpage,
              idProfissional: s.idProfissional,
              uid: s.uid));
        }
        Agendamento agendamento = Agendamento(
            uid: documentos[i]["id"],
            uidProfissional: documentos[i]["idprofissional"],
            data: documentos[i]["data"],
            horario: documentos[i]["horario"],
            dateTimeAgenda: date,
            diaDaSemana: documentos[i]["diadasemana"],
            concluido: documentos[i]["concluido"],
            confimado: documentos[i]["confimado"],
            nomeCliente: documentos[i]["nomecliente"],
            totalAgendamento: documentos[i]["totalagendamento"],
            nomeProfissional: documentos[i]["nomeprofissional"],
            telefoneCliente: documentos[i]["telefonecliente"],
            isoCodePhone: documentos[i]["iso_code_phone"],
            codeTelefoneCliente: documentos[i]["code_telefone"],
            idEstabelecimento: documentos[i]["idestabelecimento"],
            servicos: servicos);

        agentes.add(agendamento);
      } catch (e) {
        print("Agendameno limiteErro ao processar documento $i: $e");
      }
    }

    return agentes;
  }

  Future<int> countAgendamentosMes(
      {required int uidProfissional,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    DateTime dateNow = DateTime.now();
    DateTime inicio = DateTime(dateNow.year, dateNow.month, 1);

    DateTime fim = DateTime(dateNow.year, dateNow.month + 1, 1)
        .subtract(Duration(microseconds: 1));

    var documentos;
    if (isAdmin) {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .gte("datetime", inicio.toIso8601String())
          .lte("datetime", fim.toIso8601String())
          .order("datetime")
          .count();
    } else {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .eq("idprofissional", uidProfissional)
          .gte("datetime", inicio.toIso8601String())
          .lte("datetime", fim.toIso8601String())
          .order("datetime")
          .count();
    }
    return documentos.count;
  }

  Future<int> countAgendamentoDia(
      {required int uidProfissional,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    DateTime dateNow = DateTime.now();
    DateTime inicio = DateTime(dateNow.year, dateNow.month, dateNow.day);

    DateTime fim = DateTime(dateNow.year, dateNow.month, dateNow.day + 1)
        .subtract(Duration(microseconds: 1));

    var documentos;
    if (isAdmin) {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .gte("datetime", inicio.toIso8601String())
          .lte("datetime", fim.toIso8601String())
          .order("datetime")
          .count();
    } else {
      documentos = await supabase
          .from("agendamentos")
          .select()
          .eq("idestabelecimento", idEstabelecimento)
          .eq("idprofissional", uidProfissional)
          .gte("datetime", inicio.toIso8601String())
          .lte("datetime", fim.toIso8601String())
          .order("datetime")
          .count();
    }
    return documentos.count;
  }

  Future<double> totalFaturamentoMes(
      {required int idProfissional,
      required bool isAdmin,
      required int idEstabelecimento}) async {
    DateTime datenow = DateTime.now();

    final inicioMes = DateTime(datenow.year, datenow.month, 1);
    final fimMes = DateTime(datenow.year, datenow.month + 1, 0);

    var documentos = [];
    if (isAdmin) {
      documentos = await supabase
          .from('agendamentos')
          .select("totalagendamento")
          .eq("idestabelecimento", idEstabelecimento)
          .eq("concluido", true)
          .gte('datetime', inicioMes.toIso8601String()) // >= início do mês
          .lte('datetime', fimMes.toIso8601String()) // <= final do mês
          .order('datetime', ascending: true);
    } else {
      documentos = await supabase
          .from('agendamentos')
          .select("totalagendamento")
          .eq("idestabelecimento", idEstabelecimento)
          .eq("concluido", true)
          .eq("idprofissional", idProfissional)
          .gte('datetime', inicioMes.toIso8601String()) // >= início do mês
          .lte('datetime', fimMes.toIso8601String()) // <= final do mês
          .order('datetime', ascending: true);
    }

    if (documentos.isEmpty) {
      return 0;
    } else {
      double faturamentoMes = 0;
      for (var i in documentos) {
        faturamentoMes += i["totalagendamento"];
      }
      return faturamentoMes;
    }
  }

  Future<List<Agendamento>> buscarAgendamentosRepository(
      {required String telefoneCliente, required int idEstabelecimento}) async {
    List<Agendamento> agendamentos = [];

    var documentos = await supabase
        .from("agendamentos")
        .select("*,agendamentos_servicos(*)")
        .eq("idestabelecimento", idEstabelecimento)
        .eq("telefonecliente", telefoneCliente)
        .eq("concluido", false)
        .order("datetime");

    for (var i = 0; i < documentos.length; i++) {
      String dataString = documentos[i]["datetime"];
      DateTime date = DateTime.parse(dataString);

      var servicosResult = await Servicorepository()
          .getServicosAgendamento(idAgendamento: documentos[i]["id"]);

      List<Servico> servicos = [];

      for (var s in servicosResult) {
        servicos.add(Servico(
            nome: s.nome,
            valor: s.valor,
            urlImg: s.urlImg,
            ativo: s.ativo,
            ativoLadingpage: s.ativoLadingpage,
            idProfissional: s.idProfissional,
            uid: s.uid));
      }

      Agendamento agendamento = Agendamento(
          uid: documentos[i]["id"],
          uidProfissional: documentos[i]["idprofissional"],
          data: documentos[i]["data"],
          horario: documentos[i]["horario"],
          dateTimeAgenda: date,
          diaDaSemana: documentos[i]["diadasemana"],
          concluido: documentos[i]["concluido"],
          confimado: documentos[i]["confimado"],
          nomeCliente: documentos[i]["nomecliente"],
          totalAgendamento: documentos[i]["totalagendamento"],
          nomeProfissional: documentos[i]["nomeprofissional"],
          telefoneCliente: documentos[i]["telefonecliente"],
          codeTelefoneCliente: documentos[i]["code_telefone"],
          isoCodePhone: documentos[i]["iso_code_phone"],
          idEstabelecimento: documentos[i]["idestabelecimento"],
          servicos: servicos);

      agendamentos.add(agendamento);
    }

    return agendamentos;
  }

  Future<List<String>> buscarHorariosOcupadosRepository(
      {required String data, required int uidProfissional}) async {
    var documentos = await supabase
        .from("agendamentos")
        .select("horario")
        .eq("data", data)
        .eq("idprofissional", uidProfissional);
    List<String> listaHorariosOcupado = [];

    for (var i = 0; i < documentos.length; i++) {
      listaHorariosOcupado.add(documentos[i]["horario"]);
    }

    return listaHorariosOcupado;
  }

  Future<List<String>> buscarHorariosdisponiveisProfissional(
      {required String data, required int uidProfissional}) async {
    var documentos = await supabase
        .from("agendamentos")
        .select("horario")
        .eq("data", data)
        .eq("idprofissional", uidProfissional);
    List<String> listaHorariosOcupado = [];

    for (var i = 0; i < documentos.length; i++) {
      listaHorariosOcupado.add(documentos[i]["horario"]);
    }

    var documentsHorariosProfissional = await supabase
        .from('profissional_horarios')
        .select('hora,ativado')
        .eq('id_profissional', uidProfissional);

    List<String> listaHorariosProfisional = [];
    for (var horario in documentsHorariosProfissional) {
      if (horario["ativado"] == true) {
        listaHorariosProfisional.add(horario["hora"]);
      }
    }

    // Passo 3: Filtrar horários disponíveis
    final horariosDisponiveis = listaHorariosProfisional
        .where((horario) => !listaHorariosOcupado.contains(horario))
        .toList();

    return horariosDisponiveis;
  }

  Future<void> updateAgendamentoRepository(
      {required String nomeCliente,
      required String telefoneCliente,
      required String codeTelefoneCliente,
      required int uidProfissional,
      required String nomeProfissional,
      required String dataString,
      required String diaDaSemana,
      required String horario,
      required double totalAgendamento,
      required DateTime dateTime,
      required List<int> servicos,
      required bool confimado,
      required bool concluido,
      required String isoCodePhone,
      required int uidAgendamento,
      required int idEstabelecimento}) async {
    final agendamentoJson = {
      "nomecliente": nomeCliente,
      "telefonecliente": telefoneCliente,
      "code_telefone": codeTelefoneCliente,
      "idprofissional": uidProfissional,
      "diadasemana": diaDaSemana,
      "horario": horario,
      "datetime": dateTime.toIso8601String(),
      "confimado": confimado,
      "concluido": concluido,
      "totalagendamento": totalAgendamento,
      "nomeprofissional": nomeProfissional,
      "data": dataString,
      "iso_code_phone": isoCodePhone,
      "idestabelecimento": idEstabelecimento
    };
    await supabase
        .from("agendamentos")
        .update(agendamentoJson)
        .eq("id", uidAgendamento);
    updateAgendamentoServico(
        servicosId: servicos, agendamentoId: uidAgendamento);
  }

  Future<void> updateStatusAgendamentoRepository({
    required bool confimado,
    required bool concluido,
    required int uidAgendamento,
  }) async {
    final agendamentoJson = {
      "confimado": confimado,
      "concluido": concluido,
    };

    await supabase
        .from("agendamentos")
        .update(agendamentoJson)
        .eq("id", uidAgendamento);
  }

  Future<void> deleteAgendamentoRepository(
      {required int uidAgendamento}) async {
    deleteAgendamentoServicoRepository(uidAgendamento: uidAgendamento).then(
      (value) async {
        await supabase.from("agendamentos").delete().eq('id', uidAgendamento);
      },
    );
  }

  Future<void> deleteAgendamentoServicoRepository(
      {required int uidAgendamento}) async {
    await supabase
        .from("agendamentos_servicos")
        .delete()
        .eq("id_agendamento", uidAgendamento);
  }
}
