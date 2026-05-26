import 'package:dio_viacep/models/viacep_b4app_model.dart';
import 'package:dio_viacep/models/viacep_model.dart';
import 'package:dio_viacep/repositories/viacep_b4app_repository.dart';
import 'package:flutter/material.dart';

class ConsultaCep extends StatefulWidget {
  const ConsultaCep({super.key});

  @override
  State<ConsultaCep> createState() => _ConsultaCepState();
}

class _ConsultaCepState extends State<ConsultaCep> {
  TextEditingController cepController = TextEditingController(text: "");

  var viacepModel = ViaCEPModel();
  var viacepB4AModel = ViaCepBack4AppModel([]);
  var viacepRepository = ViaCepB4appRepository();
  List b4aCeps = [];

  bool _isLoading = false;

  @override
  void initState() {
    _loadCeps();
    super.initState();
  }

  void _loadCeps() async {
    setState(() {
      _isLoading = true;
    });

    try {
      viacepB4AModel = await viacepRepository.obterCepsB4A();
      for (var i = 0; i <= viacepB4AModel.ceps.length - 1; i++) {
        if (viacepB4AModel.ceps[i].cep == null) return;
        var formattedCep = formatCep(viacepB4AModel.ceps[i].cep!);
        b4aCeps.add(formattedCep);
      }
      print("Lista: $b4aCeps");
    } catch (e) {
      throw Exception('Erro ao carregar CEPs do Back 4 App: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String formatCep(String cep) {
    var formattedCep = cep.replaceAll(RegExp(r'[^0-9]'), '');
    return formattedCep;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Text(
                "Consulta de CEP",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLength: 8,
                controller: cepController,
                keyboardType: TextInputType.number,
                onChanged: (value) async {
                  var cep = formatCep(value);
                  if (cep.length == 8) {
                    setState(() {
                      _isLoading = true;
                    });
                    viacepModel = await viacepRepository.consultarViaCep(cep);
                    var hasCep = b4aCeps.contains(cepController.text);
                    if (!hasCep && viacepModel.cep != null) {
                      await viacepRepository.criarCepB4A(viacepModel);
                    } else if (hasCep) {}
                    b4aCeps.clear();
                    _loadCeps();
                  }
                  setState(() {
                    _isLoading = false;
                  });
                },
              ),
              const SizedBox(height: 24),
              // Widget para setar visibilidade de coisas
              Visibility(
                visible: _isLoading,
                child: CircularProgressIndicator(),
              ),
              // Ou fazer com IF
              if (_isLoading) CircularProgressIndicator(),
              if (cepController.text.isNotEmpty && cepController.text.length == 8 && !_isLoading && viacepModel.cep == null) ...[
                Text("Insira um CEP Válido", style: TextStyle(fontSize: 20, color: Colors.red),),
              ] else ...[
                Text(
                  viacepModel.logradouro ?? "",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${viacepModel.localidade ?? ""} - ${viacepModel.uf ?? ""}",
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}