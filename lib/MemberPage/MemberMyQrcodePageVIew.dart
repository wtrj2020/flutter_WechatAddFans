import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:addfans/Class/MemberClass.dart';
import 'package:addfans/Common/httpHeaders.dart';
import 'package:addfans/Common/server_config.dart';
import 'package:addfans/MemberPage/MemberPageProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_extend/share_extend.dart';
import 'package:tip_dialog/tip_dialog.dart';

class MemberMyQrcodePageVIew extends StatefulWidget {
  MemberMyQrcodePageVIew({Key key}) : super(key: key);

  @override
  _MemberMyQrcodePageVIewState createState() => _MemberMyQrcodePageVIewState();
}

class _MemberMyQrcodePageVIewState extends State<MemberMyQrcodePageVIew> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MemberPageProvider>(
        create: (context) => MemberPageProvider.instance(),
        child: Consumer<MemberPageProvider>(
          builder: (context, viewModel, child) {
            return FutureBuilder(
                future: viewModel.request(),
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
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        elevation: 0,
                        title: Text("???????????????"),
                      ),
                      body: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: ScreenUtil().setWidth(48)),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      viewModel.data.data.userInfo.shareCode.toString(),
                                      style: TextStyle(fontSize: ScreenUtil().setSp(40), fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    width: ScreenUtil().setWidth(55),
                                    height: ScreenUtil().setHeight(25),
                                    child: FlatButton(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text('??????', style: TextStyle(color: Colors.white)),
                                      color: Color(0xFF5FCB60),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: viewModel.data.data.userInfo.shareCode.toString()));
                                        TipDialogHelper.success("??????????????????");
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setSp(40)),
                              Center(
                                child: Container(
                                    decoration: new BoxDecoration(color: Color(0xFFF8F8F8), borderRadius: new BorderRadius.circular((10.0))),
                                    height: ScreenUtil().setHeight(90),
                                    width: MediaQuery.of(context).size.width - 60,
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(viewModel.data.data.userInfo.aId.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20))),
                                              SizedBox(height: 5),
                                              Text("????????????", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xffB8B8B8)))
                                            ],
                                          ),
                                          Container(
                                              height: ScreenUtil().setHeight(40),
                                              child: VerticalDivider(
                                                color: Colors.grey,
                                                width: ScreenUtil().setWidth(80),
                                              )),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(viewModel.data.data.userInfo.bId.toString(), style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(20))),
                                              SizedBox(height: 5),
                                              Text("????????????", style: TextStyle(fontWeight: FontWeight.w400, color: Color(0xffB8B8B8)))
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(height: ScreenUtil().setHeight(100)),
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("??????????????????", style: TextStyle(fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.w700)),
                                    SizedBox(height: 15),
                                    Text("1????????????????????????????????????????????????????????????????????????????????????", style: TextStyle(fontSize: 14)),
                                    SizedBox(height: 10),
                                    Text("2????????????????????????????????????(??????????????????)??????????????????????????????????????????????????????", style: TextStyle(fontSize: 14)),
                                    SizedBox(height: 10),
                                    Text("3???????????????????????????????????????????????????????????????????????????", style: TextStyle(fontSize: 14)),
                                    SizedBox(height: 10),
                                    Text("4????????????????????????????????????????????????????????????????????????????????????????????????", style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              )
                            ],
                          ),
                          TipDialogContainer(
                              duration: const Duration(seconds: 2),
                              outsideTouchable: true,
                              onOutsideTouch: (Widget tipDialog) {
                                if (tipDialog is TipDialog && tipDialog.type == TipDialogType.LOADING) {
                                  TipDialogHelper.dismiss();
                                }
                              }),
                        ],
                      ),
                      bottomNavigationBar: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text('??????????????????', style: TextStyle(color: Colors.white)),
                            color: Color(0xFF5FCB60),
                            onPressed: () {
                              Get.dialog(EwmImgs(data: viewModel.data.data));
                            },
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          },
        ));
  }
}

class EwmImgs extends StatefulWidget {
  final Data data;
  EwmImgs({Key key, this.data}) : super(key: key);

  @override
  _EwmImgsState createState() => _EwmImgsState();
}

Future<String> savefile(pathName, GlobalKey<State<StatefulWidget>> rootWidgetKey) async {
  String path;
  Directory dir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
  Uint8List pngBytes;
  RenderRepaintBoundary boundary = rootWidgetKey.currentContext.findRenderObject();
  var image = await boundary.toImage();
  ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
  pngBytes = byteData.buffer.asUint8List();
  String sTempDir = dir.path;
  bool isDirExist = await Directory(sTempDir).exists();
  if (!isDirExist) {
    Directory(sTempDir).create();
  }
  Future<File> file = File(sTempDir + "/" + pathName + ".jpg").writeAsBytes(pngBytes);
  await file.then((f) {
    path = f.path;
  });

  return path;
}

class _EwmImgsState extends State<EwmImgs> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
    //qrcodeImages = List<String>();
    // ScreenUtil.instance = ScreenUtil(width: 828, height: 1792)..init(context);
    // ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RepaintBoundary(
                  key: rootWidgetKey0,
                  child: Column(
                    children: <Widget>[
                      Container(
                          color: Colors.green,
                          width: ScreenUtil().setWidth(315),
                          height: ScreenUtil().setHeight(95),
                          child: Column(
                            children: <Widget>[
                              Center(
                                  child: Text(
                                "[????????????]??????APP",
                                style: TextStyle(fontSize: ScreenUtil().setSp(32), color: Colors.white),
                              )),
                              Center(child: Text("???????????????:" + widget.data.userInfo.shareCode.toString(), style: TextStyle(fontSize: ScreenUtil().setSp(24), color: Colors.white))),
                            ],
                          )),
                      Container(
                        alignment: Alignment.center,
                        height: ScreenUtil().setWidth(315),
                        width: ScreenUtil().setWidth(315),
                        color: Colors.green,
                        child: Container(
                            height: ScreenUtil().setWidth(300),
                            width: ScreenUtil().setWidth(300),
                            child: Container(
                                color: Colors.white,
                                child: QrImage(data: widget.data.shareUrl + widget.data.userInfo.shareCode.toString()+".jpeg" + "&time=" + now, version: 4, size: 500, gapless: true))),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  // padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('??????????????????', style: TextStyle(color: Colors.white)),
                  color: Color(0xFF5FCB60),
                  onPressed: () async {
                    String path = await savefile(widget.data.userInfo.shareCode.toString(), rootWidgetKey0);
                    if (path != null) {
                      await ShareExtend.share(path, "image", subject: "share muti image");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
