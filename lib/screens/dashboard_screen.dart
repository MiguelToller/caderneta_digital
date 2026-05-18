import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

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
    final theme = Theme.of(context);
    final String idadeTexto = currentUser.dataNascimento != null 
        ? '${_calcularIdade(currentUser.dataNascimento!)} anos' 
        : 'Idade não informada';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status de Imunização',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sua carteira está atualizada',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.verified_user, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tipo: ${currentUser.tipoSanguineo ?? 'N/A'} | Idade: $idadeTexto',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
            ],
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
