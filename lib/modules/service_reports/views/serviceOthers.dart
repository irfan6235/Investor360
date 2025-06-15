import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:investor360/modules/services_others/controller/subscribe_ecas_controller.dart';
import 'package:investor360/routes/routes.dart';
import '../../../shared/style/colors.dart';

class ServiceOthers extends StatefulWidget {
  const ServiceOthers({super.key});

  @override
  State<ServiceOthers> createState() => _ServiceOthersState();
}

class _ServiceOthersState extends State<ServiceOthers> {
  final SubscribeEcasController subscribeEcasController =
      Get.put(SubscribeEcasController());
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(children: [
          const SizedBox(height: 25),
          OthersCard(
            title: 'Update KYC',
            subtitle: 'Update your KYC here',
            svgPath: "assets/changeemail.svg",
            onTap: () {
              // Handle the tap event
            },
          ),
          const SizedBox(height: 10),
          // OthersCard(
          //   title: 'Change Mobile Number',
          //   subtitle: 'simply dummy text of the typesetting',
          //   svgPath: "assets/changemobilenumber.svg",
          //   onTap: () {
          //     // Handle the tap event
          //   },
          // ),
          // const SizedBox(height: 10),
          OthersCard(
            title: 'Update Nominee Details',
            subtitle: 'Update Nominee Details',
            svgPath: "assets/changenomiedetail.svg",
            onTap: () {
              // Handle the tap event
            },
          ),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor:
                  NsdlInvestor360Colors.lightGrey4, // Set the divider color
            ),
            child: ExpansionTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: SvgPicture.asset("assets/ecas.svg"),
                ),
              ),
              title: const Text(
                'eCAS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text('simply dummy text of the typesetting'),
              children: <Widget>[
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/subscribe.svg"),
                    ),
                  ),
                  title: const Text(
                    'Subscribe',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    subscribeEcasController.getEcasDetailsApi(
                        "IN487875", "12055001");
                    //Get.toNamed(Routes.subscribeEcas.name);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: SvgPicture.asset("assets/ecasService.svg"),
                    ),
                  ),
                  title: const Text(
                    'eCAS Services',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.toNamed(Routes.ecasServices.name);
                  },
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: NsdlInvestor360Colors.lightGrey4,
            indent: 80,
          ),
        ]));
  }
}

class OthersCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgPath;
  final VoidCallback onTap;

  const OthersCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            //   padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SvgPicture.asset(svgPath),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const SizedBox(height: 5),
        const Divider(
          height: 1,
          color: NsdlInvestor360Colors.lightGrey4,
          indent: 80,
        ),
      ],
    );
  }
}
