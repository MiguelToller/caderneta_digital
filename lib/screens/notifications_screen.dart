import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import 'record_form_screen.dart';

class NotificationReminder {
  final String titulo;
  final String descricao;
  final DateTime? dataReferencia;
  final String status; // 'atrasado', 'agendado', 'pendente'
  final Color corDestaque;
  final IconData icone;
  final String acaoTexto;
  final String nomeOriginalVacina;
  final String? dosePreSelecionada;

  NotificationReminder({
    required this.titulo,
    required this.descricao,
    this.dataReferencia,
    required this.status,
    required this.corDestaque,
    required this.icone,
    required this.acaoTexto,
    required this.nomeOriginalVacina,
    this.dosePreSelecionada,
  });
}

class NotificationsScreen extends StatelessWidget {
  final Usuario user;
  const NotificationsScreen({super.key, required this.user});

  int _calcularIdade(DateTime dataNasc) {
    final hoje = DateTime.now();
    int idade = hoje.year - dataNasc.year;
    if (hoje.month < dataNasc.month || (hoje.month == dataNasc.month && hoje.day < dataNasc.day)) {
      idade--;
    }
    return idade;
  }

  String _obterCategoriaPorIdade(int idade) {
    if (idade <= 10) return 'Criança (0 a 10 anos)';
    if (idade <= 19) return 'Adolescente (11 a 19 anos)';
    if (idade <= 59) return 'Adulto (20 a 59 anos)';
    return 'Idoso (60 anos ou mais)';
  }

  // Mapeamento idêntico ao calendário para manter coerência completa de negócio
  static final Map<String, List<Map<String, dynamic>>> _calendarioSusData = {
    'Criança (0 a 10 anos)': [
      {'nome': 'BCG', 'desc': 'Tuberculose (formas graves)', 'doses': 1},
      {'nome': 'Hepatite B', 'desc': 'Hepatite B', 'doses': 1},
      {'nome': 'Pentavalente', 'desc': 'Difteria, Tétano, Coqueluche, HepB, Hib', 'doses': 3},
      {'nome': 'VIP/VOP (Poliomielite)', 'desc': 'Paralisia infantil', 'doses': 5},
      {'nome': 'Pneumocócica 10V', 'desc': 'Pneumonia, otite, meningite', 'doses': 3},
      {'nome': 'Rotavírus', 'desc': 'Diarreia por rotavírus', 'doses': 2},
      {'nome': 'Meningocócica C', 'desc': 'Meningite C', 'doses': 3},
      {'nome': 'Febre Amarela', 'desc': 'Febre amarela', 'doses': 2},
      {'nome': 'Tríplice Viral (SRC)', 'desc': 'Sarampo, Caxumba, Rubéola', 'doses': 2},
      {'nome': 'Hepatite A', 'desc': 'Hepatite A', 'doses': 1},
      {'nome': 'DTP', 'desc': 'Difteria, Tétano, Coqueluche (reforço)', 'doses': 2},
      {'nome': 'Varicela', 'desc': 'Catapora', 'doses': 1},
    ],
    'Adolescente (11 a 19 anos)': [
      {'nome': 'HPV Quadrivalente', 'desc': 'Prevenção de cânceres e verrugas genitais', 'doses': 2},
      {'nome': 'Meningocócica ACWY', 'desc': 'Meningites ACWY', 'doses': 1},
      {'nome': 'Hepatite B', 'desc': 'Hepatite B (iniciar ou completar esquema)', 'doses': 3},
      {'nome': 'Tríplice Viral (SRC)', 'desc': 'Sarampo, Caxumba, Rubéola (se não vacinado)', 'doses': 2},
      {'nome': 'dT (Dupla Adulto)', 'desc': 'Difteria e Tétano (reforço)', 'doses': 1},
    ],
    'Adulto (20 a 59 anos)': [
      {'nome': 'Hepatite B', 'desc': 'Hepatite B (iniciar ou completar esquema)', 'doses': 3},
      {'nome': 'Tríplice Viral (SRC)', 'desc': 'Sarampo, Caxumba, Rubéola (se não vacinado)', 'doses': 2},
      {'nome': 'dT (Dupla Adulto)', 'desc': 'Difteria e Tétano', 'doses': 1},
      {'nome': 'Febre Amarela', 'desc': 'Febre amarela (se nunca tomou)', 'doses': 1},
    ],
    'Idoso (60 anos ou mais)': [
      {'nome': 'Hepatite B', 'desc': 'Hepatite B (iniciar ou completar esquema)', 'doses': 3},
      {'nome': 'dT (Dupla Adulto)', 'desc': 'Difteria e Tétano', 'doses': 1},
      {'nome': 'Gripe (Influenza)', 'desc': 'Gripe comum', 'doses': 1},
      {'nome': 'Pneumocócica 23V', 'desc': 'Prevenção de pneumonia grave', 'doses': 1},
    ],
  };

