import 'package:dio_viacep/models/viacep_b4app_model.dart';
import 'package:dio_viacep/models/viacep_model.dart';
import 'package:dio_viacep/repositories/viacep_b4app_repository.dart';
import 'package:flutter/material.dart';

class CepHistory extends StatefulWidget {
  const CepHistory({super.key});

  @override
  State<CepHistory> createState() => _CepHistoryState();
}

class _CepHistoryState extends State<CepHistory> {
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

  Widget _showEditDialog(ViacepB4AModel cep) {
    return AlertDialog(
      title: Text("Editar CEP"),
      content: SizedBox(
        height: 300,
        child: TextField(
          controller: cepController,
          keyboardType: TextInputType.number,
          onChanged: (value) async {
            var novoCep = formatCep(value);
            if (novoCep.length == 8) {
              viacepModel = await viacepRepository.consultarViaCep(novoCep);
            }
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () async {
            cep.cep = viacepModel.cep;
            cep.logradouro = viacepModel.logradouro;
            cep.complemento = viacepModel.complemento;
            cep.unidade = viacepModel.unidade;
            cep.bairro = viacepModel.bairro;
            cep.localidade = viacepModel.localidade;
            cep.uf = viacepModel.uf;
            cep.estado = viacepModel.estado;
            cep.regiao = viacepModel.regiao;
            cep.ibge = viacepModel.ibge;
            cep.gia = viacepModel.gia;
            cep.ddd = viacepModel.ddd;
            cep.siafi = viacepModel.siafi;

            var hasCep = b4aCeps.contains(cepController.text);
            if (viacepModel.cep == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(

                  backgroundColor: Colors.orange,
                  content: Text(
                    "Insira um CEP Válido",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            } else if (hasCep) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.orange,
                  content: Text(
                    "CEP ja cadastrado",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            } else if (!hasCep && viacepModel.cep != null) {
              await viacepRepository.atualizarCepB4A(cep);
              b4aCeps.clear();
              _loadCeps();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    "CEP Atualizado com sucesso", 
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }            
          }, 
          child: const Text("Salvar"),
        )
      ],
    );
  }

  Widget _showConfirmDeleteDialog(ViacepB4AModel cep) {
    return AlertDialog(
      title: Text("Deseja realmente excluir o CEP?"),
      content: SizedBox(
        height: 200,
        child: Column(
          children: [
            Text(
              cep.cep ?? "",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cep.logradouro ?? "",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${cep.localidade ?? ""} - ${cep.uf ?? ""}",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),       
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          }, 
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () async {
            await viacepRepository.removerCepB4A(cep.objectId!);
            _loadCeps();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  "CEP excluido com sucesso", 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
          child: Text("Excluir"),
        )
      ],
    );
  }

  Widget _buildCepCard(ViacepB4AModel cep) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(12),
      ),
      elevation: 4,
      shadowColor: Colors.blue,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cep.cep!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        cepController.text = "";
                        viacepModel.logradouro = "";
                        viacepModel.localidade = "";
                        viacepModel.uf = "";
                        showDialog(
                          context: context, 
                          builder: (BuildContext bc) { 
                            return _showEditDialog(cep);
                          }
                        );
                      },
                      child: Icon(Icons.edit),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext bc) {
                            return _showConfirmDeleteDialog(cep);
                          },
                        );
                      },
                      child: Icon(Icons.delete_forever_outlined, color: Colors.red,),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 2),
            if ((cep.logradouro != null && cep.logradouro!.isNotEmpty) || (cep.bairro != null && cep.bairro!.isNotEmpty)) ...[
              Row(
                children: [
                  Text(cep.logradouro!),
                  Text(" - ${cep.bairro!}"),
                  if (cep.complemento != null && cep.complemento!.isNotEmpty) Text(" - ${cep.complemento!}"),
                ],
              ),
              const SizedBox(height: 2),
            ],
            if ((cep.localidade != null && cep.localidade!.isNotEmpty) || (cep.uf != null && cep.uf!.isNotEmpty)) ...[
              Row(
                children: [
                  Text(cep.localidade!),
                  Text(" - ${cep.uf!}"),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading 
      ? Center(
        child: CircularProgressIndicator(),
      ) 
      : ListView.builder(
          itemCount: viacepB4AModel.ceps.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 4),
              child: _buildCepCard(viacepB4AModel.ceps[index]),
            );
          },
        );
  }
}