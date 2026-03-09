import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerInfoScreen extends StatefulWidget {
  final Function(
    String nombre,
    String telefono,
    String direccion,
    String metodoPago,
    String comentarios,
  ) onConfirm;

  const CustomerInfoScreen({super.key, required this.onConfirm});

  @override
  State<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final comentariosController = TextEditingController();

  String metodoPago = "transferencia"; // Default

  @override
  void initState() {
    super.initState();
    _cargarDatosGuardados();
  }

  Future<void> _cargarDatosGuardados() async {
    final prefs = await SharedPreferences.getInstance();

    nombreController.text = prefs.getString("nombre_cliente") ?? "";
    telefonoController.text = prefs.getString("telefono_cliente") ?? "";
    direccionController.text = prefs.getString("direccion_cliente") ?? "";
  }

  Future<void> _guardarDatos(
      String nombre, String telefono, String direccion) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("nombre_cliente", nombre);
    await prefs.setString("telefono_cliente", telefono);
    await prefs.setString("direccion_cliente", direccion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos del cliente"),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                labelText: "Nombre completo",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Número de teléfono",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: direccionController,
              decoration: const InputDecoration(
                labelText: "Dirección exacta",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // ⭐ COMENTARIOS DEL CLIENTE
            TextField(
              controller: comentariosController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Comentarios para tu pedido (opcional)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // ⭐ MÉTODO DE PAGO
            const Text(
              "Método de pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            RadioListTile(
              title: const Text("Transferencia bancaria"),
              value: "transferencia",
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() => metodoPago = value.toString());
              },
            ),

            RadioListTile(
              title: const Text("Tarjeta de crédito (pago al recibir)"),
              value: "tarjeta",
              groupValue: metodoPago,
              onChanged: (value) {
                setState(() => metodoPago = value.toString());
              },
            ),

            if (metodoPago == "transferencia") ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Datos para transferencia:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 6),
                    Text("Banco Industrial"),
                    Text("Cuenta Monetaria"),
                    Text("410-004888-5"),
                    Text("A nombre de: Tacos Con Todo"),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
              onPressed: () async {
                final nombre = nombreController.text.trim();
                final telefono = telefonoController.text.trim();
                final direccion = direccionController.text.trim();
                final comentarios = comentariosController.text.trim();

                if (nombre.isEmpty ||
                    telefono.isEmpty ||
                    direccion.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Por favor completa todos los campos"),
                    ),
                  );
                  return;
                }

                await _guardarDatos(nombre, telefono, direccion);

                widget.onConfirm(
                  nombre,
                  telefono,
                  direccion,
                  metodoPago,
                  comentarios,
                );

                Navigator.pop(context);
              },
              child: const Text(
                "Confirmar datos",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
