# 🛡️ Caderneta Digital de Vacinação

Uma aplicação mobile e web moderna, interativa e de alto padrão estético para o gerenciamento inteligente do histórico de imunização pessoal, totalmente integrada com o calendário oficial do **Programa Nacional de Imunizações (PNI) do SUS**.

---

## ✨ Principais Funcionalidades

### 📊 1. Painel de Cobertura Imunológica (Gamificado)
* **Gauge Circular Animado**: Um gráfico circular desenvolvido nativamente em canvas (`CustomPaint`) que executa uma animação fluída e contínua do progresso de cobertura vacinal do usuário.
* **Pílulas de Saúde**: Badges coloridos dinâmicos que segmentam as vacinas em **Concluídas** 🟢, **Em Andamento** 🟡 e **Não Iniciadas** ⚪.
* **Fases da Vida do SUS**: Barra de progresso linear para cada fase de vida (**Criança**, **Adolescente**, **Adulto** e **Idoso**) com destaque luminoso de `"Atual"` na faixa etária correspondente à idade real do usuário.

### 📋 2. Carteira de Vacinação & Histórico Detalhado
* Registro completo de cada aplicação contendo: **Dose**, **Fabricante/Laboratório**, **Lote**, **Local de Aplicação**, **Data da Aplicação** e **Previsão da Próxima Dose**.
* Filtros rápidos por tipo de vacina (Rotina/Campanha) e por laboratório fabricante.

### 🧠 3. Lógica Transacional & Agendamento Inteligente
* **Previsão Reativa**: O formulário esconde automaticamente o campo de agendamento ao selecionar a última dose recomendada de um imunizante (ou quando todas as doses posteriores daquela vacina já constam como registradas).
* **Consistência SQLite**: As inserções ocorrem em blocos transacionais que limpam automaticamente agendamentos obsoletos de registros anteriores da mesma vacina, eliminando "alertas fantasma" na interface.
* **Suporte Específico para VIP/VOP**: Regra dedicada para o esquema de 5 doses oficiais da Poliomielite (3 doses de VIP + 2 reforços de VOP).

### 👥 4. Perfis Customizados & Alergias
* **Seletor de Avatar Premium**: Escolha dinâmica de 8 avatares ilustrados baseados em saúde e ciência sobre fundos com degradês metálicos (salvos de forma reativa por ID via `SharedPreferences`).
* **Prontuário de Alergias**: Painel para registro de restrições médicas categorizadas (Alimentar, Medicamentosa, Ambiental) com chips destacados por gravidade clínica:
  * 🔴 **Grave**
  * 🟡 **Moderada**
  * 🔵 **Leve**

### 📄 5. Exportação Premium para PDF (Padrão SUS)
* Geração instantânea e impressão de um arquivo PDF estilizado imitando a caderneta oficial física do SUS, incluindo metadados pessoais, histórico detalhado de vacinas aplicadas e prontuário de alergias ativas.

---

## 🛠️ Stack Tecnológica

* **Framework**: [Flutter](https://flutter.dev) (Dart)
* **Banco de Dados**: [Drift](https://drift.simonbinder.eu) (SQLite reativo com suporte a WASM no ambiente Web)
* **Gerenciamento de Estado**: [Provider](https://pub.dev/packages/provider)
* **Persistência Leve**: [SharedPreferences](https://pub.dev/packages/shared_preferences)
* **Geração de Documentos**: [PDF & Printing](https://pub.dev/packages/pdf)

---

## 🗄️ Arquitetura do Banco de Dados (Schema)

O aplicativo utiliza um banco de dados **SQLite altamente normalizado** estruturado em 4 tabelas conectadas por chaves estrangeiras:

### 1. Tabela: `Usuarios`
Armazena as contas e dados básicos de saúde do usuário.
| Coluna | Tipo SQLite | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | Chave Primária (`AUTOINCREMENT`) | Identificador único do usuário. |
| `nome` | `TEXT` | `NOT NULL` | Nome completo do usuário. |
| `email` | `TEXT` | `NOT NULL` | E-mail da conta (login). |
| `senha` | `TEXT` | `NOT NULL` | Senha da conta. |
| `tipoSanguineo`| `TEXT` | `NULLABLE` | Tipo sanguíneo (ex: `'O+'`, `'A-'`). |
| `dataNascimento`| `INTEGER` (Timestamp)| `NULLABLE` | Data de nascimento do usuário. |

### 2. Tabela: `Vacinas`
Tabela estática de referência contendo o catálogo do PNI do SUS.
| Coluna | Tipo SQLite | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | Chave Primária (`AUTOINCREMENT`) | Identificador único da vacina de referência. |
| `nome` | `TEXT` | `NOT NULL` | Nome comercial/comum (ex: `'BCG'`, `'VIP/VOP'`). |
| `categoria` | `TEXT` | `NOT NULL` | Grupo da vacina (ex: `'Rotina'`, `'Campanha'`). |
| `descricao` | `TEXT` | `NOT NULL` | Explicação de quais doenças ela previne. |

### 3. Tabela: `Agendas`
Tabela transacional que atua como histórico de aplicações e agenda de lembretes futuros.
| Coluna | Tipo SQLite | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | Chave Primária (`AUTOINCREMENT`) | Identificador único da dose registrada. |
| `usuarioId` | `INTEGER` | Chave Estrangeira -> `Usuarios(id)` | Usuário dono da aplicação. |
| `vacinaId` | `INTEGER` | Chave Estrangeira -> `Vacinas(id)` | Vacina associada. |
| `dose` | `TEXT` | `NOT NULL` | Dose aplicada (ex: `'1ª Dose'`, `'2º Reforço'`). |
| `lote` | `TEXT` | `NULLABLE` | Código do lote do imunizante. |
| `fabricante` | `TEXT` | `NULLABLE` | Laboratório (ex: `'Fiocruz'`, `'Butantan'`). |
| `dataAplicacao`| `INTEGER` (Timestamp)| `NOT NULL` | Data da aplicação. |
| `local` | `TEXT` | `NULLABLE` | Posto ou clínica de vacinação. |
| `proximaDose` | `INTEGER` (Timestamp)| `NULLABLE` | Data prevista de reforço (vazio se finalizada). |

### 4. Tabela: `Alergias`
Registros de restrições alérgicas ativas cadastradas no perfil.
| Coluna | Tipo SQLite | Restrições | Descrição |
| :--- | :--- | :--- | :--- |
| `id` | `INTEGER` | Chave Primária (`AUTOINCREMENT`) | Identificador único da restrição. |
| `usuarioId` | `INTEGER` | Chave Estrangeira -> `Usuarios(id)` | Usuário com a alergia. |
| `nome` | `TEXT` | `NOT NULL` | Alergênio cadastrado (ex: `'Dipirona'`). |
| `categoria` | `TEXT` | `NOT NULL` | Categoria (ex: `'Medicamento'`, `'Alimentar'`). |
| `gravidade` | `TEXT` | `NOT NULL` | Gravidade clínica (ex: `'Grave'`, `'Leve'`). |

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
* [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado na sua máquina (SDK `>= 3.2.0`).
* Emulador Android/iOS ou navegador web configurado.

### Passos para Inicialização

1. **Clonar o Repositório**:
   ```bash
   git clone <URL-DO-REPOSITORIO>
   cd caderneta_digital
   ```

2. **Instalar Dependências**:
   ```bash
   flutter pub get
   ```

3. **Gerar Arquivos do Drift (SQLite)**:
   Como o Drift utiliza geração de código estático para mapear as tabelas e queries tipadas, execute o build_runner:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Executar a Aplicação**:
   ```bash
   flutter run
   ```
