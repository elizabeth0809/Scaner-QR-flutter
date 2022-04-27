import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:qr_reader/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String tipoSeleccionado = 'http';

  Future<ScanModel> nuevoScan(String valor) async {
    final nuevoScan = new ScanModel(valor: valor);
    //esto regresa el id del registro insertado, lo cual metera en el nuevo id
    final id = await DBProvider.db.nuevoScan(nuevoScan);
    //Asignar el id de la base de datos al modelo
    nuevoScan.id = id;
    //esto inserta al nuevoScan
    this.scans.add(nuevoScan);
    //un condicional para insertar el registro solo si es del mismo tipo
    if (this.tipoSeleccionado == nuevoScan.tipo) {
      this.scans.add(nuevoScan);
      //esto notifica a cualquier widget sobre el cambio
      notifyListeners();
    }
    return nuevoScan;
  }

  cargarScans() async {
//esto regresa un listado de scans
    final scans = await DBProvider.db.getTodosLosScans();
    //crear un nuevo listado de scans
    this.scans = [...scans];
    //actualizar pantallas
    notifyListeners();
  }

  cargarScanPorTipo(String tipo) async {
//esto regresa un listado de scans
    final scans = await DBProvider.db.getScansPorTipo(tipo);
    //crear un nuevo listado de scans
    this.scans = [...scans];
    //esto se puede saber el tipo seleccionado
    this.tipoSeleccionado = tipo;
    //actualizar pantallas
    notifyListeners();
  }

  borrarTodos() async {
    await DBProvider.db.deleteAllScan();
    this.scans = [];
    notifyListeners();
  }

  borrarScanPorId(int id) async {
    await DBProvider.db.deleteScan(id);

    notifyListeners();
  }
}
