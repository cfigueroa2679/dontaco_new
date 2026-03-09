import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import 'cart_screen.dart';
import 'combos_list.dart'; // ← CORRECTO

class ComboDetailScreen extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final String precio;
  final String imagen;

  const ComboDetailScreen({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imagen,
  });

  @override
  State<ComboDetailScreen> createState() => _ComboDetailScreenState();
}

class _ComboDetailScreenState extends State<ComboDetailScreen> {
  String carneSeleccionada = 'Al Pastor';

  int cantidad = 1;

  // Sopas y caldos
  int cantidadSopa = 0;
  int cantidadCaldo = 0;

  // Bebidas
  int cantidadUva = 0;
  int cantidadNaranjada = 0;
  int cantidadLimonada = 0;

  int get totalSopasCaldos => cantidadSopa + cantidadCaldo;
  int get totalBebidas => cantidadUva + cantidadNaranjada + cantidadLimonada;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    final bool esSuperFamiliar = widget.nombre == "Combo Super Familiar";
    final bool esFamiliar = widget.nombre == "Combo Fiestón Familiar";

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombre),
        backgroundColor: Colors.red,
        actions: [
          // BOTÓN SEGUIR PIDIENDO
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MenuScreen()),
              );
            },
            child: const Text(
              "Seguir pidiendo",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          // CARRITO CON CONTADOR
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.items.length.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // IMAGEN ULTRA PEQUEÑA (40×40)
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset(
                  widget.imagen,
                  fit: BoxFit.contain, // ← NO SE ESTIRA
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(widget.descripcion, style: const TextStyle(fontSize: 18)),

          const SizedBox(height: 20),

          // Carne
          const Text(
            'Selecciona la carne:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          DropdownButton<String>(
            value: carneSeleccionada,
            items: const [
              DropdownMenuItem(value: 'Al Pastor', child: Text('Al Pastor')),
              DropdownMenuItem(value: 'Cochinita Pibil', child: Text('Cochinita Pibil')),
              DropdownMenuItem(value: 'Pollo a la Plancha', child: Text('Pollo a la Plancha')),
              DropdownMenuItem(value: 'Pollo al Pastor', child: Text('Pollo al Pastor')),
              DropdownMenuItem(value: 'Solo Pibil', child: Text('Solo Pibil')),
            ],
            onChanged: (value) {
              setState(() => carneSeleccionada = value!);
            },
          ),

          const SizedBox(height: 20),

          // Sopas y caldos
          if (esSuperFamiliar) ...[
            const Text(
              'Combina Sopas y Caldos (total 4):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Seleccionados: $totalSopasCaldos / 4",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: totalSopasCaldos == 4 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: totalSopasCaldos / 4,
                    backgroundColor: Colors.grey.shade300,
                    color: totalSopasCaldos == 4 ? Colors.green : Colors.red,
                    minHeight: 8,
                  ),
                ],
              ),
            ),

            _contador(
              titulo: "Sopas de Tortilla",
              valor: cantidadSopa,
              onAdd: () {
                if (totalSopasCaldos < 4) setState(() => cantidadSopa++);
              },
              onRemove: () {
                if (cantidadSopa > 0) setState(() => cantidadSopa--);
              },
            ),

            _contador(
              titulo: "Caldos Tlalpeños",
              valor: cantidadCaldo,
              onAdd: () {
                if (totalSopasCaldos < 4) setState(() => cantidadCaldo++);
              },
              onRemove: () {
                if (cantidadCaldo > 0) setState(() => cantidadCaldo--);
              },
            ),

            const SizedBox(height: 20),
          ],

          // Bebidas
          if (esSuperFamiliar || esFamiliar) ...[
            const Text(
              'Selecciona tus 4 bebidas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Seleccionadas: $totalBebidas / 4",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: totalBebidas == 4 ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: totalBebidas / 4,
                    backgroundColor: Colors.grey.shade300,
                    color: totalBebidas == 4 ? Colors.green : Colors.red,
                    minHeight: 8,
                  ),
                ],
              ),
            ),

            _contador(
              titulo: "Uva",
              valor: cantidadUva,
              onAdd: () {
                if (totalBebidas < 4) setState(() => cantidadUva++);
              },
              onRemove: () {
                if (cantidadUva > 0) setState(() => cantidadUva--);
              },
            ),

            _contador(
              titulo: "Naranjada con soda",
              valor: cantidadNaranjada,
              onAdd: () {
                if (totalBebidas < 4) setState(() => cantidadNaranjada++);
              },
              onRemove: () {
                if (cantidadNaranjada > 0) setState(() => cantidadNaranjada--);
              },
            ),

            _contador(
              titulo: "Limonada",
              valor: cantidadLimonada,
              onAdd: () {
                if (totalBebidas < 4) setState(() => cantidadLimonada++);
              },
              onRemove: () {
                if (cantidadLimonada > 0) setState(() => cantidadLimonada--);
              },
            ),

            const SizedBox(height: 20),
          ],

          // Cantidad del combo
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle, size: 32),
                onPressed: () {
                  if (cantidad > 1) setState(() => cantidad--);
                },
              ),
              Text(
                cantidad.toString(),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32),
                onPressed: () => setState(() => cantidad++),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Botón agregar
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: () {
              cart.addItem(
                CartItem(
                  nombre: widget.nombre,
                  carne: carneSeleccionada,
                  cantidad: cantidad,
                  precio: double.parse(widget.precio.replaceAll('Q', '')),
                  extra1: esSuperFamiliar
                      ? "Sopas: $cantidadSopa, Caldos: $cantidadCaldo"
                      : null,
                  extra2: (esSuperFamiliar || esFamiliar)
                      ? "Bebidas: Uva $cantidadUva, Naranjada $cantidadNaranjada, Limonada $cantidadLimonada"
                      : null,
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Agregado al carrito')),
              );
            },
            child: Text(
              'Agregar al carrito — ${widget.precio}',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contador({
    required String titulo,
    required int valor,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(titulo, style: const TextStyle(fontSize: 16)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: onRemove,
            ),
            Text("$valor", style: const TextStyle(fontSize: 20)),
            IconButton(
              icon: const Icon(Icons.add_circle),
              onPressed: onAdd,
            ),
          ],
        ),
      ],
    );
  }
}
