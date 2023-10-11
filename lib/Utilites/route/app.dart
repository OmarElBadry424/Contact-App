
import 'package:flutter/material.dart';

import 'route.dart';
import '../../Screen/splash.dart';

Route? onGenerateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){
    case AppRoute.splashScreen :
      return MaterialPageRoute(builder: (_)=>const SplashScreen() );

  }

}