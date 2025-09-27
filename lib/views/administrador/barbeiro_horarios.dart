import 'package:agendamento_barber/models/Profissional.dart';
import 'package:agendamento_barber/repository/profissionalRepository.dart';
import 'package:agendamento_barber/utils/WidgetsDesign.dart';
import 'package:agendamento_barber/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BarbeiroHorarios extends StatefulWidget {
  const BarbeiroHorarios({super.key, required this.profissional});

  final Profissional profissional;
  @override
  State<BarbeiroHorarios> createState() => _BarbeiroHorariosState();
}

class _BarbeiroHorariosState extends State<BarbeiroHorarios> {
  Widgetsdesign widgetsdesign = Widgetsdesign();
  final keyForm = GlobalKey<FormState>();
  List<Map<String, dynamic>> horariosJson = [];
  @override
  void initState() {
    super.initState();
    horariosJson =
        Utils().completarHorarios(widget.profissional.horariosTrabalho);
  }

  Widget horarios({required double widthMedia}) {
    return Wrap(
      direction: Axis.horizontal,
      children: List.generate(horariosJson.length, (index) {
        return SizedBox(
          width: widthMedia * 0.45,
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Checkbox(
              value: horariosJson[index]["ativado"],
              onChanged: (value) {
                setState(() {
                  horariosJson[index]["ativado"] = value!;
                });
              },
            ),
            title: Text(
              horariosJson[index]["hora"],
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 19, 19, 19),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widthMedia * 0.04),
          child: Column(
            children: [
              SizedBox(
                height: 45,
              ),
              widgetsdesign.getCabecalhoHorariosDetalhes(
                label: "Horários",
                botaoWidget: Container(),
                colorLabel: widgetsdesign.amareloColor,
                fontWeight: FontWeight.w700,
                paddingTop: 0,
                sizeLabel: 20,
                labelButton: "Salvar",
                buscarWidget: Container(),
                iconButton: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                callback: () {
                  setState(() {
                    widget.profissional.horariosTrabalho = horariosJson;
                  });
                  EasyLoading.show(
                      dismissOnTap: false, status: "Carregando...");
                  Profissionalrepository()
                      .atualizarHorariosProfissional(
                          idProfisssional: widget.profissional.uid!,
                          profissional: widget.profissional)
                      .then(
                    (value) {
                      EasyLoading.showSuccess("Salvo com sucesso");
                      EasyLoading.dismiss();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
                context: context,
              ),
              SizedBox(
                height: 15,
              ),
              horarios(widthMedia: widthMedia),
            ],
          ),
        ),
      ),
    );
  }
}
