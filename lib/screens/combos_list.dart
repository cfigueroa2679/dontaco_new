import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'combo_detail.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    final combos = [
      {
        "nombre": "Combo Fiestón",
        "precio": "Q95",
        "descripcion":
            "Incluye 1 libra de carne, 25 tortillas, cilantro, limón, salsa de tomate, cebolla y salsa de aguacate.",
        "imagen": "assets/combos/fieston.png",
      },
      {
        "nombre": "Combo Completo",
        "precio": "Q89",
        "descripcion":
            "Incluye 1 libra de carne, 25 tortillas, salsa de aguacate y salsa de tomate.",
        "imagen": "assets/combos/completo.png",
      },
      {
        "nombre": "Combo Salsero",
        "precio": "Q79",
        "descripcion":
            "Incluye 1 libra de carne, salsa de tomate, salsa de aguacate y picante.",
        "imagen": "assets/combos/salsero.png",
      },
      {
        "nombre": "Combo Simple Tortilla",
        "precio": "Q79",
        "descripcion":
            "Incluye 1 libra de carne y 25 tortillas gluten free.",
        "imagen": "assets/combos/simple_tortilla.png",
      },
      {
        "nombre": "Combo Simple",
        "precio": "Q69",
        "descripcion": "Incluye 1 libra de carne.",
        "imagen": "assets/combos/simple.png",
      },
      {
        "nombre": "Combo Fiestón Familiar",
        "precio": "Q199",
        "descripcion":
            "2 libras de carne, 50 tortillas, 4 gaseosas Salvavidas, cilantro, limón, salsas y cebolla.",
        "imagen": "assets/combos/fieston_familiar.jpg",
      },
      {
        "nombre": "Combo Super Familiar",
        "precio": "Q219",
        "descripcion":
            "4 Sopas o Caldos, bebidas Salvavidas, 1 libra de carne sellada, 25 tortillas y salsas.",
        "imagen": "assets/combos/super_familiar.jpg",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú'),
        backgroundColor: Colors.red,
        actions: [
          // 🟡 CARRITO CON CONTADOR
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
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

      body: ListView.builder(
        itemCount: combos.length,
        itemBuilder: (context, index) {
          final combo = combos[index];

          return Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ComboDetailScreen(
                      nombre: combo["nombre"]!,
                      descripcion: combo["descripcion"]!,
                      precio: combo["precio"]!,
                      imagen: combo["imagen"]!,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGEN 140×140
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 140,
                        height: 140,
                        child: Image.asset(
                          combo["imagen"]!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // TEXTO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            combo["nombre"]!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            combo["descripcion"]!,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            combo["precio"]!,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}