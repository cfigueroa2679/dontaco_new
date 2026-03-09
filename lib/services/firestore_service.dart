import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference pedidosRef =
      FirebaseFirestore.instance.collection('Pedidos');

  Future<void> guardarPedido({
    required int correlativo,
    required String fecha,
    required String hora,
    required String nombre,
    required String telefono,
    required String direccion,
    required String metodoPago,
    required String comentarios,
    required double subtotal,
    required double envio,
    required double total,
    required List<Map<String, dynamic>> items,
  }) async {
    await pedidosRef.add({
      'correlativo': correlativo,
      'fecha': fecha,
      'hora': hora,
      'cliente': nombre,
      'telefono': telefono,
      'direccion': direccion,
      'metodo_pago': metodoPago,
      'comentarios': comentarios,
      'subtotal': subtotal,
      'envio': envio,
      'total': total,
      'items': items,
      'estado': 'pendiente',
      'timestamp': Timestamp.now(),
    });
  }
}