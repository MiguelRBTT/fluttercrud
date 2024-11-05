import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/create.dart';
import 'package:flutterapp/pages/service/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController dscontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();

  String? status;
  Stream? CourseStream;

  final Color colorPrimary = Color(0xFFAB947E);
  final Color colorSecondary = Color(0xFF6F5E53);
  final Color colorAccent = Color(0xFF593D3B);
  final Color backgroundColor = Color(0xFFC3A995);

  // Função para carregar os dados dos cursos
  getontheload() async {
    CourseStream = await DatabaseMethods().getCourseDetails();
    setState(() {}); // Atualiza a interface após carregar o stream
  }

  @override
  void initState() {
    getontheload(); // Carrega os dados ao iniciar a tela
    super.initState();
  }

  // Widget para exibir todos os cursos
  Widget allCourseDetails() {
    return StreamBuilder(
      stream: CourseStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Nome do Curso: " + ds["Nome do Curso"],
                            style: TextStyle(
                              color: colorPrimary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              // Preenche campos para edição
                              namecontroller.text = ds["Nome do Curso"];
                              dscontroller.text = ds["Descrição do Curso"];
                              statuscontroller.text = ds["Status"];
                              EditCourseDetails(ds["Id"]);
                            },
                            child: Icon(Icons.edit, color: colorAccent),
                          ),
                          SizedBox(width: 5.0),
                          GestureDetector(
                            onTap: () async {
                              // Remove o curso do banco de dados
                              await DatabaseMethods().deleteCourseDetail(ds["Id"]);
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                      Text(
                        "Descrição do Curso: " + ds["Descrição do Curso"],
                        style: TextStyle(
                          color: colorSecondary,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Status: " + ds["Status"],
                        style: TextStyle(
                          color: colorPrimary,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )
            : Container(); // Retorna um container vazio caso não tenha dados
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de criação de curso
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Course()));
        },
        backgroundColor: colorAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: colorAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Gerenciador de",
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
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            Expanded(child: allCourseDetails()), // Exibe a lista de cursos
          ],
        ),
      ),
    );
  }

  // Função de edição de curso
  Future EditCourseDetails(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        content: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.cancel, color: colorAccent),
                  ),
                  SizedBox(width: 60.0),
                  Text(
                    "Editar",
                    style: TextStyle(
                      color: colorPrimary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    " Detalhes",
                    style: TextStyle(
                      color: colorSecondary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                "Nome do Curso",
                style: TextStyle(
                  color: colorAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: colorSecondary),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Escreva o nome do curso",
                    hintStyle: TextStyle(color: colorPrimary),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                "Descrição do Curso",
                style: TextStyle(
                  color: colorAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: colorSecondary),
                    borderRadius: BorderRadius.circular(10)),
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
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
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
                    // Valida campos obrigatórios antes de atualizar
                    if (namecontroller.text.isEmpty ||
                        dscontroller.text.isEmpty ||
                        status == null) {
                      Fluttertoast.showToast(
                        msg: "Por favor, preencha todos os campos obrigatórios.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      return;
                    }

                    // Atualiza informações do curso
                    Map<String, dynamic> updateInfo = {
                      "Nome do Curso": namecontroller.text,
                      "Descrição do Curso": dscontroller.text,
                      "Id": id,
                      "Status": statuscontroller.text,
                    };
                    await DatabaseMethods().updateCourseDetail(id, updateInfo).then((value) {
                      Navigator.pop(context);
                    });
                  },
                  child: Text("Atualizar"),
                ),
              ),
            ],
          ),
        ),
      ));
}
