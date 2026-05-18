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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        
        await batch((batch) {
          batch.insertAll(vacinas, [
            VacinasCompanion.insert(nome: 'BCG', categoria: 'Rotina', descricao: 'Tuberculose'),
            VacinasCompanion.insert(nome: 'Hepatite B', categoria: 'Rotina', descricao: 'Hepatite B'),
            VacinasCompanion.insert(nome: 'Pentavalente', categoria: 'Rotina', descricao: 'Difteria, Tétano, etc'),
            VacinasCompanion.insert(nome: 'Febre Amarela', categoria: 'Viagem', descricao: 'Febre Amarela'),
            VacinasCompanion.insert(nome: 'Gripe', categoria: 'Campanha', descricao: 'Influenza'),
          ]);
        });
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(alergias);
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

  Future<int> registrarDose(AgendasCompanion companion) {
    return into(agendas).insert(companion);
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
