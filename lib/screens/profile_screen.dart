import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';

class ProfileScreen extends StatefulWidget {
  final Usuario user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  String? _selectedTipoSanguineo;
  DateTime? _dataNascimento;

  bool _isEditing = false;
  bool _isLoading = false;

  final List<String> _tiposSanguineos = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.user.nome);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedTipoSanguineo = widget.user.tipoSanguineo;
    _dataNascimento = widget.user.dataNascimento;
  }

  void _save() async {
    setState(() => _isLoading = true);
    final db = context.read<AppDatabase>();

    await db.atualizarUsuario(
      widget.user.id,
      _nomeController.text,
      _emailController.text,
      _selectedTipoSanguineo,
      _dataNascimento,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dataNascimento = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();

    return StreamBuilder<Usuario?>(
      stream: db.watchUsuario(widget.user.id),
      initialData: widget.user,
      builder: (context, snapshot) {
        final currentUser = snapshot.data ?? widget.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Meu Perfil'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (!_isEditing) {
                      _nomeController.text = currentUser.nome;
                      _emailController.text = currentUser.email;
                      _selectedTipoSanguineo = currentUser.tipoSanguineo;
                      _dataNascimento = currentUser.dataNascimento;
                    }
                    _isEditing = !_isEditing;
                  });
                },
                icon: Icon(_isEditing ? Icons.close : Icons.edit),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blueAccent,
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 32),
                _buildInfoField('Nome Completo', _nomeController, Icons.person),
                const SizedBox(height: 16),
                _buildInfoField('E-mail', _emailController, Icons.email),
                const SizedBox(height: 16),
                _buildDatePickerTile('Data de Nascimento', _dataNascimento, _selectBirthDate),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedTipoSanguineo,
                  decoration: const InputDecoration(labelText: 'Tipo Sanguíneo', prefixIcon: Icon(Icons.bloodtype)),
                  items: _tiposSanguineos.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: _isEditing ? (val) => setState(() => _selectedTipoSanguineo = val) : null,
                ),
                const SizedBox(height: 40),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SALVAR ALTERAÇÕES'),
                  ),
                _buildAlergiasSection(context, db),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildAlergiasSection(BuildContext context, AppDatabase db) {
    return StreamBuilder<List<Alergia>>(
      stream: db.watchAlergias(widget.user.id),
      builder: (context, snapshot) {
        final alergias = snapshot.data ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minhas Alergias',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                  onPressed: () => _mostrarDialogoAlergia(context, db),
                  tooltip: 'Adicionar Alergia',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (alergias.isEmpty)
              const Text('Nenhuma alergia cadastrada.', style: TextStyle(color: Colors.grey, fontSize: 13))
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: alergias.map((alergia) => _buildAlergiaChip(context, db, alergia)).toList(),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAlergiaChip(BuildContext context, AppDatabase db, Alergia alergia) {
    Color color;
    switch (alergia.gravidade) {
      case 'Grave':
        color = Colors.redAccent;
        break;
      case 'Moderada':
        color = Colors.orangeAccent;
        break;
      default:
        color = Colors.blueAccent;
    }

    return Chip(
      label: Text(
        '${alergia.nome} (${alergia.categoria})',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
      deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
      onDeleted: () async {
        final confirmar = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Remover alergia?'),
            content: Text('Deseja realmente remover a alergia a "${alergia.nome}"?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCELAR')),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('REMOVER', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        if (confirmar == true) {
          await db.excluirAlergia(alergia.id, widget.user.id);
        }
      },
    );
  }

  void _mostrarDialogoAlergia(BuildContext context, AppDatabase db) {
    final nomeController = TextEditingController();
    String selectedCategoria = 'Alimentar';
    String selectedGravidade = 'Leve';
    
    final categorias = ['Alimentar', 'Medicamento', 'Ambiental', 'Outro'];
    final gravidades = ['Leve', 'Moderada', 'Grave'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Nova Alergia'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Alergia a quê?',
                    hintText: 'Ex: Amendoim, Dipirona',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategoria,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCategoria = val!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedGravidade,
                  decoration: const InputDecoration(labelText: 'Gravidade'),
                  items: gravidades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) => setDialogState(() => selectedGravidade = val!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCELAR')),
            FilledButton(
              onPressed: () async {
                if (nomeController.text.trim().isEmpty) return;
                await db.adicionarAlergia(AlergiasCompanion.insert(
                  usuarioId: widget.user.id,
                  nome: nomeController.text.trim(),
                  categoria: selectedCategoria,
                  gravidade: selectedGravidade,
                ));
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('ADICIONAR'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      enabled: _isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildDatePickerTile(String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: _isEditing ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isEditing ? Colors.transparent : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: _isEditing ? Border.all(color: Colors.grey) : null,
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
                  date != null ? DateFormat('dd/MM/yyyy').format(date) : 'Não informada',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(Icons.calendar_month, color: _isEditing ? Theme.of(context).colorScheme.primary : Colors.grey),
          ],
        ),
      ),
    );
  }
}
