import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/banner_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/cart_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerView extends StatefulWidget {
  const BannerView({Key? key}) : super(key: key);

  @override
  _BannerViewState createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentPage <
          Provider.of<BannerProvider>(context, listen: false)
                  .bannerList!
                  .length -
              1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: TitleWidget(title: getTranslated('banner', context)),
        ),
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Consumer<BannerProvider>(
                builder: (context, banner, child) {
                  return banner.bannerList != null
                      ? banner.bannerList!.isNotEmpty
                          ? PageView.builder(
                              controller: _pageController,
                              itemCount: banner.bannerList!.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      // Your onTap logic here
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: Dimensions.paddingSizeSmall),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[
                                                Provider.of<ThemeProvider>(
                                                            context)
                                                        .darkTheme
                                                    ? 900
                                                    : 300]!,
                                            blurRadius:
                                                Provider.of<ThemeProvider>(
                                                            context)
                                                        .darkTheme
                                                    ? 2
                                                    : 5,
                                            spreadRadius:
                                                Provider.of<ThemeProvider>(
                                                            context)
                                                        .darkTheme
                                                    ? 0
                                                    : 1,
                                          )
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholderBanner,
                                          width: 250,
                                          height: 85,
                                          fit: BoxFit.cover,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.bannerImageUrl}/${banner.bannerList![index].image}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(
                                            Images.placeholderBanner,
                                            width: 250,
                                            height: 85,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ));
                              },
                            )
                          : Center(
                              child: Text(getTranslated(
                                  'no_banner_available', context)!))
                      : const BannerShimmer();
                },
              ),
              Provider.of<BannerProvider>(context).bannerList != null
                  ? Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          Provider.of<BannerProvider>(context)
                              .bannerList!
                              .length,
                          (index) => buildDot(index),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDot(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      width: _currentPage == index ? 10 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 2),
          enabled: Provider.of<BannerProvider>(context).bannerList == null,
          child: Container(
            width: 250,
            height: 85,
            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[
                      Provider.of<ThemeProvider>(context).darkTheme
                          ? 900
                          : 300]!,
                  blurRadius:
                      Provider.of<ThemeProvider>(context).darkTheme ? 2 : 5,
                  spreadRadius:
                      Provider.of<ThemeProvider>(context).darkTheme ? 0 : 1,
                )
              ],
              color: Theme.of(context).shadowColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }
}
