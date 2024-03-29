import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:citasnuevo/DatosAplicacion/Conversacion.dart';
import 'package:citasnuevo/DatosAplicacion/PerfilesUsuarios.dart';
import 'package:citasnuevo/DatosAplicacion/Usuario.dart';
import 'package:citasnuevo/DatosAplicacion/Valoraciones.dart';
import 'package:citasnuevo/DatosAplicacion/actividad.dart';
import 'package:citasnuevo/InterfazUsuario/Actividades/Pantalla_Actividades.dart';
import 'package:citasnuevo/InterfazUsuario/Gente/people_screen.dart';


import 'package:citasnuevo/InterfazUsuario/Busqueda/search_screen.dart';
import 'package:citasnuevo/InterfazUsuario/Social/social_screen.dart';

import 'package:citasnuevo/InterfazUsuario/Directo/live_screen.dart';
import 'package:citasnuevo/InterfazUsuario/Social/social_screen.dart';

import 'package:citasnuevo/main.dart';


import 'package:flutter_screenutil/flutter_screenutil.dart';

class starter_app extends State<start> {
  static final id = 'starter_app';
  void initState() {
    super.initState();
  
    WidgetsFlutterBinding.ensureInitialized();
  }

  int page_index = 0;
  final tabs = [pantalla(), people(), live(), search_screen(), social_screen()];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return starter_app();
  }

  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1440, height: 3120, allowFontScaling: true);
    // TODO: implement build
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Usuario()),
        ChangeNotifierProvider(create: (_) => Actividad()),
        ChangeNotifierProvider(create: (_) => Perfiles()),
        ChangeNotifierProvider(create: (_)=>Valoraciones()),
        ChangeNotifierProvider(create: (_)=>Conversacion.Instancia()),


      ],
      child: MaterialApp(

          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
              highlightColor: Colors.transparent,
              tabBarTheme: TabBarTheme(

                unselectedLabelStyle: TextStyle(fontSize: ScreenUtil().setSp(50)),
                  labelColor: Colors.green,
                  unselectedLabelColor: Colors.black87,
                  labelStyle: TextStyle(fontSize: ScreenUtil().setSp(50))),

              primaryColor: Colors.pinkAccent,
              accentColor: Colors.white),
          home: Scaffold(

            resizeToAvoidBottomPadding: false,
            backgroundColor: Color.fromRGBO(255, 78, 132, 100),

            body: tabs[page_index],

            //***************************************************************************************Barra Baja
            bottomNavigationBar: BottomNavigationBar(

              iconSize: ScreenUtil().setSp(50),
              unselectedLabelStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(50),
                  fontStyle: FontStyle.italic,
                  color: Colors.black87),
              selectedLabelStyle: TextStyle(
                  fontSize: ScreenUtil().setSp(60),
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              selectedIconTheme: IconThemeData(color: Colors.white, size: 25),
              selectedItemColor: Colors.white,
              currentIndex: page_index,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color.fromRGBO(255, 78, 132, 100),
              elevation: 0.0,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,size: ScreenUtil().setSp(100)
                  ),
                  title: new Text(
                    "",
                    style: TextStyle( fontSize: ScreenUtil().setSp(0),),
                  ),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.people,size: ScreenUtil().setSp(100)
                    ),
                    title: new Text(
                      "",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(0),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(
                      LineAwesomeIcons.heart,size: ScreenUtil().setSp(100),
                    ),
                    title: new Text(
                      "",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(0),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    backgroundColor: Colors.white),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,size: ScreenUtil().setSp(100)
                    ),
                    title: new Text(
                      "",
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(0),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    backgroundColor: Colors.white),
              ],
              onTap: (index) {
                setState(() {
                  page_index = index;
                });
              },
            ),
          )),
    );
  }
}
