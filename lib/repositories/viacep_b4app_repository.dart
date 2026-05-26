import 'dart:convert';

import 'package:dio_viacep/models/viacep_b4app_model.dart';
import 'package:dio_viacep/models/viacep_model.dart';
import 'package:dio_viacep/repositories/back4app_custom_dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ViaCepB4appRepository {
  final _customDio = Back4appCustomDio();

  final baseViaCepUrl = dotenv.get("VIA_CEP_BASE_URL");

  ViaCepB4appRepository();
  
  Future<ViaCepBack4AppModel> obterCepsB4A() async {
    var url = "/viacep";
    var result = await _customDio.dio.get(url);

    return ViaCepBack4AppModel.fromJson(result.data);
  }

  Future<void> criarCepB4A(ViaCEPModel cep) async {
    try {
      await _customDio.dio.post("/viacep", data: cep.toJsonEndpoint()); 
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizarCepB4A(ViacepB4AModel cep) async {
    try {
      await _customDio.dio.put("/viacep/${cep.objectId}", data: cep.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }   
  }

  Future<void> removerCepB4A(String objectId) async {
    try {
      await _customDio.dio.delete("/viacep/$objectId");
    } catch (e) {
      rethrow;
    }   
  }

  Future<ViaCEPModel> consultarViaCep(String cep) async {
    var response = await http.get(Uri.parse("$baseViaCepUrl/$cep/json"));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      return ViaCEPModel.fromJson(json);
    }
    return ViaCEPModel();
  }
}