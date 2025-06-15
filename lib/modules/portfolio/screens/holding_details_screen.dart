import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:investor360/shared/style/colors.dart';

import '../../../utils/formatnumber.dart';
import '../../dashboard/model/GetNsdlHoldingDataResponse.dart';
import '../controller/PortfolioController.dart';
import 'others.dart';

class HoldingDetail extends StatelessWidget {
  final int selectedIndexHolding;
  final String securityType;
  final PortfolioController portfolioController = Get.find<PortfolioController>();

  HoldingDetail({Key? key, required this.selectedIndexHolding, required this.securityType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool darkMode = ThemeUtils.isDarkMode(context);
    return Scaffold(
      appBar:AppBar(
        backgroundColor: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :  NsdlInvestor360Colors.bottomCardHomeColour0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Row(
          children: [
            Expanded(
              child: Text(
                "Holding Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Container(
        decoration:  BoxDecoration(
          color: darkMode ? NsdlInvestor360Colors.bottomCardHomeColour3Dark :NsdlInvestor360Colors.bottomCardHomeColour0,
        ),
        child: SingleChildScrollView(
          child: Obx(() {


            // Filter holdings by security type
            List<HoldingDataList> holding = portfolioController.filteredHoldings.where((holding) => holding.securityType == securityType).toList();

            /*if (selectedIndexHolding < 0 || selectedIndexHolding >= holding.length) {
              return Center(
                child: Text("Invalid index", style: TextStyle(color: Colors.white)),
              );
            }
*/
            final currentHolding = holding[selectedIndexHolding];


      /*      List<HoldingDataList> holding = portfolioController.filteredHoldings
                .where((holding) => holding.securityType == securityType)
                .toList();



            final currentHolding = holding[selectedIndexHolding];*/


            print( currentHolding.unlockBalance.toString());
            return Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          currentHolding.companyName ?? 'Unknown Company',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ISIN: ${currentHolding.isin ?? 'Unknown ISIN'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    color: Colors.white70,
                    thickness: 1,
                    height: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Qty',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        formatNumberWithCommasHoldinDetails(double.parse(currentHolding.totalPosition?.toString() ?? '0')),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Market Price',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "\u20B9${formatNumberWithCommas(currentHolding.closingPrice ?? '0')}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Current Value',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        "\u20B9${formatNumberWithCommas(double.parse(currentHolding.totalValue.toString() ?? '0'))}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: Container(
                    decoration:  BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                      color: darkMode? NsdlInvestor360Colors.darkmodeBlack : NsdlInvestor360Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          const Text(
                            'MORE INFO',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 24,
                          ),
                          const SizedBox(height: 10),
                          MoreInfoRow(
                            title: 'Beneficiary Free Balance',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.unlockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Block',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.blockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Lockin',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.lockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Demat Unlock',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.dematUnlockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Remat Unlock',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.rematUnlockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Remat Lockin',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.rematLockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Pledge',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.pledgeUnlockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Pledge Lockin',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.pledgeLockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Pledge Transit Unlock',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.pledgeTransitUnlockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Pledge Lockin Transit',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.pledgeTransitLockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Blocked IDT',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse("0.000"))}",
                          ),
                          MoreInfoRow(
                            title: 'Hold Lock Balance',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.holdLockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Hold Transit Lock Balance',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.holdTransitLockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Hold Transit Unlock Balance',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.holdTransitUnlockBalance?.toString() ?? '0'))}",
                          ),
                          MoreInfoRow(
                            title: 'Hold Unlock Balance',
                            value: "${formatNumberWithCommasHoldinDetails(double.parse(currentHolding.holdUnlockBalance?.toString() ?? '0'))}",
                          ),
                          SizedBox(height: 50,)
                          /*    const Text(
                            'TRANSACTION DETAILS',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                        Divider(
                            color: Colors.grey,
                            thickness: 1,
                            height: 24,
                          ),
                          SizedBox(height: 8),
                          TransactionItem(
                            date: '12 Jun 2024',
                            quantity: '10,500',
                            acqPrice: '₹133.00',
                            totalPrice: '₹8,180.00',
                          ),
                          TransactionItem(
                            date: '11 Jun 2024',
                            quantity: '500',
                            acqPrice: '₹155.00',
                            totalPrice: '₹6,280.00',
                          ),*/
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );

  }
}

class MoreInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const MoreInfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}


class TransactionItem extends StatelessWidget {
  final String date;
  final String quantity;
  final String acqPrice;
  final String totalPrice;

  const TransactionItem({
    super.key,
    required this.date,
    required this.quantity,
    required this.acqPrice,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              quantity,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Acq. Price. $acqPrice',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              totalPrice,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
