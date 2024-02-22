import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_app/Cutom_widget/custom_widgets.dart';

class WallpaperDetailPage extends StatefulWidget {
  String imgUrl;

  WallpaperDetailPage({required this.imgUrl});

  @override
  State<WallpaperDetailPage> createState() => _WallpaperDetailPageState();
}

class _WallpaperDetailPageState extends State<WallpaperDetailPage> {
  double? mWidth;

  double? mHeight;

  @override
  Widget build(BuildContext context) {
    mWidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.imgUrl), fit: BoxFit.fitHeight)),
          ),
          Positioned(
              top: 60,
              left: 25,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(Icons.arrow_back_outlined,size: 28,),
                ),
              )),

          // -----------------Choose user Preference work-----------------
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(21.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // ------------- Set Download Wallpaper Work----------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          downloadWallpaper();
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Icon(Icons.download,color: Colors.white,size: 28,),
                        ),
                      ),
                      SizedBox(height: 6,),
                      Text("Save",style: TextStyle(color: Colors.white),)
                    ],
                  ),
                  SizedBox(width: 25,),

                  // ------------- set Apply Wallpaper Work-------------------
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          setWallpaper();
                        },
                        child: Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: Icon(Icons.brush_sharp,color: Colors.white,size: 28,),
                        ),

                      ),
                      SizedBox(height: 6,),
                      Text("Apply",style: TextStyle(color: Colors.white),)
                    ],
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void downloadWallpaper(){
    GallerySaver.saveImage(widget.imgUrl).then((value) {
      CustomToast().toastMessage(msg: 'Image is saved');
    });
  }

  void setWallpaper()async{

    var downloadStream = Wallpaper.imageDownloadProgress(widget.imgUrl);
    downloadStream.listen((event) {
      // ye humko download ka percentage dega
      print(event.toString());
    },onDone: ()async{
      print('wallpaper download in cache..');


      // -------------------use AlertDialog to set Wallpaper---------------------
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Choose your Preference"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IConText(title: "Home Screen", icon: Icons.home,onTab: ()async{
                    var check = await Wallpaper.homeScreen(
                        width: mWidth!,
                        height: mHeight!,
                        options: RequestSizeOptions.RESIZE_FIT
                    );
                    CustomToast().toastMessage(msg: check);
                    Navigator.pop(context);
                  }),
                  IConText(title: "Lock Screen", icon: Icons.lock,onTab: ()async{
                    var check = await Wallpaper.lockScreen(
                        width: mWidth!,
                        height: mHeight!,
                        options: RequestSizeOptions.RESIZE_FIT
                    );
                    CustomToast().toastMessage(msg: check);
                    Navigator.pop(context);
                  }),
                ],
              ),
              actions: [
                ElevatedButton(
                    onPressed: (){Navigator.pop(context);},
                    child: Text("Cancel")
                )
              ],
            );
          },
      );


    },onError: (e){
      print('Error: $e');
    }
    );
  }

  // ---------------------Custom Icon Text---------------------------------
  Widget IConText({required String title,required IconData icon,required VoidCallback onTab}){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTab,
          child: Container(
            margin: EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)
            ),
            child: Icon(icon,size: 40,),
          ),
        ),
        Text(title,style: TextStyle(fontSize: 14),)
      ],
    );
  }

}