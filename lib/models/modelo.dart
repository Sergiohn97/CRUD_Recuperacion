class Despesa {
  int? id;
  late String data;
  late String categoria;
  late String tipo;
  late String concepte;
  late int quantitat;
  late int km;

  static final Despesa _modelo = Despesa._internal();
  factory Despesa(){
    return _modelo;
  }
  Despesa._internal();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'categoria': categoria,
      'tipo': tipo,
      'concepte': concepte,
      'quantitat': quantitat,
      'km': km,

    };
  }

  // Convert a Map to a Dog Object
  Despesa.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    data = map['data'];
    categoria = map['categoria'];
    tipo = map['tipo'];
    concepte = map['concepte'];
    quantitat = map['quantitat'];
    km = map['km'];
  }
  void updateDespesa(int _id,String _fecha,String _categoria,String _tipo,String _concepte,int _quantitat, int _km){
    id = _id;
    data = _fecha;
    categoria = _categoria;
    tipo = _tipo;
    concepte = _concepte;
    quantitat = _quantitat;
    km=_km;
  }
  void setDespesa2(String _fecha,String _categoria,String _tipo,String _concepte,int _quantitat, int _km){
    data = _fecha;
    categoria = _categoria;
    tipo = _tipo;
    concepte = _concepte;
    quantitat = _quantitat;
    km= _km;
  }
}
