import 'package:dogs_db_pseb_bridge/vista/update_orden_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/modelo.dart';
import '../vista/afegir_screen.dart';
import 'package:intl/intl.dart';
import '../db/controlador.dart';

class ListaDespeses extends StatefulWidget {
  const ListaDespeses({Key? key}) : super(key: key);

  @override
  State<ListaDespeses> createState() => _ListaDespesesState();
}

class _ListaDespesesState extends State<ListaDespeses> {
  late List<Despesa> despeses;
  late List<String> categorias;
  late String selectedCategoria;

  @override
  void initState() {
    super.initState();
    selectedCategoria = 'Totes';
    despeses = [];
    categorias = [];
    getAllDespeses();
  }

  Future<void> getAllDespeses() async {
    List<Despesa> allDespeses = await DatabaseHelper.instance.getAllDespesa();
    List<String> allCategorias = ['Totes'];

    for (var gasto in allDespeses) {
      if (!allCategorias.contains(gasto.categoria)) {
        allCategorias.add(gasto.categoria);
      }
    }

    setState(() {
      despeses = allDespeses;
      categorias = allCategorias;
    });
  }

  List<Despesa> getFilteredDespeses() {
    if (selectedCategoria == 'Totes') {
      return despeses;
    } else {
      return despeses.where((despesa) => despesa.categoria == selectedCategoria).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Llista de despeses'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DropdownButton<String>(
              value: selectedCategoria,
              items: categorias.map((categoria) {
                return DropdownMenuItem<String>(
                  value: categoria,
                  child: Text(categoria),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoria = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: getFilteredDespeses().length,
              itemBuilder: (context, index) {
                Despesa despesa = getFilteredDespeses()[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(despesa.data)),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text('Tipus: ${despesa.tipo}'),
                              Text('Categoria: ${despesa.categoria}'),
                              Text('Concepte: ${despesa.concepte}'),
                              Text('Quantitat: ${despesa.quantitat}'),
                              Text('km: ${despesa.km}'),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () async {
                                var result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return Actualizar(despesa: despesa);
                                    },
                                  ),
                                );

                                if (result == 'done') {
                                  getAllDespeses();
                                }
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                int result = await DatabaseHelper.instance
                                    .deleteDespesa(despesa.id!);
                                if (result > 0) {
                                  Fluttertoast.showToast(
                                      msg: 'Despesa esborrada correctament!');
                                  getAllDespeses();
                                }
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AfegirDespesa()),
          ).then((value) {
            if (value == 'done') {
              getAllDespeses();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }}