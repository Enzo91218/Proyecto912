import '../dominio/entidades/rutina.dart';
import '../dominio/repositorios/repositorio_de_rutinas.dart';

class AdaptadorDeRutinasEnMemoria implements RepositorioDeRutinas {
  final List<Rutina> _rutinas = [
    Rutina(
      id: '1',
      nombre: 'Rutina Alimenticia Básica',
      descripcion: 'Plan de comidas saludables para 7 días.',
      alimentos: [
        // Día 1
        Alimento(
          dia: 1,
          horario: 'Desayuno',
          alimento: 'Avena con frutas',
          cantidad: '1 tazón',
        ),
        Alimento(
          dia: 1,
          horario: 'Almuerzo',
          alimento: 'Pollo a la plancha con arroz integral',
          cantidad: '200g pollo + 150g arroz',
        ),
        Alimento(
          dia: 1,
          horario: 'Cena',
          alimento: 'Ensalada verde',
          cantidad: '1 plato grande',
        ),

        // Día 2
        Alimento(
          dia: 2,
          horario: 'Desayuno',
          alimento: 'Yogur griego con frutas',
          cantidad: '1 taza + frutas',
        ),
        Alimento(
          dia: 2,
          horario: 'Almuerzo',
          alimento: 'Pescado al horno con verduras',
          cantidad: '200g pescado',
        ),
        Alimento(
          dia: 2,
          horario: 'Cena',
          alimento: 'Sopa de verduras',
          cantidad: '1 plato',
        ),

        // Día 3
        Alimento(
          dia: 3,
          horario: 'Desayuno',
          alimento: 'Tostadas integrales con aguacate',
          cantidad: '2 tostadas',
        ),
        Alimento(
          dia: 3,
          horario: 'Almuerzo',
          alimento: 'Carne magra con puré de papas',
          cantidad: '150g carne + 1 taza puré',
        ),
        Alimento(
          dia: 3,
          horario: 'Cena',
          alimento: 'Omelette de verduras',
          cantidad: '2 huevos',
        ),

        // Día 4
        Alimento(
          dia: 4,
          horario: 'Desayuno',
          alimento: 'Frutas frescas variadas',
          cantidad: '2 tazas',
        ),
        Alimento(
          dia: 4,
          horario: 'Almuerzo',
          alimento: 'Pasta integral con salsa de tomate',
          cantidad: '200g pasta',
        ),
        Alimento(
          dia: 4,
          horario: 'Cena',
          alimento: 'Ensalada de atún',
          cantidad: '1 lata atún + ensalada',
        ),

        // Día 5
        Alimento(
          dia: 5,
          horario: 'Desayuno',
          alimento: 'Batido de frutas con leche',
          cantidad: '1 vaso grande',
        ),
        Alimento(
          dia: 5,
          horario: 'Almuerzo',
          alimento: 'Pollo al horno con batatas',
          cantidad: '200g pollo + 1 batata',
        ),
        Alimento(
          dia: 5,
          horario: 'Cena',
          alimento: 'Verduras salteadas',
          cantidad: '1 plato',
        ),

        // Día 6
        Alimento(
          dia: 6,
          horario: 'Desayuno',
          alimento: 'Pan integral con queso',
          cantidad: '2 rebanadas + 50g queso',
        ),
        Alimento(
          dia: 6,
          horario: 'Almuerzo',
          alimento: 'Lentejas guisadas',
          cantidad: '1 plato grande',
        ),
        Alimento(
          dia: 6,
          horario: 'Cena',
          alimento: 'Sopa de pollo con verduras',
          cantidad: '1 plato',
        ),

        // Día 7
        Alimento(
          dia: 7,
          horario: 'Desayuno',
          alimento: 'Huevos revueltos con espinaca',
          cantidad: '2 huevos',
        ),
        Alimento(
          dia: 7,
          horario: 'Almuerzo',
          alimento: 'Pescado al vapor con brócoli',
          cantidad: '200g pescado',
        ),
        Alimento(
          dia: 7,
          horario: 'Cena',
          alimento: 'Ensalada mixta completa',
          cantidad: '1 plato grande',
        ),
      ],
    ),
    Rutina(
      id: '2',
      nombre: 'Rutina Vegetariana',
      descripcion: 'Menú vegetariano para una semana.',
      alimentos: [
        // Día 1
        Alimento(
          dia: 1,
          horario: 'Desayuno',
          alimento: 'Frutas tropicales',
          cantidad: '2 tazas',
        ),
        Alimento(
          dia: 1,
          horario: 'Almuerzo',
          alimento: 'Ensalada de quinoa con vegetales',
          cantidad: '1 plato grande',
        ),
        Alimento(
          dia: 1,
          horario: 'Cena',
          alimento: 'Sopa de verduras',
          cantidad: '1 plato',
        ),

        // Día 2
        Alimento(
          dia: 2,
          horario: 'Desayuno',
          alimento: 'Avena con almendras',
          cantidad: '1 tazón + 30g almendras',
        ),
        Alimento(
          dia: 2,
          horario: 'Almuerzo',
          alimento: 'Hamburguesa de lentejas con ensalada',
          cantidad: '1 hamburguesa',
        ),
        Alimento(
          dia: 2,
          horario: 'Cena',
          alimento: 'Tortilla de espinaca y champiñones',
          cantidad: '2 huevos',
        ),

        // Día 3
        Alimento(
          dia: 3,
          horario: 'Desayuno',
          alimento: 'Yogur natural con granola',
          cantidad: '1 taza + 50g granola',
        ),
        Alimento(
          dia: 3,
          horario: 'Almuerzo',
          alimento: 'Pasta integral con tomate y albahaca',
          cantidad: '200g pasta',
        ),
        Alimento(
          dia: 3,
          horario: 'Cena',
          alimento: 'Ensalada de garbanzos',
          cantidad: '1 plato grande',
        ),

        // Día 4
        Alimento(
          dia: 4,
          horario: 'Desayuno',
          alimento: 'Pan integral con hummus',
          cantidad: '2 rebanadas',
        ),
        Alimento(
          dia: 4,
          horario: 'Almuerzo',
          alimento: 'Curry de vegetales con arroz',
          cantidad: '1 plato',
        ),
        Alimento(
          dia: 4,
          horario: 'Cena',
          alimento: 'Sopa crema de calabaza',
          cantidad: '1 plato',
        ),

        // Día 5
        Alimento(
          dia: 5,
          horario: 'Desayuno',
          alimento: 'Batido verde (espinaca, banana, manzana)',
          cantidad: '1 vaso grande',
        ),
        Alimento(
          dia: 5,
          horario: 'Almuerzo',
          alimento: 'Tacos de vegetales con frijoles',
          cantidad: '3 tacos',
        ),
        Alimento(
          dia: 5,
          horario: 'Cena',
          alimento: 'Ensalada de arroz integral',
          cantidad: '1 plato',
        ),

        // Día 6
        Alimento(
          dia: 6,
          horario: 'Desayuno',
          alimento: 'Tostadas con aguacate y tomate',
          cantidad: '2 tostadas',
        ),
        Alimento(
          dia: 6,
          horario: 'Almuerzo',
          alimento: 'Wok de vegetales con tofu',
          cantidad: '1 plato',
        ),
        Alimento(
          dia: 6,
          horario: 'Cena',
          alimento: 'Sopa minestrone',
          cantidad: '1 plato grande',
        ),

        // Día 7
        Alimento(
          dia: 7,
          horario: 'Desayuno',
          alimento: 'Panqueques de avena con frutas',
          cantidad: '3 panqueques',
        ),
        Alimento(
          dia: 7,
          horario: 'Almuerzo',
          alimento: 'Lasaña vegetariana',
          cantidad: '1 porción',
        ),
        Alimento(
          dia: 7,
          horario: 'Cena',
          alimento: 'Ensalada caprese',
          cantidad: '1 plato',
        ),
      ],
    ),
    Rutina(
      id: '3',
      nombre: 'Rutina Fitness',
      descripcion: 'Plan alimenticio para deportistas.',
      alimentos: [
        // Día 1
        Alimento(
          dia: 1,
          horario: 'Desayuno',
          alimento: 'Claras de huevo con espinaca',
          cantidad: '5 claras',
        ),
        Alimento(
          dia: 1,
          horario: 'Almuerzo',
          alimento: 'Pechuga de pollo con batata',
          cantidad: '250g pollo + 200g batata',
        ),
        Alimento(
          dia: 1,
          horario: 'Merienda',
          alimento: 'Proteína whey con banana',
          cantidad: '1 scoop + 1 banana',
        ),
        Alimento(
          dia: 1,
          horario: 'Cena',
          alimento: 'Salmón con espárragos',
          cantidad: '200g salmón',
        ),

        // Día 2
        Alimento(
          dia: 2,
          horario: 'Desayuno',
          alimento: 'Avena con proteína y frutos rojos',
          cantidad: '1 tazón + 1 scoop',
        ),
        Alimento(
          dia: 2,
          horario: 'Almuerzo',
          alimento: 'Carne magra con arroz integral',
          cantidad: '200g carne + 150g arroz',
        ),
        Alimento(
          dia: 2,
          horario: 'Merienda',
          alimento: 'Yogur griego con nueces',
          cantidad: '200g yogur + 30g nueces',
        ),
        Alimento(
          dia: 2,
          horario: 'Cena',
          alimento: 'Pechuga de pavo con ensalada',
          cantidad: '200g pavo',
        ),

        // Día 3
        Alimento(
          dia: 3,
          horario: 'Desayuno',
          alimento: 'Tortilla de claras con vegetales',
          cantidad: '6 claras',
        ),
        Alimento(
          dia: 3,
          horario: 'Almuerzo',
          alimento: 'Atún con quinoa y verduras',
          cantidad: '200g atún + 150g quinoa',
        ),
        Alimento(
          dia: 3,
          horario: 'Merienda',
          alimento: 'Batido de proteína con avena',
          cantidad: '1 scoop + 50g avena',
        ),
        Alimento(
          dia: 3,
          horario: 'Cena',
          alimento: 'Pollo al horno con brócoli',
          cantidad: '200g pollo',
        ),

        // Día 4
        Alimento(
          dia: 4,
          horario: 'Desayuno',
          alimento: 'Panqueques de proteína',
          cantidad: '3 panqueques',
        ),
        Alimento(
          dia: 4,
          horario: 'Almuerzo',
          alimento: 'Pescado blanco con arroz',
          cantidad: '250g pescado + 150g arroz',
        ),
        Alimento(
          dia: 4,
          horario: 'Merienda',
          alimento: 'Frutas con mantequilla de maní',
          cantidad: '2 frutas + 2 cdas',
        ),
        Alimento(
          dia: 4,
          horario: 'Cena',
          alimento: 'Carne de res magra con vegetales',
          cantidad: '200g carne',
        ),

        // Día 5
        Alimento(
          dia: 5,
          horario: 'Desayuno',
          alimento: 'Huevos enteros con aguacate',
          cantidad: '4 huevos + 1/2 aguacate',
        ),
        Alimento(
          dia: 5,
          horario: 'Almuerzo',
          alimento: 'Pollo con batata y espinaca',
          cantidad: '250g pollo + 200g batata',
        ),
        Alimento(
          dia: 5,
          horario: 'Merienda',
          alimento: 'Proteína con almendras',
          cantidad: '1 scoop + 30g almendras',
        ),
        Alimento(
          dia: 5,
          horario: 'Cena',
          alimento: 'Salmón con ensalada',
          cantidad: '200g salmón',
        ),

        // Día 6
        Alimento(
          dia: 6,
          horario: 'Desayuno',
          alimento: 'Avena con proteína y banana',
          cantidad: '1 tazón + 1 scoop',
        ),
        Alimento(
          dia: 6,
          horario: 'Almuerzo',
          alimento: 'Pechuga de pavo con quinoa',
          cantidad: '250g pavo + 150g quinoa',
        ),
        Alimento(
          dia: 6,
          horario: 'Merienda',
          alimento: 'Yogur griego con frutas',
          cantidad: '200g yogur',
        ),
        Alimento(
          dia: 6,
          horario: 'Cena',
          alimento: 'Atún con vegetales al vapor',
          cantidad: '200g atún',
        ),

        // Día 7
        Alimento(
          dia: 7,
          horario: 'Desayuno',
          alimento: 'Tortilla con vegetales',
          cantidad: '5 claras + 2 huevos',
        ),
        Alimento(
          dia: 7,
          horario: 'Almuerzo',
          alimento: 'Pollo con arroz integral',
          cantidad: '250g pollo + 150g arroz',
        ),
        Alimento(
          dia: 7,
          horario: 'Merienda',
          alimento: 'Batido post-entreno',
          cantidad: '1 scoop + 1 banana',
        ),
        Alimento(
          dia: 7,
          horario: 'Cena',
          alimento: 'Pescado con ensalada verde',
          cantidad: '200g pescado',
        ),
      ],
    ),
  ];

  @override
  Future<List<Rutina>> obtenerRutinas() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return _rutinas;
  }

  @override
  Future<void> marcarDiaCompletado(
    String rutinaId,
    int dia,
    bool completada,
  ) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));

    // Buscar la rutina por ID
    final rutina = _rutinas.firstWhere(
      (r) => r.id == rutinaId,
      orElse: () => throw Exception('Rutina no encontrada'),
    );

    // Marcar todos los alimentos del día como completados
    for (final alimento in rutina.alimentos) {
      if (alimento.dia == dia) {
        alimento.completada = completada;
      }
    }
  }
}