  List<AgendaWithVacina> _obterDosesTomadas(String recNome, List<AgendaWithVacina> historico) {
    final query = recNome.toLowerCase();
    return historico.where((item) {
      final vacNome = item.vacina.nome.toLowerCase();
      if (vacNome == query) return true;
      if (vacNome.contains('bcg') && query.contains('bcg')) return true;
      if (vacNome.contains('hepatite b') && query.contains('hepatite b')) return true;
      if (vacNome.contains('pentavalente') && query.contains('pentavalente')) return true;
      if (vacNome.contains('poliomielite') && query.contains('poliomielite')) return true;
      if (vacNome.contains('vip/vop') && query.contains('vip/vop')) return true;
      if (vacNome.contains('pneumoc') && query.contains('pneumoc')) return true;
      if (vacNome.contains('rotav') && query.contains('rotav')) return true;
      if (vacNome.contains('meningoc') && query.contains('meningoc')) return true;
      if (vacNome.contains('febre amarela') && query.contains('febre amarela')) return true;
      if (vacNome.contains('tríplice viral') && query.contains('tríplice viral')) return true;
      if (vacNome.contains('hepatite a') && query.contains('hepatite a')) return true;
      if (vacNome.contains('dtp') && query.contains('dtp')) return true;
      if (vacNome.contains('varicela') && query.contains('varicela')) return true;
      if (vacNome.contains('hpv') && query.contains('hpv')) return true;
      if (vacNome.contains('dt ') && query.contains('dt ')) return true;
      if (vacNome.contains('dupla adulto') && query.contains('dupla adulto')) return true;
      if (vacNome.contains('gripe') && query.contains('gripe')) return true;
      if (vacNome.contains('influenza') && query.contains('influenza')) return true;
      if (vacNome.contains('covid') && query.contains('covid')) return true;
      if (vacNome.contains('dengue') && query.contains('dengue')) return true;
      return false;
    }).toList();
  }

  Future<Vacina?> _obterVacinaDoBanco(BuildContext context, String nomeVacina) async {
    final db = context.read<AppDatabase>();
    final vacinas = await db.select(db.vacinas).get();
    
    final query = nomeVacina.toLowerCase();
    try {
      return vacinas.firstWhere((v) {
        final dbName = v.nome.toLowerCase();
        if (dbName == query) return true;
        if (dbName.contains('bcg') && query.contains('bcg')) return true;
        if (dbName.contains('hepatite b') && query.contains('hepatite b')) return true;
        if (dbName.contains('pentavalente') && query.contains('pentavalente')) return true;
        if (dbName.contains('vip/vop') && query.contains('vip/vop')) return true;
        if (dbName.contains('pneumoc') && query.contains('pneumoc')) return true;
        if (dbName.contains('rotav') && query.contains('rotav')) return true;
        if (dbName.contains('meningoc') && query.contains('meningoc')) return true;
        if (dbName.contains('febre amarela') && query.contains('febre amarela')) return true;
        if (dbName.contains('tríplice viral') && query.contains('tríplice viral')) return true;
        if (dbName.contains('hepatite a') && query.contains('hepatite a')) return true;
        if (dbName.contains('dtp') && query.contains('dtp')) return true;
        if (dbName.contains('varicela') && query.contains('varicela')) return true;
        if (dbName.contains('hpv') && query.contains('hpv')) return true;
        if (dbName.contains('dt ') && query.contains('dt ')) return true;
        if (dbName.contains('dupla adulto') && query.contains('dupla adulto')) return true;
        if (dbName.contains('gripe') && query.contains('gripe')) return true;
        if (dbName.contains('influenza') && query.contains('influenza')) return true;
        return false;
      });
    } catch (_) {
      return null;
    }
  }

