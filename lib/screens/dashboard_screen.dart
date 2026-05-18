import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatelessWidget {
  final Usuario user;
  const DashboardScreen({super.key, required this.user});

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

  List<AgendaWithVacina> _obterDosesTomadas(_RecomendacaoVacina rec, List<AgendaWithVacina> historico) {
    final recNome = rec.nome.toLowerCase();
    return historico.where((item) {
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
      if (vacNome.contains('gripe') && recNome.contains('gripe')) return true;
      if (vacNome.contains('influenza') && recNome.contains('influenza')) return true;
      return false;
    }).toList();
  }

  static const List<_RecomendacaoVacina> _recomendacoes = [
    // Criança
    _RecomendacaoVacina(nome: 'BCG', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 1),
    _RecomendacaoVacina(nome: 'Hepatite B', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 1),
    _RecomendacaoVacina(nome: 'Pentavalente', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 3),
    _RecomendacaoVacina(nome: 'VIP/VOP (Poliomielite)', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 5),
    _RecomendacaoVacina(nome: 'Pneumocócica 10V', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 3),
    _RecomendacaoVacina(nome: 'Rotavírus', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 2),
    _RecomendacaoVacina(nome: 'Meningocócica C', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 3),
    _RecomendacaoVacina(nome: 'Febre Amarela', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 2),
    _RecomendacaoVacina(nome: 'Tríplice Viral (SRC)', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 2),
    _RecomendacaoVacina(nome: 'Hepatite A', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 1),
    _RecomendacaoVacina(nome: 'DTP', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 2),
    _RecomendacaoVacina(nome: 'Varicela', categoria: 'Criança (0 a 10 anos)', dosesNecessarias: 1),
    
    // Adolescente
    _RecomendacaoVacina(nome: 'HPV Quadrivalente', categoria: 'Adolescente (11 a 19 anos)', dosesNecessarias: 2),
    _RecomendacaoVacina(nome: 'Meningocócica ACWY', categoria: 'Adolescente (11 a 19 anos)', dosesNecessarias: 1),
    _RecomendacaoVacina(nome: 'Hepatite B', categoria: 'Adolescente (11 a 19 anos)', dosesNecessarias: 3),
    _RecomendacaoVacina(nome: 'Tríplice Viral (SRC)', categoria: 'Adolescente (11 a 19 anos)', dosesNecessarias: 2),
    _RecomendacaoVacina(nome: 'dT (Dupla Adulto)', categoria: 'Adolescente (11 a 19 anos)', dosesNecessarias: 1),
    
    // Adulto
    _RecomendacaoVacina(nome: 'Hepatite B', categoria: 'Adulto (20 a 59 anos)', dosesNecessarias: 3),
    _RecomendacaoVacina(nome: 'Tríplice Viral (SRC)', categoria: 'Adulto (20 a 59 anos)', dosesNecessarias: 2),
    _RecomendacaoVacina(nome: 'dT (Dupla Adulto)', categoria: 'Adulto (20 a 59 anos)', dosesNecessarias: 1),
    _RecomendacaoVacina(nome: 'Febre Amarela', categoria: 'Adulto (20 a 59 anos)', dosesNecessarias: 1),
    
    // Idoso
    _RecomendacaoVacina(nome: 'Hepatite B', categoria: 'Idoso (60 anos ou mais)', dosesNecessarias: 3),
    _RecomendacaoVacina(nome: 'dT (Dupla Adulto)', categoria: 'Idoso (60 anos ou mais)', dosesNecessarias: 1),
    _RecomendacaoVacina(nome: 'Gripe (Influenza)', categoria: 'Idoso (60 anos ou mais)', dosesNecessarias: 1),
    _RecomendacaoVacina(nome: 'Pneumocócica 23V', categoria: 'Idoso (60 anos ou mais)', dosesNecessarias: 1),
  ];

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final theme = Theme.of(context);

    return StreamBuilder<Usuario?>(
      stream: db.watchUsuario(user.id),
      initialData: user,
      builder: (context, snapshot) {
        final currentUser = snapshot.data ?? user;
        
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: Text('Olá, ${currentUser.nome.split(' ')[0]}'),
                actions: [
                  StreamBuilder<List<AgendaWithVacina>>(
                    stream: db.watchHistoricoDetalhado(user.id),
                    builder: (context, snapshot) {
                      final hasNotifications = snapshot.hasData && snapshot.data!.any((item) => item.agenda.proximaDose != null && item.agenda.proximaDose!.isBefore(DateTime.now()));
                      return IconButton(
                        tooltip: 'Avisos e Lembretes',
                        icon: Badge(
                          isLabelVisible: hasNotifications,
                          backgroundColor: Colors.redAccent,
                          child: const Icon(Icons.notifications_none_outlined),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => NotificationsScreen(user: user)),
                          );
                        },
                      );
                    },
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    icon: const Icon(Icons.logout),
                    onPressed: () => _confirmarLogout(context),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(context, currentUser),
                      const SizedBox(height: 24),
                      Text('Última Aplicação', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildLastVaccineCard(context, db),
                      const SizedBox(height: 24),
                      Text('Próximo Reforço', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      _buildNextDoseCard(context, db),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildSummaryCard(BuildContext context, Usuario currentUser) {
    final db = context.watch<AppDatabase>();
    final theme = Theme.of(context);
    final String idadeTexto = currentUser.dataNascimento != null 
        ? '${_calcularIdade(currentUser.dataNascimento!)} anos' 
        : 'Idade não informada';
    final int idade = currentUser.dataNascimento != null ? _calcularIdade(currentUser.dataNascimento!) : 30;
    final String faseAtual = _obterCategoriaPorIdade(idade);

    return StreamBuilder<List<AgendaWithVacina>>(
      stream: db.watchHistoricoDetalhado(currentUser.id),
      builder: (context, snapshot) {
        final historico = snapshot.data ?? [];

        // 1. Filtrar recomendações da fase atual
        final recsFase = _recomendacoes.where((r) => r.categoria == faseAtual).toList();
        int concluidas = 0;
        int incompletas = 0;
        int naoIniciadas = 0;

        for (final rec in recsFase) {
          final tomadas = _obterDosesTomadas(rec, historico).length;
          if (tomadas >= rec.dosesNecessarias) {
            concluidas++;
          } else if (tomadas > 0) {
            incompletas++;
          } else {
            naoIniciadas++;
          }
        }

        final double cobertura = recsFase.isNotEmpty ? (concluidas / recsFase.length) : 1.0;

        // 2. Calcular coberturas por fase (Criança, Adolescente, Adulto, Idoso)
        final fases = ['Criança (0 a 10 anos)', 'Adolescente (11 a 19 anos)', 'Adulto (20 a 59 anos)', 'Idoso (60 anos ou mais)'];
        final Map<String, double> coberturaFase = {};

        for (final f in fases) {
          final recs = _recomendacoes.where((r) => r.categoria == f).toList();
          int comp = 0;
          for (final rec in recs) {
            final tomadas = _obterDosesTomadas(rec, historico).length;
            if (tomadas >= rec.dosesNecessarias) {
              comp++;
            }
          }
          coberturaFase[f] = recs.isNotEmpty ? (comp / recs.length) : 1.0;
        }

        final statusTexto = naoIniciadas == 0 && incompletas == 0
            ? 'Imunização em Dia'
            : (incompletas > 0 ? 'Esquema Incompleto' : 'Pendências Encontradas');

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card Principal com o Gráfico e Status Geral
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer.withBlue(220)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      // Gráfico circular animado
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: cobertura),
                        duration: const Duration(milliseconds: 1200),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return CustomPaint(
                            size: const Size(80, 80),
                            painter: _CircularProgressPainter(
                              progress: value,
                              trackColor: Colors.white24,
                              progressColor: Colors.white,
                            ),
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Center(
                                child: Text(
                                  '${(value * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 24),
                      // Textos de Imunização
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'COBERTURA DA FASE',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              statusTexto,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                faseAtual.split(' ')[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 32),
                  // Informações de Perfil e Tipo Sanguíneo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSummaryMeta(Icons.verified_user, 'Tipo', currentUser.tipoSanguineo ?? 'N/A'),
                      _buildSummaryMeta(Icons.cake, 'Idade', idadeTexto),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Pílulas Estatísticas Rápidas
            Row(
              children: [
                Expanded(
                  child: _buildStatBadge(
                    context, 
                    'Concluídas', 
                    concluidas.toString(), 
                    Colors.green.shade700, 
                    Colors.green.shade50
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatBadge(
                    context, 
                    'Em Andamento', 
                    incompletas.toString(), 
                    Colors.orange.shade700, 
                    Colors.orange.shade50
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatBadge(
                    context, 
                    'Não Iniciadas', 
                    naoIniciadas.toString(), 
                    Colors.grey.shade700, 
                    Colors.grey.shade100
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Progresso por Fases da Vida do SUS
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progresso por Fases do SUS',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ...fases.map((f) {
                      final isAtual = f == faseAtual;
                      final valor = coberturaFase[f] ?? 0.0;
                      
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      f.split(' ')[0],
                                      style: TextStyle(
                                        fontWeight: isAtual ? FontWeight.bold : FontWeight.normal,
                                        color: isAtual ? theme.colorScheme.primary : Colors.black87,
                                        fontSize: 13,
                                      ),
                                    ),
                                    if (isAtual) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Atual',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  '${(valor * 100).toInt()}%',
                                  style: TextStyle(
                                    fontWeight: isAtual ? FontWeight.bold : FontWeight.w500,
                                    fontSize: 12,
                                    color: isAtual ? theme.colorScheme.primary : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: valor,
                                backgroundColor: Colors.grey.shade100,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isAtual ? theme.colorScheme.primary : Colors.grey.shade400,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildSummaryMeta(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildStatBadge(
    BuildContext context, 
    String label, 
    String count, 
    Color textColor, 
    Color bgColor
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: textColor
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10, 
              fontWeight: FontWeight.w600, 
              color: textColor.withOpacity(0.8)
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLastVaccineCard(BuildContext context, AppDatabase db) {
    return StreamBuilder<List<AgendaWithVacina>>(
      stream: db.watchHistoricoDetalhado(user.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
            child: const ListTile(title: Text('Nenhuma vacina registrada.', style: TextStyle(color: Colors.grey))),
          );
        }

        final historico = snapshot.data!;
        historico.sort((a, b) => b.agenda.dataAplicacao.compareTo(a.agenda.dataAplicacao));
        final ultima = historico.first;

        return Card(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.1),
              child: const Icon(Icons.check_circle, color: Colors.green),
            ),
            title: Text(ultima.vacina.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Aplicada em ${DateFormat('dd/MM/yyyy').format(ultima.agenda.dataAplicacao)}'),
          ),
        );
      },
    );
  }

  Widget _buildNextDoseCard(BuildContext context, AppDatabase db) {
    return StreamBuilder<List<AgendaWithVacina>>(
      stream: db.watchHistoricoDetalhado(user.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final dosesComProxima = snapshot.data!
            .where((d) => d.agenda.proximaDose != null && d.agenda.proximaDose!.isAfter(DateTime.now()))
            .toList();
        
        if (dosesComProxima.isEmpty) return _buildEmptyState();

        dosesComProxima.sort((a, b) => a.agenda.proximaDose!.compareTo(b.agenda.proximaDose!));
        final proxima = dosesComProxima.first;

        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.calendar_today, color: Colors.white),
            ),
            title: Text(proxima.vacina.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Previsão para dose de reforço'),
            trailing: Text(
              DateFormat('dd/MM/yyyy').format(proxima.agenda.proximaDose!),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Text('Nenhum reforço agendado no momento.', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              // Limpa a sessão salva
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('usuario_id');
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color trackColor;
  final Color progressColor;
  _CircularProgressPainter({required this.progress, required this.trackColor, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 6;
    
    final paintTrack = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paintTrack);

    final paintProgress = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paintProgress,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.progressColor != progressColor;
  }
}

class _RecomendacaoVacina {
  final String nome;
  final String categoria;
  final int dosesNecessarias;
  const _RecomendacaoVacina({required this.nome, required this.categoria, required this.dosesNecessarias});
}
