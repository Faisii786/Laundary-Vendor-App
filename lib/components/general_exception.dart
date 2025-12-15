import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/colors/app_color.dart';


class GeneralExceptionWidget extends StatefulWidget {
  final VoidCallback onPress;
  const GeneralExceptionWidget({super.key, required this.onPress});

  @override
  State<GeneralExceptionWidget> createState() => _GeneralExceptionWidgetState();
}

class _GeneralExceptionWidgetState extends State<GeneralExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Icon(Icons.cloud_off, color: AppColor.RedColor,size: 20,),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Center(
                  child: Text('general_exception'.tr, textAlign: TextAlign.center,)),
            ),
            SizedBox(height: height * 1.5,),
            InkWell(
              onTap: widget.onPress,
              child: Container(
                height: 44,
                width: 160,
                decoration: BoxDecoration(
                  color: AppColor.progressColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child:  Center(child: Text('Retry', style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColor.WhiteColor),)),
        
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//where you call the function InternetExceptionWidget(onPress: (){})