import 'package:flutter/material.dart';
import 'package:pastry_shop_pos/components/custom_container.dart';

class UserPageLayout extends StatelessWidget {
  const UserPageLayout({
    super.key,
    required this.pageWidgets,
    required this.shopName,
    this.topDividerSpace = 20,
  });

  final List<Widget> pageWidgets;
  final String? shopName;
  final double topDividerSpace;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: CustomContainer(
          outerPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
          innerPadding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          containerColor: const Color(0xFFCDE8FF),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        const Expanded(
                          child: Text(
                            'Pastry Shop POS',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    shopName!,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                color: Colors.black38,
                thickness: 1,
              ),
              SizedBox(
                height: topDividerSpace,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...pageWidgets,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
