import '../models/compra_model.dart';

/// Datasource — simula a camada de dados externa (JSON).
/// Em produção, aqui ficaria a chamada HTTP ou leitura de arquivo.
class CamisetaDatasource {
  /// Retorna o JSON com a lista de camisetas (simulando resposta de API/arquivo).
  /// Usa Map<String, dynamic> conforme requisito técnico.
  List<Map<String, dynamic>> getCamisetasJson() {
    return [
      {
        'id': 1,
        'titulo': 'Tour 2023 - The Dark Side',
        'banda': 'Pink Floyd',
        'preco': 89.90,
        'imagemAsset': 'assets/images/camiseta_01.png',
        'tamanhos': ['P', 'M', 'G', 'GG'],
        'disponivel': true,
        'descricao':
            'Camiseta oficial da turnê The Dark Side of the Moon 50th Anniversary.',
      },
      {
        'id': 2,
        'titulo': 'Back in Black Tour',
        'banda': 'AC/DC',
        'preco': 79.90,
        'imagemAsset': 'assets/images/camiseta_02.png',
        'tamanhos': ['P', 'M', 'G'],
        'disponivel': true,
        'descricao': 'Camiseta clássica da turnê Back in Black, edição limitada.',
      },
      {
        'id': 3,
        'titulo': 'Master of Puppets',
        'banda': 'Metallica',
        'preco': 99.90,
        'imagemAsset': 'assets/images/camiseta_03.png',
        'tamanhos': ['M', 'G', 'GG', 'XGG'],
        'disponivel': true,
        'descricao': 'Homenagem ao álbum Master of Puppets, arte exclusiva.',
      },
      {
        'id': 4,
        'titulo': 'Nevermind Anniversary',
        'banda': 'Nirvana',
        'preco': 85.00,
        'imagemAsset': 'assets/images/camiseta_04.png',
        'tamanhos': ['P', 'M', 'G'],
        'disponivel': false,
        'descricao': 'Edição comemorativa 30 anos do álbum Nevermind.',
      },
      {
        'id': 5,
        'titulo': 'Paranoid World Tour',
        'banda': 'Black Sabbath',
        'preco': 95.00,
        'imagemAsset': 'assets/images/camiseta_05.png',
        'tamanhos': ['P', 'M', 'G', 'GG'],
        'disponivel': true,
        'descricao': 'Tour mundial do clássico Paranoid, arte retro.',
      },
      {
        'id': 6,
        'titulo': 'Appetite for Destruction',
        'banda': "Guns N' Roses",
        'preco': 92.50,
        'imagemAsset': 'assets/images/camiseta_06.png',
        'tamanhos': ['M', 'G', 'GG'],
        'disponivel': true,
        'descricao': 'Arte original do álbum de estreia do Guns N\' Roses.',
      },
      {
        'id': 7,
        'titulo': 'The Number of the Beast',
        'banda': 'Iron Maiden',
        'preco': 88.00,
        'imagemAsset': 'assets/images/camiseta_07.png',
        'tamanhos': ['P', 'M', 'G', 'GG', 'XGG'],
        'disponivel': false,
        'descricao': 'Clássico do metal com a icônica arte do Eddie.',
      },
      {
        'id': 8,
        'titulo': 'Houses of the Holy',
        'banda': 'Led Zeppelin',
        'preco': 110.00,
        'imagemAsset': 'assets/images/camiseta_08.png',
        'tamanhos': ['P', 'M', 'G'],
        'disponivel': true,
        'descricao': 'Arte psicodélica inspirada no álbum Houses of the Holy.',
      },
    ];
  }

  /// Recebe a compra finalizada e imprime como JSON no terminal (RF15 item 4).
  void registrarCompra(Compra compra) {
    final json = compra.toJson();
    // ignore: avoid_print
    print('===== COMPRA REGISTRADA =====');
    // ignore: avoid_print
    print(json);
    // ignore: avoid_print
    print('=============================');
  }
}
