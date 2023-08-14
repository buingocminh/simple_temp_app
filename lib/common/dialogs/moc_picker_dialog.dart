import 'package:flutter/material.dart';

import '../../models/mock_case.dart';

class MockPickerDialog extends StatelessWidget {
  const MockPickerDialog(
    this.listCase,
    this.action,
    {super.key}
  );
  final List<MockCase> listCase;
  final String action;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            Text(
              "Pick case for: $action",
              style: const TextStyle(
                color: Colors.white
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: listCase.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(listCase[index].callBack);
                  },
                  child: Container(
                    color: Colors.white10,
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listCase[index].name,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                        Text(
                          listCase[index].description,
                          style: const TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      );
  }
}