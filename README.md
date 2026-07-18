# 🎸 Camiseta de Banda — Simulador de Loja Virtual

Projeto Avaliativo Final — Mobile Flutter T1 | Módulo 01 · Semana 13

Vídeo: https://drive.google.com/file/d/1EO1DnsuF_lryXmcxaQIBRRrYOSTqgpn3/view?usp=sharing

---

## 📋 Sobre o Projeto

**Camiseta de Banda** é um aplicativo Flutter que simula uma loja virtual de camisetas de bandas de rock. O usuário pode navegar pelo catálogo, filtrar por título e faixa de preço, alternar entre visualização em lista e grade, e finalizar uma compra com cálculo de parcelas e juros.

---

## 🎯 Problema que resolve

Demonstra na prática a integração entre lógica de negócio (Dart/POO) e interface visual (Flutter/Widgets), seguindo o padrão arquitetural **MVVM** com separação clara de responsabilidades entre camadas.

---

## 🏗️ Arquitetura — MVVM

```
lib/
├── main.dart                          # Entry point + rotas nomeadas
├── data/
│   ├── datasources/
│   │   └── camiseta_datasource.dart   # JSON e registro de compra
│   ├── repositories/
│   │   └── camiseta_repository.dart   # Lógica de negócio + filtros
│   └── models/
│       ├── camiseta_model.dart        # Entidade Camiseta
│       └── compra_model.dart          # Entidade Compra
├── view/
│   ├── catalogo_view.dart             # Tela 01 — Catálogo
│   ├── compra_view.dart               # Tela 02 — Compra
│   └── widgets/
│       ├── camiseta_card_list.dart    # Card modo lista
│       └── camiseta_card_grid.dart    # Card modo grid
└── viewModel/
    ├── catalogo_view_model.dart       # ViewModel do catálogo
    └── compra_view_model.dart         # ViewModel da compra
```

---

## ✅ Funcionalidades Implementadas

### Tela 01 — Catálogo
| RF | Descrição | Status |
|----|-----------|--------|
| RF01 | JSON → Lista de Entidades | ✅ |
| RF02 | Listagem com Lazy Loading | ✅ |
| RF03 | Alternar List / Grid | ✅ |
| RF04 | Filtro por título + faixa de preço | ✅ |
| RF05 | Card com imagem, preço e botão | ✅ |
| RF06 | Navegação nomeada para tela de compra | ✅ |

### Tela 02 — Compra
| RF | Descrição | Status |
|----|-----------|--------|
| RF07 | Tela de compra completa | ✅ |
| RF08 | Limite de quantidade (1–5) | ✅ |
| RF09 | Cálculo do total (qtd × preço) | ✅ |
| RF10 | Limite de parcelas (máx 6) | ✅ |
| RF11 | Juros 0,5% por parcela acima da 1ª | ✅ |
| RF12 | Validação nome/endereço (mín 4 chars) | ✅ |
| RF13 | Validator + Snackbar de erro | ✅ |
| RF14 | Entidade Compra criada | ✅ |
| RF15 | Snackbar sucesso + print JSON + retorno | ✅ |

---

## 🛠️ Tecnologias e Técnicas Utilizadas

- **Flutter** 3.10+ / **Dart** 3.0+
- **Padrão MVVM** com `ChangeNotifier`
- **POO**: Classes, Objetos, Encapsulamento, Polimorfismo (`@override`)
- **Métodos avançados**: `map`, `where`, `firstWhere`, `every`, `reduce`
- **Arrow functions**, operadores lógicos e ternários
- `ListView.builder` e `GridView.builder` com **Lazy Loading**
- `Image.asset` com `errorBuilder` para tratamento de imagem
- **Navegação nomeada** com `Navigator.pushNamed` + `arguments`
- `Form` + `FormField` + **validators** + `SnackBar`
- `DropdownButtonFormField`, `Slider`, `RangeSlider`
- `intl` para formatação de moeda em R$

---

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK ≥ 3.10.0
- Dart SDK ≥ 3.0.0
- Android Studio / VS Code com extensões Flutter

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/amandaespindulamachado/amandaespindulamachadoflutter.git
cd amandaespindulamachadoflutter

# 2. Instale as dependências
flutter pub get

# 3. Execute o projeto
flutter run
```

---

## 📈 Melhorias Futuras

- Integração com API REST real
- Carrinho de compras persistente
- Autenticação de usuário
- Histórico de pedidos
- Animações nas transições de tela
- Testes unitários e de widget

---

## 👩‍💻 Autora

**Amanda Espindula Machado**  
Turma: Mobile Flutter T1 — LAB365 / SENAI SC  
Projeto Avaliativo — Módulo 01, Semana 13
