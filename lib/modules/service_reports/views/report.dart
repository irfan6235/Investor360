import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../shared/style/colors.dart';
import 'package:get/get.dart';
import 'package:investor360/routes/routes.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          const SizedBox(height: 25),
          ReportCard(
            title: 'Client Master Reports',
            subtitle: 'Clients Master reports can be Downloaded',
            svgPath: "assets/client_report.svg",
            onTap: () {
              Get.toNamed(Routes.clientMasterReport.name);
            },
          ),
          ReportCard(
            title: 'eCAS',
            subtitle: 'E-CAS can be Downloaded',
            svgPath: "assets/ecas.svg",
            onTap: () {
              Get.toNamed(Routes.ecas.name);
            },
          ),
          const SizedBox(height: 10),
          // const SizedBox(height: 10),
          // ReportCard(
          //   title: 'Statement of Holding',
          //   subtitle: 'simply dummy text of the typesetting',
          //   svgPath: "assets/soh.svg",
          //   onTap: () {
          //     // Handle the tap event
          //   },
          // ),
          // const SizedBox(height: 10),
          ReportCard(
            title: 'Statement of Transaction',
            subtitle: 'Statement of Transaction can be Downloaded',
            svgPath: "assets/sot.svg",
            onTap: () {
              Get.toNamed(Routes.statementOfTransaction.name);
            },
          ),
          const SizedBox(height: 10),
          ReportCard(
            title: 'Statement of Financial Txn',
            subtitle: 'Statement of Financial Txn can be Downloaded',
            svgPath: "assets/sof.svg",
            onTap: () {
              Get.toNamed(Routes.statementOfFinancialTxn.name);
            },
          ),
          const SizedBox(height: 10),
          ReportCard(
            title: 'Statement of Account',
            subtitle: 'Statement of Account can be Downloaded',
            svgPath: "assets/soaimg.svg",
            onTap: () {
              Get.toNamed(Routes.statementOfAccount.name);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgPath;
  final VoidCallback onTap;

  const ReportCard({
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