  String _obterProximaDoseNome(String doseAtual) {
    if (doseAtual == '1ª Dose') return '2ª Dose';
    if (doseAtual == '2ª Dose') return '3ª Dose';
    if (doseAtual == '3ª Dose') return 'Reforço';
    return 'Reforço';
  }

  String _obterDosePreSelecionadaParaPendente(String nomeVacina, int totalTomadas) {
    final nome = nomeVacina.toLowerCase();
    if (nome.contains('bcg') || 
        nome.contains('hepatite a') || 
        nome.contains('acwy') || 
        nome.contains('23v') || 
        nome.contains('pneumocócica 23v')) {
      return 'Dose Única';
    }
    if (nome.contains('gripe') || nome.contains('influenza')) {
      return 'Dose Anual';
    }
    if (totalTomadas == 0) return '1ª Dose';
    return '${totalTomadas + 1}ª Dose';
  }

  List<String> _obterOpcoesDosePermitidas(String nomeVacina) {
    final nome = nomeVacina.toLowerCase();
    
    // 1. Vacinas de Dose Única
    if (nome.contains('bcg') || 
        nome.contains('hepatite a') || 
        nome.contains('acwy') || 
        nome.contains('23v') || 
        nome.contains('pneumocócica 23v')) {
      return ['Dose Única'];
    }
    
    // 2. Vacinas Anuais
    if (nome.contains('gripe') || nome.contains('influenza')) {
      return ['Dose Anual'];
    }

    // 3. Vacinas de 2 doses (sem reforço por padrão)
    if (nome.contains('rotav') || 
        nome.contains('hpv') || 
        nome.contains('varicela') ||
        nome.contains('dengue')) {
      return ['1ª Dose', '2ª Dose'];
    }

    // 4. Febre Amarela e Tríplice Viral
    if (nome.contains('febre amarela')) {
      return ['1ª Dose', 'Reforço'];
    }
    if (nome.contains('tríplice viral') || nome.contains('src')) {
      return ['1ª Dose', '2ª Dose'];
    }

    // 5. Vacinas de 3 doses
    if (nome.contains('hepatite b')) {
      return ['1ª Dose', '2ª Dose', '3ª Dose'];
    }

    // 6. Vacinas de 3 doses com Reforço (Pentavalente, Poliomielite, DTP, dT, Pneumo 10V, Meningo C)
    if (nome.contains('pentavalente') || 
        nome.contains('poliomielite') || 
        nome.contains('vip/vop') || 
        nome.contains('pneumo') || 
        nome.contains('meningo') || 
        nome.contains('dtp') || 
        nome.contains('dt ') || 
        nome.contains('dupla adulto')) {
      return ['1ª Dose', '2ª Dose', '3ª Dose', 'Reforço'];
    }

    // Padrão seguro para qualquer vacina customizada/avulsa
    return ['1ª Dose', '2ª Dose', '3ª Dose', 'Reforço'];
  }

