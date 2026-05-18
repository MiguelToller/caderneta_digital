import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';

class RecordFormScreen extends StatefulWidget {
  final Usuario user;
  final AgendaWithVacina? agendaParaEditar;
  final Vacina? vacinaPreSelecionada;
  const RecordFormScreen({
    super.key,
    required this.user,
    this.agendaParaEditar,
    this.vacinaPreSelecionada,
  });

  @override
  State<RecordFormScreen> createState() => _RecordFormScreenState();
}

class _RecordFormScreenState extends State<RecordFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  Vacina? _selectedVacina;
  String? _selectedDose = '1ª Dose';
  String? _selectedFabricante;
  final _loteController = TextEditingController();
  final _localController = TextEditingController();
  
  DateTime _dataAplicacao = DateTime.now();
  DateTime? _proximaDose;

  bool _isLoading = false;
  late Future<List<Vacina>> _vacinasFuture;
  List<String> _dosesJaRegistradas = [];

  @override
  void initState() {
    super.initState();
    // Carregar vacinas uma única vez para evitar que rebuilds causados
    // por mudanças no banco resetem o estado do formulário
    _vacinasFuture = context.read<AppDatabase>().todasVacinas;

    if (widget.agendaParaEditar != null) {
      final a = widget.agendaParaEditar!.agenda;
      _selectedVacina = widget.agendaParaEditar!.vacina;
      _selectedDose = a.dose;
      _selectedFabricante = a.fabricante;
      _loteController.text = a.lote ?? '';
      _localController.text = a.local ?? '';
      _dataAplicacao = a.dataAplicacao;
      _proximaDose = a.proximaDose;
      _carregarDosesJaRegistradas();
    } else if (widget.vacinaPreSelecionada != null) {
      _selectedVacina = widget.vacinaPreSelecionada;
      _carregarDosesJaRegistradas();
    }
  }

  void _carregarDosesJaRegistradas() async {
    if (_selectedVacina == null) return;
    final db = context.read<AppDatabase>();
    final results = await (db.select(db.agendas)
      ..where((a) => a.usuarioId.equals(widget.user.id) & a.vacinaId.equals(_selectedVacina!.id)))
      .get();
    
    if (!mounted) return;
    setState(() {
      _dosesJaRegistradas = results.map((r) => r.dose).toList();
      
      final dosesDisponiveis = ['1ª Dose', '2ª Dose', '3ª Dose', 'Dose Única', 'Reforço', 'Dose Anual']
          .where((d) => !_dosesJaRegistradas.contains(d) || (widget.agendaParaEditar != null && widget.agendaParaEditar!.agenda.dose == d))
          .toList();
          
      if (dosesDisponiveis.isNotEmpty) {
        if (_selectedDose == null || 
            (!dosesDisponiveis.contains(_selectedDose) && 
             (widget.agendaParaEditar == null || widget.agendaParaEditar!.agenda.dose != _selectedDose))) {
          _selectedDose = dosesDisponiveis.first;
        }
      }
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate() || _selectedVacina == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma vacina.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final db = context.read<AppDatabase>();

    try {
      // Campos opcionais: passar null se estiver vazio
      final lote = _loteController.text.trim().isEmpty ? null : _loteController.text.trim();
      final local = _localController.text.trim().isEmpty ? null : _localController.text.trim();

      final companion = AgendasCompanion.insert(
        usuarioId: widget.user.id,
        vacinaId: _selectedVacina!.id,
        dose: _selectedDose ?? '1ª Dose',
        lote: drift.Value(lote),
        fabricante: drift.Value(_selectedFabricante),
        dataAplicacao: _dataAplicacao,
        local: drift.Value(local),
        proximaDose: drift.Value(_proximaDose),
      );

      if (widget.agendaParaEditar == null) {
        await db.registrarDose(companion);
      } else {
        await db.atualizarDose(widget.agendaParaEditar!.agenda.id, widget.user.id, companion);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.agendaParaEditar == null ? 'Registro salvo com sucesso!' : 'Registro atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isProxima) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isProxima ? (_proximaDose ?? DateTime.now().add(const Duration(days: 30))) : _dataAplicacao,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isProxima) {
          _proximaDose = picked;
        } else {
          _dataAplicacao = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.agendaParaEditar == null ? 'Novo Registro' : 'Editar Registro')),
      body: FutureBuilder<List<Vacina>>(
        future: _vacinasFuture, // Usar o Future fixo do initState
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final vacinas = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<Vacina>(
                    value: _selectedVacina != null
                        ? vacinas.firstWhere((v) => v.id == _selectedVacina!.id, orElse: () => _selectedVacina!)
                        : null,
                    decoration: const InputDecoration(labelText: 'Selecione a Vacina', prefixIcon: Icon(Icons.medication)),
                    items: vacinas.map((v) => DropdownMenuItem(value: v, child: Text(v.nome))).toList(),
                    onChanged: (v) {
                      setState(() {
                        _selectedVacina = v;
                      });
                      _carregarDosesJaRegistradas();
                    },
                    validator: (v) => v == null ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedDose,
                    decoration: const InputDecoration(labelText: 'Dose', prefixIcon: Icon(Icons.numbers)),
                    items: ['1ª Dose', '2ª Dose', '3ª Dose', 'Dose Única', 'Reforço', 'Dose Anual']
                        .where((d) => !_dosesJaRegistradas.contains(d) || (widget.agendaParaEditar != null && widget.agendaParaEditar!.agenda.dose == d))
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedDose = val),
                    validator: (val) => val == null ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedFabricante,
                    decoration: const InputDecoration(labelText: 'Fabricante / Laboratório', prefixIcon: Icon(Icons.business)),
                    items: ['Butantan', 'Fiocruz / Bio-Manguinhos', 'Pfizer', 'AstraZeneca', 'Janssen', 'GSK', 'Sanofi Pasteur', 'Outro']
                        .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedFabricante = val),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _loteController,
                    decoration: const InputDecoration(labelText: 'Lote', prefixIcon: Icon(Icons.qr_code)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _localController,
                    decoration: const InputDecoration(labelText: 'Local de Aplicação', prefixIcon: Icon(Icons.location_on)),
                  ),
                  const SizedBox(height: 24),
                  _buildDatePickerTile('Data da Aplicação', _dataAplicacao, () => _selectDate(context, false)),
                  const SizedBox(height: 16),
                  _buildDatePickerTile(
                    'Previsão Próxima Dose', 
                    _proximaDose, 
                    () => _selectDate(context, true),
                    isOptional: true,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading ? const CircularProgressIndicator() : Text(widget.agendaParaEditar == null ? 'SALVAR REGISTRO' : 'ATUALIZAR REGISTRO'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDatePickerTile(String label, DateTime? date, VoidCallback onTap, {bool isOptional = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  date != null ? DateFormat('dd/MM/yyyy').format(date) : (isOptional ? 'Não agendada' : 'Selecionar data'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }
}
