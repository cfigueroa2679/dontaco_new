class CartItem {
  final String nombre;
  final String carne;
  int cantidad;
  final double precio;

  // Nuevos campos opcionales
  final String? extra1; // Ej: "Sopas: 2, Caldos: 2"
  final String? extra2; // Ej: "Bebida: Uva"

  CartItem({
    required this.nombre,
    required this.carne,
    required this.cantidad,
    required this.precio,
    this.extra1,
    this.extra2,
  });

  double get subtotal => precio * cantidad;
}