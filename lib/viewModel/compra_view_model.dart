import 'package:flutter/foundation.dart';
import '../data/models/camiseta_model.dart';
import '../data/models/compra_model.dart';

/// ViewModel da tela de Compra — gerencia estado do formulário de pedido.
class CompraViewModel extends ChangeNotifier {
  final Camiseta camiseta;

  CompraViewModel({required this.camiseta}) {
    // Inicializa tamanho com o primeiro disponível
    _tamanhoSelecionado = camiseta.tamanhos.isNotEmpty
        ? camiseta.tamanhos.first
        : 'M';
  }

  // Estado do formulário
  int _quantidade = 1;
  int _parcelas = 1;
  String _tamanhoSelecionado = 'M';

  // Getters — encapsulamento
  int get quantidade => _quantidade;
  int get parcelas => _parcelas;
  String get tamanhoSelecionado => _tamanhoSelecionado;

  /// Calcula o valor total considerando quantidade e juros (RF09 + RF11).
  /// Juros: 0,5% por parcela acima da primeira.
  double get valorTotal {
    final subtotal = camiseta.preco * _quantidade;
    if (_parcelas <= 1) return subtotal;

    // Adiciona 0,5% de juros por parcela acima da primeira — RF11
    final juros = (_parcelas - 1) * 0.005;
    return subtotal * (1 + juros);
  }

  /// Valor de cada parcela com juros aplicados.
  double get valorParcela => valorTotal / _parcelas;

  /// Percentual de juros total aplicado.
  double get percentualJuros {
    if (_parcelas <= 1) return 0.0;
    return (_parcelas - 1) * 0.5;
  }

  /// Incrementa quantidade respeitando limite de 1 a 5 (RF08).
  void incrementarQuantidade() {
    if (_quantidade < 5) {
      _quantidade++;
      notifyListeners();
    }
  }

  /// Decrementa quantidade respeitando limite mínimo de 1 (RF08).
  void decrementarQuantidade() {
    if (_quantidade > 1) {
      _quantidade--;
      notifyListeners();
    }
  }

  /// Atualiza parcelas respeitando limite de 1 a 6 (RF10).
  void atualizarParcelas(int valor) {
    if (valor >= 1 && valor <= 6) {
      _parcelas = valor;
      notifyListeners();
    }
  }

  /// Atualiza tamanho selecionado (RF07 item 3.1).
  void atualizarTamanho(String tamanho) {
    _tamanhoSelecionado = tamanho;
    notifyListeners();
  }

  /// Constrói o objeto Compra com todos os dados do pedido (RF14).
  Compra construirCompra({
    required String responsavel,
    required String endereco,
  }) {
    return Compra(
      idProduto: camiseta.id,
      tituloProduto: camiseta.titulo,
      tamanho: _tamanhoSelecionado,
      quantidade: _quantidade,
      valorTotal: valorTotal,
      parcelas: _parcelas,
      responsavel: responsavel.trim(),
      endereco: endereco.trim(),
    );
  }

  /// Validação do responsável — mínimo 4 caracteres sem espaços nas bordas (RF12).
  String? validarResponsavel(String? valor) {
    if (valor == null || valor.trim().length < 4) {
      return 'Nome deve ter pelo menos 4 caracteres';
    }
    return null;
  }

  /// Validação do endereço — mínimo 4 caracteres sem espaços nas bordas (RF12).
  String? validarEndereco(String? valor) {
    if (valor == null || valor.trim().length < 4) {
      return 'Endereço deve ter pelo menos 4 caracteres';
    }
    return null;
  }
}
