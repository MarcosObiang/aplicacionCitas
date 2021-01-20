import 'dart:async';
import 'dart:core';

import 'dart:typed_data';

import 'dart:io' as Io;
import 'package:citasnuevo/DatosAplicacion/ControladorInicioSesion.dart';
import 'package:citasnuevo/DatosAplicacion/ControladorLocalizacion.dart';
import 'package:citasnuevo/DatosAplicacion/ControladorSanciones.dart';

import 'package:citasnuevo/DatosAplicacion/UtilidadesAplicacion/GeneradorCodigos.dart';
import 'package:citasnuevo/base_app.dart';
import 'package:ntp/ntp.dart';
import 'package:blurhash_dart/blurhash_dart.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


import 'package:network_image_to_byte/network_image_to_byte.dart';


class Usuario with ChangeNotifier {
  static Usuario esteUsuario;
  
   int creditosUsuario = 0;
  bool tieneHistorias = false;
  Map<String, Object> datosUsuario = new Map();
  List<File> _fotosPerfil = new List(6);
  List<File> fotosHistorias = new List(6);
  List<File> get fotosPerfil => _fotosPerfil;
  List<Map<String, dynamic>> listaDeHistoriasRed = new List(6);
  List<File> fotosUsuarioActualizar = new List();
  double latitud;
  double longitud;
  String geohash;
  Map<String, dynamic> posicion;
  int dia = 0;
  int mes = 0;
  int anio = 0;
  List<int> listaEdades = new List();
  int edadInicial = 18;
  int edadfinal;
  bool sexoMujer = false;
  int preferenciaSexual = 0;
  String idUsuario;
  String nombre;
  String alias;
  String clave;
  int orientacionSexual=0;
  List<dynamic>perfilesBloqueados=new List();
 
  String email;
  DateTime nacimiento;
  int edad = 0;

  DateTime fechaNacimiento;
  String observaciones;
  bool estaConectado = false;
  Map<String, dynamic> imagenUrl1 = new Map();
  Map<String, dynamic> imagenUrl2 = new Map();
  Map<String, dynamic> imagenUrl3 = new Map();
  Map<String, dynamic> imagenUrl4 = new Map();
  Map<String, dynamic> imagenUrl5 = new Map();
  Map<String, dynamic> imagenUrl6 = new Map();
  Map<String, String> formacion = new Map();
  Map<String, String> trabajo = new Map();
  double altura;
  int complexion = 0;
  int alcohol = 0;
  int tabaco = 0;
  int idiomas = 0;
  int mascotas = 0;
  int busco = 0;
  int hijos = 0;
  int zodiaco = 0;
  int vegetarianoOvegano = 0;
  int politica = 0;
  int religion = 0;
  int vivoCon = 0;
  int tiempoEstimadoRecompensa=0;
   Map<String, dynamic> usuario = Map();
  Map<String, dynamic> ajustesUSuario = new Map();
  Map<String, bool> gustosUsuario = Map();
  Map<String, dynamic> preguntasPersonales = Map();
  Map<String, dynamic> datosParaFiltrosUsuario = Map();
  StreamController<int> tiempoHastaRecompensa;
  int segundosRestantesRecompensa;
  int minutosRestantesVideoChat;
  String verificado="noVerificado";
  bool usuarioBloqueado;
  DateTime bloqueadoHasta;
  Map<String,dynamic> mapaSanciones;

    void contadorHastaRecompensa()async{
      tiempoHastaRecompensa= StreamController.broadcast();
    Timer flutterTimer;
    DateTime cacheTiempoAhora=await NTP.now();
    
 
    segundosRestantesRecompensa=tiempoEstimadoRecompensa-(cacheTiempoAhora.millisecondsSinceEpoch~/1000);
    flutterTimer=new Timer.periodic(Duration(seconds:1), (valor){
      

if(segundosRestantesRecompensa>0){
  segundosRestantesRecompensa-=1;
tiempoHastaRecompensa.add(segundosRestantesRecompensa);

        

    }
    if(segundosRestantesRecompensa<=0){
      flutterTimer.cancel();
     tiempoHastaRecompensa.close();
   
    }
    });


    

      
       
    

  }

   List<String> listaDeImagenesUsuario = [];

  List<String>orientacionesSexuales=[
    "",
"Heterosexual","Gay","Lesbiana","Bisexual","Asexual","Demisexual","Queer","Pansexual","Preguntame"
  ];

