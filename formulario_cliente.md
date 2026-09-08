# `lib/main.dart`

Formulario de ingreso de clientes (Flutter · Material 3).

Captura los datos del cliente (DNI, apellidos, nombres, celular, correo,
nacionalidad, estado civil, fecha de nacimiento y años de experiencia),
los valida y los guarda en una lista temporal en memoria. Desde aquí se
navega a `ClientesPage`, que los muestra en una tabla (`DataTable`).

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'clientes_page.dart';
import 'models/cliente.dart';

void main() => runApp(const MainApp());

/// Widget raíz de la aplicación.
///
/// Define el tema global (Material 3) y la pantalla inicial.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Clientes',
      debugShowCheckedModeBanner: false,
      // Tema Material 3 generado a partir de un color semilla:
      // Flutter deriva automáticamente una paleta coherente (claros/oscuros).
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
        // Estilo por defecto para TODOS los campos de texto del formulario,
        // así no repetimos la decoración en cada uno.
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      home: const FormularioClientePage(),
    );
  }
}

/// Página con el formulario de ingreso de clientes. Es Stateful porque cada
/// control (dropdown, segmented button, slider, fecha…) guarda y actualiza
/// su valor, y porque mantenemos la lista temporal de clientes en memoria.
class FormularioClientePage extends StatefulWidget {
  const FormularioClientePage({super.key});

  @override
  State<FormularioClientePage> createState() => _FormularioClientePageState();
}

class _FormularioClientePageState extends State<FormularioClientePage> {
  // Clave global que identifica el Form y permite validarlo/guardarlo.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ---- Controladores de los campos de texto ----
  final TextEditingController _dniCtrl = TextEditingController();
  final TextEditingController _apellidosCtrl = TextEditingController();
  final TextEditingController _nombresCtrl = TextEditingController();
  final TextEditingController _celularCtrl = TextEditingController();
  final TextEditingController _correoCtrl = TextEditingController();

  // ---- Estado de los demás controles ----
  String? _nacionalidad; // Dropdown de países.
  String _estadoCivil = 'Soltero(a)'; // SegmentedButton (selección única).
  DateTime? _fechaNacimiento; // Resultado de showDatePicker.
  double _aniosExperiencia = 0; // Slider (0..40).

  /// Almacenamiento TEMPORAL en memoria. Aquí se acumulan los clientes
  /// registrados durante la sesión. En el futuro esta lista se reemplazaría
  /// por inserciones en una base de datos (por ejemplo MySQL).
  final List<Cliente> _clientes = <Cliente>[];

  // Lista de nacionalidades (países) para el desplegable.
  final List<String> _paises = const [
    'Perú',
    'México',
    'Colombia',
    'Argentina',
    'Chile',
    'Ecuador',
    'Bolivia',
    'Venezuela',
    'España',
    'Estados Unidos',
    'Brasil',
    'Otro',
  ];

  // Opciones del estado civil (SegmentedButton).
  final List<String> _estadosCiviles = const [
    'Soltero(a)',
    'Casado(a)',
    'Divorciado(a)',
    'Viudo(a)',
  ];

  @override
  void dispose() {
    // Siempre liberar los controladores para evitar fugas de memoria.
    _dniCtrl.dispose();
    _apellidosCtrl.dispose();
    _nombresCtrl.dispose();
    _celularCtrl.dispose();
    _correoCtrl.dispose();
    super.dispose();
  }

