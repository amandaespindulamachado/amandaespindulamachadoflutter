import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/camiseta_model.dart';

/// Card de camiseta para modo lista (RF05).
class CamisetaCardList extends StatelessWidget {
  final Camiseta camiseta;
  final VoidCallback? onComprar;

  const CamisetaCardList({
    super.key,
    required this.camiseta,
    this.onComprar,
  });

  @override
  Widget build(BuildContext context) {
    final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: camiseta.disponivel ? onComprar : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem com tratamento de erro (RF05 item 1)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  camiseta.imagemAsset,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 90,
                      height: 90,
                      color: const Color(0xFF1A1A2E),
                      child: const Icon(
                        Icons.music_note,
                        color: Color(0xFFE94560),
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      camiseta.titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      camiseta.banda,
                      style: const TextStyle(
                        color: Color(0xFFE94560),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      camiseta.descricao,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Preço formatado em R$ (RF05 item 2)
                        Text(
                          formatoMoeda.format(camiseta.preco),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent,
                          ),
                        ),
                        // Botão Comprar ou texto Indisponível (RF05 item 3)
                        camiseta.disponivel
                            ? ElevatedButton(
                                onPressed: onComprar,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Comprar',
                                  style: TextStyle(fontSize: 13),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Indisponível',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
