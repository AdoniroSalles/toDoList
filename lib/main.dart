import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; //para utilizar arquivos
import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main(){
  runApp( MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _toDoController = TextEditingController();

  //lista para armazenar as tarefas
  List _toDoList = [];

  //adiciona tarefa
  void _addToDo(){
    //para poder atualizar a lista
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                  ),
                ),    
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                ),
              ],
            ),
          ),
          Expanded(
            //construe a lista conforme for visualizada 
            child: ListView.builder(
              padding  : EdgeInsets.only(top: 10),
              itemCount: _toDoList.length,
              itemBuilder: (context, index){
                //index = elemente da lista 
                return CheckboxListTile(
                  title: Text(_toDoList[index]["title"]),
                  value: _toDoList[index]["ok"],
                  secondary: CircleAvatar( 
                    child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
                  ),
                  onChanged: (event){
                    //para poder mudar quando for selecionado
                    setState(() {
                     _toDoList[index]["ok"] = event; 
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  //pega o arquvio json
  Future<File> _getFile() async{
    final directory = await getApplicationDocumentsDirectory(); // usada para pegar o diretorio onde possa ser armazenado os documentos do app
    return File("${directory.path}/data.json");

  } 

  //salvar dados no  arquivo
  Future<File> _saveData(_toDoList) async{
    
    String data = json.decode(_toDoList);
    final file  = await _getFile();

    return file.writeAsString(data);
  }

  //ler os dados no arquivo
  Future<String> _readData() async{
    try{
      final file = await _getFile();
      return file.readAsString(); 
    }catch(e){
      return null;
    }
  }
}

