import 'package:flutter/material.dart';
import 'package:fitcarib/ui/otpexample/pin_entry_text.dart';

final GlobalKey<ScaffoldState> _scaffoldKeyOTPScreen = new GlobalKey<ScaffoldState>();

class OTPScreen extends StatefulWidget {
  final String otp;
  OTPScreen({
    required Key key,
    required this.otp,
  })
      : super(
    key: key,
  );
  @override
  OTPScreenState createState() => OTPScreenState(otp);
}

class OTPScreenState extends State<OTPScreen> {

  var otp;
  OTPScreenState(this.otp);

  var optInt;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKeyOTPScreen,
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(onPressed: () => Navigator.of(context).pop, icon: Icon(Icons.arrow_back,color: Colors.orange,size: 35.0,),),
          ),
          Center(
            child: Image.asset(
              'assets/images/otp.png',
              height: screenHeight/4,
              width: screenWidth/2,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 30.0),),
          Center(
            child: Text("Enter OTP",style: TextStyle(color: Colors.orange,fontWeight: FontWeight.bold,fontSize: 30.0),),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0),),
          Center(
            child: Text("OTP has been sent to your registered\nemail address please enter it below.",style: TextStyle(color: Colors.tealAccent[700],fontSize: 18.0),),
          ),
          Padding(padding: EdgeInsets.only(top: 30.0),),

//            Padding(
//              padding: EdgeInsets.only(left: 50.0,right: 50.0),
//              child: Row(
//                children: <Widget>[
//                  Expanded(child: TextField(
//                    keyboardType: TextInputType.number,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(fontSize: 30.0,color: Colors.black),
//                    controller: optVal1,
//                    maxLength: 1,
//                    maxLines: 1,
//                    obscureText: true,
//                    autofocus: true,
//                    onChanged: (optVal1) {
//                      if(optVal1.length == 1){
//                        FocusScope.of(context).requestFocus(textSecondFocusNode);
//                      }
//                    },
//                    decoration: InputDecoration(border: OutlineInputBorder(), counterText: ""),
//                  ),
//                  ),
//                  Padding(padding: EdgeInsets.only(left: 10.0),),
//                  Expanded(child: TextField(
//                    keyboardType: TextInputType.number,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(fontSize: 30.0,color: Colors.black),
//                    controller: optVal2,
//                    maxLength: 1,
//                    maxLines: 1,
//                    obscureText: true,
//                    focusNode: textSecondFocusNode,
//                    onChanged: (optVal2) {
//                      if(optVal2.length == 1){
//                        FocusScope.of(context).requestFocus(textThirdFocusNode);
//                      }
//                    },
//                    decoration: InputDecoration(border: OutlineInputBorder(), counterText: ""),
//                  ),
//                  ),
//                  Padding(padding: EdgeInsets.only(left: 10.0),),
//                  Expanded(child: TextField(
//                    keyboardType: TextInputType.number,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(fontSize: 30.0,color: Colors.black),
//                    controller: optVal3,
//                    maxLength: 1,
//                    maxLines: 1,
//                    obscureText: true,
//                    focusNode: textThirdFocusNode,
//                    onChanged: (optVal3) {
//                      if(optVal3.length == 1){
//                        FocusScope.of(context).requestFocus(textFourthFocusNode);
//                      }
//                    },
//                    decoration: InputDecoration(border: OutlineInputBorder(), counterText: ""),
//                  ),
//                  ),
//                  Padding(padding: EdgeInsets.only(left: 10.0),),
//                  Expanded(child: TextField(
//                    keyboardType: TextInputType.number,
//                    textAlign: TextAlign.center,
//                    style: TextStyle(fontSize: 30.0,color: Colors.black),
//                    controller: optVal4,
//                    maxLength: 1,
//                    maxLines: 1,
//                    obscureText: true,
//                    focusNode: textFourthFocusNode,
//                    decoration: InputDecoration(border: OutlineInputBorder(), counterText: ""),
//                  ),
//                  ),
//                ],
//              ),
//            ),

          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PinEntryTextField(
                isTextObscure: true,
                inputStyle: TextStyle(color: Colors.black),
                fontSize: 30.0,
                fieldWidth: 50.0,
                onSubmit: (String pin) {
                  optInt = int.parse(pin);
                  assert(optInt is int);
                },
              ),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: 40.0),),

          Center(
            child: FlatButton(
              onPressed: () {
                print(optInt);
              },
              child: Container(
                decoration: BoxDecoration(color: Colors.tealAccent[700],borderRadius: BorderRadius.circular(100.0)),
                width: 160,
                height: 60.0,
                child: Center(
                  child: Text("Done",style: TextStyle(color: Colors.white,fontSize: 20.0)),
                ),
              ),
            ),
          ),

          Padding(padding: EdgeInsets.only(top: 25.0),),

          Center(
            child: Column(
              children: <Widget>[
                Text("Didn't Receive OTP?",style: TextStyle(color: Colors.grey,fontSize: 20.0),),
                FlatButton(onPressed: null,child: Text("RESEND",style: TextStyle(color: Colors.tealAccent[700],fontWeight: FontWeight.bold,fontSize: 20.0),),),
              ],
            ),
          )
        ],
      ),
    );
  }

}