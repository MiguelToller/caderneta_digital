import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/database.dart';

class _AvatarOption {
  final String emoji;
  final List<Color> gradientColors;
  const _AvatarOption({required this.emoji, required this.gradientColors});
}

const List<_AvatarOption> _avatarOptions = [
  _AvatarOption(emoji: '💉', gradientColors: [Colors.purple, Colors.indigo]),
  _AvatarOption(emoji: '🩺', gradientColors: [Colors.blue, Colors.teal]),
  _AvatarOption(emoji: '🦸', gradientColors: [Colors.orange, Colors.red]),
  _AvatarOption(emoji: '🧬', gradientColors: [Colors.indigo, Colors.deepPurple]),
  _AvatarOption(emoji: '🛡️', gradientColors: [Colors.teal, Colors.green]),
  _AvatarOption(emoji: '🌡️', gradientColors: [Colors.yellow, Colors.orange]),
  _AvatarOption(emoji: '🧠', gradientColors: [Colors.pink, Colors.redAccent]),
  _AvatarOption(emoji: '👤', gradientColors: [Colors.blueGrey, Colors.grey]),
];

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
  int _avatarIndex = 0;

  final List<String> _tiposSanguineos = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.user.nome);
    _emailController = TextEditingController(text: widget.user.email);
    _selectedTipoSanguineo = widget.user.tipoSanguineo;
    _dataNascimento = widget.user.dataNascimento;
    _carregarAvatar();
  }

  void _carregarAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('usuario_avatar_${widget.user.id}') ?? 0;
    if (mounted) {
      setState(() {
        _avatarIndex = index;
      });
    }
  }

  void _salvarAvatar(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('usuario_avatar_${widget.user.id}', index);
    if (mounted) {
      setState(() {
        _avatarIndex = index;
      });
    }
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
                Builder(
                  builder: (context) {
                    final avatar = _avatarOptions[_avatarIndex >= 0 && _avatarIndex < _avatarOptions.length ? _avatarIndex : 0];
                    return GestureDetector(
                      onTap: _mostrarSeletorAvatar,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: avatar.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: avatar.gradientColors.first.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                avatar.emoji,
                                style: const TextStyle(fontSize: 44),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
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

  void _mostrarSeletorAvatar() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Escolha seu Avatar',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione um ícone de perfil personalizado',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _avatarOptions.length,
                itemBuilder: (context, index) {
                  final option = _avatarOptions[index];
                  final isSelected = index == _avatarIndex;
                  return GestureDetector(
                    onTap: () {
                      _salvarAvatar(index);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: option.gradientColors,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: isSelected
                            ? Border.all(color: Theme.of(context).colorScheme.primary, width: 4)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: option.gradientColors.first.withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          option.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
