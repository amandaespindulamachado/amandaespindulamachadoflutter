/// Entidade que representa um Pedido de Compra (RF14).
/// Contém todos os dados pertinentes ao pedido.
class Compra {
  final int idProduto;
  final String tituloProduto;
  final String tamanho;
  final int quantidade;
  final double valorTotal;
  final int parcelas;
  final String responsavel;
  final String endereco;

  // Atributo privado — encapsulamento
  final double _valorParcela;
  double get valorParcela => _valorParcela;

  Compra({
    required this.idProduto,
    required this.tituloProduto,
    required this.tamanho,
    required this.quantidade,
    required this.valorTotal,
    required this.parcelas,
    required this.responsavel,
    required this.endereco,
  }) : _valorParcela = valorTotal / parcelas;

  /// Converte a entidade para Map<String, dynamic> (usado no print da camada service)
  Map<String, dynamic> toJson() {
    return {
      'idProduto': idProduto,
      'tituloProduto': tituloProduto,
      'tamanho': tamanho,
      'quantidade': quantidade,
      'valorTotal': double.parse(valorTotal.toStringAsFixed(2)),
      'parcelas': parcelas,
      'valorParcela': double.parse(_valorParcela.toStringAsFixed(2)),
      'responsavel': responsavel,
      'endereco': endereco,
    };
  }

  /// Polimorfismo — @override em toString
  @override
  String toString() {
    return 'Compra(idProduto: $idProduto, tamanho: $tamanho, '
        'quantidade: $quantidade, valorTotal: R\$${valorTotal.toStringAsFixed(2)}, '
        'parcelas: $parcelas, responsavel: $responsavel, endereco: $endereco)';
  }
}
