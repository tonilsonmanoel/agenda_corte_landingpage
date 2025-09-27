import 'package:agendamento_barber/models/Profissional.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:xor_encryption/xor_encryption.dart';

class Profissionalrepository {
  var db = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  //Metodos Login

  Future<Map<String, dynamic>> getLoginProfissional(
      {required String email,
      required String senha,
      required int idEstabelecimento}) async {
    String mensagem = "Email ou senhas incorreto";
    Profissional? profissional;

    var documents = await supabase
        .from("profissionais")
        .select()
        .eq("email", email)
        .eq("idestabelecimento", idEstabelecimento);
    if (documents.isNotEmpty) {
      final decrypted = XorCipher()
          .encryptData(documents.first['senha'], documents.first['keyhash']);

      if (senha == decrypted) {
        print('senha: $senha, senha decry $decrypted');
        List<Map<String, dynamic>> listaDiasDaSemanaResultado =
            await getDiasTrabalhoProfissional(
                idProfissional: documents.first['id']);
        List<Map<String, dynamic>> listaHorariosResultado =
            await geHorariosProfissional(idProfissional: documents.first['id']);
        print("");
        profissional = Profissional(
            uid: documents.first['id'],
            nome: documents.first["nome"],
            email: documents.first["email"],
            telefone: documents.first["telefone"],
            codeTelefone: documents.first["codigo_telefone"],
            telefoneWhatsapp: documents.first["telefonewhatsapp"],
            codeTelefoneWhatsapp: documents.first["codigo_telefone_whatsapp"],
            isoCodePhone: documents.first["iso_code_phone"],
            isoCodePhoneWhatsapp: documents.first["iso_code_phone_whatsapp"],
            fotoPerfil: documents.first["fotoperfil"],
            perfil: documents.first["perfil"],
            idEstabelecimento: documents.first["idestabelecimento"],
            horariosTrabalho:
                listaHorariosResultado.cast<Map<String, dynamic>>(),
            diasTrabalho:
                listaDiasDaSemanaResultado.cast<Map<String, dynamic>>(),
            status: documents.first["status"]);

        mensagem = "Login realizado";
      } else {
        return {
          "profissinalObjeto": profissional,
          "mensagem": mensagem,
        };
      }
    }

    return {
      "profissinalObjeto": profissional,
      "mensagem": mensagem,
    };
  }

  Future<Map<String, dynamic>> verificarEmailExistir(
      {required String email, required int idEstabelecimento}) async {
    var documents = await supabase
        .from("profissionais")
        .select('id')
        .eq("email", email)
        .eq("idestabelecimento", idEstabelecimento)
        .single();

    if (documents.isNotEmpty) {
      return {
        "id": documents["id"],
      };
    }

    return {
      "id": null,
    };
  }

  Future<Profissional?> getProfissional(
      {required int id, required int idEstabelecimento}) async {
    Profissional? profissional;

    var documents = await supabase
        .from("profissionais")
        .select()
        .eq("id", id)
        .eq("idestabelecimento", idEstabelecimento)
        .single();

    if (documents.isNotEmpty) {
      List<Map<String, dynamic>> listaDiasDaSemanaResultado =
          await getDiasTrabalhoProfissional(idProfissional: documents['id']);
      List<Map<String, dynamic>> listaHorariosResultado =
          await geHorariosProfissional(idProfissional: documents['id']);
      print("getProfissional perfil ${documents["perfil"]}");
      profissional = Profissional(
          uid: documents['id'],
          nome: documents["nome"],
          email: documents["email"],
          telefone: documents["telefone"],
          codeTelefone: documents["codigo_telefone"],
          telefoneWhatsapp: documents["telefonewhatsapp"],
          codeTelefoneWhatsapp: documents["codigo_telefone_whatsapp"],
          isoCodePhoneWhatsapp: documents["iso_code_phone_whatsapp"],
          fotoPerfil: documents["fotoperfil"],
          perfil: documents["perfil"],
          isoCodePhone: documents["iso_code_phone"],
          idEstabelecimento: documents["idestabelecimento"],
          horariosTrabalho: listaHorariosResultado.cast<Map<String, dynamic>>(),
          diasTrabalho: listaDiasDaSemanaResultado.cast<Map<String, dynamic>>(),
          status: documents["status"]);
    }
    return profissional;
  }

