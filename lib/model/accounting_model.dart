class AccountingModel {
  final int? id;
  final String fecha;
  final String tipo;
  final String descripcion;
  final double monto;
  final String categoria;
  final String? createdAt;

  AccountingModel({
    this.id,
    required this.fecha,
    required this.tipo,
    required this.descripcion,
    required this.monto,
    required this.categoria,
    this.createdAt,
  });

  factory AccountingModel.fromMap(Map<String, dynamic> map) {
    return AccountingModel(
      id: map['id'],
      fecha: map['fecha'],
      tipo: map['tipo'],
      descripcion: map['descripcion'],
      monto: map['monto'],
      categoria: map['categoria'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'tipo': tipo,
      'descripcion': descripcion,
      'monto': monto,
      'categoria': categoria,
      'created_at': createdAt,
    };
  }
}