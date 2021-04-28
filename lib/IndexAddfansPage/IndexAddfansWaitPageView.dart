import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:addfans/Class/QrcodesClass.dart';
import 'package:addfans/Common/httpHeaders.dart';
import 'package:addfans/Common/server_config.dart';
import 'package:addfans/Common/server_method.dart';
import 'package:addfans/IndexAddfansUploadPage/IndexAddfansUploadQrcodePageView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:tip_dialog/tip_dialog.dart';

import '../asd.dart';
import 'IndexAddfansProvider.dart';
import 'UpTopDialogPageView.dart';

class IndexAddfansWaitPageView extends StatelessWidget {
  final int viewType;
  const IndexAddfansWaitPageView({Key key, this.viewType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IndexAddfansProvider>(
        create: (context) => IndexAddfansProvider.instance(),
        child: Consumer<IndexAddfansProvider>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.request(viewType),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return Scaffold(
                        backgroundColor: const Color(0xFFECECEC),
                        body: ListView(
                          children: <Widget>[
                            SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                TipDialogHelper.info("请批量添加");
                              },
                              child: Center(
                                child: Wrap(
                                  children: <Widget>[
                                    ...viewModel.data.data.map((e) => AnimationLimiter(
                                          child: AnimationConfiguration.staggeredList(
                                            position: viewModel.data.data.indexOf(e),
                                            duration: const Duration(milliseconds: 375),
                                            // FadeInAnimation
                                            // SlideAnimation verticalOffset: 50.0,
                                            // ScaleAnimation
                                            // FlipAnimation
                                            child: FadeInAnimation(
                                              //verticalOffset: 50.0,
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(5),
                                                  child: Stack(
                                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      CachedNetworkImage(
                                                        progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                                        imageUrl: checkServerUrl(e.headImg),
                                                        width: ScreenUtil().setWidth(120),
                                                        height: ScreenUtil().setWidth(120),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        // padding: const EdgeInsets.all(4.0),
                                                        child: Text(e.cityName, style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500)),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        // padding: const EdgeInsets.all(4.0),
                                                        child: Container(
                                                            height: ScreenUtil().setHeight(20),
                                                            color: Colors.black54,
                                                            child: Center(child: Text(e.describes, style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(15))))),
                                                      ),
                                                      //Text(e.wechatName)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: OutlineButton(
                                child: Text('刷新一下'), //
                                onPressed: () {
                                  viewModel.changeTabBarIndex(viewType);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: OutlineButton(
                                child: Text('批量添加'),
                                onPressed: () async {
                                  QrcodesClass data;
                                  var formData = {};
                                  await requestPost('MyQrcodeList', formData: formData).then((val) {
                                    data = QrcodesClass.fromJson(val);
                                    //  print(val);
                                  });
                                  if (data.data.length == 0) {
                                    Get.defaultDialog(
                                        title: "提示",
                                        content: Text("请上传你的微信二维码\n并确保已【关闭好友验证】"),
                                        confirm: FlatButton(
                                          child: Text("上传"),
                                          onPressed: () async {
                                            //Get.back();
                                            Get.off(IndexAddfansUploadQrcodePageView());
                                          },
                                        ),
                                        cancel: FlatButton(
                                          child: Text("取消", style: TextStyle(color: Colors.black45)),
                                          onPressed: () => Get.back(),
                                        ));
                                    return;
                                  }
                                  Get.defaultDialog(
                                      title: "重要",
                                      content: Padding(
                                        padding: const EdgeInsets.all(28.0),
                                        child: Text("点击【开始】找到【微信】发送给任意好友，然后逐个扫码完成添加"),
                                      ),
                                      confirm: FlatButton(
                                        child: Text("开始"),
                                        onPressed: () async {
                                          TipDialogHelper.loading("准备中");
                                          //准备合成新的二维码
                                          shareQrcodes(viewModel.data.data, viewModel, context);
                                          Get.back();
                                        },
                                      ),
                                      cancel: FlatButton(
                                        child: Text("取消", style: TextStyle(color: Colors.black45)),
                                        onPressed: () => Get.back(),
                                      ));
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: OutlineButton(
                                child: Text('我的名片'),
                                onPressed: () async {
                                  var data = await Get.to(UpTopDialogPageView(), opaque: false, transition: Transition.fade);
                                  if (data == 'sucess') {
                                    viewModel.changeTabBarIndex(viewType);
                                  }
                                },
                              ),
                            ),
                            // GestureDetector(
                            //   child: Text("data"),
                            //   onTap: () {
                            //     showCupertinoDialog(
                            //         context: context,
                            //         builder: (context) {
                            //           return CupertinoAlertDialog(
                            //             title: Text('问答'),
                            //             content: Text('您刚加的好友中是否存在\n【没关好友验证】\n如果有请投诉\n奖励10分钟置顶'),
                            //             actions: <Widget>[
                            //               CupertinoDialogAction(
                            //                 child: Text('投诉'),
                            //                 onPressed: () {},
                            //               ),
                            //               CupertinoDialogAction(
                            //                 child: Text('没有'),
                            //                 onPressed: () {
                            //                   Get.back();
                            //                 },
                            //               ),
                            //             ],
                            //           );
                            //         });
                            //   },
                            // )
                          ],
                        ));
                  } else {
                    return Scaffold(
                      backgroundColor: Color(0xFFECECEC),
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                });
          },
        ));
  }

  faq(List<Data> dataArray, IndexAddfansProvider viewModel, context) {
    //   viewModel.checkTime(false);
    // Timer(Duration(milliseconds: 20000), () {
    //   print("microseconds");

    // });

    showModalBottomSheet(
        isDismissible: false,
        context: context,
        builder: (builder) {
          return new Container(
            height: ScreenUtil().setHeight(350),
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Center(
                        child: new Text("上面好友都添加完成了吗？", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red, fontSize: ScreenUtil().setSp(20))),
                      ),
                      SizedBox(height: 10),
                      Text("请认真选择，系统会随机抽查您的加粉是否真实。", style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            disabledBorderColor: Colors.black,
                            highlightedBorderColor: Colors.red,
                            child: Text('加完了'),
                            onPressed: () async {
                              // print(viewModel.isok);
                              // print(viewModel.isok);
                              // print(viewModel.isok);
                              // print(viewModel.isok);

                              // if (viewModel.isok == false) {
                              //   TipDialogHelper.fail("不，系统检测到你没有加完。");
                              //   print("object");
                              //   return;
                              // }
                              //addFinished(dataArray);
                              QrcodesClass res = await viewModel.addFinished(dataArray);
                              if (res.status == 1) {
                                viewModel.changeTabBarIndex(viewType);
                                //  TipDialogHelper.success(res.msg);
                                Get.back();
                                showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: Text('成功'),
                                        content: Text(res.msg),
                                        actions: <Widget>[
                                          CupertinoDialogAction(
                                            child: Text('继续'),
                                            onPressed: () async {
                                              Get.back();
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: Text('请在5小时内换成小红花,天热种子容易烂掉', style: TextStyle(fontSize: 12, color: Colors.red)),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: Text('投诉有人没关验证(奖励100小红花)', style: TextStyle(fontSize: 12, color: Colors.red)),
                                            onPressed: () {
                                              Get.back();
                                              TipDialogHelper.info("在【我添加的】找到没关验证的人");
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              } else {
                                TipDialogHelper.fail(res.msg);
                              }
                            },
                          ),
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            disabledBorderColor: Colors.black,
                            highlightedBorderColor: Colors.red,
                            child: Text('啥也没干'),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          OutlineButton(
                            borderSide: BorderSide(color: Colors.blue, width: 2),
                            disabledBorderColor: Colors.black,
                            highlightedBorderColor: Colors.red,
                            child: Text('再试一次'),
                            onPressed: () async {
                              shareQrcodes(dataArray, viewModel, context);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  Future<bool> asas() {
    //
  }

  Future shareQrcodes(List<Data> dataArray, IndexAddfansProvider viewModel, context) async {
    await asas();
    qrcodeImages = List<String>();
    var aa = await Get.to(Asdsdwdw(dataArray: dataArray), opaque: false, transition: Transition.downToUp);

    if (aa == 'ok') {
      TipDialogHelper.dismiss();
      // qrcodeImages = qrcodeImages.toSet().toList();//去重（build重回导致）
      faq(viewModel.data.data, viewModel, context);
      await ShareExtend.shareMultiple(qrcodeImages, "image", subject: "share muti image");
    }
    return;
  }

//稳定模式
  Future shareQrcodes2(List<Data> dataArray, IndexAddfansProvider viewModel, context) async {
    // Directory dir = await getApplicationDocumentsDirectory();
    Directory dir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    Response response;
    var imagesTemp = List<String>();
    for (var i = 0; i < dataArray.length; i++) {
      String name = i.toString() + i.toString() + i.toString() + ".jpeg";
      if (response.statusCode == 200) {
        String imagePath = "${dir.path}/$name";
        imagesTemp.add(imagePath);
      }
    }

    TipDialogHelper.dismiss();

    faq(viewModel.data.data, viewModel, context);
    await ShareExtend.shareMultiple(imagesTemp, "image");
  }
}
