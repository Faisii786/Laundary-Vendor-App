import 'package:flutter/material.dart';


import '../res/colors/app_color.dart';
import '../res/fonts/app_fonts.dart';
class RoundButton extends StatelessWidget {
  const RoundButton({super.key,
    this.buttonColor = AppColor.primeryBlueColor,
    this.textColor = AppColor.bgcolor,
    required this.title,
    required this.onPress,
     this.width = 60,
     this.height = 50,
    this.loading = false,
  });

 final bool loading;
 final String title;
 final double height , width;
 final VoidCallback onPress;
  final Color textColor, buttonColor;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container (
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(50)
        ),
        child: loading ?
        const Center(
            child: CircularProgressIndicator()):
        Center(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium!.copyWith(color:AppColor.bgcolor,fontFamily: AppFonts.gilroyBold),
        ),
        ),),
    );
  }
}
//to use in code aadd RoundButton(onPress(){}, title:'Login', width: double.infinity or 200) then if indise parameter loading:tru the indicator start