
import 'package:compound/shared_components/banner/dynamic_banner.dart';
import 'package:compound/shared_components/pages/base_page.dart';
import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:sliver_fill_remaining_box_adapter/sliver_fill_remaining_box_adapter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

mixin FeatureBannerMixin<Page extends BasePage> on BaseState<Page> {

  @override 
	Widget body(BuildContext context){
          final double height = super.imgViewHelper == null? 250.0.w : super.imgViewHelper.getViewHeight(context);
          return SliverFab(topScalingEdge: -super.bannerHeight,
                    floatingPosition: FloatingPosition(top:0, right:0, left:0),
                    floatingWidget:  Container(
                                      height: super.bannerHeight,
                                      width:  MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0.w),
                                            topRight: Radius.circular(30.0.w),
                                        ),
                                      ),
                                      child: super.bannerChild
                                    ),
                      expandedHeight: height - super.bannerExpandedHeight,
                      slivers: <Widget>[
                      SliverAppBar(
                        leading: Container(),
                        actions : null,
                        pinned: false,
                        elevation: 0,
                        expandedHeight: height,
                        flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.parallax,
                                                        background: Stack(children: [
                                                            Positioned.fill(child:  DynamicBannerView(viewImage: super.imgViewHelper)),
                                                          ],
                                                        ),
                      )),
                      SliverFillRemainingBoxAdapter(child:_wrap(context))
                    ],
                  );
  }

  Widget _wrap(BuildContext context){
       return  Container(decoration: BoxDecoration(color: Colors.white),
                         child: content(context));
  }
}
