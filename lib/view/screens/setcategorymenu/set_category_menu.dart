import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/helper/router_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class SetCategoryMenuScreen extends StatefulWidget {
  const SetCategoryMenuScreen({Key? key}) : super(key: key);

  @override
  State<SetCategoryMenuScreen> createState() => _SetCategoryMenuScreenState();
}

class _SetCategoryMenuScreenState extends State<SetCategoryMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context,
        title: getTranslated('all_categories', context),
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          return category.categoryList != null
              ? category.categoryList!.isNotEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await Provider.of<CategoryProvider>(context,
                                listen: false)
                            .getCategoryList(true);
                      },
                      backgroundColor: Theme.of(context).primaryColor,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Center(
                            child: SizedBox(
                                width: 1170,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: category.categoryList!.length,
                                  padding: const EdgeInsets.all(
                                      Dimensions.paddingSizeSmall),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 13,
                                          mainAxisSpacing: 13,
                                          childAspectRatio: 1 / 1.3,
                                          crossAxisCount: ResponsiveHelper
                                                  .isDesktop(context)
                                              ? 6
                                              : ResponsiveHelper.isTab(context)
                                                  ? 4
                                                  : 2),
                                  itemBuilder: (context, index) {
                                    String? name = '';
                                    category.categoryList![index].name!.length >
                                            15
                                        ? name =
                                            '${category.categoryList![index].name!.substring(0, 15)} ...'
                                        : name =
                                            category.categoryList![index].name;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: InkWell(
                                        onTap: () =>
                                            RouterHelper.getCategoryRoute(
                                                category.categoryList![index]),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                              ]),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ClipOval(
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        Images.placeholderImage,
                                                    width: 150,
                                                    // height: 65,
                                                    fit: BoxFit.cover,
                                                    image: Provider.of<SplashProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .baseUrls !=
                                                            null
                                                        ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.categoryImageUrl}/${category.categoryList![index].image}'
                                                        : '',
                                                    imageErrorBuilder: (c, o,
                                                            s) =>
                                                        Image.asset(
                                                            Images
                                                                .placeholderImage,
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover),
                                                    // width: 100, height: 100, fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: Dimensions
                                                          .paddingSizeDefault),
                                                  child: Text(
                                                    name!,
                                                    style: rubikMedium.copyWith(
                                                        fontSize: Dimensions
                                                            .fontSizeLarge),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ),
                        ),
                      ))
                  : const NoDataScreen()
              : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor)));
        },
      ),
    );
  }
}
