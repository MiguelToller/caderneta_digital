import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

@DataClassName('Usuario')
class Usuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get email => text()();
  TextColumn get senha => text()();
  TextColumn get tipoSanguineo => text().nullable()();
  DateTimeColumn get dataNascimento => dateTime().nullable()();
}

@DataClassName('Vacina')
class Vacinas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nome => text()();
  TextColumn get categoria => text()();
  TextColumn get descricao => text()();
}

@DataClassName('Agenda')
class Agendas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().references(Usuarios, #id)();
  IntColumn get vacinaId => integer().references(Vacinas, #id)();
  TextColumn get dose => text()();
  TextColumn get lote => text().nullable()();
  TextColumn get fabricante => text().nullable()();
  DateTimeColumn get dataAplicacao => dateTime()();
  TextColumn get local => text().nullable()();
  DateTimeColumn get proximaDose => dateTime().nullable()();
}

class AgendaWithVacina {
  final Agenda agenda;
  final Vacina vacina;
  AgendaWithVacina({required this.agenda, required this.vacina});
}

@DataClassName('Alergia')
class Alergias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().references(Usuarios, #id)();
  TextColumn get nome => text()();
  TextColumn get categoria => text()();
  TextColumn get gravidade => text()();
}

@DriftDatabase(tables: [Usuarios, Vacinas, Agendas, Alergias])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(
    name: 'caderneta_db',
    // Parâmetro obrigatório para web: aponta para os arquivos WASM na pasta web/
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  ));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        
        await batch((batch) {
          batch.insertAll(vacinas, [
            VacinasCompanion.insert(nome: 'BCG', categoria: 'Rotina', descricao: 'Previne as formas graves de tuberculose (Dose única ao nascer)'),
            VacinasCompanion.insert(nome: 'Hepatite B', categoria: 'Rotina', descricao: 'Previne a hepatite B (Ao nascer)'),
            VacinasCompanion.insert(nome: 'Pentavalente', categoria: 'Rotina', descricao: 'Previne difteria, tétano, coqueluche, hepatite B e meningite por Hib (3 doses aos 2, 4 e 6 meses)'),
            VacinasCompanion.insert(nome: 'VIP/VOP (Poliomielite)', categoria: 'Rotina', descricao: 'Previne a paralisia infantil (3 doses aos 2, 4 e 6 meses + reforços)'),
            VacinasCompanion.insert(nome: 'Pneumocócica 10V', categoria: 'Rotina', descricao: 'Previne pneumonia, otite e meningite por pneumococo (2 doses aos 2 e 4 meses + reforço)'),
            VacinasCompanion.insert(nome: 'Rotavírus', categoria: 'Rotina', descricao: 'Previne diarreia por rotavírus (2 doses aos 2 e 4 meses)'),
            VacinasCompanion.insert(nome: 'Meningocócica C', categoria: 'Rotina', descricao: 'Previne a meningite C (2 doses aos 3 e 5 meses + reforço)'),
            VacinasCompanion.insert(nome: 'Febre Amarela', categoria: 'Rotina', descricao: 'Previne a febre amarela (Aos 9 meses + reforço aos 4 anos)'),
            VacinasCompanion.insert(nome: 'Tríplice Viral (SRC)', categoria: 'Rotina', descricao: 'Previne sarampo, caxumba e rubéola (2 doses aos 12 e 15 meses)'),
            VacinasCompanion.insert(nome: 'Hepatite A', categoria: 'Rotina', descricao: 'Previne a hepatite A (1 dose aos 15 meses)'),
            VacinasCompanion.insert(nome: 'DTP', categoria: 'Rotina', descricao: 'Previne difteria, tétano e coqueluche (Reforços aos 15 meses e 4 anos)'),
            VacinasCompanion.insert(nome: 'Varicela', categoria: 'Rotina', descricao: 'Previne a catapora (Aos 15 meses e 4 anos)'),
            VacinasCompanion.insert(nome: 'HPV Quadrivalente', categoria: 'Rotina', descricao: 'Previne cânceres do colo do útero e verrugas genitais (2 doses de 9 a 14 anos)'),
            VacinasCompanion.insert(nome: 'Meningocócica ACWY', categoria: 'Rotina', descricao: 'Previne meningites ACWY (1 dose de 11 a 12 anos)'),
            VacinasCompanion.insert(nome: 'dT (Dupla Adulto)', categoria: 'Rotina', descricao: 'Previne difteria e tétano (Reforço a cada 10 anos)'),
            VacinasCompanion.insert(nome: 'Gripe (Influenza)', categoria: 'Campanha', descricao: 'Previne a gripe (Dose anual)'),
            VacinasCompanion.insert(nome: 'Covid-19', categoria: 'Campanha', descricao: 'Previne a Covid-19'),
            VacinasCompanion.insert(nome: 'Dengue', categoria: 'Campanha', descricao: 'Previne a dengue'),
          ]);
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(alergias);
        }
        if (from < 3) {
          await m.addColumn(agendas, agendas.fabricante);
          
          // Adiciona as novas vacinas oficiais do SUS para quem já tem a base criada
          await batch((batch) {
            batch.insertAll(vacinas, [
              VacinasCompanion.insert(nome: 'VIP/VOP (Poliomielite)', categoria: 'Rotina', descricao: 'Previne a paralisia infantil (3 doses aos 2, 4 e 6 meses + reforços)'),
              VacinasCompanion.insert(nome: 'Pneumocócica 10V', categoria: 'Rotina', descricao: 'Previne pneumonia, otite e meningite por pneumococo (2 doses aos 2 e 4 meses + reforço)'),
              VacinasCompanion.insert(nome: 'Rotavírus', categoria: 'Rotina', descricao: 'Previne diarreia por rotavírus (2 doses aos 2 e 4 meses)'),
              VacinasCompanion.insert(nome: 'Meningocócica C', categoria: 'Rotina', descricao: 'Previne a meningite C (2 doses aos 3 e 5 meses + reforço)'),
              VacinasCompanion.insert(nome: 'Tríplice Viral (SRC)', categoria: 'Rotina', descricao: 'Previne sarampo, caxumba e rubéola (2 doses aos 12 e 15 meses)'),
              VacinasCompanion.insert(nome: 'Hepatite A', categoria: 'Rotina', descricao: 'Previne a hepatite A (1 dose aos 15 meses)'),
              VacinasCompanion.insert(nome: 'DTP', categoria: 'Rotina', descricao: 'Previne difteria, tétano e coqueluche (Reforços aos 15 meses e 4 anos)'),
              VacinasCompanion.insert(nome: 'Varicela', categoria: 'Rotina', descricao: 'Previne a catapora (Aos 15 meses e 4 anos)'),
              VacinasCompanion.insert(nome: 'HPV Quadrivalente', categoria: 'Rotina', descricao: 'Previne cânceres do colo do útero e verrugas genitais (2 doses de 9 a 14 anos)'),
              VacinasCompanion.insert(nome: 'Meningocócica ACWY', categoria: 'Rotina', descricao: 'Previne meningites ACWY (1 dose de 11 a 12 anos)'),
              VacinasCompanion.insert(nome: 'dT (Dupla Adulto)', categoria: 'Rotina', descricao: 'Previne difteria e tétano (Reforço a cada 10 anos)'),
              VacinasCompanion.insert(nome: 'Covid-19', categoria: 'Campanha', descricao: 'Previne a Covid-19'),
              VacinasCompanion.insert(nome: 'Dengue', categoria: 'Campanha', descricao: 'Previne a dengue'),
            ]);
          });
        }
      },
    );
  }

  Future<Usuario?> login(String email, String senha) {
    return (select(usuarios)..where((u) => u.email.equals(email) & u.senha.equals(senha))).getSingleOrNull();
  }

  Future<Usuario?> buscarUsuarioPorId(int id) {
    return (select(usuarios)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  Stream<Usuario?> watchUsuario(int id) {
    return (select(usuarios)..where((u) => u.id.equals(id))).watchSingleOrNull();
  }

  Future<int> cadastrarUsuario(UsuariosCompanion companion) {
    return into(usuarios).insert(companion);
  }

  Future<void> atualizarUsuario(int id, String nome, String email, String? tipoSanguineo, DateTime? dataNascimento) {
    return (update(usuarios)..where((u) => u.id.equals(id))).write(
      UsuariosCompanion(
        nome: Value(nome),
        email: Value(email),
        tipoSanguineo: Value(tipoSanguineo),
        dataNascimento: Value(dataNascimento),
      ),
    );
  }

  Future<List<Vacina>> get todasVacinas => select(vacinas).get();

  Stream<List<AgendaWithVacina>> watchHistoricoDetalhado(int userId) {
    final query = select(agendas).join([
      innerJoin(vacinas, vacinas.id.equalsExp(agendas.vacinaId)),
    ])..where(agendas.usuarioId.equals(userId));

    return query.watch().map((rows) {
      return rows.map((row) {
        return AgendaWithVacina(
          agenda: row.readTable(agendas),
          vacina: row.readTable(vacinas),
        );
      }).toList();
    });
  }

  Future<int> registrarDose(AgendasCompanion companion) async {
    final userId = companion.usuarioId.value;
    final vacId = companion.vacinaId.value;

    return transaction(() async {
      // 1. Limpar data de próxima dose/reforço de registros passados desta mesma vacina
      await (update(agendas)
            ..where((a) => a.usuarioId.equals(userId) & a.vacinaId.equals(vacId)))
          .write(const AgendasCompanion(proximaDose: Value(null)));

      // 2. Inserir o novo registro
      return into(agendas).insert(companion);
    });
  }

  Future<void> excluirDose(int id, int usuarioId) {
    return (delete(agendas)..where((a) => a.id.equals(id) & a.usuarioId.equals(usuarioId))).go();
  }

  Future<void> atualizarDose(int id, int usuarioId, AgendasCompanion companion) {
    return (update(agendas)..where((a) => a.id.equals(id) & a.usuarioId.equals(usuarioId))).write(companion);
  }

  Stream<List<Alergia>> watchAlergias(int userId) {
    return (select(alergias)..where((a) => a.usuarioId.equals(userId))).watch();
  }

  Future<int> adicionarAlergia(AlergiasCompanion companion) {
    return into(alergias).insert(companion);
  }

  Future<void> excluirAlergia(int id, int userId) {
    return (delete(alergias)..where((a) => a.id.equals(id) & a.usuarioId.equals(userId))).go();
  }
}