  Future<void> createProfissionalRepository(
      {required Profissional profissional,
      required String senha,
      int? idEstabecimento}) async {
    final String key = XorCipher().getSecretKey(20);

    final encrypted = XorCipher().encryptData(senha, key);
    var profissionalJson = {
      "nome": profissional.nome,
      "email": profissional.email,
      "telefone": profissional.telefone,
      "codigo_telefone": profissional.codeTelefone,
      "telefonewhatsapp": profissional.telefoneWhatsapp,
      "codigo_telefone_whatsapp": profissional.codeTelefoneWhatsapp,
      "fotoperfil": profissional.fotoPerfil,
      "status": profissional.status,
      "perfil": profissional.perfil,
      "senha": encrypted,
      "keyhash": key,
      "idestabelecimento": idEstabecimento ?? profissional.idEstabelecimento,
      "iso_code_phone": profissional.isoCodePhone,
      "iso_code_phone_whatsapp": profissional.isoCodePhoneWhatsapp,
    };

    final idProfissional = await supabase
        .from("profissionais")
        .insert(profissionalJson)
        .select('id')
        .single();
    createDiasProfissional(
        idProfissional: idProfissional['id'], profissional: profissional);
    createHorariosProfissional(
        idProfissional: idProfissional['id'], profissional: profissional);
  }

  Future<void> createDiasProfissional(
      {required int idProfissional, required Profissional profissional}) async {
    for (var dia in profissional.diasTrabalho) {
      dia["profissional_id"] = idProfissional;
    }

    await supabase.from("profissional_dias").insert(profissional.diasTrabalho);
  }

  Future<void> createHorariosProfissional(
      {required int idProfissional, required Profissional profissional}) async {
    for (var horario in profissional.horariosTrabalho) {
      horario["id_profissional"] = idProfissional;
    }

    await supabase
        .from("profissional_horarios")
        .insert(profissional.horariosTrabalho);
  }

  //Fim metodos Login

  Future<List<Profissional>> getFuncionariosDisponivelRepository(
      {required String diaDaSemana, required int idEstabecimento}) async {
    List<Profissional> profissionais = [];
    var documentsProfissionais = await supabase
        .from("profissionais")
        .select()
        .eq("idestabelecimento", idEstabecimento);

    for (var profissional in documentsProfissionais) {
      var documentsDiaHorario = await supabase
          .from("profissional_dias")
          .select()
          .eq("profissional_id", profissional['id'])
          .eq("dia", diaDaSemana)
          .eq('ativado', true)
          .limit(1);

      if (documentsDiaHorario.isNotEmpty) {
        List<Map<String, dynamic>> listaDiasDaSemanaResultado =
            await getDiasTrabalhoProfissional(
                idProfissional: profissional['id']);
        List<Map<String, dynamic>> listaHorariosResultado =
            await geHorariosProfissional(idProfissional: profissional['id']);

        Profissional profissionalObjeto = Profissional(
            uid: profissional['id'],
            nome: profissional["nome"],
            email: profissional["email"],
            perfil: profissional["perfil"],
            telefone: profissional["telefone"],
            codeTelefone: profissional["codigo_telefone"],
            telefoneWhatsapp: profissional["telefonewhatsapp"],
            codeTelefoneWhatsapp: profissional["codigo_telefone_whatsapp"],
            fotoPerfil: profissional["fotoperfil"],
            idEstabelecimento: profissional["idestabelecimento"],
            isoCodePhone: profissional["iso_code_phone"],
            isoCodePhoneWhatsapp: profissional["iso_code_phone_whatsapp"],
            horariosTrabalho:
                listaHorariosResultado.cast<Map<String, dynamic>>(),
            diasTrabalho:
                listaDiasDaSemanaResultado.cast<Map<String, dynamic>>(),
            status: profissional["status"]);

        profissionais.add(profissionalObjeto);
      }
    }

    return profissionais;
  }

  Future<List<Map<String, dynamic>>> getDiasTrabalhoProfissional(
      {required int idProfissional}) async {
    var documents = await supabase
        .from("profissional_dias")
        .select("dia,ativado")
        .eq("profissional_id", idProfissional);

    List<Map<String, dynamic>> listaDiasDaSemana = [];

    for (var dia in documents) {
      listaDiasDaSemana.add({
        "dia": dia["dia"],
        "ativado": dia["ativado"],
      });
    }

    return listaDiasDaSemana;
  }

