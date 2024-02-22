import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper_app/Screens/search_wallpaper_image.dart';
import 'package:wallpaper_app/Screens/wallpaper_detail_page.dart';
import '../bloc services/bloc/wallpaper_bloc.dart';
import '../constant/app_constant.dart';
import 'cat_wallpaper_page.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({Key? key}) : super(key: key);

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {

  @override
  void initState() {
    super.initState();

    context.read<WallpaperBloc>().add(GetTrendingWallpaper());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          //* Stack to take a Gradient Color
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xffE8D7DA),
                    Color(0xffA0D3D6),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //--------------- Wallpaper search box..-----------------
                    InkWell(
                      onTap : (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchWallpaperPage(colorTone: false),));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            color: const Color(0xffDBEBF1),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Find Wallpaper...',style: TextStyle(fontSize: 16,color: Colors.grey),),
                              Icon(Icons.image_search,color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),

                    //* Best if the Month Image
                    const Text('Best of the month',
                      style: TextStyle(
                        fontSize: 21, fontWeight: FontWeight.bold,),
                    ),


                    // --------------Show trending Wallpapers----------------
                    const SizedBox(height: 10,),
                    SizedBox(
                        height: 220,
                      child: BlocBuilder<WallpaperBloc,WallpaperState>(
                          builder: (context, state) {
                            if(state is WallpaperLoadingState){
                            return Center(child: CircularProgressIndicator(),);
                            } else if(state is WallpaperErrorState){
                            return Center(child: Text('${state.errorMsg}'),);
                            } else if(state is WallpaperInternetErrorState){
                              return Center(child: Lottie.asset('assets/lottie/internet_error.json'));
                            }else if(state is WallpaperLoadedState){
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.wallpaperModel.photos!.length,
                                itemBuilder: (context, index) {
                                  var eachWall = state.wallpaperModel.photos![index].src!.portrait!;
                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => WallpaperDetailPage(imgUrl: eachWall),));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 20),
                                      width: 170,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(eachWall),
                                        ),
                                      ),
                                      // child: Image.asset(listImage[index]),
                                    ),
                                  );
                                },
                              );
                            }
                            return Container();
                          },
                      )
                    ),
                    const SizedBox(height: 30,),


                    //------------------Color Tone---------------------------
                    const Text('Search wallpaper with Theme',
                      style: TextStyle(
                        fontSize: 21, fontWeight: FontWeight.bold,),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppConstant.listColor.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) => SearchWallpaperPage(mColor: AppConstant.listColor[index]['code']),));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppConstant.listColor[index]['color'],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    //--------------------- All Category--------------------
                    const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: AppConstant.categoriesName.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 16 / 9,
                      ),
                      itemBuilder: (Context, index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CategoriesWallpaperImage(catName: AppConstant.categoriesName[index]['name']),));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              right: 15,
                              bottom: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  AppConstant.categoriesName[index]['img_cat']
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                AppConstant.categoriesName[index]['name'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
