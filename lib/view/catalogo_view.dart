import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../viewModel/catalogo_view_model.dart';
import '../data/models/camiseta_model.dart';
import 'widgets/camiseta_card_list.dart';
import 'widgets/camiseta_card_grid.dart';
import 'compra_view.dart';

/// Tela 01 — Catálogo de Camisetas (RF02 a RF06).
class CatalogoView extends StatefulWidget {
  static const String routeName = '/catalogo';

  const CatalogoView({super.key});

  @override
  State<CatalogoView> createState() => _CatalogoViewState();
}

class _CatalogoViewState extends State<CatalogoView> {
  final CatalogoViewModel _viewModel = CatalogoViewModel();
  final TextEditingController _buscaController = TextEditingController();
  bool _mostrarFiltroPreco = false;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.carregarCamisetas();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  /// Navega para a tela de compra com rota nomeada (RF06).
  void _navegarParaCompra(Camiseta camiseta) {
    Navigator.pushNamed(
      context,
      CompraView.routeName,
      arguments: {'camiseta': camiseta, 'viewModel': _viewModel},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🎸 Camisetas de Banda',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Ícone para alternar entre filtro de preço
          IconButton(
            icon: Icon(
              _mostrarFiltroPreco
                  ? Icons.filter_alt
                  : Icons.filter_alt_outlined,
              color: _mostrarFiltroPreco
                  ? const Color(0xFFE94560)
                  : Colors.white,
            ),
            tooltip: 'Filtrar por preço',
            onPressed: () {
              setState(() {
                _mostrarFiltroPreco = !_mostrarFiltroPreco;
              });
            },
          ),
          // Ícone para alternar List / Grid (RF03)
          IconButton(
            icon: Icon(
              _viewModel.exibirGrid ? Icons.list : Icons.grid_view,
              color: Colors.white,
            ),
            tooltip: _viewModel.exibirGrid
                ? 'Visualizar em lista'
                : 'Visualizar em grade',
            onPressed: _viewModel.alternarVisualizacao,
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busca por título (RF04 item 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _buscaController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon:
                    const Icon(Icons.search, color: Color(0xFFE94560)),
                suffixIcon: _buscaController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _buscaController.clear();
                          _viewModel.atualizarBusca('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF0F3460),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: _viewModel.atualizarBusca,
            ),
          ),

          // Painel de filtro por faixa de preço (RF04 item 2)
          if (_mostrarFiltroPreco) _buildFiltroPrecoPainel(),

          // Contador de resultados
          if (!_viewModel.isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_viewModel.camisetas.length} camiseta(s) encontrada(s)',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                  if (_viewModel.termoBusca.isNotEmpty ||
                      _viewModel.precoMin > 0 ||
                      _viewModel.precoMax < _viewModel.precoMaximoSlider)
                    TextButton(
                      onPressed: () {
                        _buscaController.clear();
                        _viewModel.limparFiltros();
                      },
                      child: const Text(
                        'Limpar filtros',
                        style: TextStyle(
                          color: Color(0xFFE94560),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

          // Lista / Grid com lazy loading (RF02 + RF03)
          Expanded(child: _buildConteudo()),
        ],
      ),
    );
  }

  Widget _buildFiltroPrecoPainel() {
    final formatoMoeda =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE94560).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por preço',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Min: ${formatoMoeda.format(_viewModel.precoMin)}',
                style:
                    const TextStyle(color: Colors.greenAccent, fontSize: 13),
              ),
              Text(
                'Max: ${formatoMoeda.format(_viewModel.precoMax)}',
                style:
                    const TextStyle(color: Colors.greenAccent, fontSize: 13),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(_viewModel.precoMin, _viewModel.precoMax),
            min: 0,
            max: _viewModel.precoMaximoSlider,
            divisions: 20,
            activeColor: const Color(0xFFE94560),
            inactiveColor: Colors.white24,
            labels: RangeLabels(
              formatoMoeda.format(_viewModel.precoMin),
              formatoMoeda.format(_viewModel.precoMax),
            ),
            onChanged: (values) {
              _viewModel.atualizarPrecoMin(values.start);
              _viewModel.atualizarPrecoMax(values.end);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConteudo() {
    if (_viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE94560)),
      );
    }

    if (_viewModel.erro != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFE94560), size: 48),
            const SizedBox(height: 12),
            Text(
              _viewModel.erro!,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _viewModel.carregarCamisetas,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_viewModel.camisetas.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.white38, size: 48),
            SizedBox(height: 12),
            Text(
              'Nenhuma camiseta encontrada',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Alterna entre GridView e ListView com lazy loading (RF02 + RF03)
    return _viewModel.exibirGrid ? _buildGridView() : _buildListView();
  }

  /// ListView com lazy loading — builder renderiza sob demanda (RF02).
  Widget _buildListView() {
    return ListView.builder(
      itemCount: _viewModel.camisetas.length,
      // Lazy loading: cada item só é criado quando entra na viewport
      itemBuilder: (context, index) {
        final camiseta = _viewModel.camisetas[index];
        return CamisetaCardList(
          camiseta: camiseta,
          onComprar: () => _navegarParaCompra(camiseta),
        );
      },
    );
  }

  /// GridView com lazy loading — builder renderiza sob demanda (RF03).
  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: _viewModel.camisetas.length,
      // Lazy loading: cada item só é criado quando entra na viewport
      itemBuilder: (context, index) {
        final camiseta = _viewModel.camisetas[index];
        return CamisetaCardGrid(
          camiseta: camiseta,
          onComprar: () => _navegarParaCompra(camiseta),
        );
      },
    );
  }
}
