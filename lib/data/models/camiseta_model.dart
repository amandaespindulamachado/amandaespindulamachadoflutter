/// Entidade que representa uma Camiseta de Banda.
/// Utiliza encapsulamento com atributo privado e getter (RF técnico).
class Camiseta {
  final int id;
  final String titulo;
  final String banda;
  final double preco;
  final String imagemAsset;
  final List<String> tamanhos;
  final bool disponivel;
  final String descricao;

  // Atributo privado com getter — demonstra encapsulamento
  final double _precoOriginal;
  double get precoOriginal => _precoOriginal;

  Camiseta({
    required this.id,
    required this.titulo,
    required this.banda,
    required this.preco,
    required this.imagemAsset,
    required this.tamanhos,
    required this.disponivel,
    required this.descricao,
  }) : _precoOriginal = preco;

  /// Factory constructor — converte Map<String, dynamic> em objeto Camiseta
  factory Camiseta.fromJson(Map<String, dynamic> json) {
    return Camiseta(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      banda: json['banda'] as String,
      preco: (json['preco'] as num).toDouble(),
      imagemAsset: json['imagemAsset'] as String,
      tamanhos: List<String>.from(json['tamanhos'] as List),
      disponivel: json['disponivel'] as bool,
      descricao: json['descricao'] as String,
    );
  }

  /// Converte a entidade de volta para Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'banda': banda,
      'preco': preco,
      'imagemAsset': imagemAsset,
      'tamanhos': tamanhos,
      'disponivel': disponivel,
      'descricao': descricao,
    };
  }

  /// Polimorfismo — sobrescreve toString com @override
  @override
  String toString() {
    return 'Camiseta(id: $id, titulo: $titulo, banda: $banda, '
        'preco: R\$${preco.toStringAsFixed(2)}, disponivel: $disponivel)';
  }

  /// Sobrescreve == para comparação por id
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Camiseta && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
