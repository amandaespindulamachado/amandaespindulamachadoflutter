import '../datasources/camiseta_datasource.dart';
import '../models/camiseta_model.dart';
import '../models/compra_model.dart';

/// Repository — faz a ponte entre Datasource e ViewModel.
/// Responsável por transformar o JSON em lista de entidades (RF01).
class CamisetaRepository {
  final CamisetaDatasource _datasource;

  CamisetaRepository({CamisetaDatasource? datasource})
      : _datasource = datasource ?? CamisetaDatasource();

  /// Busca os dados brutos e converte em List<Camiseta>.
  /// Utiliza map + arrow function + where (métodos avançados RF técnico).
  List<Camiseta> getCamisetas() {
    try {
      final jsonList = _datasource.getCamisetasJson();

      // Uso de map com arrow function — requisito técnico
      final camisetas = jsonList
          .map<Camiseta>((json) => Camiseta.fromJson(json))
          .toList();

      return camisetas;
    } catch (e) {
      // Tratamento de erro — retorna lista vazia em caso de falha
      return [];
    }
  }

  /// Filtra camisetas pelo título (RF04 item 1).
  /// Uso de where — método avançado
  List<Camiseta> filtrarPorTitulo(List<Camiseta> lista, String termo) {
    if (termo.trim().isEmpty) return lista;
    return lista
        .where((c) => c.titulo.toLowerCase().contains(termo.toLowerCase()))
        .toList();
  }

  /// Filtra camisetas por faixa de preço (RF04 item 2).
  /// Uso de where — método avançado
  List<Camiseta> filtrarPorPreco(
    List<Camiseta> lista,
    double precoMin,
    double precoMax,
  ) {
    return lista
        .where((c) => c.preco >= precoMin && c.preco <= precoMax)
        .toList();
  }

  /// Filtra por título E faixa de preço simultaneamente.
  /// Uso de operadores lógicos compostos — requisito técnico
  List<Camiseta> filtrar({
    required List<Camiseta> lista,
    required String termo,
    required double precoMin,
    required double precoMax,
  }) {
    return lista.where((c) {
      final matchTitulo =
          termo.trim().isEmpty ||
          c.titulo.toLowerCase().contains(termo.toLowerCase());
      final matchPreco = c.preco >= precoMin && c.preco <= precoMax;
      return matchTitulo && matchPreco;
    }).toList();
  }

  /// Retorna o maior preço da lista usando reduce — método avançado
  double getPrecoMaximo(List<Camiseta> lista) {
    if (lista.isEmpty) return 200.0;
    return lista.reduce((a, b) => a.preco > b.preco ? a : b).preco;
  }

  /// Verifica se todas as camisetas têm imagem — uso de every — método avançado
  bool todasComImagem(List<Camiseta> lista) {
    return lista.every((c) => c.imagemAsset.isNotEmpty);
  }

  /// Busca uma camiseta pelo id — uso de firstWhere — método avançado
  Camiseta? buscarPorId(List<Camiseta> lista, int id) {
    try {
      return lista.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Envia a compra para a camada de datasource (RF15 item 3 — caminho inverso).
  void finalizarCompra(Compra compra) {
    _datasource.registrarCompra(compra);
  }
}
