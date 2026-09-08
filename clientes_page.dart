import 'package:flutter/material.dart';

import 'models/cliente.dart';

/// Pantalla que RECIBE la lista de clientes registrados y los muestra en una
/// tabla (`DataTable`).
///
/// El almacenamiento es temporal: la lista vive en memoria mientras la app
/// está abierta. Más adelante se puede reemplazar por una consulta a una base
/// de datos (por ejemplo MySQL) sin cambiar esta vista.
class ClientesPage extends StatelessWidget {
  const ClientesPage({super.key, required this.clientes});

  /// Lista de clientes a mostrar. Se recibe por el constructor desde el
  /// formulario (paso de datos entre pantallas).
  final List<Cliente> clientes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Clientes registrados (${clientes.length})'),
      ),
      body: clientes.isEmpty
          // Mensaje amable cuando todavía no hay ningún cliente.
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Aún no hay clientes registrados.\n'
                  'Vuelve al formulario y agrega el primero.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          // Doble scroll (vertical + horizontal) para que la tabla ancha
          // se pueda desplazar y no provoque overflow en pantallas pequeñas.
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('DNI')),
                    DataColumn(label: Text('Apellidos')),
                    DataColumn(label: Text('Nombres')),
                    DataColumn(label: Text('Celular')),
                    DataColumn(label: Text('Correo')),
                    DataColumn(label: Text('Nacionalidad')),
                    DataColumn(label: Text('Estado civil')),
                    DataColumn(label: Text('F. nacimiento')),
                    DataColumn(label: Text('Años exp.'), numeric: true),
                  ],
                  rows: clientes
                      .map(
                        (c) => DataRow(
                          cells: [
                            DataCell(Text(c.dni)),
                            DataCell(Text(c.apellidos)),
                            DataCell(Text(c.nombres)),
                            DataCell(Text(c.celular)),
                            DataCell(Text(c.correo)),
                            DataCell(Text(c.nacionalidad)),
                            DataCell(Text(c.estadoCivil)),
                            DataCell(Text(c.fechaNacimientoTexto)),
                            DataCell(Text('${c.aniosExperiencia}')),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }
}