  void _irParaRegistro(BuildContext context, String nomeVacina, String? dosePreSelecionada) async {
    final vacina = await _obterVacinaDoBanco(context, nomeVacina);
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecordFormScreen(
          user: user,
          vacinaPreSelecionada: vacina,
          dosePreSelecionada: dosePreSelecionada,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final theme = Theme.of(context);

    return StreamBuilder<Usuario?>(
      stream: db.watchUsuario(user.id),
      initialData: user,
      builder: (context, userSnapshot) {
        final currentUser = userSnapshot.data ?? user;
        final int idade = currentUser.dataNascimento != null ? _calcularIdade(currentUser.dataNascimento!) : 30;
        final String faseAtual = _obterCategoriaPorIdade(idade);

        return StreamBuilder<List<AgendaWithVacina>>(
          stream: db.watchHistoricoDetalhado(user.id),
          builder: (context, historicoSnapshot) {
            final historico = historicoSnapshot.data ?? [];

            // 1. Processamento e Geração dos Avisos em Tempo Real
            final List<NotificationReminder> lembretes = [];

            // Regra A: Reforços e Agendamentos no Banco de Dados
            for (final item in historico) {
              if (item.agenda.proximaDose != null) {
                final proxima = item.agenda.proximaDose!;
                
                // Verificar se este agendamento já foi cumprido
                final proximaDoseNome = _obterProximaDoseNome(item.agenda.dose);
                
                // Se todas as opções permitidas de dose já foram registradas, o esquema está concluído por completo!
                final opcoesPermitidas = _obterOpcoesDosePermitidas(item.vacina.nome);
                final dosesJaRegistradas = historico
                    .where((other) => other.vacina.id == item.vacina.id)
                    .map((other) => other.agenda.dose)
                    .toSet();
                
                final completouEsquema = opcoesPermitidas.every((op) => dosesJaRegistradas.contains(op));
                if (completouEsquema) {
                  continue; // Pula este aviso de reforço pois o esquema inteiro já foi preenchido!
                }

                final jaFoiCumprida = historico.any((other) =>
                    other.vacina.id == item.vacina.id &&
                    other.agenda.id != item.agenda.id &&
                    (other.agenda.dose == proximaDoseNome || 
                     other.agenda.dataAplicacao.isAfter(item.agenda.dataAplicacao)));

                if (jaFoiCumprida) {
                  continue; // Pula este aviso pois a dose já foi registrada!
                }

                final atrasada = proxima.isBefore(DateTime.now());

                lembretes.add(NotificationReminder(
                  titulo: '${item.vacina.nome} ($proximaDoseNome)',
                  descricao: atrasada
                      ? '$proximaDoseNome muito atrasada! Estava programada para ${DateFormat('dd/MM/yyyy').format(proxima)}.'
                      : '$proximaDoseNome agendada para: ${DateFormat('dd/MM/yyyy').format(proxima)}.',
                  dataReferencia: proxima,
                  status: atrasada ? 'atrasado' : 'agendado',
                  corDestaque: atrasada ? Colors.red.shade800 : Colors.blue.shade800,
                  icone: atrasada ? Icons.warning_amber_rounded : Icons.alarm,
                  acaoTexto: 'Registrar $proximaDoseNome',
                  nomeOriginalVacina: item.vacina.nome,
                  dosePreSelecionada: proximaDoseNome,
                ));
              }
            }

            // Regra B: Vacinas Obrigatórias Pendentes com base na idade atual
            final recomendacoes = _calendarioSusData[faseAtual] ?? [];
            for (final rec in recomendacoes) {
              final nome = rec['nome'] as String;
              final desc = rec['desc'] as String;
              final dosesNecessarias = rec['doses'] as int;

              final tomadas = _obterDosesTomadas(nome, historico);
              final totalTomadas = tomadas.length;

              if (totalTomadas == 0) {
                final dosePre = _obterDosePreSelecionadaParaPendente(nome, 0);
                lembretes.add(NotificationReminder(
                  titulo: nome,
                  descricao: '$desc. Nenhuma dose registrada no seu histórico para sua faixa etária.',
                  status: 'pendente',
                  corDestaque: Colors.orange.shade800,
                  icone: Icons.error_outline,
                  acaoTexto: 'Registrar $dosePre',
                  nomeOriginalVacina: nome,
                  dosePreSelecionada: dosePre,
                ));
              } else if (totalTomadas < dosesNecessarias) {
                // Esquema incompleto sem data de reforço definida
                final jaTemAgendamento = tomadas.any((t) => t.agenda.proximaDose != null);
                if (!jaTemAgendamento) {
                  final dosePre = _obterDosePreSelecionadaParaPendente(nome, totalTomadas);
                  lembretes.add(NotificationReminder(
                    titulo: nome,
                    descricao: 'Esquema incompleto ($totalTomadas/$dosesNecessarias doses aplicadas). Nenhuma data de reforço foi programada!',
                    status: 'pendente',
                    corDestaque: Colors.orange.shade800,
                    icone: Icons.hourglass_empty,
                    acaoTexto: 'Registrar $dosePre',
                    nomeOriginalVacina: nome,
                    dosePreSelecionada: dosePre,
                  ));
                }
              }
            }

            // Separar as categorias para visualização premium
            final atrasados = lembretes.where((l) => l.status == 'atrasado').toList();
            final agendados = lembretes.where((l) => l.status == 'agendado').toList();
            final pendentes = lembretes.where((l) => l.status == 'pendente').toList();

            // Ordenar agendados e atrasados por proximidade da data
            atrasados.sort((a, b) => b.dataReferencia!.compareTo(a.dataReferencia!));
            agendados.sort((a, b) => a.dataReferencia!.compareTo(b.dataReferencia!));

            return Scaffold(
              appBar: AppBar(
                title: const Text('Avisos e Lembretes'),
              ),
              body: Column(
                children: [
                  // Painel Superior de Resumo Premium
                  _buildHeaderSummary(theme, atrasados.length, pendentes.length, agendados.length),
                  
                  Expanded(
                    child: lembretes.isEmpty
                        ? _buildCleanState()
                        : ListView(
                            padding: const EdgeInsets.all(16),
                            children: [
                              if (atrasados.isNotEmpty) ...[
                                _buildSectionHeader(theme, 'Atrasadas / Críticas', Colors.red.shade800, Icons.dangerous),
                                const SizedBox(height: 8),
                                ...atrasados.map((l) => _buildReminderCard(context, theme, l)),
                                const SizedBox(height: 24),
                              ],
                              if (pendentes.isNotEmpty) ...[
                                _buildSectionHeader(theme, 'Pendentes da Fase Atual', Colors.orange.shade800, Icons.warning_amber),
                                const SizedBox(height: 8),
                                ...pendentes.map((l) => _buildReminderCard(context, theme, l)),
                                const SizedBox(height: 24),
                              ],
                              if (agendados.isNotEmpty) ...[
                                _buildSectionHeader(theme, 'Próximos Reforços Agendados', Colors.blue.shade800, Icons.alarm_on),
                                const SizedBox(height: 8),
                                ...agendados.map((l) => _buildReminderCard(context, theme, l)),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderSummary(ThemeData theme, int totalAtrasados, int totalPendentes, int totalAgendados) {
    final bool temPerigo = totalAtrasados > 0 || totalPendentes > 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                temPerigo ? Icons.notifications_active : Icons.notifications_off_outlined,
                color: temPerigo ? Colors.redAccent : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                temPerigo ? 'Atenção aos seus prazos!' : 'Tudo em dia!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: temPerigo ? Colors.red.shade900 : Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryBadge('Críticas', totalAtrasados, Colors.red.shade50, Colors.red.shade800),
              _buildSummaryBadge('Pendentes', totalPendentes, Colors.orange.shade50, Colors.orange.shade800),
              _buildSummaryBadge('Agendadas', totalAgendados, Colors.blue.shade50, Colors.blue.shade800),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBadge(String label, int count, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textColor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String titulo, Color cor, IconData icone) {
    return Row(
      children: [
        Icon(icone, size: 18, color: cor),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
      ],
    );
  }

  Widget _buildReminderCard(BuildContext context, ThemeData theme, NotificationReminder l) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: l.corDestaque.withOpacity(0.3), width: 1),
      ),
      color: l.corDestaque.withOpacity(0.04),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: l.corDestaque.withOpacity(0.1),
                  child: Icon(l.icone, size: 20, color: l.corDestaque),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.titulo,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.descricao,
                        style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (l.dataReferencia != null)
                  Text(
                    'Prazo: ${DateFormat('dd/MM/yyyy').format(l.dataReferencia!)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: l.corDestaque,
                    ),
                  )
                else
                  Text(
                    'Esquema Incompleto',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: l.corDestaque,
                    ),
                  ),
                OutlinedButton(
                  onPressed: () => _irParaRegistro(context, l.nomeOriginalVacina, l.dosePreSelecionada),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: l.corDestaque),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(
                    l.acaoTexto,
                    style: TextStyle(color: l.corDestaque, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified, size: 64, color: Colors.green.shade400),
            const SizedBox(height: 16),
            const Text(
              'Parabéns! Tudo em dia!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nenhum reforço atrasado ou vacina de rotina pendente identificada.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
