import 'package:flutter/material.dart';
import '../../configs/style_config.dart';
import '../extensions/string_extension.dart';

class NoInternetDialog extends StatelessWidget {
  const NoInternetDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.hardEdge,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.fromLTRB(17, 28, 16, 26),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "noInternetAlertTitle".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kColorBlack,
                fontSize: 20,
                fontWeight: FontWeight.w500
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "noInternetAlertContent".tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kColorBlack,
                fontSize: 17
              ),
            ),
            const SizedBox(
              height: 37,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kColorGrey
                    ),
                    child: Text(
                      "cancel".tr(),
                      style: const TextStyle(
                        color: kColorBlack
                      ),
                    )
                  )
                ),
                const SizedBox(
                  width: 14,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop(true);
                    }, 
                    child: Text(
                      "retry".tr()
                    )
                  )
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}