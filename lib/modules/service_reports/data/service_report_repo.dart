import 'package:investor360/modules/dashboard/model/GetNsdlHoldingDataRequest.dart';
import 'package:investor360/modules/service_reports/model/createCmrFileRequest.dart';
import 'package:investor360/modules/service_reports/model/createSoaFileRequest.dart';
import 'package:investor360/modules/service_reports/model/createSotFileRequest.dart';
import 'package:investor360/modules/service_reports/model/generateSftFileRequest.dart';
import 'package:investor360/modules/service_reports/model/getCmrFileRequest.dart';
import 'package:investor360/modules/service_reports/model/getCmrListRequest.dart';
import 'package:investor360/modules/service_reports/model/getEcasRequest.dart';
import 'package:investor360/modules/service_reports/model/getFinancialQrtzRequest.dart';
import 'package:investor360/modules/service_reports/model/getSftFileListRequest.dart';
import 'package:investor360/modules/service_reports/model/getSoaFileListRequest.dart';
import 'package:investor360/modules/service_reports/model/getSoaFileRequest.dart';
import 'package:investor360/modules/service_reports/model/getSoftFileRequest.dart';
import 'package:investor360/modules/service_reports/model/getSotFIleRequest.dart';
import 'package:investor360/modules/service_reports/model/getSotListRequest.dart';
import 'package:investor360/shared/http/master_provider.dart';
import 'package:investor360/utils/api_url_endpoint.dart';

import '../model/GetEcasPdfRequest.dart';

class ServiceReportRepo {
  MasterProvider masterProvider = MasterProvider();
  //Ecas API
  Future getEcas(GetEcasRequest getcas) async {
    String resourceUrl = ApiUrlEndpoint.ecas;
    return masterProvider.post(resourceUrl, getcas, false);
  }

  Future getEcasPdf(GetEcasPdfRequest getEcasPdfRequest) async {
    String resourceUrl = ApiUrlEndpoint.ecasPdf;
    return masterProvider.post(resourceUrl, getEcasPdfRequest, true);
  }

  //SOT API
  Future getSotList(GetSotListRequest getSotListRequest) async {
    String resourceUrl = ApiUrlEndpoint.sotList;
    return masterProvider.post(resourceUrl, getSotListRequest, false);
  }

  Future createSotFile(CreateSotFileRequest createSotFileRequest) async {
    String resourceUrl = ApiUrlEndpoint.createSot;
    return masterProvider.post(resourceUrl, createSotFileRequest, false);
  }

  Future getSotFile(GetSotFileRequest getSotFileRequest) async {
    String resourceUrl = ApiUrlEndpoint.getSotFile;
    return masterProvider.post(resourceUrl, getSotFileRequest, true);
  }

  //CMR API
  Future getCmrList(Getcmrlistrequest getcmrlist) async {
    String resourceUrl = ApiUrlEndpoint.cmrList;
    return masterProvider.post(resourceUrl, getcmrlist, false);
  }

  Future createCmrFile(CreateCmrFileRequest createCmrFile) async {
    String resourceUrl = ApiUrlEndpoint.createCmr;
    return masterProvider.post(resourceUrl, createCmrFile, false);
  }

  Future getCmrFile(GetCmrFileRequest getCmrFileRequest) async {
    String resourceUrl = ApiUrlEndpoint.getCmrFile;
    return masterProvider.post(resourceUrl, getCmrFileRequest, true);
  }

  Future getFinancialQrts(GetFinancialqrtzRequest getFinancialQrts) async {
    String resourceUrl = ApiUrlEndpoint.getfinancialqrts;
    return masterProvider.post(resourceUrl, getFinancialQrts, false);
  }

  Future generateSftFile(GenerateSftFileRequest generateSftFile) async {
    String resourceUrl = ApiUrlEndpoint.generatesftfile;
    return masterProvider.post(resourceUrl, generateSftFile, false);
  }

  Future getSftFileList(GetSftFileListRequest getSftfileList) async {
    String resourceUrl = ApiUrlEndpoint.getSftFileList;
    return masterProvider.post(resourceUrl, getSftfileList, false);
  }

  Future getSftFile(GetSoftFileRequest getSftfile) async {
    String resourceUrl = ApiUrlEndpoint.getsftfile;
    return masterProvider.post(resourceUrl, getSftfile, true);
  }

  Future getSoaFileList(GetSoaFileListRequest getSoafileList) async {
    String resourceUrl = ApiUrlEndpoint.getSoaFileList;
    return masterProvider.post(resourceUrl, getSoafileList, false);
  }

  Future generateSoaFile(CreateSoaFileRequest generateSoaFile) async {
    String resourceUrl = ApiUrlEndpoint.generatesoafile;
    return masterProvider.post(resourceUrl, generateSoaFile, false);
  }

  Future getSoaFile(GetSoaFileRequest getSoaFileRequest) async {
    String resourceUrl = ApiUrlEndpoint.getsoafile;
    return masterProvider.post(resourceUrl, getSoaFileRequest, true);
  }
}