  int get getPreferenciaSexual => preferenciaSexual;

  set setPreferenciaSexual(int preferenciaSexual) {
    this.preferenciaSexual = preferenciaSexual;
    notifyListeners();
  }

  bool get getSexoMujer => sexoMujer;

  set setSexoMujer(bool sexoMujer) {
    this.sexoMujer = sexoMujer;
    notifyListeners();
  }

  void establecerEdades() {
    listaEdades.add(Usuario.esteUsuario.edad);
  }

  set fotosPerfil(List<File> value) {
    _fotosPerfil = value;
    notifyListeners();
  }
  int get getOrientacionSexual => orientacionSexual;

 set setOrientacionSexual(int orientacionSexual) { this.orientacionSexual = orientacionSexual;
 
 notifyListeners();
 }

  Future<void> descarGarImagenesUsuario(List<String> listaDeImagenes) async {
    Directory directorio = await getApplicationDocumentsDirectory();
    String directorioImagenes = directorio.path;

    for (int i = 0; i < listaDeImagenesUsuario.length; i++) {
      if (listaDeImagenesUsuario[i] != null) {
        Uint8List archivo = await networkImageToByte(listaDeImagenes[i]);
        String referenciaCompleta =
            "$directorioImagenes/${GeneradorCodigos.instancia.crearCodigo()}";
        Io.File puntero = new Io.File(referenciaCompleta);
        puntero.writeAsBytes(archivo);
        File imagenGuardada = File(referenciaCompleta);

        Usuario.esteUsuario.fotosUsuarioActualizar.add(imagenGuardada);
      } else {
        File archivoVacio;
        Usuario.esteUsuario.fotosUsuarioActualizar.add(archivoVacio);
      }
    }
  }

  void iniciarMapas() {
    imagenUrl1["Imagen"] = "";
    imagenUrl2["Imagen"] = "";
    imagenUrl3["Imagen"] = "";
    imagenUrl4["Imagen"] = "";
    imagenUrl5["Imagen"] = "";
    imagenUrl6["Imagen"] = "";
  }



  void cargarFiltrosPersonales() {
    esteUsuario.altura =
        esteUsuario.datosParaFiltrosUsuario["Altura"].toDouble();
    esteUsuario.complexion = esteUsuario.datosParaFiltrosUsuario["Complexion"];
    esteUsuario.tabaco = esteUsuario.datosParaFiltrosUsuario["Tabaco"];
    esteUsuario.alcohol = esteUsuario.datosParaFiltrosUsuario["Alcohol"];
    esteUsuario.mascotas = esteUsuario.datosParaFiltrosUsuario["Mascotas"];
    esteUsuario.busco = esteUsuario.datosParaFiltrosUsuario["Busco"];
    esteUsuario.hijos = esteUsuario.datosParaFiltrosUsuario["Hijos"];
    esteUsuario.politica = esteUsuario.datosParaFiltrosUsuario["Politca"];
    esteUsuario.vivoCon = esteUsuario.datosParaFiltrosUsuario["Que viva con"];
    esteUsuario.setOrientacionSexual = esteUsuario.datosParaFiltrosUsuario["orientacionSexual"];
  }

  final databaseReference = FirebaseFirestore.instance;
  static final dbRef = FirebaseFirestore.instance;