  Future<List<Map<String, dynamic>>> geHorariosProfissional(
      {required int idProfissional}) async {
    var documents = await supabase
        .from('profissional_horarios')
        .select('hora,ativado')
        .eq('id_profissional', idProfissional);

    List<Map<String, dynamic>> listaHorarios = [];
    for (var hora in documents) {
      listaHorarios.add({
        "hora": hora["hora"],
        "ativado": hora["ativado"],
      });
    }

    return listaHorarios;
  }

  Future<List<Profissional>> getTodosBarbeiros(
      {required int idEstabecimento}) async {
    var documents = await supabase
        .from("profissionais")
        .select()
        .eq("idestabelecimento", idEstabecimento);
    List<Profissional> profissionais = [];

    for (var profissional in documents) {
      List<Map<String, dynamic>> listaDiasDaSemanaResultado =
          await getDiasTrabalhoProfissional(idProfissional: profissional['id']);
      List<Map<String, dynamic>> listaHorariosResultado =
          await geHorariosProfissional(idProfissional: profissional['id']);
      profissionais.add(Profissional(
          uid: profissional['id'],
          nome: profissional["nome"],
          email: profissional["email"],
          perfil: profissional["perfil"],
          telefone: profissional["telefone"],
          codeTelefone: profissional["codigo_telefone"],
          telefoneWhatsapp: profissional["telefonewhatsapp"],
          isoCodePhone: profissional["iso_code_phone"],
          isoCodePhoneWhatsapp: profissional["iso_code_phone_whatsapp"],
          codeTelefoneWhatsapp: profissional["codigo_telefone_whatsapp"],
          fotoPerfil: profissional["fotoperfil"],
          idEstabelecimento: profissional["idestabelecimento"],
          horariosTrabalho: listaHorariosResultado.cast<Map<String, dynamic>>(),
          diasTrabalho: listaDiasDaSemanaResultado.cast<Map<String, dynamic>>(),
          status: profissional["status"]));
    }

    return profissionais;
  }

  Future<List<Map<String, dynamic>>> getBarbeirosLandingPage(
      {required int idEstabecimento}) async {
    var documents = await supabase
        .from("profissionais")
        .select('id,nome,fotoperfil,status')
        .eq("idestabelecimento", idEstabecimento);

    List<Map<String, dynamic>> barbeiros = [];
    for (var profissional in documents) {
      var jsonBarbeiro = {
        "id": profissional['id'],
        "nome": profissional["nome"],
        "fotoperfil": profissional["fotoperfil"],
        "status": profissional["status"],
      };
      barbeiros.add(jsonBarbeiro);
    }

    return barbeiros;
  }

  Future<List<String>> getHorariosProfissional(
      {required int uidProfissional}) async {
    var documents = await supabase
        .from("profissional_horarios")
        .select()
        .eq("id_profissional", uidProfissional);
    List<String> horariosProfissional = [];
    for (var horario in documents) {
      if (horario["ativado"] == true) {
        horariosProfissional.add(horario["hora"]);
      }
    }

    return horariosProfissional;
  }

  Future<void> updateProfissionalRepository(
      {required Profissional profissional,
      required int uidProfissional}) async {
    var profissionalJson = {
      "nome": profissional.nome,
      "email": profissional.email,
      "telefone": profissional.telefone,
      "codigo_telefone": profissional.codeTelefone,
      "telefonewhatsapp": profissional.telefoneWhatsapp,
      "codigo_telefone_whatsapp": profissional.codeTelefoneWhatsapp,
      "iso_code_phone": profissional.isoCodePhone,
      "iso_code_phone_whatsapp": profissional.isoCodePhoneWhatsapp,
      "fotoperfil": profissional.fotoPerfil,
      "perfil": profissional.perfil,
      "status": profissional.status,
      "idestabelecimento": profissional.idEstabelecimento
    };

    await supabase
        .from("profissionais")
        .update(profissionalJson)
        .eq("id", uidProfissional);
    atualizarDiasDaSemanaProfissional(
        diasdaSemana: profissional.diasTrabalho,
        idProfisssional: uidProfissional);
  }

