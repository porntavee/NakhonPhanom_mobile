import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../component/material/custom_alert_dialog.dart';
import '../../shared/api_provider.dart';
import '../blank_page/dialog_fail.dart';
import 'car_registration.dart';
import 'change_password.dart';
import 'connect_social.dart';
import 'edit_user_information.dart';
import 'id_card_verification.dart';
import 'identity_verification.dart';
import 'register_with_diver_license.dart';
import 'register_with_license_plate.dart';
import 'setting_notification.dart';

class UserInformationPage extends StatefulWidget {
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final storage = new FlutterSecureStorage();
  Future<dynamic>? _futureProfile;
  Future<dynamic>? _futureAboutUs;
  dynamic _tempData = {'imageUrl': '', 'firstName': '', 'lastName': ''};

  @override
  void initState() {
    _read();
    _futureAboutUs = postDio('${aboutUsApi}read', {});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: _futureProfile,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return card(snapshot.data);
          } else if (snapshot.hasError) {
            return dialogFail(context);
          } else {
            return card(_tempData);
          }
        },
      ),
    );
  }

  _read() async {
    //read profile
    var profileCode = await storage.read(key: 'profileCode2');
    if (profileCode != '' && profileCode != null)
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
  }

  _goBack() async {
    Navigator.pop(context, false);
  }

  card(dynamic model) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Stack(
                children: [
                  Container(
                    height: 270,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: Image.asset(
                            'assets/background/profile_bg.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 130,
                width: 130,
                margin: EdgeInsets.only(top: 80),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.transparent, // สีของขอบวงกลม
                    width: 1, // ความหนาของขอบ
                  ),
                ),
                child: ClipOval(
                  child: model['imageUrl'] != ''
                      ? CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: model['imageUrl'] != null
                              ? NetworkImage(model['imageUrl'])
                              : null,
                        )
                      : Container(
                          color: Colors.black12,
                          child: Image.asset(
                            'assets/images/user_not_found.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.only(
                    top: 200.0, left: 20.0, right: 20.0, bottom: 30.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          model['firstName'] + ' ' + model['lastName'],
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Sarabun',
                              fontSize: 25.0,
                              color: Color(0xFF9e6e19)),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 270.0, bottom: 30.0),
                constraints: const BoxConstraints(
                  minHeight: 200,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Container(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ตั้งค่าผู้ใช้',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      SizedBox(height: 12),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserInformationPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                            'assets/icons/person.png',
                            'ข้อมูลผู้ใช้งาน',
                            'ข้อมูลผู้ใช้งาน ข้อมูลผู้ใช้งาน'),
                      ),
                      // InkWell(
                      //   onTap: () async {
                      //     final msg = model['idcard'] == ''
                      //         ? await showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return _buildDialogRegister();
                      //             },
                      //           )
                      //         : await Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => IDCardInfo(),
                      //             ),
                      //           );
                      //     if (!msg) {
                      //       _read();
                      //     }
                      //   },
                      //   child: buttonMenuUser(
                      //       'assets/icons/id_card.png', 'ข้อมูลบัตรประชาชน'),
                      // ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IdentityVerificationPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/papers.png',
                          'ข้อมูลสมาชิก',
                          'ข้อมูลสมาชิก ข้อมูลสมาชิก',
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingNotificationPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/bell.png',
                          'ตั้งค่าการแจ้งเตือน',
                          'ตั้งค่าการแจ้งเตือน ตั้งค่าการแจ้งเตือน',
                        ),
                      ),
                      // InkWell(
                      //   onTap: () async {
                      //     final msg = model['idcard'] == ''
                      //         ? await showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) {
                      //               return _buildDialogRegister();
                      //             })
                      //         : model['isDF'] != true
                      //             ? await showDialog(
                      //                 context: context,
                      //                 builder: (BuildContext context) {
                      //                   return _buildDialogdriverLicence();
                      //                 })
                      //             : await Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                   builder: (context) => DriversInfo(),
                      //                 ),
                      //               );
                      //     if (!msg) {
                      //       _read();
                      //     }
                      //   },
                      //   child:
                      //       buttonMenuUser('assets/car.png', 'ข้อมูลใบขับขี่'),
                      // ),
                      // InkWell(
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => AboutUsForm(
                      //         model: _futureAboutUs,
                      //         title: 'ติดต่อเรา',
                      //       ),
                      //     ),
                      //   ),
                      //   child: buttonMenuUser(
                      //       'assets/icons/phone.png', 'ติดต่อเรา'),
                      // ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectSocialPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/link.png',
                          'การเชื่อมต่อ',
                          'การเชื่อมต่อ การเชื่อมต่อ',
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangePasswordPage(),
                          ),
                        ),
                        child: buttonMenuUser(
                          'assets/icons/lock.png',
                          'เปลี่ยนรหัสผ่าน',
                          'เปลี่ยนรหัสผ่าน เปลี่ยนรหัสผ่าน',
                        ),
                      ),
                      // InkWell(
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => CarRegistration(
                      //         type: 'C',
                      //       ),
                      //     ),
                      //   ),
                      //   child: buttonMenuUser(
                      //       'assets/icons/papers.png', 'ชำระภาษีรถตนเอง'),
                      // ),
                      // InkWell(
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => CarRegistration(
                      //         type: 'V',
                      //       ),
                      //     ),
                      //   ),
                      //   child: buttonMenuUser(
                      //       'assets/icons/papers.png', 'ตรวจสภาพรถ'),
                      // ),
                      // InkWell(
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => ImageBinaryPage(),
                      //     ),
                      //   ),
                      //   child: buttonMenuUser(
                      //       'assets/icons/link.png', 'ดึงรูปใบสั่ง (เบต้า)'),
                      // ),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          versionName,
                          style: TextStyle(
                            fontSize: 9,
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        // width: 200,
                        margin: EdgeInsets.only(top: 20.0),
                        child: Container(
                          // padding: EdgeInsets.all(10),
                          // color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => logout(context),
                                child: Icon(
                                  Icons.power_settings_new,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () => logout(context),
                                child: Text(
                                  'ออกจากระบบ',
                                  style: TextStyle(
                                    fontFamily: 'Sarabun',
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  buttonMenuUser(String image, String title, String subtitle) {
    return Container(
      height: 80,
      padding: EdgeInsets.only(bottom: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(15),
        color: Color(0xFFf6f8fc),
      ),
      margin: EdgeInsets.only(bottom: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 14.0,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFfffadd),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: const Color(0xFF9e6e19),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDialogRegister() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: CustomAlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Container(
          width: 325,
          height: 300,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/check_register.png',
                  height: 50,
                ),
                // Icon(
                //   Icons.check_circle_outline_outlined,
                //   color: Color(0xFF5AAC68),
                //   size: 60,
                // ),
                SizedBox(height: 10),
                Text(
                  'ยืนยันตัวตน',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 15,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'กรุณาลงทะเบียนด้วยบัตรประชาชน',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 13,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                Text(
                  'เพื่อเชื่อมต่อใบอนุญาต และข้อมูลพาหนะในครอบครอง',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 13,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                SizedBox(height: 50),
                Container(height: 0.5, color: Color(0xFFcfcfcf)),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context, false);
                    final msg = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IDCardVerification(),
                      ),
                    );
                    if (!msg) {
                      _read();
                    }
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      'ลงทะเบียนเพื่อตรวจสอบใบอนุญาต',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 13,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                  ),
                ),
                Container(height: 0.5, color: Color(0xFFcfcfcf)),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Color(0xFF9C0000),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 13,
                        color: Color(0xFF9C0000),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          // child: //Contents here
        ),
      ),
    );
  }

  _buildDialogdriverLicence() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: CustomAlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Container(
          width: 325,
          height: 300,
          // width: MediaQuery.of(context).size.width / 1.3,
          // height: MediaQuery.of(context).size.height / 2.5,
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  'assets/check_register.png',
                  height: 50,
                ),
                // Icon(
                //   Icons.check_circle_outline_outlined,
                //   color: Color(0xFF5AAC68),
                //   size: 60,
                // ),
                SizedBox(height: 10),
                Text(
                  'ยืนยันตัวตร',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 15,
                    // color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'กรุณายืนยันตัวผ่านตัวเลือกดังต่อไปนี้',
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 15,
                    color: Color(0xFF4D4D4D),
                  ),
                ),
                SizedBox(height: 28),
                Container(height: 0.5, color: Color(0xFFcfcfcf)),
                InkWell(
                  onTap: () async {
                    // Navigator.pop(context,false);
                    final msg = await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterWithDriverLicense(),
                      ),
                    );

                    if (!msg) {
                      _read();
                    }
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'ยืนยันตัวตนผ่านใบขับขี่',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 15,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                  ),
                ),
                Container(height: 0.5, color: Color(0xFFcfcfcf)),
                InkWell(
                  onTap: () async {
                    // Navigator.pop(context,false);
                    final msg = await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterWithLicensePlate(),
                      ),
                    );
                    if (!msg) {
                      _read();
                    }
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'ยืนยันตัวตนผ่านทะเบียนรถที่ครอบครอง',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 15,
                        color: Color(0xFF4D4D4D),
                      ),
                    ),
                  ),
                ),
                Container(height: 0.5, color: Color(0xFFcfcfcf)),
                InkWell(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 45,
                    alignment: Alignment.center,
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 15,
                        color: Color(0xFF9C0000),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // child: //Contents here
        ),
      ),
    );
  }
}
