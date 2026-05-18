import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'record_form_screen.dart';

class RecomendacaoVacina {
  final String nome;
  final String descricao;
  final String doseRecomendada;
  final String idadeRecomendada;

  RecomendacaoVacina({
    required this.nome,
    required this.descricao,
    required this.doseRecomendada,
    required this.idadeRecomendada,
  });
}

class CalendarScreen extends StatelessWidget {
  final Usuario user;
  const CalendarScreen({super.key, required this.user});

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

  bool _verificarSeTomou(RecomendacaoVacina rec, List<AgendaWithVacina> historico) {
    final recNome = rec.nome.toLowerCase();
    return historico.any((item) {
      final vacNome = item.vacina.nome.toLowerCase();
      if (vacNome == recNome) return true;
      if (vacNome.contains('bcg') && recNome.contains('bcg')) return true;
      if (vacNome.contains('hepatite b') && recNome.contains('hepatite b')) return true;
      if (vacNome.contains('pentavalente') && recNome.contains('pentavalente')) return true;
      if (vacNome.contains('poliomielite') && recNome.contains('poliomielite')) return true;
      if (vacNome.contains('vip/vop') && recNome.contains('vip/vop')) return true;
      if (vacNome.contains('pneumoc') && recNome.contains('pneumoc')) return true;
      if (vacNome.contains('rotav') && recNome.contains('rotav')) return true;
      if (vacNome.contains('meningoc') && recNome.contains('meningoc')) return true;
      if (vacNome.contains('febre amarela') && recNome.contains('febre amarela')) return true;
      if (vacNome.contains('tríplice viral') && recNome.contains('tríplice viral')) return true;
      if (vacNome.contains('hepatite a') && recNome.contains('hepatite a')) return true;
      if (vacNome.contains('dtp') && recNome.contains('dtp')) return true;
      if (vacNome.contains('varicela') && recNome.contains('varicela')) return true;
      if (vacNome.contains('hpv') && recNome.contains('hpv')) return true;
      if (vacNome.contains('dt ') && recNome.contains('dt ')) return true;
      if (vacNome.contains('dupla adulto') && recNome.contains('dupla adulto')) return true;
      if (vacNome.contains('gripe') && recNome.contains('gripe')) return true;
      if (vacNome.contains('influenza') && recNome.contains('influenza')) return true;
      if (vacNome.contains('covid') && recNome.contains('covid')) return true;
      if (vacNome.contains('dengue') && recNome.contains('dengue')) return true;
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final theme = Theme.of(context);

    final Map<String, List<RecomendacaoVacina>> calendarioSus = {
      'Criança (0 a 10 anos)': [
        RecomendacaoVacina(nome: 'BCG', descricao: 'Tuberculose (formas graves)', doseRecomendada: 'Dose única ao nascer', idadeRecomendada: 'Ao nascer'),
        RecomendacaoVacina(nome: 'Hepatite B', descricao: 'Hepatite B', doseRecomendada: 'Dose única ao nascer', idadeRecomendada: 'Ao nascer'),
        RecomendacaoVacina(nome: 'Pentavalente', descricao: 'Difteria, Tétano, Coqueluche, HepB, Hib', doseRecomendada: '3 doses', idadeRecomendada: '2, 4 e 6 meses'),
        RecomendacaoVacina(nome: 'VIP/VOP (Poliomielite)', descricao: 'Paralisia infantil', doseRecomendada: '3 doses VIP + 2 reforços VOP', idadeRecomendada: '2, 4, 6 meses (VIP) e 15 meses, 4 anos (VOP)'),
        RecomendacaoVacina(nome: 'Pneumocócica 10V', descricao: 'Pneumonia, otite, meningite', doseRecomendada: '2 doses + 1 reforço', idadeRecomendada: '2, 4 meses e reforço aos 12 meses'),
        RecomendacaoVacina(nome: 'Rotavírus', descricao: 'Diarreia por rotavírus', doseRecomendada: '2 doses', idadeRecomendada: '2 e 4 meses'),
        RecomendacaoVacina(nome: 'Meningocócica C', descricao: 'Meningite C', doseRecomendada: '2 doses + 1 reforço', idadeRecomendada: '3, 5 meses e reforço aos 12 meses'),
        RecomendacaoVacina(nome: 'Febre Amarela', descricao: 'Febre amarela', doseRecomendada: '1 dose + 1 reforço', idadeRecomendada: '9 meses e reforço aos 4 anos'),
        RecomendacaoVacina(nome: 'Tríplice Viral (SRC)', descricao: 'Sarampo, Caxumba, Rubéola', doseRecomendada: '2 doses', idadeRecomendada: '12 e 15 meses'),
        RecomendacaoVacina(nome: 'Hepatite A', descricao: 'Hepatite A', doseRecomendada: '1 dose', idadeRecomendada: '15 meses'),
        RecomendacaoVacina(nome: 'DTP', descricao: 'Difteria, Tétano, Coqueluche (reforço)', doseRecomendada: '2 reforços', idadeRecomendada: '15 meses e 4 anos'),
        RecomendacaoVacina(nome: 'Varicela', descricao: 'Catapora', doseRecomendada: '1 dose', idadeRecomendada: '15 meses'),
      ],
      'Adolescente (11 a 19 anos)': [
        RecomendacaoVacina(nome: 'HPV Quadrivalente', descricao: 'Prevenção de cânceres e verrugas genitais', doseRecomendada: '2 doses', idadeRecomendada: '9 a 14 anos'),
        RecomendacaoVacina(nome: 'Meningocócica ACWY', descricao: 'Meningites ACWY', doseRecomendada: 'Dose única', idadeRecomendada: '11 a 12 anos'),
        RecomendacaoVacina(nome: 'Hepatite B', descricao: 'Hepatite B (iniciar ou completar esquema)', doseRecomendada: '3 doses', idadeRecomendada: '11 a 19 anos'),
        RecomendacaoVacina(nome: 'Tríplice Viral (SRC)', descricao: 'Sarampo, Caxumba, Rubéola (se não vacinado)', doseRecomendada: '2 doses', idadeRecomendada: '11 a 19 anos'),
        RecomendacaoVacina(nome: 'dT (Dupla Adulto)', descricao: 'Difteria e Tétano (reforço)', doseRecomendada: 'Reforço a cada 10 anos', idadeRecomendada: '11 a 19 anos'),
      ],
      'Adulto (20 a 59 anos)': [
        RecomendacaoVacina(nome: 'Hepatite B', descricao: 'Hepatite B (iniciar ou completar esquema)', doseRecomendada: '3 doses', idadeRecomendada: '20 a 59 anos'),
        RecomendacaoVacina(nome: 'Tríplice Viral (SRC)', descricao: 'Sarampo, Caxumba, Rubéola (se não vacinado)', doseRecomendada: '1 ou 2 doses', idadeRecomendada: 'Até 49 anos (2 doses até 29, 1 dose de 30-49)'),
        RecomendacaoVacina(nome: 'dT (Dupla Adulto)', descricao: 'Difteria e Tétano', doseRecomendada: 'Reforço a cada 10 anos', idadeRecomendada: 'A partir de 20 anos'),
        RecomendacaoVacina(nome: 'Febre Amarela', descricao: 'Febre amarela (se nunca tomou)', doseRecomendada: 'Dose única', idadeRecomendada: 'Até 59 anos'),
      ],
      'Idoso (60 anos ou mais)': [
        RecomendacaoVacina(nome: 'Hepatite B', descricao: 'Hepatite B (iniciar ou completar esquema)', doseRecomendada: '3 doses', idadeRecomendada: 'A partir de 60 anos'),
        RecomendacaoVacina(nome: 'dT (Dupla Adulto)', descricao: 'Difteria e Tétano', doseRecomendada: 'Reforço a cada 10 anos', idadeRecomendada: 'A partir de 60 anos'),
        RecomendacaoVacina(nome: 'Gripe (Influenza)', descricao: 'Gripe comum', doseRecomendada: 'Dose anual', idadeRecomendada: 'Anual'),
        RecomendacaoVacina(nome: 'Pneumocócica 23V', descricao: 'Prevenção de pneumonia grave (acamados/institucionalizados)', doseRecomendada: 'Dose única', idadeRecomendada: '60 anos ou mais'),
      ],
    };

    return StreamBuilder<Usuario?>(
      stream: db.watchUsuario(user.id),
      initialData: user,
      builder: (context, userSnapshot) {
        final currentUser = userSnapshot.data ?? user;
        final int? idade = currentUser.dataNascimento != null ? _calcularIdade(currentUser.dataNascimento!) : null;
        final String faseAtual = idade != null ? _obterCategoriaPorIdade(idade) : '';

        return Scaffold(
          body: StreamBuilder<List<AgendaWithVacina>>(
            stream: db.watchHistoricoDetalhado(user.id),
            builder: (context, historicoSnapshot) {
              final historico = historicoSnapshot.data ?? [];

              return CustomScrollView(
                slivers: [
                  const SliverAppBar.large(
                    title: Text('Calendário SUS'),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildIntroCard(context, currentUser, idade, faseAtual),
                          const SizedBox(height: 20),
                          Text(
                            'Calendário Nacional de Imunização',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...calendarioSus.keys.map((fase) {
                            final isUserFase = fase == faseAtual;
                            final recomendacoes = calendarioSus[fase]!;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: isUserFase ? 3 : 0,
                              shadowColor: isUserFase ? theme.colorScheme.primary.withOpacity(0.2) : null,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                  color: isUserFase
                                      ? theme.colorScheme.primary.withOpacity(0.5)
                                      : Colors.grey.shade200,
                                  width: isUserFase ? 1.5 : 1,
                                ),
                              ),
                              child: Theme(
                                data: theme.copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  initiallyExpanded: isUserFase,
                                  leading: Icon(
                                    Icons.lens,
                                    size: 14,
                                    color: isUserFase ? theme.colorScheme.primary : Colors.grey[400],
                                  ),
                                  title: Row(
                                    children: [
                                      Text(
                                        fase,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isUserFase ? theme.colorScheme.primary : null,
                                        ),
                                      ),
                                      if (isUserFase) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primaryContainer,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Sua Fase',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  children: recomendacoes.map((rec) {
                                    final tomou = _verificarSeTomou(rec, historico);

                                    return ListTile(
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      title: Text(
                                        rec.nome,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 2),
                                          Text(
                                            rec.descricao,
                                            style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(Icons.info_outline, size: 14, color: theme.colorScheme.secondary),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  'Recomendado: ${rec.idadeRecomendada} (${rec.doseRecomendada})',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: theme.colorScheme.secondary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: tomou
                                          ? Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: Colors.green.shade50,
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: Colors.green.shade300),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.check_circle, size: 14, color: Colors.green.shade700),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Aplicada',
                                                    style: TextStyle(
                                                      color: Colors.green.shade700,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : OutlinedButton(
                                              onPressed: () => _registrarVacinaPendente(context, rec, db),
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              ),
                                              child: const Text('Registrar', style: TextStyle(fontSize: 11)),
                                            ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildIntroCard(BuildContext context, Usuario currentUser, int? idade, String faseAtual) {
    final theme = Theme.of(context);

    if (idade == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.secondaryContainer),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_month, color: theme.colorScheme.secondary, size: 30),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Preencha sua data de nascimento no Perfil para receber recomendações de vacinas personalizadas de acordo com a sua idade.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.primaryContainer),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            radius: 20,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fase de Imunização Atual',
                  style: TextStyle(color: theme.colorScheme.primary, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 2),
                Text(
                  faseAtual,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'Idade: $idade anos. Vacinas recomendadas pelo SUS:',
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _registrarVacinaPendente(BuildContext context, RecomendacaoVacina rec, AppDatabase db) async {
    // Buscar a vacina no catálogo por nome aproximado
    final vacinas = await db.todasVacinas;
    Vacina? vacinaCorrespondente;
    try {
      vacinaCorrespondente = vacinas.firstWhere(
        (v) => v.nome.toLowerCase().contains(rec.nome.toLowerCase()) ||
               rec.nome.toLowerCase().contains(v.nome.toLowerCase()),
      );
    } catch (_) {
      // Se não encontrar por contêm, pega a vacina pelo primeiro termo (ex: "VIP/VOP (Poliomielite)" vs "VIP")
      final primeiroTermo = rec.nome.split(' ')[0].toLowerCase();
      try {
        vacinaCorrespondente = vacinas.firstWhere(
          (v) => v.nome.toLowerCase().contains(primeiroTermo) ||
                 primeiroTermo.contains(v.nome.toLowerCase()),
        );
      } catch (_) {
        // Sem correspondência direta
      }
    }

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RecordFormScreen(
            user: user,
            vacinaPreSelecionada: vacinaCorrespondente,
          ),
        ),
      );
    }
  }
}
