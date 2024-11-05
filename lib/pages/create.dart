import 'package:flutter/material.dart';
import 'package:flutterapp/pages/service/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class Course extends StatefulWidget {
  const Course({super.key});

  @override
  State<Course> createState() => _CourseState();
}

class _CourseState extends State<Course> {
  String? status;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController dscontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();

  // Definição da paleta de cores
  final Color colorPrimary = Color(0xFFAB947E);
  final Color colorSecondary = Color(0xFF6F5E53);
  final Color colorAccent = Color(0xFF593D3B);
  final Color backgroundColor = Color(0xFFC3A995); // Cor de fundo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAccent, // Cor de fundo da AppBar
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Formulário de",
              style: TextStyle(
                color: colorPrimary,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              " Cursos",
              style: TextStyle(
                color: colorPrimary,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: backgroundColor, // Define a cor de fundo para toda a tela
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nome do Curso",
                style: TextStyle(
                  color: colorAccent, // Cor do texto da seção
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorSecondary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Escreva o nome do curso",
                    hintStyle: TextStyle(color: colorPrimary), // Cor do hint
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Descrição do Curso",
                style: TextStyle(
                  color: colorAccent,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorSecondary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: dscontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Escreva a descrição do curso",
                    hintStyle: TextStyle(color: colorPrimary),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Status",
                style: TextStyle(
                  color: colorAccent,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorSecondary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  hint: Text(
                    "Clique para escolher",
                    style: TextStyle(color: colorPrimary),
                  ),
                  value: status,
                  items: [
                    DropdownMenuItem(
                      child: Text("A fazer"),
                      value: "A fazer",
                    ),
                    DropdownMenuItem(
                      child: Text("Já feito"),
                      value: "Já feito",
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      status = newValue;
                      statuscontroller.text = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Verificação de campos obrigatórios
                    if (namecontroller.text.isEmpty ||
                        dscontroller.text.isEmpty ||
                        status == null) {
                      Fluttertoast.showToast(
                        msg:
                            "Por favor, preencha todos os campos obrigatórios.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    // Prepara as informações do curso
                    String Id = randomAlphaNumeric(10);
                    Map<String, dynamic> courseInfoMap = {
                      "Nome do Curso": namecontroller.text,
                      "Descrição do Curso": dscontroller.text,
                      "Id": Id,
                      "Status": statuscontroller.text,
                    };
                    await DatabaseMethods()
                        .addCourseDetails(courseInfoMap, Id)
                        .then((value) {
                      Fluttertoast.showToast(
                        msg: "Informações adicionadas com sucesso!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: colorSecondary,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      Navigator.pop(
                          context); // Retorna à tela anterior após adicionar
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPrimary, // Cor do botão
                  ),
                  child: Text(
                    "Adicionar",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: colorAccent, // Cor do texto do botão
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
