import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:investor360/routes/routes.dart';
import 'package:investor360/shared/style/colors.dart';

class Transact extends StatelessWidget {
  const Transact({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 25),
          // TransactTile(
          //   title: 'e-DIS',
          //   subtitle: 'Facility for Off Market Instruction',
          //   svgPath: "assets/edis.svg",
          //   onTap: () {
          //     // Handle the tap event
          //   },
          // ),
          TransactTile(
            title: 'Beneficiary Details',
            subtitle: ' Add , View and Delete Beneficiaries',
            svgPath: "assets/mfRedemption.svg",
            onTap: () {
            //  Get.toNamed(Routes.beneficiary.name);
            },
          ),
          TransactTile(
            title: 'Off Market Instruction',
            subtitle: 'Facility for Off Market Instruction',
            svgPath: "assets/offmarketimg.svg",
            onTap: () {
              // Handle the tap event
            },
          ),
          const SizedBox(height: 10),
          TransactTile(
            title: 'On Market Instruction',
            subtitle: 'Facility for On Market Instruction',
            svgPath: "assets/repledge.svg",
            onTap: () {
              // Handle the tap event
            },
          ),
          TransactTile(
            title: 'e-Voting',
            subtitle: 'Facility for E-Voting',
            svgPath: "assets/evoting.svg",
            onTap: () {
              Get.toNamed(Routes.eVoting.name);
            },
          ),
          TransactTile(
            title: 'MF Redemption',
            subtitle: 'Facility for MF Redemption',
            svgPath: "assets/mfRedemption.svg",
            onTap: () {
              // Handle the tap event
            },
          ),
          TransactTile(
            title: 'Margin Pledge Acceptance',
            subtitle: 'Facility for Margin Pledge Acceptance',
            svgPath: "assets/mpi.svg",
            onTap: () {
              // Handle the tap event
            },
          ),
          TransactTile(
            title: 'eDIS Confirmation',
            subtitle: 'Facility for eDIS Confirmation',
            svgPath: "assets/confirmedis.svg",
            onTap: () {
              // Handle the tap event
            },
          ),
          // TransactTile(
          //   title: 'Margin Pledge Re-Pledge',
          //   subtitle: 'Facility for Off Market Instruction',
          //   svgPath: "assets/repledge.svg",
          //   onTap: () {
          //     // Handle the tap event
          //   },
          // ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class TransactTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgPath;
  final VoidCallback onTap;

  const TransactTile({
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
            padding: const EdgeInsets.all(0.0),
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
        Divider(
          height: 1,
          color: NsdlInvestor360Colors.lightGrey4,
          indent: 80,
        ),
      ],
    );
  }
}