   Map<String, dynamic> imagenes = Map();
  Map<String, dynamic> imagenesHistorias = Map();
  void inicializarUsuario()async {
  
    mapaSanciones=datosUsuario["sancionado"];
  
    Timestamp temporalParaFecha;
    minutosRestantesVideoChat=datosUsuario["minutosVideo"];
    nombre = datosUsuario["Nombre"];
    tiempoEstimadoRecompensa=datosUsuario["siguienteRecompensa"];
    setPreferenciaSexual = datosUsuario["Citas con"];
     perfilesBloqueados=datosUsuario["bloqueados"];
    posicion = datosUsuario["posicion"];
    edad = datosUsuario["Edad"];
    setSexoMujer = datosUsuario["Sexo"];
    Map<String,dynamic> mapaVerificacion=datosUsuario["verificado"];
    
 




    verificado=mapaVerificacion["estadoVerificacion"];
    


    creditosUsuario = datosUsuario["creditos"];
    temporalParaFecha = datosUsuario["fechaNacimiento"];
    fechaNacimiento = temporalParaFecha.toDate();
    observaciones = datosUsuario["Descripcion"];
    datosParaFiltrosUsuario = datosUsuario["Filtros usuario"];
    
    cargarFiltrosPersonales();
    contadorHastaRecompensa();

    GeoPoint punto = posicion["geopoint"];
    geohash = posicion["geohash"];

    latitud = punto.latitude;
    longitud = punto.longitude;

    imagenUrl1 = datosUsuario["IMAGENPERFIL1"];
    imagenUrl2 = datosUsuario["IMAGENPERFIL2"];
    imagenUrl3 = datosUsuario["IMAGENPERFIL3"];
    imagenUrl4 = datosUsuario["IMAGENPERFIL4"];
    imagenUrl5 = datosUsuario["IMAGENPERFIL5"];
    imagenUrl6 = datosUsuario["IMAGENPERFIL6"];

      listaDeImagenesUsuario = [
    imagenUrl1["Imagen"],
    imagenUrl2["Imagen"],
    imagenUrl3["Imagen"],
    imagenUrl4["Imagen"],
    imagenUrl5["Imagen"],
    imagenUrl6["Imagen"],
  ];
    Usuario.esteUsuario
        .descarGarImagenesUsuario(Usuario.esteUsuario.listaDeImagenesUsuario)
        .then((value) {});

    ///Obtenemos los ajustes de la cuenta de usuario
    ///
    Map<String, dynamic> ajustes = datosUsuario["Ajustes"];
    ControladorLocalizacion.instancia.setMostrarmeEnHotty =
        ajustes["mostrarPerfil"];
    ControladorLocalizacion.instancia.setDiistanciaMaxima =
        ajustes["distanciaMaxima"].toDouble();
    ControladorLocalizacion.instancia.setEdadFinal =
        ajustes["edadFinal"].toDouble();
    ControladorLocalizacion.instancia.setEdadInicial =
        ajustes["edadInicial"].toDouble();
    ControladorLocalizacion.instancia.setVisualizarDistanciaEnMillas =
        ajustes["enMillas"];
    ControladorLocalizacion.instancia.mostrarMujeres =
        ajustes["mostrarMujeres"];
    ControladorLocalizacion.instancia.activadorEdadesDeseadas =
        new List<int>.from(ajustes["rangoEdades"]);
  }

  Uint8List rgbRaw(File archivo){
   
          Uint8List bytesImagen=  esteUsuario.fotosPerfil[0].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl1["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
     
});
});

