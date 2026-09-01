# 📋 Catálogo de Controles de Formulario en Flutter

> **Proyecto:** `appinicial` · **Archivo principal:** `lib/main.dart` · **Framework:** Flutter (Material 3)

Formulario de ejemplo que reúne los principales controles de Flutter,
organizados por bloques, comentados y con un diseño limpio basado en tarjetas.

---

## 📑 Índice

- [Introducción](#-introducción)
- [Estructura general (distribución)](#-estructura-general-distribución)
- [Bloque 1 — Datos personales](#-bloque-1--datos-personales-campos-de-texto)
- [Bloque 2 — Preferencias](#-bloque-2--preferencias-selección)
- [Bloque 3 — Opciones](#-bloque-3--opciones-booleanas-y-radio)
- [Bloque 4 — Valores y fechas](#-bloque-4--valores-y-fechas)
- [Bloque 5 — Botones de acción](#-bloque-5--botones-de-acción)
- [Gestión de estado](#-gestión-de-estado)
- [Cambios en `pubspec.yaml`](#-cambios-en-pubspecyaml)
- [Código completo de `lib/main.dart`](#-código-completo-de-libmaindart)
- [Cómo ejecutar](#-cómo-ejecutar)

---

## 🧭 Introducción

Este documento describe **bloque por bloque** todos los controles incluidos en
la pantalla `FormularioPage` (`lib/main.dart`). El formulario usa únicamente
widgets del paquete **Material** que trae Flutter por defecto, por lo que
**no requiere dependencias externas**.

Cada bloque agrupa controles relacionados dentro de una tarjeta (`Card`)
mediante el widget auxiliar `_Seccion`, lo que da estructura visual y evita
repetir contenedores.

---

## 🏗️ Estructura general (distribución)

Jerarquía de layout:

```text
MaterialApp
└─ Scaffold
   ├─ AppBar (título centrado)
   └─ Align (topCenter)
      └─ ConstrainedBox (maxWidth: 480)   ← limita ancho en web/desktop
         └─ SingleChildScrollView          ← evita overflow con teclado
            └─ Form (key: _formKey)
               └─ Column (crossAxisAlignment: stretch)
                  ├─ _Seccion "Datos personales"
                  ├─ _Seccion "Preferencias"
                  ├─ _Seccion "Opciones"
                  ├─ _Seccion "Valores y fechas"
                  └─ Row (botones de acción)
```

**Widgets de layout utilizados:**

| Widget | Función en el formulario |
|---|---|
| `ConstrainedBox` | Limita el ancho máximo (480 px) para que los campos no se estiren en pantallas grandes. |
| `SingleChildScrollView` | Permite desplazamiento vertical; evita *overflow* con el teclado abierto. |
| `Column` | Apila los controles verticalmente. Con `stretch` cada hijo ocupa todo el ancho. |
| `Row` + `Expanded` | Distribuye elementos en horizontal repartiendo el espacio (fecha/hora, botones). |
| `Wrap` | Coloca los chips en fila y salta de línea automáticamente. |
| `SizedBox` | Separador de espaciado fijo entre controles. |
| `Card` (vía `_Seccion`) | Agrupa visualmente cada bloque con título. |

---

## 🧑 Bloque 1 — Datos personales (campos de texto)

Controles basados en `TextFormField`.

| Control | Propiedad clave | Descripción |
|---|---|---|
| Nombre completo | `validator` | Campo de texto simple. Valida que no esté vacío. `prefixIcon` de persona. |
| Correo electrónico | `keyboardType: emailAddress` | Teclado optimizado para email. Valida el formato con expresión regular. |
| Contraseña | `obscureText` | Oculta el texto. El `suffixIcon` (`IconButton`) alterna la visibilidad. Mínimo 6 caracteres. |
| Comentario | `maxLines: 3` / `maxLength: 200` | Área de texto multilínea con contador de caracteres. |

**Notas de diseño**

- `textInputAction: TextInputAction.next` para saltar al siguiente campo desde el teclado.
- La decoración común (borde, `filled`) se define una sola vez en el tema global (`inputDecorationTheme`).

---

## ⚙️ Bloque 2 — Preferencias (selección)

| Control | Tipo de selección | Descripción |
|---|---|---|
| `DropdownButtonFormField` | Única | Lista desplegable de países. Integra validación como cualquier campo. |
| `SegmentedButton` | Única | Alterna entre planes (Básico / Pro / Premium) al estilo *toggle*. |
| `FilterChip` (en `Wrap`) | Múltiple | Conjunto de intereses; cada chip se activa/desactiva. Se almacenan en un `Set<String>`. |

---

## ✅ Bloque 3 — Opciones (booleanas y radio)

| Control | Estado | Descripción |
|---|---|---|
| `RadioListTile` | `String` (grupo) | Selección única dentro de un grupo (Género). Comparten `groupValue`. |
| `SwitchListTile` | `bool` | Interruptor on/off con etiqueta (notificaciones). |
| `CheckboxListTile` | `bool` | Casilla de verificación con etiqueta (aceptar términos). Se comprueba al enviar. |

---

## 📊 Bloque 4 — Valores y fechas

| Control | Tipo de dato | Descripción |
|---|---|---|
| `Slider` | `double` | Valor continuo (experiencia 0–10) con `divisions` para pasos discretos. |
| `RangeSlider` | `RangeValues` | Selección de un rango (precio mínimo y máximo). |
| `showDatePicker` | `DateTime?` | Diálogo nativo de fecha, lanzado desde un `OutlinedButton.icon`. |
| `showTimePicker` | `TimeOfDay?` | Diálogo nativo de hora, lanzado desde un `OutlinedButton.icon`. |

> Fecha y hora se colocan en un `Row` con dos `Expanded` para repartir el ancho al 50 %.

---

## 🔘 Bloque 5 — Botones de acción

| Control | Jerarquía | Descripción |
|---|---|---|
| `TextButton` | Secundaria | *Limpiar*: reinicia el formulario con `_formKey.currentState.reset()`. |
| `ElevatedButton.icon` | Primaria | *Enviar*: valida, comprueba los términos y muestra un `SnackBar`. |

> Ambos van dentro de un `Row`; el botón principal usa `flex: 2` para ocupar más espacio.

---

## 🧠 Gestión de estado

- La pantalla es un `StatefulWidget` porque cada control guarda y actualiza su valor con `setState`.
- Los campos de texto usan `TextEditingController`, liberados en `dispose()` para evitar fugas de memoria.
- La validación se centraliza con `GlobalKey<FormState>` y la función `_enviar()`.

---

## 📦 Cambios en `pubspec.yaml`

**No se requieren dependencias adicionales.** El formulario solo usa widgets de
Material, disponibles al importar `package:flutter/material.dart`.

El único requisito es que `uses-material-design` esté activo (para los iconos).
El `pubspec.yaml` actual ya lo cumple:

```yaml
name: appinicial
description: "A new Flutter project."
publish_to: 'none'
version: 0.1.0+1

environment:
  sdk: ^3.13.0

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true   # ← necesario para los iconos
```

Si en el futuro añades controles que sí necesiten paquetes externos, estos
serían los cambios típicos (ejemplos):

```yaml
dependencies:
  flutter:
    sdk: flutter
  intl: ^0.19.0            # formateo avanzado de fechas
  image_picker: ^1.1.2     # seleccionar imágenes (cámara/galería)
  file_picker: ^8.0.0      # seleccionar archivos
```

Tras editar el `pubspec.yaml` hay que ejecutar:

```bash
flutter pub get
```

---

## 💻 Código completo de `lib/main.dart`

<details>
<summary><strong>Mostrar / ocultar código completo</strong></summary>

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MainApp());

/// Widget raíz de la aplicación.
///
/// Define el tema global (Material 3) y la pantalla inicial.
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Controles',
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
      home: const FormularioPage(),
    );
  }
}

/// Página que contiene el formulario. Es Stateful porque cada control
/// (checkbox, switch, slider, etc.) necesita guardar y actualizar su valor.
class FormularioPage extends StatefulWidget {
  const FormularioPage({super.key});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  // Clave global que identifica el Form y permite validarlo/guardarlo.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ---- Controladores de los campos de texto ----
  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _correoCtrl = TextEditingController();
  final TextEditingController _passCtrl = TextEditingController();
  final TextEditingController _comentarioCtrl = TextEditingController();

  // ---- Estado de los demás controles ----
  bool _ocultarPass = true; // Muestra/oculta la contraseña.
  String? _pais; // Valor seleccionado en el Dropdown.
  bool _aceptaTerminos = false; // Checkbox.
  bool _recibirNotificaciones = true; // Switch.
  String _genero = 'M'; // Grupo de RadioListTile.
  double _experiencia = 3; // Slider (0..10).
  RangeValues _rangoPrecio = const RangeValues(20, 80); // RangeSlider.
  DateTime? _fecha; // Resultado de showDatePicker.
  TimeOfDay? _hora; // Resultado de showTimePicker.
  final Set<String> _intereses = <String>{}; // FilterChips (multi-selección).
  String _plan = 'basico'; // SegmentedButton (selección única).

  final List<String> _paises = const ['México', 'Colombia', 'Perú', 'España'];
  final List<String> _todosLosIntereses = const [
    'Flutter',
    'Backend',
    'UI/UX',
    'IA',
  ];

  @override
  void dispose() {
    // Siempre liberar los controladores para evitar fugas de memoria.
    _nombreCtrl.dispose();
    _correoCtrl.dispose();
    _passCtrl.dispose();
    _comentarioCtrl.dispose();
    super.dispose();
  }

  /// Abre el selector de fecha nativo y guarda el resultado.
  Future<void> _seleccionarFecha() async {
    final DateTime? elegida = await showDatePicker(
      context: context,
      initialDate: _fecha ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (elegida != null) setState(() => _fecha = elegida);
  }

  /// Abre el selector de hora nativo y guarda el resultado.
  Future<void> _seleccionarHora() async {
    final TimeOfDay? elegida = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
    );
    if (elegida != null) setState(() => _hora = elegida);
  }

  /// Valida el formulario y muestra un aviso con el resultado.
  void _enviar() {
    if (_formKey.currentState!.validate()) {
      if (!_aceptaTerminos) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes aceptar los términos.')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulario enviado correctamente ✅')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Catálogo de Controles'),
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
                  // SECCIÓN 1: CAMPOS DE TEXTO
                  // ============================================================
                  _Seccion(
                    titulo: 'Datos personales',
                    children: [
                      // TextFormField simple con validación de obligatorio.
                      TextFormField(
                        controller: _nombreCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nombre completo',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Ingresa tu nombre' : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo de correo: teclado optimizado para email
                      // y validación con expresión regular.
                      TextFormField(
                        controller: _correoCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Correo electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ingresa tu correo';
                          final regex = RegExp(r'^[\w.\-]+@[\w\-]+\.[\w.\-]+$');
                          return regex.hasMatch(v) ? null : 'Correo no válido';
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo de contraseña: obscureText la oculta y el
                      // suffixIcon permite alternar su visibilidad.
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _ocultarPass,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_ocultarPass
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => _ocultarPass = !_ocultarPass),
                          ),
                        ),
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Mínimo 6 caracteres'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo multilínea: maxLines > 1 lo convierte en un
                      // área de texto para comentarios largos.
                      TextFormField(
                        controller: _comentarioCtrl,
                        maxLines: 3,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          labelText: 'Comentario',
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),

                  // ============================================================
                  // SECCIÓN 2: SELECCIÓN
                  // ============================================================
                  _Seccion(
                    titulo: 'Preferencias',
                    children: [
                      // Dropdown: lista desplegable de opción única.
                      DropdownButtonFormField<String>(
                        initialValue: _pais,
                        decoration: const InputDecoration(
                          labelText: 'País',
                          prefixIcon: Icon(Icons.public),
                        ),
                        items: _paises
                            .map((p) => DropdownMenuItem(
                                  value: p,
                                  child: Text(p),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _pais = v),
                        validator: (v) => v == null ? 'Selecciona un país' : null,
                      ),
                      const SizedBox(height: 20),

                      // SegmentedButton: alterna entre opciones mutuamente
                      // excluyentes (estilo pestañas/toggle).
                      const Text('Plan de suscripción'),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'basico', label: Text('Básico')),
                          ButtonSegment(value: 'pro', label: Text('Pro')),
                          ButtonSegment(value: 'premium', label: Text('Premium')),
                        ],
                        selected: {_plan},
                        onSelectionChanged: (s) =>
                            setState(() => _plan = s.first),
                      ),
                      const SizedBox(height: 20),

                      // FilterChips: selección múltiple compacta.
                      const Text('Intereses'),
                      const SizedBox(height: 8),
                      Wrap(
                        // Wrap coloca los chips en fila y salta de línea
                        // automáticamente cuando no caben.
                        spacing: 8,
                        children: _todosLosIntereses.map((interes) {
                          final sel = _intereses.contains(interes);
                          return FilterChip(
                            label: Text(interes),
                            selected: sel,
                            onSelected: (v) => setState(() {
                              v
                                  ? _intereses.add(interes)
                                  : _intereses.remove(interes);
                            }),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  // ============================================================
                  // SECCIÓN 3: OPCIONES BOOLEANAS Y RADIO
                  // ============================================================
                  _Seccion(
                    titulo: 'Opciones',
                    children: [
                      // RadioListTile: elige UNA opción de un grupo.
                      const Text('Género'),
                      RadioListTile<String>(
                        title: const Text('Masculino'),
                        value: 'M',
                        groupValue: _genero,
                        onChanged: (v) => setState(() => _genero = v!),
                      ),
                      RadioListTile<String>(
                        title: const Text('Femenino'),
                        value: 'F',
                        groupValue: _genero,
                        onChanged: (v) => setState(() => _genero = v!),
                      ),
                      const Divider(),

                      // SwitchListTile: interruptor on/off con etiqueta.
                      SwitchListTile(
                        title: const Text('Recibir notificaciones'),
                        value: _recibirNotificaciones,
                        onChanged: (v) =>
                            setState(() => _recibirNotificaciones = v),
                      ),

                      // CheckboxListTile: casilla de verificación con etiqueta.
                      CheckboxListTile(
                        title: const Text('Acepto los términos y condiciones'),
                        value: _aceptaTerminos,
                        onChanged: (v) =>
                            setState(() => _aceptaTerminos = v ?? false),
                      ),
                    ],
                  ),

                  // ============================================================
                  // SECCIÓN 4: RANGOS Y FECHAS
                  // ============================================================
                  _Seccion(
                    titulo: 'Valores y fechas',
                    children: [
                      // Slider: valor continuo dentro de un rango.
                      Text('Años de experiencia: ${_experiencia.round()}'),
                      Slider(
                        value: _experiencia,
                        min: 0,
                        max: 10,
                        divisions: 10, // Muestra pasos discretos.
                        label: _experiencia.round().toString(),
                        onChanged: (v) => setState(() => _experiencia = v),
                      ),
                      const SizedBox(height: 12),

                      // RangeSlider: selecciona un rango (mínimo y máximo).
                      Text('Rango de precio: '
                          '\$${_rangoPrecio.start.round()} - '
                          '\$${_rangoPrecio.end.round()}'),
                      RangeSlider(
                        values: _rangoPrecio,
                        min: 0,
                        max: 100,
                        divisions: 20,
                        labels: RangeLabels(
                          '\$${_rangoPrecio.start.round()}',
                          '\$${_rangoPrecio.end.round()}',
                        ),
                        onChanged: (v) => setState(() => _rangoPrecio = v),
                      ),
                      const SizedBox(height: 12),

                      // Selectores de fecha y hora dispuestos en fila (Row).
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.calendar_today),
                              label: Text(_fecha == null
                                  ? 'Fecha'
                                  : '${_fecha!.day}/${_fecha!.month}/${_fecha!.year}'),
                              onPressed: _seleccionarFecha,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.access_time),
                              label: Text(
                                  _hora == null ? 'Hora' : _hora!.format(context)),
                              onPressed: _seleccionarHora,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ============================================================
                  // SECCIÓN 5: BOTONES DE ACCIÓN
                  // ============================================================
                  // Fila con los tres tipos de botón de Material.
                  Row(
                    children: [
                      // TextButton: acción secundaria, sin relleno.
                      Expanded(
                        child: TextButton(
                          onPressed: () => _formKey.currentState!.reset(),
                          child: const Text('Limpiar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // ElevatedButton: acción principal, con relieve.
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _enviar,
                          icon: const Icon(Icons.send),
                          label: const Text('Enviar'),
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

</details>

---

## ▶️ Cómo ejecutar

```bash
flutter pub get   # solo si modificaste pubspec.yaml
flutter run
```
