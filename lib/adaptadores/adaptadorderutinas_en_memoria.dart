import '../dominio/entidades/rutina.dart';
import '../dominio/repositorios/repositorio_de_rutinas.dart';

class AdaptadorDeRutinasEnMemoria implements RepositorioDeRutinas {
  final List<Rutina> _rutinas = [
    Rutina(
      id: '1',
      nombre: 'Rutina Alimenticia Básica',
      descripcion: 'Plan de comidas saludables para 7 días.',
      ejercicios: [
        'Día 1: Desayuno - Avena, Almuerzo - Pollo y arroz, Cena - Ensalada',
        'Día 2: Desayuno - Yogur y frutas, Almuerzo - Pescado y verduras, Cena - Sopa de verduras',
        'Día 3: Desayuno - Tostadas integrales, Almuerzo - Carne magra y puré, Cena - Omelette de verduras',
        'Día 4: Desayuno - Frutas frescas, Almuerzo - Pasta integral, Cena - Ensalada de atún',
        'Día 5: Desayuno - Batido de frutas, Almuerzo - Pollo al horno, Cena - Verduras salteadas',
        'Día 6: Desayuno - Pan integral, Almuerzo - Lentejas, Cena - Sopa de pollo',
        'Día 7: Desayuno - Huevos revueltos, Almuerzo - Pescado al vapor, Cena - Ensalada mixta',
      ],
    ),
    Rutina(
      id: '2',
      nombre: 'Rutina Vegetariana',
      descripcion: 'Menú vegetariano para una semana.',
      ejercicios: [
        'Día 1: Desayuno - Frutas, Almuerzo - Ensalada de quinoa, Cena - Sopa de verduras',
        'Día 2: Desayuno - Avena, Almuerzo - Hamburguesa de lentejas, Cena - Tortilla de espinaca',
        'Día 3: Desayuno - Yogur, Almuerzo - Pasta con tomate, Cena - Ensalada de garbanzos',
        'Día 4: Desayuno - Pan integral, Almuerzo - Curry de vegetales, Cena - Sopa de calabaza',
        'Día 5: Desayuno - Batido verde, Almuerzo - Tacos de vegetales, Cena - Ensalada de arroz',
        'Día 6: Desayuno - Frutas, Almuerzo - Pizza vegetariana, Cena - Sopa de tomate',
        'Día 7: Desayuno - Tostadas, Almuerzo - Falafel, Cena - Ensalada de lentejas',
      ],
    ),
    Rutina(
      id: '3',
      nombre: 'Rutina Proteica',
      descripcion: 'Plan semanal alto en proteínas.',
      ejercicios: [
        'Día 1: Desayuno - Huevos, Almuerzo - Pollo, Cena - Atún',
        'Día 2: Desayuno - Yogur griego, Almuerzo - Carne magra, Cena - Queso cottage',
        'Día 3: Desayuno - Batido proteico, Almuerzo - Pescado, Cena - Omelette',
        'Día 4: Desayuno - Tostadas con pavo, Almuerzo - Pollo, Cena - Sopa de pollo',
        'Día 5: Desayuno - Frutas y nueces, Almuerzo - Lentejas, Cena - Ensalada de huevo',
        'Día 6: Desayuno - Pan integral, Almuerzo - Pavo, Cena - Yogur',
        'Día 7: Desayuno - Omelette, Almuerzo - Pescado, Cena - Ensalada de pollo',
      ],
    ),
  ];

  @override
  Future<List<Rutina>> obtenerRutinas() async {
    return _rutinas;
  }
}
