import 'package:agendamento_barber/models/Estabelecimento.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Estabelecimentorepository {
  var db = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> createEstabelecimentoRepositorySetUP(
      {required Estabelecimento estabelecimento, required String senha}) async {
    var estabelecimentoJson = {
      "nome": estabelecimento.nome,
      "telefone": estabelecimento.telefone,
      "codigo_telefone": estabelecimento.codeTelefone,
      "telefonewhatsapp": estabelecimento.telefoneWhatsapp,
      "codigo_telefone_whatsapp": estabelecimento.codeTelefoneWhatsapp,
      "endereco": estabelecimento.endereco,
      "urliframemapa": estabelecimento.urlIframeMapa,
      "complemento": estabelecimento.complemento,
      "cep": estabelecimento.cep,
      "urllogo": estabelecimento.urlLogo,
      "cnpj": estabelecimento.cnpj ?? "",
      "email": estabelecimento.email,
      "sobre_nos": estabelecimento.sobreNos,
      "sobre_nos_img": estabelecimento.sobreNosImg,
      "horario_funcionamento": estabelecimento.horarioFuncionamento,
      "razao_social": estabelecimento.razaoSocial,
      "set_up": estabelecimento.setUp,
      "iso_code_phone": estabelecimento.isoCodePhone,
      "urlbarbearia": estabelecimento.urlBarbearia,
      "ativo_landing": estabelecimento.ativoLanding,
      "site_manutencao": estabelecimento.siteManutencao,
    };
    //await db.collection("estabelecimento").add(estabelecimentoJson);
    var idEstabecimento = await supabase
        .from("estabelecimento")
        .insert(estabelecimentoJson)
        .select('id')
        .single();

    return idEstabecimento;
  }

  Future<int> createEstabelecimento(
      {required Estabelecimento estabelecimento}) async {
    var estabelecimentoJson = {
      "nome": estabelecimento.nome,
      "telefone": estabelecimento.telefone,
      "codigo_telefone": estabelecimento.codeTelefone,
      "telefonewhatsapp": estabelecimento.telefoneWhatsapp,
      "codigo_telefone_whatsapp": estabelecimento.codeTelefoneWhatsapp,
      "endereco": estabelecimento.endereco,
      "urliframemapa": estabelecimento.urlIframeMapa,
      "complemento": estabelecimento.complemento,
      "cep": estabelecimento.cep,
      "urllogo": estabelecimento.urlLogo,
      "cnpj": estabelecimento.cnpj ?? "",
      "email": estabelecimento.email,
      "sobre_nos": estabelecimento.sobreNos,
      "sobre_nos_img": estabelecimento.sobreNosImg,
      "horario_funcionamento": estabelecimento.horarioFuncionamento,
      "razao_social": estabelecimento.razaoSocial,
      "set_up": estabelecimento.setUp,
      "iso_code_phone": estabelecimento.isoCodePhone,
      "urlbarbearia": estabelecimento.urlBarbearia,
      "ativo_landing": estabelecimento.ativoLanding,
      "site_manutencao": estabelecimento.siteManutencao,
    };
    //await db.collection("estabelecimento").add(estabelecimentoJson);
    var idEstabecimento = await supabase
        .from("estabelecimento")
        .insert(estabelecimentoJson)
        .select('id');

    return idEstabecimento.first["id"];
  }

  Future<Estabelecimento> getEstabelecimentoRepository() async {
    // var documentos = await db.collection("estabelecimento").get();
    var documentos = await supabase.from('estabelecimento').select();

    Estabelecimento estabelecimento = Estabelecimento(
        uid: documentos.first["id"],
        nome: documentos.first["nome"],
        telefone: documentos.first["telefone"],
        codeTelefone: documentos.first["codigo_telefone"],
        telefoneWhatsapp: documentos.first["telefonewhatsapp"],
        codeTelefoneWhatsapp: documentos.first["codigo_telefone_whatsapp"],
        cep: documentos.first["cep"],
        endereco: documentos.first["endereco"],
        complemento: documentos.first["complemento"],
        urlLogo: documentos.first["urllogo"],
        cnpj: documentos.first["cnpj"],
        email: documentos.first["email"],
        horarioFuncionamento: documentos.first["horario_funcionamento"],
        razaoSocial: documentos.first["razao_social"],
        setUp: documentos.first["set_up"],
        sobreNos: documentos.first["sobre_nos"],
        sobreNosImg: documentos.first["sobre_nos_img"],
        isoCodePhone: documentos.first["iso_code_phone"],
        urlBarbearia: documentos.first["urlbarbearia"],
        ativoLanding: documentos.first["ativo_landing"],
        siteManutencao: documentos.first["site_manutencao"],
        urlIframeMapa: documentos.first["urliframemapa"]);

    return estabelecimento;
  }

  Future<Estabelecimento?> getEstabelecimentoRepositoryId(
      {required int id}) async {
    // var documentos = await db.collection("estabelecimento").get();
    var documentos =
        await supabase.from('estabelecimento').select().eq("id", id);

    if (documentos.isNotEmpty) {
      Estabelecimento estabelecimento = Estabelecimento(
          uid: documentos.first["id"],
          nome: documentos.first["nome"],
          telefone: documentos.first["telefone"],
          codeTelefone: documentos.first["codigo_telefone"],
          telefoneWhatsapp: documentos.first["telefonewhatsapp"],
          codeTelefoneWhatsapp: documentos.first["codigo_telefone_whatsapp"],
          cep: documentos.first["cep"],
          endereco: documentos.first["endereco"],
          complemento: documentos.first["complemento"],
          urlLogo: documentos.first["urllogo"],
          cnpj: documentos.first["cnpj"],
          email: documentos.first["email"],
          horarioFuncionamento: documentos.first["horario_funcionamento"],
          razaoSocial: documentos.first["razao_social"],
          setUp: documentos.first["set_up"],
          sobreNos: documentos.first["sobre_nos"],
          sobreNosImg: documentos.first["sobre_nos_img"],
          isoCodePhone: documentos.first["iso_code_phone"],
          urlBarbearia: documentos.first["urlbarbearia"],
          ativoLanding: documentos.first["ativo_landing"],
          siteManutencao: documentos.first["site_manutencao"],
          urlIframeMapa: documentos.first["urliframemapa"]);

      return estabelecimento;
    } else {
      return null;
    }
  }

  /// Busca um estabelecimento pelo campo `url_loja`.
  /// Retorna `null` se nenhum estabelecimento for encontrado.
  Future<Estabelecimento?> getEstabelecimentoByUrl(String url) async {
    try {
      final documentos = await supabase
          .from('estabelecimento')
          .select()
          .eq('urlbarbearia', url)
          .maybeSingle();

      if (documentos == null) return null;

      final estabelecimento = Estabelecimento(
          uid: documentos["id"],
          nome: documentos["nome"],
          telefone: documentos["telefone"],
          codeTelefone: documentos["codigo_telefone"],
          telefoneWhatsapp: documentos["telefonewhatsapp"],
          codeTelefoneWhatsapp: documentos["codigo_telefone_whatsapp"],
          cep: documentos["cep"],
          endereco: documentos["endereco"],
          complemento: documentos["complemento"],
          urlLogo: documentos["urllogo"],
          cnpj: documentos["cnpj"],
          email: documentos["email"],
          horarioFuncionamento: documentos["horario_funcionamento"],
          razaoSocial: documentos["razao_social"],
          setUp: documentos["set_up"],
          sobreNos: documentos["sobre_nos"],
          sobreNosImg: documentos["sobre_nos_img"],
          isoCodePhone: documentos["iso_code_phone"],
          urlBarbearia: documentos["urlbarbearia"],
          ativoLanding: documentos["ativo_landing"],
          siteManutencao: documentos["site_manutencao"],
          urlIframeMapa: documentos["urliframemapa"]);

      return estabelecimento;
    } catch (e) {
      // Em caso de erro, retorna null para tratar como "não encontrado".
      return null;
    }
  }

  Future<int> getIdEstabelecimento() async {
    // var documentos = await db.collection("estabelecimento").get();
    var documentos = await supabase.from('estabelecimento').select('id');

    int estabelecimentoId = documentos.first["id"];

    return estabelecimentoId;
  }

  Future<bool> verificarDisponibilidadeUrl(
      {required String urlBarbearia}) async {
    // var documentos = await db.collection("estabelecimento").get();
    bool disponivelUrl = false;
    var documentos = await supabase
        .from('estabelecimento')
        .select()
        .eq("urlbarbearia", urlBarbearia);
    if (documentos.isEmpty) {
      disponivelUrl = true;
    }

    return disponivelUrl;
  }

  Future<bool> setUpStatus() async {
    // var documentos = await db.collection("estabelecimento").get();
    var documentos = await supabase.from('estabelecimento').select('set_up');

    if (documentos.isNotEmpty && documentos.first["set_up"] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateEstabelecimentoRepository(
      {required Estabelecimento estabelecimento,
      required int uidEstabelecimento}) async {
    var estabelecimentoJson = {
      "nome": estabelecimento.nome,
      "telefone": estabelecimento.telefone,
      "codigo_telefone": estabelecimento.codeTelefone,
      "telefonewhatsapp": estabelecimento.telefoneWhatsapp,
      "codigo_telefone_whatsapp": estabelecimento.codeTelefoneWhatsapp,
      "endereco": estabelecimento.endereco,
      "complemento": estabelecimento.complemento,
      "cep": estabelecimento.cep,
      "urllogo": estabelecimento.urlLogo,
      "cnpj": estabelecimento.cnpj,
      "razao_social": estabelecimento.razaoSocial,
      "sobre_nos": estabelecimento.sobreNos,
      "sobre_nos_img": estabelecimento.sobreNosImg,
      "horario_funcionamento": estabelecimento.horarioFuncionamento,
      "urliframemapa": estabelecimento.urlIframeMapa,
      "iso_code_phone": estabelecimento.isoCodePhone,
      "urlbarbearia": estabelecimento.urlBarbearia,
      "ativo_landing": estabelecimento.ativoLanding,
      "site_manutencao": estabelecimento.siteManutencao,
      "set_up": estabelecimento.setUp,
    };
    await supabase
        .from('estabelecimento')
        .update(estabelecimentoJson)
        .eq("id", uidEstabelecimento);
    //await db .collection("estabelecimento") .doc(uidEstabelecimento)  .update(estabelecimentoJson);
  }

  Future<void> deleteEstabelecimentoRepository(
      {required int uidEstabelecimento}) async {
    await supabase
        .from('estabelecimento')
        .delete()
        .eq("id", uidEstabelecimento);
    // await db.collection("estabelecimento").doc(uidEstabelecimento).delete();
  }

  // metodos assinatura

  Future<bool> temPlanoAtivo({required int idEstabecimento}) async {
    final response = await supabase
        .from('assinaturas')
        .select('fim, status')
        .eq('estabelecimento_id', idEstabecimento)
        .eq('status', "ativa")
        .order('fim', ascending: false);

    if (response.isEmpty) return false;

    print("status: ${response[0]['status'].toString()}");
    print("fim: ${response[0]['fim'].toString()}");

    final fim = DateTime.parse(response[0]['fim']);
    return fim.isAfter(DateTime.now());
  }

  Future<List<Map<String, dynamic>>> buscaPlanos() async {
    final response = await supabase.from('planos').select().eq('ativo', true);

    List<Map<String, dynamic>> planos = [];
    if (response.isNotEmpty) {
      planos = response
          .map((p) => {
                "id": p["id"],
                "nome": p["nome"],
                "descricao": p["descricao"],
                "valor": p["valor"],
                "quantidade_dias": p["quantidade_dias"],
                "ativo": p["ativo"],
              })
          .toList();

      print("planos nome: ${planos[0]['nome'].toString()}");
    }
    return planos;
  }
}
