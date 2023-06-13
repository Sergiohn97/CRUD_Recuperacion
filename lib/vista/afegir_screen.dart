import 'package:dogs_db_pseb_bridge/db/controlador.dart';
import 'package:dogs_db_pseb_bridge/models/modelo.dart';
import 'package:dogs_db_pseb_bridge/vista/orden_lista_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AfegirDespesa extends StatefulWidget {
  const AfegirDespesa({Key? key}) : super(key: key);

  @override
  State<AfegirDespesa> createState() => _AfegirDespesaState();
}

class _AfegirDespesaState extends State<AfegirDespesa> {
  late int id;
  DateTime? data;
  // variables para dropdownlist
  late String categoria;
  late List<String> items2 = ['Combustible', 'Avaria', 'Assegurança', 'Equipament', 'Altres'];
  late String? selectedItem2 = 'Combustible';
  // variables para dropdownlist
  late List<String> items = ['Recurrent', 'Extraordinari'];
  late String? selectedItem = 'Recurrent';
  late String tipo;
  late String concepte;
  late int quantitat;
  late int km;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    categoria = selectedItem2!;
    tipo = selectedItem!;
  }

  void handleCategoriaChanged(String? item) {
    setState(() {
      selectedItem2 = item;
      categoria = item ?? '';
    });
  }

  void handleTipoChanged(String? item) {
    setState(() {
      selectedItem = item;
      tipo = item ?? '';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Afegir despesa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    DatePicker.showDatePicker(
                      context,
                      locale: LocaleType.es, // Cambia a tu idioma preferido
                      currentTime: data ?? DateTime.now(),
                      onConfirm: (selectedDate) {
                        setState(() {
                          data = selectedDate;
                        });
                      },
                    );
                  },
                  child: const Text('Selecciona data de la despesa'),
                ),
                if (data != null)
                  Text(
                    'Data seleccionada: ${data!.day}/${data!.month}/${data!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                const SizedBox(height: 10,),
                TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Concepte de la despesa'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Introdueix un concepte';
                    }
                    concepte = value;
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Quantitat de diners (€)'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Introdueix una quantitat de diners';
                    }
                    quantitat = int.parse(value);
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Km recorregutss'
                  ),
                  validator: (String? value){
                    if( value == null || value.isEmpty){
                      return 'Introdueix una quantitat de km';
                    }
                    km = int.parse(value);
                    return null;
                  },
                ),
                DropdownButton<String>(
                  value: selectedItem2,
                  items: items2.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize:15))
                  )).toList(),
                  onChanged: handleCategoriaChanged,
                ),
                const SizedBox(height: 10,),
                DropdownButton<String>(
                  value: selectedItem,
                  items: items.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize:15))
                  )).toList(),
                  onChanged: handleTipoChanged,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (data == null) {
                      Fluttertoast.showToast(msg: 'La data no pot ser nula');
                      return;
                    }

                    if (formKey.currentState!.validate()) {
                      var dbHelper = DatabaseHelper.instance;
                      if (categoria == null) {
                        categoria = selectedItem2 ?? '';
                      }
                      if (tipo == null) {
                        tipo = selectedItem ?? '';
                      }
                      dbHelper.setDespesa(
                        data != null ? data!.toString() : '',
                        categoria,
                        tipo,
                        concepte,
                        quantitat,
                        km,
                      );

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Desat correctament'),
                            actions: [
                              TextButton(
                                child: Text('Acceptar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Desar'),
                ),
                ElevatedButton(
                  onPressed: () async{
                    await Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return const ListaDespeses();
                    }));
                    Despesa().id = null;
                  },
                  child: const Text('Veure totes les despeses'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}