import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'package:intl/intl.dart';
import 'record_form_screen.dart';
import '../services/pdf_service.dart';

class HistoryScreen extends StatefulWidget {
  final Usuario user;
  const HistoryScreen({super.key, required this.user});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _searchQuery = '';
  String _selectedCategoryFilter = 'Todas';
  String _selectedDoseFilter = 'Todas';
  String _selectedFabricanteFilter = 'Todos';
  bool _showAdvancedFilters = false;

  bool _hasActiveFilters() {
    return _selectedCategoryFilter != 'Todas' ||
        _selectedDoseFilter != 'Todas' ||
        _selectedFabricanteFilter != 'Todos';
  }

  void _clearAllFilters() {
    setState(() {
      _selectedCategoryFilter = 'Todas';
      _selectedDoseFilter = 'Todas';
      _selectedFabricanteFilter = 'Todos';
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Carteira'),
        actions: [
          StreamBuilder<Usuario?>(
            stream: db.watchUsuario(widget.user.id),
            builder: (context, userSnapshot) {
              final currentUser = userSnapshot.data ?? widget.user;
              return StreamBuilder<List<Alergia>>(
                stream: db.watchAlergias(widget.user.id),
                builder: (context, alergiasSnapshot) {
                  final alergias = alergiasSnapshot.data ?? [];
                  return StreamBuilder<List<AgendaWithVacina>>(
                    stream: db.watchHistoricoDetalhado(widget.user.id),
                    builder: (context, snapshot) {
                      return IconButton(
                        tooltip: 'Exportar PDF',
                        icon: const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                        onPressed: snapshot.hasData && snapshot.data!.isNotEmpty
                            ? () => PdfService.generateAndPrintVaccineHistory(currentUser, snapshot.data!, alergias)
                            : null,
                      );
                    },
                  );
                }
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilterPanel(theme),
          Expanded(
            child: StreamBuilder<List<AgendaWithVacina>>(
              stream: db.watchHistoricoDetalhado(widget.user.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data ?? [];
                
                final filteredData = data.where((item) {
                  // 1. Filtro de Texto (Pesquisa)
                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    final vacNome = item.vacina.nome.toLowerCase();
                    final vacDesc = item.vacina.descricao.toLowerCase();
                    final fabricante = (item.agenda.fabricante ?? '').toLowerCase();
                    final lote = (item.agenda.lote ?? '').toLowerCase();
                    final local = (item.agenda.local ?? '').toLowerCase();
                    if (!vacNome.contains(query) &&
                        !vacDesc.contains(query) &&
                        !fabricante.contains(query) &&
                        !lote.contains(query) &&
                        !local.contains(query)) {
                      return false;
                    }
                  }
                  // 2. Filtro de Categoria
                  if (_selectedCategoryFilter != 'Todas' && item.vacina.categoria != _selectedCategoryFilter) {
                    return false;
                  }
                  // 3. Filtro de Dose
                  if (_selectedDoseFilter != 'Todas' && item.agenda.dose != _selectedDoseFilter) {
                    return false;
                  }
                  // 4. Filtro de Fabricante
                  if (_selectedFabricanteFilter != 'Todos') {
                    final fabItem = item.agenda.fabricante ?? 'N/A';
                    if (_selectedFabricanteFilter == 'Outro' &&
                        ['Butantan', 'Fiocruz / Bio-Manguinhos', 'Pfizer', 'AstraZeneca', 'Janssen', 'GSK', 'Sanofi Pasteur'].contains(fabItem)) {
                      return false;
                    }
                    if (_selectedFabricanteFilter != 'Outro' && fabItem != _selectedFabricanteFilter) {
                      return false;
                    }
                  }
                  return true;
                }).toList();

                if (filteredData.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_edu, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty || _hasActiveFilters()
                              ? 'Nenhum registro corresponde aos filtros.'
                              : 'Nenhum registro encontrado.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        if (_searchQuery.isNotEmpty || _hasActiveFilters()) ...[
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _clearAllFilters();
                              });
                            },
                            child: const Text('Limpar filtros e busca'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    final item = filteredData[index];
                    return Dismissible(
                      key: Key(item.agenda.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        await db.excluirDose(item.agenda.id, widget.user.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.vacina.nome} removida')),
                          );
                        }
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Excluir registro?'),
                            content: const Text('Esta ação não pode ser desfeita.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
                              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('EXCLUIR', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                      },
                      child: _buildVaccineCard(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterPanel(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por vacina, lote, fabricante...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: _hasActiveFilters() ? theme.colorScheme.primaryContainer : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: _hasActiveFilters() ? theme.colorScheme.primary : Colors.grey.shade700,
                  ),
                  onPressed: () {
                    setState(() {
                      _showAdvancedFilters = !_showAdvancedFilters;
                    });
                  },
                  tooltip: 'Filtros Avançados',
                ),
              ),
            ],
          ),
          if (_showAdvancedFilters) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtros Avançados',
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (_hasActiveFilters())
                        TextButton.icon(
                          onPressed: _clearAllFilters,
                          icon: const Icon(Icons.clear_all, size: 16),
                          label: const Text('Limpar', style: TextStyle(fontSize: 12)),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 16),
                  
                  // Filtro por Categoria
                  _buildFilterDropdown(
                    label: 'Categoria',
                    value: _selectedCategoryFilter,
                    items: ['Todas', 'Rotina', 'Campanha', 'Viagem', 'Outros'],
                    onChanged: (val) => setState(() => _selectedCategoryFilter = val!),
                  ),
                  const SizedBox(height: 8),

                  // Filtro por Dose
                  _buildFilterDropdown(
                    label: 'Dose',
                    value: _selectedDoseFilter,
                    items: ['Todas', '1ª Dose', '2ª Dose', '3ª Dose', 'Dose Única', 'Reforço', 'Dose Anual'],
                    onChanged: (val) => setState(() => _selectedDoseFilter = val!),
                  ),
                  const SizedBox(height: 8),

                  // Filtro por Fabricante
                  _buildFilterDropdown(
                    label: 'Fabricante',
                    value: _selectedFabricanteFilter,
                    items: ['Todos', 'Butantan', 'Fiocruz / Bio-Manguinhos', 'Pfizer', 'AstraZeneca', 'Janssen', 'GSK', 'Sanofi Pasteur', 'Outro'],
                    onChanged: (val) => setState(() => _selectedFabricanteFilter = val!),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
                items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVaccineCard(AgendaWithVacina item) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.vacina.nome,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                _buildCategoryBadge(item.vacina.categoria),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) async {
                    if (value == 'editar') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordFormScreen(
                            user: widget.user,
                            agendaParaEditar: item,
                          ),
                        ),
                      );
                    } else if (value == 'excluir') {
                      final confirmar = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Excluir registro?'),
                          content: const Text('Esta ação não pode ser desfeita.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCELAR')),
                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('EXCLUIR', style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                      
                      if (confirmar == true && mounted) {
                        await context.read<AppDatabase>().excluirDose(item.agenda.id, widget.user.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${item.vacina.nome} removida')),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'editar',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 20),
                          SizedBox(width: 8),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'excluir',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text('Excluir', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _buildInfoItem(Icons.vaccines, 'Dose', item.agenda.dose),
                const SizedBox(width: 24),
                _buildInfoItem(Icons.calendar_today, 'Data', DateFormat('dd/MM/yyyy').format(item.agenda.dataAplicacao)),
              ],
            ),
            Row(
              children: [
                _buildInfoItem(Icons.qr_code, 'Lote', item.agenda.lote ?? 'N/A'),
                const SizedBox(width: 24),
                _buildInfoItem(Icons.business, 'Fabricante', item.agenda.fabricante ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoItem(Icons.location_on, 'Local', item.agenda.local ?? 'N/A'),
              ],
            ),
            if (item.agenda.proximaDose != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notification_important, size: 16, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Text(
                      'Reforço em: ${DateFormat('dd/MM/yyyy').format(item.agenda.proximaDose!)}',
                      style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    Color color;
    switch (category) {
      case 'Rotina': color = Colors.blue; break;
      case 'Viagem': color = Colors.purple; break;
      case 'Campanha': color = Colors.orange; break;
      default: color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        category,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