  /// Abre el selector de fecha nativo y guarda la fecha de nacimiento.
  Future<void> _seleccionarFechaNacimiento() async {
    final DateTime ahora = DateTime.now();
    final DateTime? elegida = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(ahora.year - 18),
      firstDate: DateTime(1900),
      lastDate: ahora, // No se puede nacer en el futuro.
      helpText: 'Selecciona la fecha de nacimiento',
    );
    if (elegida != null) setState(() => _fechaNacimiento = elegida);
  }

  /// Valida el formulario, arma el objeto Cliente y lo agrega a la lista.
  void _registrar() {
    // 1) Validaciones de los campos de texto y del dropdown.
    if (!_formKey.currentState!.validate()) return;

    // 2) La fecha se valida aparte porque no es un TextFormField.
    if (_fechaNacimiento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona la fecha de nacimiento.')),
      );
      return;
    }

    // 3) Construimos el cliente inmutable con los datos capturados.
    final Cliente cliente = Cliente(
      dni: _dniCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      nombres: _nombresCtrl.text.trim(),
      celular: _celularCtrl.text.trim(),
      correo: _correoCtrl.text.trim(),
      nacionalidad: _nacionalidad!,
      estadoCivil: _estadoCivil,
      fechaNacimiento: _fechaNacimiento!,
      aniosExperiencia: _aniosExperiencia.round(),
    );

    // 4) Lo guardamos en la lista temporal y limpiamos el formulario.
    setState(() {
      _clientes.add(cliente);
      _formKey.currentState!.reset();
      _dniCtrl.clear();
      _apellidosCtrl.clear();
      _nombresCtrl.clear();
      _celularCtrl.clear();
      _correoCtrl.clear();
      _nacionalidad = null;
      _estadoCivil = 'Soltero(a)';
      _fechaNacimiento = null;
      _aniosExperiencia = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cliente registrado ✅  (total: ${_clientes.length})',
        ),
      ),
    );
  }

  /// Navega a la pantalla que muestra la tabla de clientes registrados.
  void _verClientes() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ClientesPage(clientes: _clientes),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Registro de Clientes'),
        actions: [
          // Acceso rápido a la tabla, con un contador de clientes.
          IconButton(
            tooltip: 'Ver clientes',
            onPressed: _verClientes,
            icon: Badge(
              label: Text('${_clientes.length}'),
              isLabelVisible: _clientes.isNotEmpty,
              child: const Icon(Icons.table_rows),
            ),
          ),
        ],
      ),
      // SingleChildScrollView evita overflow cuando el teclado aparece
      // o cuando hay muchos controles que no caben en la pantalla.
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          // Limita el ancho en pantallas grandes (web/desktop) para que
          // los campos no queden desmesuradamente anchos.
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              // Column apila los controles verticalmente. stretch hace que
              // cada hijo ocupe todo el ancho disponible del formulario.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // ============================================================
                  // SECCIÓN 1: IDENTIFICACIÓN
                  // ============================================================
                  _Seccion(
                    titulo: 'Identificación',
                    children: [
                      // DNI: solo dígitos, exactamente 8 (formato Perú).
                      TextFormField(
                        controller: _dniCtrl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        maxLength: 8,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'DNI',
                          prefixIcon: Icon(Icons.badge_outlined),
                          counterText: '',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa el DNI';
                          if (v.length != 8) return 'El DNI debe tener 8 dígitos';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Apellidos.
                      TextFormField(
                        controller: _apellidosCtrl,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Apellidos',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ingresa los apellidos'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Nombres.
                      TextFormField(
                        controller: _nombresCtrl,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Nombres',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ingresa los nombres'
                            : null,
                      ),
                    ],
                  ),

                  // ============================================================
                  // SECCIÓN 2: CONTACTO
                  // ============================================================
                  _Seccion(
                    titulo: 'Contacto',
                    children: [
                      // Celular: solo dígitos, 9 (formato móvil Perú).
                      TextFormField(
                        controller: _celularCtrl,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        maxLength: 9,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Celular',
                          prefixIcon: Icon(Icons.phone_outlined),
                          counterText: '',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa el celular';
                          if (v.length != 9) {
                            return 'El celular debe tener 9 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Correo: teclado de email y validación con regex.
                      TextFormField(
                        controller: _correoCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa el correo';
                          final regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
                          return regex.hasMatch(v.trim())
                              ? null
                              : 'Correo no válido';
                        },
                      ),
                    ],
                  ),

                  // ============================================================
                  // SECCIÓN 3: DATOS ADICIONALES
                  // ============================================================
                  _Seccion(
                    titulo: 'Datos adicionales',
                    children: [
                      // Nacionalidad: lista desplegable (Dropdown) de países.
                      DropdownButtonFormField<String>(
                        initialValue: _nacionalidad,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Nacionalidad',
                          prefixIcon: Icon(Icons.public),
                        ),
                        items: _paises
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _nacionalidad = v),
                        validator: (v) =>
                            v == null ? 'Selecciona la nacionalidad' : null,
                      ),
                      const SizedBox(height: 20),

                      // Estado civil: SegmentedButton (opciones excluyentes).
                      const Text('Estado civil'),
                      const SizedBox(height: 8),
                      // El SegmentedButton no se ajusta solo al ancho, por eso
                      // permitimos scroll horizontal si las 4 opciones no caben.
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SegmentedButton<String>(
                          segments: _estadosCiviles
                              .map((e) => ButtonSegment(
                                    value: e,
                                    label: Text(e),
                                  ))
                              .toList(),
                          selected: {_estadoCivil},
                          onSelectionChanged: (s) =>
                              setState(() => _estadoCivil = s.first),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Fecha de nacimiento: botón que abre el calendario.
                      const Text('Fecha de nacimiento'),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _fechaNacimiento == null
                              ? 'Seleccionar fecha'
                              : '${_fechaNacimiento!.day.toString().padLeft(2, '0')}/'
                                  '${_fechaNacimiento!.month.toString().padLeft(2, '0')}/'
                                  '${_fechaNacimiento!.year}',
                        ),
                        onPressed: _seleccionarFechaNacimiento,
                      ),
                      const SizedBox(height: 20),

                      // Años de experiencia: Slider (0 a 40).
                      Text('Años de experiencia: '
                          '${_aniosExperiencia.round()}'),
                      Slider(
                        value: _aniosExperiencia,
                        min: 0,
                        max: 40,
                        divisions: 40, // Pasos discretos de 1 en 1.
                        label: _aniosExperiencia.round().toString(),
                        onChanged: (v) =>
                            setState(() => _aniosExperiencia = v),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ============================================================
                  // SECCIÓN 4: ACCIONES
                  // ============================================================
                  Row(
                    children: [
                      // Ver la tabla de clientes registrados.
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _verClientes,
                          icon: const Icon(Icons.table_rows),
                          label: const Text('Ver clientes'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Registrar el cliente actual (acción principal).
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _registrar,
                          icon: const Icon(Icons.person_add),
                          label: const Text('Registrar cliente'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget reutilizable que agrupa controles bajo un título dentro de una Card.
///
/// Sirve para dar estructura visual (secciones) y no repetir el mismo
/// contenedor una y otra vez en el formulario.
class _Seccion extends StatelessWidget {
  const _Seccion({required this.titulo, required this.children});

  final String titulo;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título de la sección con el estilo del tema.
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
```
