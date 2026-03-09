import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/cart_provider.dart';
import '../services/ventas_service.dart';
import '../services/firestore_service.dart';
import 'customer_info_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Necesario para abrir WhatsApp en Flutter Web
import 'dart:html' as html;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de compras'),
        backgroundColor: Colors.red,
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) {
                          cart.removeItem(index);
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: const Icon(Icons.fastfood, size: 40),
                            title: Text(item.nombre),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Carne: ${item.carne}'),
                                Text('Cantidad: ${item.cantidad}'),
                                if (item.extra1 != null)
                                  Text(item.extra1!,
                                      style: const TextStyle(
                                          color: Colors.deepOrange)),
                                if (item.extra2 != null)
                                  Text(item.extra2!,
                                      style: const TextStyle(
                                          color: Colors.blueAccent)),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Q${item.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        cart.decreaseQuantity(index);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        cart.increaseQuantity(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Costo de envío: Q20.00 (aplican restricciones)",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total productos: Q${cart.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'Envío: Q20.00',
                        style: TextStyle(fontSize: 18),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        'Gran Total: Q${(cart.total + 20).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          if (!context.mounted) return;

                          final nombreGuardado =
                              prefs.getString("nombre_cliente");
                          final telefonoGuardado =
                              prefs.getString("telefono_cliente");
                          final direccionGuardado =
                              prefs.getString("direccion_cliente");

                          if (nombreGuardado != null &&
                              telefonoGuardado != null &&
                              direccionGuardado != null &&
                              nombreGuardado.isNotEmpty &&
                              telefonoGuardado.isNotEmpty &&
                              direccionGuardado.isNotEmpty) {
                            showDialog(
                              context: context,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text("¿Usar tus datos guardados?"),
                                  content: Text(
                                    "Nombre: $nombreGuardado\n"
                                    "Teléfono: $telefonoGuardado\n"
                                    "Dirección: $direccionGuardado\n\n"
                                    "¿Deseas usar estos datos para tu pedido?"
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("Editar"),
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        _abrirPantallaDatos(context, cart);
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text("Usar datos"),
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        _procesarPedido(
                                          context,
                                          cart,
                                          nombreGuardado,
                                          telefonoGuardado,
                                          direccionGuardado,
                                          "transferencia",
                                          "",
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            _abrirPantallaDatos(context, cart);
                          }
                        },
                        child: const Text(
                          'Enviar pedido por WhatsApp',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _abrirPantallaDatos(BuildContext context, CartProvider cart) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CustomerInfoScreen(
          onConfirm: (nombre, telefono, direccion, metodoPago, comentarios) {
            _procesarPedido(
              context,
              cart,
              nombre,
              telefono,
              direccion,
              metodoPago,
              comentarios,
            );
          },
        ),
      ),
    );
  }

  void _procesarPedido(
    BuildContext context,
    CartProvider cart,
    String nombre,
    String telefono,
    String direccion,
    String metodoPago,
    String comentarios,
  ) async {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Procesando pedido...")),
    );

    final prefs = await SharedPreferences.getInstance();

    final hoy = DateTime.now();
    final fechaHoy = "${hoy.year}-${hoy.month}-${hoy.day}";

    final ultimaFecha = prefs.getString("ultima_fecha") ?? "";
    int correlativo = prefs.getInt("correlativo") ?? 0;

    if (ultimaFecha != fechaHoy) {
      correlativo = 1;
      await prefs.setString("ultima_fecha", fechaHoy);
    } else {
      correlativo++;
    }

    await prefs.setInt("correlativo", correlativo);

    final fechaStr = fechaHoy;
    final horaStr = "${hoy.hour}:${hoy.minute.toString().padLeft(2, '0')}";

    final filas = cart.items.map((item) {
      return {
        "fecha": fechaStr,
        "hora": horaStr,
        "correlativo": correlativo,
        "combo": item.nombre,
        "carne": item.carne,
        "cantidad": item.cantidad,
        "precio_unitario": item.precio,
        "total": item.subtotal,
        "cliente": nombre,
        "telefono": telefono,
        "direccion": direccion,
        "metodo_pago": metodoPago,
        "comentarios": comentarios,
      };
    }).toList();

    final firestore = FirestoreService();

    await firestore.guardarPedido(
      correlativo: correlativo,
      fecha: fechaStr,
      hora: horaStr,
      nombre: nombre,
      telefono: telefono,
      direccion: direccion,
      metodoPago: metodoPago,
      comentarios: comentarios,
      subtotal: cart.total,
      envio: 20,
      total: cart.total + 20,
      items: filas,
    );

    if (!context.mounted) return;

    await VentasService.enviarPedido(filas);

    if (!context.mounted) return;

    final mensaje = StringBuffer();

    mensaje.writeln("🔥 Pedido Fiestón #$correlativo 🔥\n");
    mensaje.writeln("Quiero ordenar:\n");

    for (var item in cart.items) {
      mensaje.writeln(
        '${item.nombre} — ${item.carne} — Cantidad: ${item.cantidad} — Subtotal: Q${item.subtotal}'
      );

      if (item.extra1 != null) mensaje.writeln(item.extra1!);
      if (item.extra2 != null) mensaje.writeln(item.extra2!);

      mensaje.writeln("");
    }

    mensaje.writeln("🔥 Subtotal: Q${cart.total}");
    mensaje.writeln("🚚 Envío: Q20");
    mensaje.writeln("💰 Total a pagar: Q${cart.total + 20}\n");

    mensaje.writeln("Nombre: $nombre");
    mensaje.writeln("Teléfono: $telefono");
    mensaje.writeln("Dirección: $direccion\n");

    if (comentarios.isNotEmpty) {
      mensaje.writeln("Comentarios:");
      mensaje.writeln("$comentarios\n");
    }

    if (metodoPago == "transferencia") {
      mensaje.writeln("Método de pago: Transferencia bancaria\n");
      mensaje.writeln("Banco Industrial");
      mensaje.writeln("Cuenta Monetaria");
      mensaje.writeln("410-004888-5");
      mensaje.writeln("A nombre de: Tacos Con Todo");
    } else {
      mensaje.writeln("Método de pago: Tarjeta de crédito (pago al recibir)");
    }

    final url =
        'https://api.whatsapp.com/send?phone=50252048482&text=${Uri.encodeComponent(mensaje.toString())}';

    final redirectUrl =
        "https://dontaco-app.web.app/whatsapp_redirect.html?url=${Uri.encodeComponent(url)}";

    try {
      if (kIsWeb) {
        html.window.open(url, "_self");
      }
    } catch (_) {
      // ignore
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        if (kIsWeb) {
          html.window.location.href = redirectUrl;
        }
      } catch (_) {
        if (kIsWeb) {
          try {
            html.window.open(redirectUrl, "_self");
          } catch (_) {
            // ignore
          }
        }
      }
    });

    try {
      cart.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pedido enviado correctamente")),
        );
      }
    } catch (_) {
      // ignore
    }
  }
}