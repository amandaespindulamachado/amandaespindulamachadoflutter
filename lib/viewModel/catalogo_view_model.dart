import 'package:flutter/foundation.dart';
import '../data/models/camiseta_model.dart';
import '../data/models/compra_model.dart';
import '../data/repositories/camiseta_repository.dart';

/// ViewModel do Catálogo — camada MVVM entre View e Repository.
/// Estende ChangeNotifier para notificar a View sobre mudanças de estado.
class CatalogoViewModel extends ChangeNotifier {
  final CamisetaRepository _repository;

  CatalogoViewModel({CamisetaRepository? repository})
      : _repository = repository ?? CamisetaRepository();

  // Estado interno
  List<Camiseta> _todasCamisetas = [];
  List<Camiseta> _camisetasFiltradas = [];
  bool _isLoading = false;
  String? _erro;
  bool _exibirGrid = false;
  String _termoBusca = '';
  double _precoMin = 0.0;
  double _precoMax = 200.0;

  // Getters públicos — encapsulamento
  List<Camiseta> get camisetas => _camisetasFiltradas;
  bool get isLoading => _isLoading;
  String? get erro => _erro;
  bool get exibirGrid => _exibirGrid;
  String get termoBusca => _termoBusca;
  double get precoMin => _precoMin;
  double get precoMax => _precoMax;
  double get precoMaximoSlider => _precoMaximoSlider;

  double _precoMaximoSlider = 200.0;

  /// Carrega a lista de camisetas do repository.
  void carregarCamisetas() {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    try {
      _todasCamisetas = _repository.getCamisetas();

      // Calcula o maior preço usando reduce (via repository) para definir o slider
      _precoMaximoSlider = _repository.getPrecoMaximo(_todasCamisetas);
      _precoMax = _precoMaximoSlider;

      // Log de validação — uso de every (via repository)
      final todasComImagem = _repository.todasComImagem(_todasCamisetas);
      debugPrint('Todas com imagem: $todasComImagem');

      _aplicarFiltros();
    } catch (e) {
      _erro = 'Erro ao carregar camisetas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Alterna entre visualização em lista e grid (RF03).
  void alternarVisualizacao() {
    _exibirGrid = !_exibirGrid;
    notifyListeners();
  }

  /// Atualiza o termo de busca e reaplica filtros (RF04 item 1).
  void atualizarBusca(String termo) {
    _termoBusca = termo;
    _aplicarFiltros();
  }

  /// Atualiza o preço mínimo e reaplica filtros (RF04 item 2).
  void atualizarPrecoMin(double valor) {
    _precoMin = valor;
    _aplicarFiltros();
  }

  /// Atualiza o preço máximo e reaplica filtros (RF04 item 2).
  void atualizarPrecoMax(double valor) {
    _precoMax = valor;
    _aplicarFiltros();
  }

  /// Aplica todos os filtros ativos sobre a lista completa.
  /// Trafega dados entre camadas (ViewModel → Repository → ViewModel).
  void _aplicarFiltros() {
    _camisetasFiltradas = _repository.filtrar(
      lista: _todasCamisetas,
      termo: _termoBusca,
      precoMin: _precoMin,
      precoMax: _precoMax,
    );
    notifyListeners();
  }

  /// Limpa todos os filtros e restaura a lista completa.
  void limparFiltros() {
    _termoBusca = '';
    _precoMin = 0.0;
    _precoMax = _precoMaximoSlider;
    _aplicarFiltros();
  }

  /// Finaliza a compra — trafega o objeto Compra até a camada de serviço (RF15 item 3).
  void finalizarCompra(Compra compra) {
    _repository.finalizarCompra(compra);
  }
}