  Future<void> updateTokenProfissional(
      {int? token, required int uidProfissional}) async {
    var profissionalJson = {
      "token": token,
    };
    await supabase
        .from("profissionais")
        .update(profissionalJson)
        .eq("id", uidProfissional);
  }

  Future<Map<String, dynamic>> verificarTokenProfissional(
      {required int token, required String email}) async {
    Map<String, dynamic> jsonResult = {
      "id": null,
      "verificadoToken": false,
    };
    var result = await supabase
        .from("profissionais")
        .select()
        .eq("email", email)
        .eq("token", token);
    if (result.isNotEmpty) {
      jsonResult = {
        "verificadoToken": true,
        "id": result[0]['id'],
      };
      return jsonResult;
    }
    return jsonResult;
  }

  Future<void> atulizarSenhaProfissional(
      {required String senha,
      required int uidProfissional,
      required int idEstabelecimento,
      required String email}) async {
    final String key = XorCipher().getSecretKey(20);

    final encrypted = XorCipher().encryptData(senha, key);
    var profissionalJson = {"senha": encrypted, "token": null, 'keyhash': key};

    await supabase
        .from("profissionais")
        .update(profissionalJson)
        .eq("id", uidProfissional)
        .eq("email", email)
        .eq("idestabelecimento", idEstabelecimento);
  }

  Future<void> atualizarDiasDaSemanaProfissional(
      {required int idProfisssional,
      required List<Map<String, dynamic>> diasdaSemana}) async {
    deletarTodosDiasDaSemanaProfissional(idProfisssional: idProfisssional);
    for (var diaJson in diasdaSemana) {
      diaJson["profissional_id"] = idProfisssional;
    }
    await supabase.from("profissional_dias").insert(diasdaSemana);
  }

  Future<void> deletarTodosDiasDaSemanaProfissional(
      {required int idProfisssional}) async {
    await supabase
        .from("profissional_dias")
        .delete()
        .eq("profissional_id", idProfisssional);
  }

  Future<void> deleteProfissionalRepository(
      {required int uidProfissional}) async {
    await supabase.from("profissionais").delete().eq("id", uidProfissional);
  }

  Future<void> updateStatusProfissionalRepository(
      {required Profissional profissional,
      required int uidProfissional}) async {
    var profissionalJson = {
      "status": profissional.status,
    };
    await supabase
        .from("profissionais")
        .update(profissionalJson)
        .eq("id", uidProfissional);
  }

  Future<void> atualizarHorariosProfissional(
      {required int idProfisssional,
      required Profissional profissional}) async {
    deletarHorariosProfissional(idProfisssional: idProfisssional);
    List<Map<String, dynamic>> horariosAtivados = [];
    for (var horario in profissional.horariosTrabalho) {
      if (horario["ativado"] == true) {
        horario["id_profissional"] = idProfisssional;
        horariosAtivados.add(horario);
      }
    }
    if (horariosAtivados.isNotEmpty) {
      await supabase.from("profissional_horarios").insert(horariosAtivados);
    }
  }

  Future<void> deletarHorariosProfissional(
      {required int idProfisssional}) async {
    await supabase
        .from("profissional_horarios")
        .delete()
        .eq("id_profissional", idProfisssional);
  }

  void updateDiasTrabalhoProfissionalRepository(
      {required Profissional profissional,
      required int uidProfissional}) async {
    var profissional_json = {
      "diastrabalho": profissional.diasTrabalho,
    };

    await supabase
        .from("profissionais")
        .update(profissional_json)
        .eq("id", uidProfissional);
  }

  //Horarios Metodos
  Future<void> criarHorarios() async {
    final List<Map<String, dynamic>> jsonHorario = [];
    int hora = 5;
    int minuto = 0;

    while (hora < 21 || (hora == 21 && minuto == 0)) {
      final horaFormatada =
          '${hora.toString().padLeft(2, '0')}:${minuto.toString().padLeft(2, '0')}';
      jsonHorario.add({"hora": horaFormatada});

      minuto += 10;
      if (minuto >= 60) {
        minuto = 0;
        hora++;
      }
    }

    await supabase.from("horarios_trabalho").insert(jsonHorario);
  }

  //Fim horarios Metodos
}
