import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


const request = "http://api.hgbrasil.com/finance";

void main() async {

  //print(await getData());

  // http.Response response = await http.get(request);
  // debugPrint('response: ');
  // print('response ${response.body}');
  // print('response type ${response.body.runtimeType}');
  // print(response.body);
  // print('response ${json.decode(response.body)}');
  // print('response ${json.decode(response.body).runtimeType}');
  //print(json.decode(response.body)['results']['currencies']['USD']['buy']);
  // print('response: ' + json.decode(response.body)['results']);

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    )
  ));
}

Future<Map> getData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body)/*['results']['currencies']['USD']*/;
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController(); 
  final dolarController = TextEditingController(); 
  final euroController = TextEditingController(); 

  double dolar;
  double euro;

  void _realChanged(String text) {
    double coin = double.parse(text);
    dolarController.text = (coin / dolar).toStringAsFixed(2);
    euroController.text = (coin / euro).toStringAsFixed(2);
    //print(text);
  }

  void _dolarChanged(String text) {
    double coin = double.parse(text);
    realController.text = (coin * dolar).toStringAsFixed(2);
    // dolarController.text = (coin/dolar).toStringAsFixed(2);
    euroController.text = (coin * dolar / euro).toStringAsFixed(2);    
  }

  void _euroChanged(String text) {
    double coin = double.parse(text);
    realController.text = (coin * euro).toStringAsFixed(2);    
    dolarController.text = (coin * euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('\$Coin Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.waiting:
              return Center(
                child: Text('Carregando dados', 
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25),
                )
              );
            default: 
              if(snapshot.hasError) {
                return Center(
                  child: Text('Error ao carregar dados', 
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25),
                  )
                );
              } else {
                dolar = snapshot.data['results']['currencies']['USD']['buy']; 
                euro = snapshot.data['results']['currencies']['EUR']['buy']; 
                print(snapshot);
                return SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.monetization_on, size: 150, color: Colors.amber,),
                      buildTextField("Real", "R\$", realController, _realChanged),
                      Divider(),
                      buildTextField("Dolar", "US\$", dolarController, _dolarChanged),
                      Divider(),
                      buildTextField("Euro", "EU\$", euroController, _euroChanged),
                    ],
                  )
                ); //Container(color: Colors.green,);
              }

          }
        }
      ),
    );
  }
}

Widget buildTextField (String label, String Prefix, TextEditingController c, Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      //border: OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.amber, width: 5.0)
      ),                          
      prefixText: Prefix
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25
    ),
    onChanged: f,
    keyboardType: TextInputType.number,
  );  
}