return rgbaList;
  }

  Future<void> establecerUsuario() async {
    establecerEdades();

    var geoposicion =
        await ControladorLocalizacion.instancia.obtenerLocalizacionPorPrimeraVez()
            .catchError((onError) =>
                print("Hubo un error con la localizacion: $onError"));

    ///
    ///
    ///Datos principales del usuario
    ///
    ///
   usuario["verificado"]={"estadoVerificacion":"noProcesado","verificacionNotificada":false};
   
    ajustesUSuario["mostrarPerfil"] =
        ControladorLocalizacion.instancia.mostrarmeEnHotty;
    ajustesUSuario["distanciaMaxima"] =
        ControladorLocalizacion.instancia.distanciaMaxima;
    ajustesUSuario["edadFinal"] =
        ControladorLocalizacion.instancia.getEdadFinal;
    ajustesUSuario["edadInicial"] =
        ControladorLocalizacion.instancia.getEdadInicial;
    ajustesUSuario["enMillas"] =
        ControladorLocalizacion.instancia.getVisualizarDistanciaEnMillas;
    ajustesUSuario["mostrarMujeres"] =
        ControladorLocalizacion.instancia.mostrarMujeres;
    ajustesUSuario["rangoEdades"] =
        ControladorLocalizacion.instancia.activadorEdadesDeseadas;

    usuario["Id"] = esteUsuario.idUsuario;
   await NTP.now().then((value){
 usuario["siguienteRecompensa"]=value.millisecondsSinceEpoch~/1000;
    });
    usuario["IMAGENPERFIL1"] = esteUsuario.imagenUrl1;
    usuario["IMAGENPERFIL2"] = esteUsuario.imagenUrl2;
    usuario["IMAGENPERFIL3"] = esteUsuario.imagenUrl3;
    usuario["IMAGENPERFIL4"] = esteUsuario.imagenUrl4;
    usuario["IMAGENPERFIL5"] = esteUsuario.imagenUrl5;
    usuario["IMAGENPERFIL6"] = esteUsuario.imagenUrl6;
    usuario["Nombre"] = esteUsuario.nombre;
    usuario["sancionado"]={"usuarioSancionado":false,"tiempoDeSancion":0,"finSancion":0,"causasSancion":[]};
   
    usuario["creditos"] = creditosUsuario;
    usuario["posicion"] = geoposicion.data;
    usuario["Email"] = esteUsuario.email;
    usuario["Edad"] = esteUsuario.edad;
    usuario["Sexo"] = esteUsuario.getSexoMujer;
    usuario["Edades"] = listaEdades;
    usuario["Ajustes"] = ajustesUSuario;

    ///
    ///
    /// Datos sobre el uso de la aplicacion
    ///
    ///
    ///
    usuario["Citas con"] = esteUsuario.getPreferenciaSexual;

    usuario["Descripcion"] = esteUsuario.observaciones;
    usuario["fechaNacimiento"] = esteUsuario.fechaNacimiento;

    ///
    ///
    ///
    /// Datos necesarios y mas especificos para coonocer mas al usuario
    ///
    ///
    ///
    ///

    esteUsuario.datosParaFiltrosUsuario["Altura"] = esteUsuario.altura ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Complexion"] =
        esteUsuario.complexion ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Tabaco"] = esteUsuario.tabaco ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Alcohol"] = esteUsuario.alcohol ?? 0;
  esteUsuario.datosParaFiltrosUsuario["orientacionSexual"]=esteUsuario.orientacionSexual??0;
    esteUsuario.datosParaFiltrosUsuario["Mascotas"] = esteUsuario.mascotas ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Busco"] = esteUsuario.busco ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Hijos"] = esteUsuario.hijos ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Vegetariano"] =
        esteUsuario.vegetarianoOvegano ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Politca"] = esteUsuario.politica ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Que viva con"] =
        esteUsuario.vivoCon ?? 0;

    usuario["Filtros usuario"] = esteUsuario.datosParaFiltrosUsuario;
  }



