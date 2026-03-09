import 'dart:convert';
import 'package:http/http.dart' as http;

class VentasService {
  static const String url =
      "https://script.google.com/macros/s/AKfycbyj_HeBE71fJzwb3nVx3lzsqSn3akLF4VWz4FvwljjqFn4ckS0PqdAE_vV8gqPAq6g5jQ/exec";

  static Future<void> enviarPedido(List<Map<String, dynamic>> filas) async {
    try {
      await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"rows": filas}),
      );
    } catch (e) {
      print("Error enviando reporte: $e");
    }
  }
}