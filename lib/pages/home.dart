import 'package:after_layout/after_layout.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scale_tap/flutter_scale_tap.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_proto_app/Globals/appColors.dart';
import 'package:restaurant_proto_app/models/product.dart';
import 'package:restaurant_proto_app/models/subcategories.dart';
import 'package:restaurant_proto_app/notifiers.dart/basket_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/home_notifier.dart';
import 'package:restaurant_proto_app/notifiers.dart/ordered_notifier.dart';
import 'package:restaurant_proto_app/services/API/menu_service.dart';
import 'package:restaurant_proto_app/services/API/orderer_service.dart';
import 'package:restaurant_proto_app/widgets/helpWidgets/animted_text_fade.dart';
import 'package:restaurant_proto_app/widgets/helpWidgets/distance_determiner.dart';
import 'package:restaurant_proto_app/widgets/helpWidgets/fadeOut_bound.dart';
import 'package:restaurant_proto_app/widgets/home/badget_button.dart';
import 'package:restaurant_proto_app/widgets/home/flat_button.dart';
import 'package:restaurant_proto_app/widgets/home/icon_button_bg.dart';
import 'package:restaurant_proto_app/widgets/home/product_item.dart';
import 'package:restaurant_proto_app/widgets/home/subcategory.dart';
import 'package:restaurant_proto_app/widgets/home/timer_button.dart';
import 'package:restaurant_proto_app/widgets/panels/basket_panel.dart';
import 'package:restaurant_proto_app/widgets/panels/categories_panel.dart';
import 'package:restaurant_proto_app/widgets/panels/ordered_panel.dart';
import 'package:restaurant_proto_app/widgets/slidingPanel/panel.dart';
import 'package:flutter/scheduler.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AfterLayoutMixin<Home>, SingleTickerProviderStateMixin{

  bool isSelected = false;
  bool isActive = false;
  Function? startTimer;
  PanelController categoriesPanelController = PanelController();
  PanelController basketPanelController = PanelController();
  HomeNotifier? homeNotifier;
  BasketNotifier? basketNotifier;
  OrderNotifier? orderNotifier;
  GlobalKey<DistanceDeterminerState> distanceDeterminer = GlobalKey();
  late MenuSerivce menuSerivce;
  ScrollController scrollController = ScrollController();

  
  @override
  void afterFirstLayout(BuildContext context) async{
    menuSerivce = MenuSerivce(homeNotifier: homeNotifier!);
    await menuSerivce.getCategories();
    homeNotifier!.distanceDeterminer = distanceDeterminer;
    homeNotifier!.scrollController = scrollController;
    OrderService(basketNotifier: basketNotifier!, orderNotifier: orderNotifier!).getOrdered();
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.0),
  )
  .animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));


  late final Tween<Offset> _offsetAnimation11 = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.0),
  );
  // final animation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, 1)).animate(_controller);

  


  Widget getHeader(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
        child: Row(
          children: [
            IconButtonBG(
              onPress: (){
                categoriesPanelController.open();
              }, 
              icon: Icons.menu_rounded, 
              iconColor: AppColors.textGrey, 
              scaleFactor: 0.7,
              iconSize: 50,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: AnimatedFadeOutIn<String>(
                  initialData: "Recommended",
                  data: homeNotifier!.categories.categories.isNotEmpty && homeNotifier!.selectedCategory != -1
                    ? homeNotifier!.categories.categories[homeNotifier!.selectedCategory!].title
                    : "Recommended",
                  builder: (value) =>  
                  Text(
                    value,
                    style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold),
                  ),
              ),
            ),
            Expanded(child: Container(height: 0,)),
            FlatButtonCustom(
              onPress: (){
                homeNotifier!.updatePanelNum(2);
                homeNotifier!.updatePanelType(PanelType.ORDERED);
                basketPanelController.open();
              },
              title: "Request Checkout",
              innerHorizontalPadding: 25,
              innerVerticalPadding: 20,
              borderRadius: 20,
              textColor: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
              child: TimerButton(
                onPress: (){
                  startTimer!.call();
                },
                title: "Call Waiter",
                innerHorizontalPadding: 25,
                innerVerticalPadding: 20,
                borderRadius: 20,
                timerFunction: (startTimer){
                  this.startTimer = startTimer;
                },
                textColor: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            BadgedButton(
              onPress: (){
                homeNotifier!.updatePanelNum(2);
                homeNotifier!.updatePanelType(PanelType.CURRENT_ORDER);
                basketPanelController.open();
              }, 
              icon: Icons.shopping_basket_outlined, 
              iconColor: Colors.black, 
              scaleFactor: 0.7,
              iconSize: 46,
              badgeNum: basketNotifier!.getNumOfBasketProducts(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSubcategories(){
    return Padding(
      padding: EdgeInsets.fromLTRB(homeNotifier!.subcategories.subcategories.isEmpty ? 34 : 84, 0, 0, 0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: homeNotifier!.subcategories.subcategories.isEmpty ? 0 : 50,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: homeNotifier!.subcategories.subcategories.length,
          itemBuilder: (BuildContext context, int index) {
            SubcategoryItem subCategory = homeNotifier!.subcategories.subcategories[index];
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: SubCategory(
                title: subCategory.title,
                isSelected: homeNotifier!.selectedSubcategory == subCategory.id,
                onPress: (title){
                  homeNotifier!.updateSubcategory(subCategory.id);
                }
              ),
            );
          },
        ),
      ),
    );
  }

  Widget getProductItems(){
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: DistanceDeterminer(
              key: distanceDeterminer,
              getDistance: (distance){
                debugPrint("Distance --> " + distance.toString());
                homeNotifier!.updateDeltaDistanceMain(distance);
              }
            ),
          ),
          SizedBox(
            height: homeNotifier!.deltaDistanceMain == null ? (MediaQuery.of(context).size.height * .817) : (MediaQuery.of(context).size.height - homeNotifier!.deltaDistanceMain!),
            width: double.infinity,
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.only(top: 30, left: 100, bottom: 40),
                child: Wrap(
                  spacing: 45,
                  runSpacing: 45,
                  // alignment: WrapAlignment.spaceBetween,
                  children: [
                    for (var index = 0; index < homeNotifier!.products.products.length; index++) ...[
                      AnimatedBuilder(
                        animation: _controller,
                        child: ProductItem(
                            onPress: (productID){
                              homeNotifier!.updateProduct(productID);
                            },
                            onEdgeTap: (productID){
                              homeNotifier!.updateProduct(-1);
                            },
                            isActive: homeNotifier!.selectedProductID == homeNotifier!.products.products[index].id,
                            product: homeNotifier!.products.products[index],
                          ),
                        builder: (context, child) {
                          
                          return SlideTransition(position: _offsetAnimation11.animate(CurvedAnimation(
                            parent: _controller,
                            curve: Curves.easeInOut,
                          )), child: child);
                        }
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          homeNotifier!.checkCanScroll()
          ? FadeoutBound(height: 35)
          : Container(),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

   homeNotifier = Provider.of<HomeNotifier>(context);
   basketNotifier = Provider.of<BasketNotifier>(context);
   orderNotifier = Provider.of<OrderNotifier>(context);

  return Scaffold(
    backgroundColor: AppColors.textWhite,
    body: SlidingPanel(
      controller: basketPanelController,
      renderPanelSheet: false,
      backdropEnabled: true,
      panel: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: homeNotifier!.activePanelType == PanelType.CURRENT_ORDER
        ? BasketPanel(panelNum: 2)
        : OrderedPanel(panelNum: 2),
      ),
      minWidth: 0.0, // Setting up the width of shown panel while collapsed
      maxWidth: 830.0, // Setting up the length of the panel 
      onPanelSlide: (position){
        homeNotifier!.updatePanelNum(2);
        homeNotifier!.updateOpacity(position);
      },
      slideDirection: SlideDirection.LEFT,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SlidingPanel(
            controller: categoriesPanelController,
          renderPanelSheet: false,
          backdropEnabled: true,
          panel: CategoriesPanel(categories: homeNotifier!.categories, panelNum: 1),
          minWidth: 120.0, // Setting up the width of shown panel while collapsed
          maxWidth: 390.0, // Setting up the length of the panel 
          onPanelSlide: (position){
            homeNotifier!.updatePanelNum(1);
            homeNotifier!.updateOpacity(position);
          },
          slideDirection: SlideDirection.RIGHT,
          body: Stack(
            children: [
              // GestureDetector(
              //   onTap: (){

              //   },
              //   child: Container(
              //     height: MediaQuery.of(context).size.height,
              //     width: MediaQuery.of(context).size.width,
              //     color: Colors.white,
              //   ),
              // ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // color: Colors.red,
                child: Column(
                  children: [
                    getHeader(),
                    getSubcategories(),
                    getProductItems(),
                  ],
                )
              ),
            ],
          ),
    ),
        ),
      ),
    ),
  );
}
}