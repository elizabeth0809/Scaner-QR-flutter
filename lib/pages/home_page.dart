import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/db_provider.dart';
import 'package:qr_reader/providers/providers.dart';
import 'package:qr_reader/providers/ui_providers.dart';
import '../widgets/widgets.dart';
import 'pages.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Historial'),
        actions: [
          //boton para eliminar
          IconButton(
              onPressed: () {
                Provider.of<ScanListProvider>(context, listen: false)
                    .borrarTodos();
              },
              icon: Icon(Icons.delete_forever))
        ],
      ),
      body: _HomePagebody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerDocked, //con esto se centra el boton flotante
    );
  }
}

class _HomePagebody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //obtener el select menu del provider
    final uiProvider = Provider.of<UIProvider>(context);
    //con esto se cambia la seleccion del widget
    final currentIndex = uiProvider.selectedMenuOpt;
    //leer la base de datos
    //final tempScan = new ScanModel(valor: 'http://google.com');
    //esto mostraba en la terminal
    //DBProvider.db.deleteAllScan().then(print);
//usar el scanList Provider, listen es para que no se redibuje
    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);
    switch (currentIndex) {
      case 0:
        scanListProvider.cargarScanPorTipo('geo');
        return MapasPage();
      case 1:
        scanListProvider.cargarScanPorTipo('http');

        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
}