Future<void> establecerUsuarioEditado() async {
    establecerEdades();

    var geoposicion =
        await ControladorLocalizacion.instancia.obtenerLocalizacionPorPrimeraVez()
            .catchError((onError) =>
                print("Hubo un error con la localizacion: $onError"));

    ///
    ///
    ///Datos principales del usuario
    ///
    ///
   usuario["verificado"]=Usuario.esteUsuario.verificado;
   
    ajustesUSuario["mostrarPerfil"] =
        ControladorLocalizacion.instancia.mostrarmeEnHotty;
    ajustesUSuario["distanciaMaxima"] =
        ControladorLocalizacion.instancia.distanciaMaxima;
    ajustesUSuario["edadFinal"] =
        ControladorLocalizacion.instancia.getEdadFinal;
    ajustesUSuario["edadInicial"] =
        ControladorLocalizacion.instancia.getEdadInicial;
    ajustesUSuario["enMillas"] =
        ControladorLocalizacion.instancia.getVisualizarDistanciaEnMillas;
    ajustesUSuario["mostrarMujeres"] =
        ControladorLocalizacion.instancia.mostrarMujeres;
    ajustesUSuario["rangoEdades"] =
        ControladorLocalizacion.instancia.activadorEdadesDeseadas;


    usuario["IMAGENPERFIL1"] = esteUsuario.imagenUrl1;
    usuario["IMAGENPERFIL2"] = esteUsuario.imagenUrl2;
    usuario["IMAGENPERFIL3"] = esteUsuario.imagenUrl3;
    usuario["IMAGENPERFIL4"] = esteUsuario.imagenUrl4;
    usuario["IMAGENPERFIL5"] = esteUsuario.imagenUrl5;
    usuario["IMAGENPERFIL6"] = esteUsuario.imagenUrl6;

   

    usuario["posicion"] = geoposicion.data;
  

    
    usuario["Edades"] = listaEdades;
    usuario["Ajustes"] = ajustesUSuario;

    ///
    ///
    /// Datos sobre el uso de la aplicacion
    ///
    ///
    ///
    usuario["Citas con"] = esteUsuario.getPreferenciaSexual;

    usuario["Descripcion"] = esteUsuario.observaciones;


    ///
    ///
    ///
    /// Datos necesarios y mas especificos para coonocer mas al usuario
    ///
    ///
    ///
    ///

    esteUsuario.datosParaFiltrosUsuario["Altura"] = esteUsuario.altura ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Complexion"] =
        esteUsuario.complexion ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Tabaco"] = esteUsuario.tabaco ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Alcohol"] = esteUsuario.alcohol ?? 0;
  esteUsuario.datosParaFiltrosUsuario["orientacionSexual"]=esteUsuario.orientacionSexual??0;
    esteUsuario.datosParaFiltrosUsuario["Mascotas"] = esteUsuario.mascotas ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Busco"] = esteUsuario.busco ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Hijos"] = esteUsuario.hijos ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Vegetariano"] =
        esteUsuario.vegetarianoOvegano ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Politca"] = esteUsuario.politica ?? 0;
    esteUsuario.datosParaFiltrosUsuario["Que viva con"] =
        esteUsuario.vivoCon ?? 0;

    usuario["Filtros usuario"] = esteUsuario.datosParaFiltrosUsuario;
  }

  Future<void> subirImagenPerfil(String idUsuario) async {
    assert(imagenes != null);
    FirebaseStorage storage = FirebaseStorage.instance;
    StorageReference reference = storage.ref();
    DocumentReference referenciaUsuario =
        databaseReference.collection("usuarios").doc(idUsuario);


    DocumentReference referenciaValoracionesLocales = databaseReference
        .collection("usuarios")
        .doc(idUsuario)
        .collection("valoraciones")
        .doc("mediaPuntos");
    DocumentReference referenciaEstadoLLamadas = databaseReference
        .collection("usuarios")
        .doc(idUsuario)
        .collection("estadoLlamada")
        .doc("estadoLlamada");
         DocumentReference referenciaDenuncias = databaseReference
        .collection("expedientes")
        .doc(idUsuario);
        
    WriteBatch escrituraUsuario = databaseReference.batch();
    if (esteUsuario.fotosPerfil[0] != null) {
      String image1 = "$idUsuario/Perfil/imagenes/Image1.jpg";
      StorageReference referenciaImagen = reference.child(image1);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[0]);
          

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      esteUsuario.imagenUrl1["Imagen"] = url;
      Uint8List bytesImagen=  esteUsuario.fotosPerfil[0].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl1["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl1["altura"]=imagen.height;
    esteUsuario.imagenUrl1["ancho"]=imagen.width;
      print(url);
});
});
     
      
    
     
  
  

    }
    if (esteUsuario.fotosPerfil[1] != null) {
      String imagen2 = "$idUsuario/Perfil/imagenes/Image2.jpg";
      StorageReference referenciaImagen = reference.child(imagen2);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[1]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      esteUsuario.imagenUrl2["Imagen"] = url;
    
      
            Uint8List bytesImagen=  esteUsuario.fotosPerfil[1].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl2["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl2["altura"]=imagen.height;
    esteUsuario.imagenUrl2["ancho"]=imagen.width;
      print(url);
});
});
      print(url);
    }
    if (esteUsuario.fotosPerfil[2] != null) {
      String imagen3 = "$idUsuario/Perfil/imagenes/Image3.jpg";
      StorageReference referenciaImagen = reference.child(imagen3);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[2]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      esteUsuario.imagenUrl3["Imagen"] = url;
             Uint8List bytesImagen=  esteUsuario.fotosPerfil[2].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl3["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl3["altura"]=imagen.height;
    esteUsuario.imagenUrl3["ancho"]=imagen.width;
      print(url);
});
});
     
    }
    if (esteUsuario.fotosPerfil[3] != null) {
      String imagen4 = "$idUsuario/Perfil/imagenes/Image4.jpg";
      StorageReference referenciaImagen = reference.child(imagen4);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[3]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      esteUsuario.imagenUrl4["Imagen"] = url;

            Uint8List bytesImagen=  esteUsuario.fotosPerfil[3].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl4["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl4["altura"]=imagen.height;
    esteUsuario.imagenUrl4["ancho"]=imagen.width;
      print(url);
});
});
    }
    if (esteUsuario.fotosPerfil[4] != null) {
      String imagen5 = "$idUsuario/Perfil/imagenes/Image5.jpg";
      StorageReference imagenReferencia = reference.child(imagen5);
      StorageUploadTask uploadTask =
          imagenReferencia.putFile(esteUsuario.fotosPerfil[4]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      esteUsuario.imagenUrl5["Imagen"] = url;
        Uint8List bytesImagen=  esteUsuario.fotosPerfil[4].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl5["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl5["altura"]=imagen.height;
    esteUsuario.imagenUrl5["ancho"]=imagen.width;
      print(url);
});
});
    }
    if (esteUsuario.fotosPerfil[5] != null) {
      String imagen6 = "$idUsuario/Perfil/imagenes/Image6.jpg";
      StorageReference referenciaImagen = reference.child(imagen6);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[5]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      esteUsuario.imagenUrl6["Imagen"] = url;
             Uint8List bytesImagen=  esteUsuario.fotosPerfil[5].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl6["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
     esteUsuario.imagenUrl6["altura"]=imagen.height;
    esteUsuario.imagenUrl6["ancho"]=imagen.width;
      print(url);
});
});
    }
    await establecerUsuario().then((value) async {
      escrituraUsuario.set(referenciaUsuario, usuario);
      escrituraUsuario
          .set(referenciaEstadoLLamadas, {"Estado": "Desconectado"});
      escrituraUsuario.set(referenciaValoracionesLocales, {
        "mediaTotal": 0,
        "Valoracion": 5,
        "cantidadValoraciones": 0,
        "puntuacionTotal": 0
      });
      escrituraUsuario.set(referenciaDenuncias,{
        "descripcion":esteUsuario.observaciones,
        "vecesProcesado":0,
        "caducidadProcesado":0,
        "cantidadDenuncias":0,"denuncias":[],"imagenes":[
          esteUsuario.imagenUrl1["Imagen"],
           esteUsuario.imagenUrl2["Imagen"],
            esteUsuario.imagenUrl3["Imagen"],
             esteUsuario.imagenUrl4["Imagen"],
              esteUsuario.imagenUrl5["Imagen"],
               esteUsuario.imagenUrl6["Imagen"],

        ]


      });


      await escrituraUsuario.commit().catchError((onError) {
        print("Error al crear usuario: $onError");
      });
    });
  }

  Future<void> editarPerfilUsuario(String idUsuario) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Usuario.esteUsuario.fotosPerfil =
        Usuario.esteUsuario.fotosUsuarioActualizar;
    StorageReference reference = storage.ref();
    DocumentReference referenciaUsuario =
        databaseReference.collection("usuarios").doc(idUsuario);
             DocumentReference referenciaDenuncias = databaseReference
        .collection("expedientes")
        .doc(idUsuario);

    WriteBatch escrituraUsuario = databaseReference.batch();
    if (esteUsuario.fotosPerfil[0] != null) {
      String image1 = "$idUsuario/Perfil/imagenes/Image1.jpg";
      StorageReference referenciaImagen = reference.child(image1);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[0]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      esteUsuario.imagenUrl1["Imagen"] = url;
      Uint8List bytesImagen=  esteUsuario.fotosPerfil[0].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl1["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl1["altura"]=imagen.height;
    esteUsuario.imagenUrl1["ancho"]=imagen.width;
      print(url);
});
});
    }
    if (esteUsuario.fotosPerfil[1] != null) {
      String imagen2 = "$idUsuario/Perfil/imagenes/Image2.jpg";
      StorageReference referenciaImagen = reference.child(imagen2);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[1]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
          esteUsuario.imagenUrl2["Imagen"] = url;
      Uint8List bytesImagen=  esteUsuario.fotosPerfil[1].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl2["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl2["altura"]=imagen.height;
    esteUsuario.imagenUrl2["ancho"]=imagen.width;
      print(url);
});
});
    }
    if (esteUsuario.fotosPerfil[2] != null) {
      String imagen3 = "$idUsuario/Perfil/imagenes/Image3.jpg";
      StorageReference referenciaImagen = reference.child(imagen3);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[2]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
          esteUsuario.imagenUrl3["Imagen"] = url;
      Uint8List bytesImagen=  esteUsuario.fotosPerfil[2].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl3["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl3["altura"]=imagen.height;
    esteUsuario.imagenUrl3["ancho"]=imagen.width;
      print(url);
});
});
    }
    if (esteUsuario.fotosPerfil[3] != null) {
      String imagen4 = "$idUsuario/Perfil/imagenes/Image4.jpg";
      StorageReference referenciaImagen = reference.child(imagen4);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[3]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
            esteUsuario.imagenUrl4["Imagen"] = url;
      Uint8List bytesImagen=  esteUsuario.fotosPerfil[3].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl4["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl4["altura"]=imagen.height;
    esteUsuario.imagenUrl4["ancho"]=imagen.width;
      print(url);
});
});
    }
    if (esteUsuario.fotosPerfil[4] != null) {
      String imagen5 = "$idUsuario/Perfil/imagenes/Image5.jpg";
      StorageReference referenciaImagen = reference.child(imagen5);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[4]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
          esteUsuario.imagenUrl5["Imagen"] = url;
      Uint8List bytesImagen=  esteUsuario.fotosPerfil[4].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl5["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl5["altura"]=imagen.height;
    esteUsuario.imagenUrl5["ancho"]=imagen.width;
      print(url);
});
});
    }
    if (esteUsuario.fotosPerfil[5] != null) {
      String imagen6 = "$idUsuario/Perfil/imagenes/Image6.jpg";
      StorageReference referenciaImagen = reference.child(imagen6);
      StorageUploadTask uploadTask =
          referenciaImagen.putFile(esteUsuario.fotosPerfil[5]);

      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
           esteUsuario.imagenUrl5["Imagen"] = url;
      Uint8List bytesImagen=  esteUsuario.fotosPerfil[5].readAsBytesSync();
      Image memoria=Image.memory(bytesImagen);
      
      Uint8List rgbaList;
      Completer completer = Completer<ui.Image>();
      ImageStream stream=memoria.image.resolve(ImageConfiguration.empty);
       ImageStreamListener listener;
       listener=ImageStreamListener((frame,sync){
        ui.Image imageni=frame.image;
        completer.complete(imageni);
        stream.removeListener(listener);




      });

stream.addListener(listener);

      completer.future.then((imagen){
imagen.toByteData(format:ui.ImageByteFormat.rawRgba).then((valor){
  rgbaList=valor.buffer.asUint8List();
    esteUsuario.imagenUrl5["hash"]=encodeBlurHash(rgbaList,imagen.width,imagen.height,);
    esteUsuario.imagenUrl5["altura"]=imagen.height;
    esteUsuario.imagenUrl5["ancho"]=imagen.width;
      print(url);
});
});
    }
    await establecerUsuario();

    escrituraUsuario.update(referenciaUsuario, usuario);
       escrituraUsuario.update(referenciaDenuncias,{
        "descripcion":esteUsuario.observaciones,
       "imagenes":[
          esteUsuario.imagenUrl1["Imagen"],
           esteUsuario.imagenUrl2["Imagen"],
            esteUsuario.imagenUrl3["Imagen"],
             esteUsuario.imagenUrl4["Imagen"],
              esteUsuario.imagenUrl5["Imagen"],
               esteUsuario.imagenUrl6["Imagen"],

        ]


      });

    await escrituraUsuario.commit().catchError((onError) {
      print("Error al actualizar  usuario: $onError");
    });
  }



  static submit(BuildContext context) async {



    
    DocumentSnapshot val;
    FirebaseFirestore referencia = FirebaseFirestore.instance;

    print(esteUsuario.idUsuario);

    Usuario.esteUsuario
        .subirImagenPerfil(esteUsuario.idUsuario)
        .then((value) async {
      val = await referencia
          .collection("usuarios")
          .doc(esteUsuario.idUsuario)
          .get();
      esteUsuario.datosUsuario = val.data();
      if (Usuario.esteUsuario.datosUsuario != null) {
        ControladorInicioSesion.instancia
            .iniciarSesion(esteUsuario.idUsuario, context);
      }
    });
    print("SiguientePantalla");

    // Perfiles.perfilesCitas.obtenetPerfilesCitas();
  }

  void alerta() {
    notifyListeners();
  }

  int validadorFecha() {
    DateTime fechaTemporal;

    fechaTemporal = new DateTime(anio ?? 0, mes ?? 0, dia ?? 0, 10, 10);

    print("Construyendo fechas:::::::::.   $fechaTemporal");

    int dur = DateTime.now().difference(fechaTemporal).inDays;
    int data = dur ~/ 365;
    edad = data;
    Usuario.esteUsuario.fechaNacimiento = fechaTemporal;
    print(data);
    notifyListeners();

    return 0;
  }
}
