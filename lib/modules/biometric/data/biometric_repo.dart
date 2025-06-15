// import '../../../shared/http/master_provider.dart';

// class BiometricRepo{

//   MasterProvider masterProvider = MasterProvider();

//  /* Future getSession(ReqGetSession reqGetSession) async {
//     String resourceUrl = ApiUrlEndpoint.getSession;
//     final response = await masterProvider.post(resourceUrl, reqGetSession);
//     try {
//       RespGetSession respGetSession = RespGetSession.fromJson(response.data);
//       // return response;
//       return respGetSession;
//     } catch(e) {
//       return response;
//     }
//   }

//   Future fetchCardDetailsv1(ReqFetchCardDetailsV1 reqFetchCardDetailsV1) async {
//     String resourceUrl = ApiUrlEndpoint.fetchCardDetailsv1;
//     // return masterProvider.post(resourceUrl, reqFetchCardDetailsV1);
//     final response = await masterProvider.post(resourceUrl, reqFetchCardDetailsV1);
//     try {
//       RespFetchCardDetailsV1 respFetchCardDetailsV1 = RespFetchCardDetailsV1.fromJson(response.data);
//       return respFetchCardDetailsV1.customerData?.first ?? respFetchCardDetailsV1.response;
//     } catch (e) {
//       return response;
//     }
//   }

//   Future cardInternationalStatusEcomm(ReqCardInternationalStatus reqCardInternationalStatus) async {
//     String resourceUrl = ApiUrlEndpoint.cardInternationalStatus;
//     return masterProvider.post(resourceUrl, reqCardInternationalStatus);
//   }

//   Future changeCardStatusApi(ReqChangeCardStatus reqChangeCardStatus) async {
//     String resourceUrl = ApiUrlEndpoint.changeCardStatus;
//     return masterProvider.post(resourceUrl, reqChangeCardStatus);
//   }

//   Future setCardLimit(ReqSetCardLimit reqSetCardLimit) async {
//     String resourceUrl = ApiUrlEndpoint.setCardLimit;
//     return masterProvider.post(resourceUrl, reqSetCardLimit);
//   }

//   Future converttoPhysDC(ReqConverttoPhysDC reqConverttoPhysDC) async {
//     String resourceUrl = ApiUrlEndpoint.converttoPhysDC;
//     return masterProvider.post(resourceUrl, reqConverttoPhysDC);
//   }

//   Future getCardProductlist(ReqGetProductList reqGetProductList) async {
//     String resourceUrl = ApiUrlEndpoint.getCardProductlist;
//     // return masterProvider.post(resourceUrl, reqGetProductList);
//     final response = await masterProvider.post(resourceUrl, reqGetProductList);
//     try {
//       RespGetCardProductList respGetCardProductList =RespGetCardProductList.fromJson(response.data);
//       return respGetCardProductList.cardProdlist ?? respGetCardProductList.response;
//     } catch (e) {
//       return response;
//     }
//   }

//   Future generateCardApi(ReqGenerateCard reqGenerateCard) async {
//     String resourceUrl = ApiUrlEndpoint.generateCardME;
//     return masterProvider.post(resourceUrl, reqGenerateCard);
//   }


//   Future getCVVDeatils(ReqGetCVVDetails getCVVDetails) async {
//     String resourceUrl = ApiUrlEndpoint.getCVVdetailsME;
//     // return masterProvider.post(resourceUrl, getCVVDetails);
//     final response = await masterProvider.post(resourceUrl, getCVVDetails);
//     try {
//       RespGetCVVDetails respGetCVVDetails =RespGetCVVDetails.fromJson(response.data);
//       return respGetCVVDetails.customerData?.first ?? respGetCVVDetails.response;
//     } catch (e) {
//       return response;
//     }
//   }


//   Future getnewPinSetMEApi(ReqNewPinSet reqNewPinSet) async {
//     String resourceUrl = ApiUrlEndpoint.getnewPinSetME;
//     return masterProvider.post(resourceUrl, reqNewPinSet);
//   }*/
// }