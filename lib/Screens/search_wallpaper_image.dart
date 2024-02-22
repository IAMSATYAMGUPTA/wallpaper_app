import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper_app/Screens/wallpaper_detail_page.dart';
import 'package:wallpaper_app/bloc%20services/search_bloc/search_bloc.dart';
import 'package:wallpaper_app/constant/app_constant.dart';
import '../Cutom_widget/custom_widgets.dart';
import '../model/photo_model.dart';

class SearchWallpaperPage extends StatefulWidget {
  String? mColor;
  bool colorTone;
  SearchWallpaperPage({this.mColor,this.colorTone=true});

  @override
  State<SearchWallpaperPage> createState() => _SearchWallpaperPageState();
}

class _SearchWallpaperPageState extends State<SearchWallpaperPage> {

  var searchController = TextEditingController();
  bool check = true;
  late ScrollController mController ;
  int mPageNo=1;
  List<PhotoModel> arrPhotos = [];

  @override
  void initState() {
    super.initState();
    mController = ScrollController();
    mController.addListener(() {
      if(mController.position.pixels==mController.position.maxScrollExtent){
        mPageNo++;
        context.read<SearchBloc>().add(GetSearchWallpaper(query: searchController.text.toString(),pageNo: mPageNo.toString()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xffE8D7DA),
                Color(0xffA0D3D6),
              ],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15,15,15,0),
              child: Column(
                children: [

                  // ----------- use Text field to search wallpaper------------
                  Container(
                    //* Find the Wallpaper search box..
                    padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Find Wallpaper..',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 152, 152, 152),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.image_search),
                          onPressed: () {
                            arrPhotos.clear();
                            context.read<SearchBloc>().add(GetSearchWallpaper(
                                query: searchController.text.toString().replaceAll(" ", "%20"),mColor: widget.mColor));
                            check = false;
                          },
                        ),
                        suffixIconColor: const Color.fromARGB(255, 172, 172, 172),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffDBEBF1),
                          ),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xffDBEBF1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18,),

                  //------------------Color Tone Option------------------------
                  widget.colorTone ? Container():Align(
                    alignment: Alignment.centerLeft,
                    child: const Text('Select Theme',
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 10,),
                  widget.colorTone ? Container():
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: AppConstant.listColor.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: (){
                              widget.mColor = AppConstant.listColor[index]['code'];
                              if(check || searchController.text.toString().isEmpty){
                                CustomToast().toastMessage(msg: "Select ${AppConstant.listColor[index]['name']} color theme");
                              }else{
                                context.read<SearchBloc>().add(GetSearchWallpaper(
                                    query: searchController.text.toString().replaceAll(" ", "%20"),mColor: widget.mColor));
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppConstant.listColor[index]['color'],
                                  shape: BoxShape.circle
                              ),
                            ),
                          );
                        },
                    ),
                  ),


                  // --------------------show search wallpaper----------------
                  SizedBox(height: 20,),
                  Expanded(
                      child: BlocListener<SearchBloc, SearchState>(
                        listener: (context, state) {
                          if (state is SearchLoadingState) {
                            // return Center(child: SpinKitWave(color: Colors.black, size: 50.0,),);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Loading...")));
                          } else if (state is SearchErrorState) {
                            // return Center(
                            //   child: Text('${state.errorMsg}'),);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${state.errorMsg}')));
                          } else if(state is SearchInternetErrorState){
                            // return Center(child: Lottie.asset('assets/lottie/internet_error.json'));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${state.errorMsg}')));
                          }else if (state is SearchLoadedState) {
                            arrPhotos.addAll(state.searchModel.photos!);
                            setState(() {

                            });
                          }
                        },
                        child: check ? Container():GridView.builder(
                          controller: mController,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 11,mainAxisSpacing: 11,childAspectRatio: 9/16),
                          itemCount: arrPhotos.length,
                          itemBuilder: (context, index) {
                            var eachWall = arrPhotos[index].src!.portrait!;
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => WallpaperDetailPage(imgUrl: eachWall),));
                              },
                              child: Container(
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
                        ),
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
