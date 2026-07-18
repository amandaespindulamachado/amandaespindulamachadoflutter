import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/camiseta_model.dart';
import '../viewModel/catalogo_view_model.dart';
import '../viewModel/compra_view_model.dart';

/// Tela 02 — Tela de Compra (RF07 a RF15).
class CompraView extends StatefulWidget {
  static const String routeName = '/compra';

  const CompraView({super.key});

  @override
  State<CompraView> createState() => _CompraViewState();
}

class _CompraViewState extends State<CompraView> {
  final _formKey = GlobalKey<FormState>();
  final _responsavelController = TextEditingController();
  final _enderecoController = TextEditingController();

  late CompraViewModel _viewModel;
  late CatalogoViewModel _catalogoViewModel;
  bool _argumentsLoaded = false;

  final _formatoMoeda =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_argumentsLoaded) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final camiseta = args['camiseta'] as Camiseta;
      _catalogoViewModel = args['viewModel'] as CatalogoViewModel;
      _viewModel = CompraViewModel(camiseta: camiseta);
      _viewModel.addListener(_onViewModelChanged);
      _argumentsLoaded = true;
    }
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _responsavelController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  /// Finaliza a compra com validação completa (RF13 + RF15).
  void _finalizarCompra() {
    // RF13 — valida formulário e exibe erros via Validator
    final valido = _formKey.currentState!.validate();

    if (!valido) {
      // RF13 — Snackbar de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Preencha todos os campos corretamente'),
            ],
          ),
          backgroundColor: const Color(0xFFE94560),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // RF14 — Constrói o objeto de compra
    final compra = _viewModel.construirCompra(
      responsavel: _responsavelController.text,
      endereco: _enderecoController.text,
    );

    // RF15 item 3 — Trafega a entidade até a camada de serviço
    _catalogoViewModel.finalizarCompra(compra);

    // RF15 item 1 — Snackbar de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Compra realizada com sucesso!'),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    // RF15 item 5 — Navega de volta ao catálogo após o snackbar
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/catalogo',
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_argumentsLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final camiseta = _viewModel.camiseta;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🛒 Finalizar Compra',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // RF07 item 1 e 2 — Imagem e preço unitário
              _buildCabecalhoProduto(camiseta),
              const SizedBox(height: 20),

              // RF07 item 3 — Formulário completo
              _buildFormulario(camiseta),
              const SizedBox(height: 20),

              // RF07 item 4 — Card de total da compra
              _buildCardTotal(),
              const SizedBox(height: 24),

              // RF07 item 5 — Botão finalizar
              ElevatedButton.icon(
                onPressed: _finalizarCompra,
                icon: const Icon(Icons.shopping_bag),
                label: const Text(
                  'Finalizar Compra',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cabeçalho com imagem + preço unitário (RF07 itens 1 e 2).
  Widget _buildCabecalhoProduto(Camiseta camiseta) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Imagem com tratamento de erro
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                camiseta.imagemAsset,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: const Color(0xFF1A1A2E),
                    child: const Icon(
                      Icons.music_note,
                      color: Color(0xFFE94560),
                      size: 48,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    camiseta.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    camiseta.banda,
                    style: const TextStyle(
                      color: Color(0xFFE94560),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Preço unitário:',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _formatoMoeda.format(camiseta.preco),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Formulário completo (RF07 item 3 + RF08 + RF09 + RF10 + RF12 + RF13).
  Widget _buildFormulario(Camiseta camiseta) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalhes do Pedido',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // RF07 item 3.1 — Tamanho (DropdownButton)
            const Text('Tamanho', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _viewModel.tamanhoSelecionado,
              dropdownColor: const Color(0xFF0F3460),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFFE94560)),
                ),
                prefixIcon: const Icon(
                  Icons.straighten,
                  color: Color(0xFFE94560),
                ),
              ),
              items: camiseta.tamanhos
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(t),
                    ),
                  )
                  .toList(),
              onChanged: (valor) {
                if (valor != null) _viewModel.atualizarTamanho(valor);
              },
            ),
            const SizedBox(height: 16),

            // RF07 item 3.2 — Quantidade com controle +/- (RF08: 1 a 5)
            const Text('Quantidade', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Row(
              children: [
                // Decrementa — desabilitado se quantidade = 1
                IconButton(
                  onPressed: _viewModel.quantidade > 1
                      ? _viewModel.decrementarQuantidade
                      : null,
                  icon: const Icon(Icons.remove_circle_outline),
                  color: const Color(0xFFE94560),
                  iconSize: 32,
                ),
                Container(
                  width: 60,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A2E),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE94560)),
                  ),
                  child: Text(
                    '${_viewModel.quantidade}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Incrementa — desabilitado se quantidade = 5
                IconButton(
                  onPressed: _viewModel.quantidade < 5
                      ? _viewModel.incrementarQuantidade
                      : null,
                  icon: const Icon(Icons.add_circle_outline),
                  color: const Color(0xFFE94560),
                  iconSize: 32,
                ),
                const SizedBox(width: 8),
                Text(
                  'Máx: 5 unidades',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // RF07 item 3.3 — Parcelas com Slider (RF10: máx 6)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Parcelas',
                  style: TextStyle(color: Colors.white70),
                ),
                Text(
                  '${_viewModel.parcelas}x de ${_formatoMoeda.format(_viewModel.valorParcela)}',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Slider(
              value: _viewModel.parcelas.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              activeColor: const Color(0xFFE94560),
              inactiveColor: Colors.white24,
              label: '${_viewModel.parcelas}x',
              onChanged: (valor) =>
                  _viewModel.atualizarParcelas(valor.round()),
            ),
            if (_viewModel.parcelas > 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '⚠ Juros: ${_viewModel.percentualJuros.toStringAsFixed(1)}% '
                  '(${_viewModel.parcelas - 1} × 0,5%)',
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(height: 8),

            // RF07 item 3.4 — Nome do comprador com validator (RF12 + RF13)
            TextFormField(
              controller: _responsavelController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nome do comprador *',
                hintText: 'Mínimo 4 caracteres',
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Color(0xFFE94560),
                ),
              ),
              validator: _viewModel.validarResponsavel,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),

            // RF07 item 3.5 — Endereço de entrega com validator (RF12 + RF13)
            TextFormField(
              controller: _enderecoController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Endereço de entrega *',
                hintText: 'Mínimo 4 caracteres',
                filled: true,
                fillColor: const Color(0xFF1A1A2E),
                prefixIcon: const Icon(
                  Icons.location_on,
                  color: Color(0xFFE94560),
                ),
              ),
              validator: _viewModel.validarEndereco,
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
    );
  }

  /// Card com total da compra atualizado em tempo real (RF09 + RF11).
  Widget _buildCardTotal() {
    return Card(
      color: const Color(0xFF1A1A2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE94560), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💳 Resumo do Pedido',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white24),
            _buildLinharesumo(
              'Preço unitário:',
              _formatoMoeda.format(_viewModel.camiseta.preco),
            ),
            _buildLinharesumo(
              'Quantidade:',
              '${_viewModel.quantidade} unidade(s)',
            ),
            _buildLinharesumo(
              'Subtotal:',
              _formatoMoeda.format(
                _viewModel.camiseta.preco * _viewModel.quantidade,
              ),
            ),
            if (_viewModel.parcelas > 1)
              _buildLinharesumo(
                'Juros (${_viewModel.percentualJuros.toStringAsFixed(1)}%):',
                '+ ${_formatoMoeda.format(_viewModel.valorTotal - (_viewModel.camiseta.preco * _viewModel.quantidade))}',
                corValor: Colors.orangeAccent,
              ),
            const Divider(color: Colors.white24),
            _buildLinharesumo(
              'TOTAL:',
              _formatoMoeda.format(_viewModel.valorTotal),
              destaque: true,
            ),
            _buildLinharesumo(
              'Parcelamento:',
              '${_viewModel.parcelas}x de ${_formatoMoeda.format(_viewModel.valorParcela)}',
              corValor: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinharesumo(
    String label,
    String valor, {
    bool destaque = false,
    Color? corValor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: destaque ? Colors.white : Colors.white70,
              fontSize: destaque ? 16 : 14,
              fontWeight:
                  destaque ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              color: corValor ??
                  (destaque ? Colors.greenAccent : Colors.white),
              fontSize: destaque ? 18 : 14,
              fontWeight:
                  destaque ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
