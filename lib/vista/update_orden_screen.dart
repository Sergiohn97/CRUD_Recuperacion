import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart'; // Importa la biblioteca intl para acceder al método DateFormat
import '../db/controlador.dart';
import '../models/modelo.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class Actualizar extends StatefulWidget {
  final Despesa despesa;

  const Actualizar({Key? key, required this.despesa}) : super(key: key);

  @override
  State<Actualizar> createState() => _ActualizarState();
}

class _ActualizarState extends State<Actualizar> {
  late DateTime data;
  String? categoria;
  late List<String> items2 = ['Combustible', 'Avaria', 'Assegurança', 'Equipament', 'Altres'];
  late String? selectedItem2 = 'Combustible';
  late List<String> items = ['Recurrent', 'Extraordinari'];
  late String? selectedItem = 'Recurrent';
  String? tipo;
  late int km;

  late String concepte;
  late int quantitat;

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    data = DateTime.parse(widget.despesa.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualitzar despesa'),
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
                      locale: LocaleType.es,
                      currentTime: data,
                      onConfirm: (selectedDate) {
                        setState(() {
                          data = selectedDate;
                        });
                      },
                    );
                  },
                  child: const Text('Seleccionar data'),
                ),
                if (data != null)
                  Text(
                    'Data seleccionada: ${DateFormat('dd/MM/yyyy').format(data)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  initialValue: widget.despesa.concepte,
                  decoration: const InputDecoration(hintText: 'Introdueix un concepte'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introdueix un concepte';
                    }

                    concepte = value;
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: widget.despesa.quantitat.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Introdueix una quantitat'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introdueix una quantitat';
                    }

                    quantitat = int.parse(value);
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: widget.despesa.km.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Introdueix una quantitat de Km'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Introdueix una quantitat';
                    }

                    km = int.parse(value);
                    return null;
                  },
                ),
                const SizedBox(height: 10,),
                DropdownButton<String>(
                  value: selectedItem2,
                  items: items2
                      .map(
                        (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize: 15)),
                    ),
                  )
                      .toList(),
                  onChanged: (item) => setState(() {
                    selectedItem2 = item;
                    categoria = item.toString();
                  }),
                ),
                DropdownButton<String>(
                  value: selectedItem,
                  items: items
                      .map(
                        (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: TextStyle(fontSize: 15)),
                    ),
                  )
                      .toList(),
                  onChanged: (item) => setState(() {
                    selectedItem = item;
                    tipo = item.toString();
                  }),
                ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var id = widget.despesa.id;
                      var dbHelper = DatabaseHelper.instance;
                      if (categoria == null) {
                        categoria = selectedItem2 ?? '';
                      }
                      if (tipo == null) {
                        tipo = selectedItem ?? '';
                      }
                      dbHelper.actualizarDespesa(
                        id,
                        DateFormat('yyyy-MM-dd').format(data),
                        categoria,
                        tipo,
                        concepte,
                        quantitat,
                        km,
                      );
                      Navigator.pop(context, 'done');
                    }
                  },
                  child: const Text('Actualitzar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}