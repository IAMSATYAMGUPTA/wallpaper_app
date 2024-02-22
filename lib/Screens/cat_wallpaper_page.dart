import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:wallpaper_app/Cutom_widget/custom_widgets.dart';
import 'package:wallpaper_app/Screens/wallpaper_detail_page.dart';
import 'package:wallpaper_app/bloc%20services/search_bloc/search_bloc.dart';

class CategoriesWallpaperImage extends StatefulWidget {
  String catName;
  String? mColor;
  CategoriesWallpaperImage({required this.catName,this.mColor});

  @override
  State<CategoriesWallpaperImage> createState() => _CategoriesWallpaperImageState();
}

class _CategoriesWallpaperImageState extends State<CategoriesWallpaperImage> {

  late ScrollController mController ;
  int i=1;


  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(GetSearchWallpaper(
        query: widget.catName,mColor: widget.mColor));
    mController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.fromLTRB(18,18,18,0),
          child: Column(
            children: [
              Row(children: [Text(widget.catName,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)],),
              SizedBox(height: 15,),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchLoadingState) {
                      return Center(child: SpinKitWave(color: Colors.white, size: 50.0,),);
                    } else if (state is SearchErrorState) {
                      return Center(
                        child: Text('${state.errorMsg}'),);
                    } else if(state is SearchInternetErrorState){
                      return Center(child: Lottie.asset('assets/lottie/internet_error.json'));
                    }else if (state is SearchLoadedState) {
                      var totalResult = state.searchModel.total_results;
                      int per_page = state.searchModel.per_page!;
                      return SingleChildScrollView(
                        child: Column(
                          children: [

                            // ----------------- Show Categories Name Text--------------------
                            Text(
                              '${totalResult} wallpaper available',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15,),


                            //--------- show cat Item-------------------------
                            GridView.builder(
                              shrinkWrap: true,
                              controller: mController,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,crossAxisSpacing: 11,mainAxisSpacing: 11,childAspectRatio: 9/16),
                              itemCount: state.searchModel.photos!.length,
                              itemBuilder: (context, index) {
                                var eachWall = state.searchModel.photos![index].src!.portrait!;
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


                            //---------------set Next Page icons----------------
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                setPageIcon(
                                    icon: Icons.arrow_back_ios_outlined,
                                    onTap: (){
                                      i--;
                                      context.read<SearchBloc>().add(GetSearchWallpaper(query: widget.catName,pageNo: i.toString()));
                                    },
                                    check: i==1 ? true:false
                                ),

                                Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(i.toString(),style: TextStyle(fontSize: 26,color: Colors.white),),),

                                setPageIcon(
                                    icon: Icons.arrow_forward_ios_outlined,
                                    onTap: (){
                                      num check ;
                                      if(totalResult! % per_page ==0){
                                        check = totalResult/per_page;
                                      }else{
                                        check = (totalResult/per_page) + 1;
                                      }

                                      if(i<=check){
                                        i++;
                                        context.read<SearchBloc>().add(GetSearchWallpaper(query: widget.catName,pageNo: i.toString()));
                                      }else{
                                        CustomToast().toastMessage(msg: "More Wallpaper are not available");
                                      }

                                    }
                                ),
                              ],
                            )

                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget setPageIcon({required IconData icon,required VoidCallback onTap,bool check=false}){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: check ? Container(
        height: 30,
        width: 30,
        color: Colors.white30,
        child: Icon(icon,color: Colors.black26,),
      ):InkWell(
        onTap: onTap,
        child: Container(
          height: 30,
          width: 30,
          color: Colors.white,
          child: Icon(icon),
        ),
      ),
    );
  }

}
