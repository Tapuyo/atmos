import 'dart:io';
class AdMobService{
    String getAdMobAppID(){
        if(Platform.isAndroid){
            return 'ca-app-pub-1156390496952979~9504024818';
        }else if(Platform.isIOS){
            return 'ca-app-pub-1156390496952979~9504024818';
        }
        return null;
    }
    String getBannerID(){
        if(Platform.isAndroid){
            return 'ca-app-pub-1156390496952979/1733346008';
        }else if(Platform.isIOS){
            return 'ca-app-pub-1156390496952979/1733346008';
        }
        return null;
    }
}