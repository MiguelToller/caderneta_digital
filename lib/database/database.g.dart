// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsuariosTable extends Usuarios with TableInfo<$UsuariosTable, Usuario> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsuariosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senhaMeta = const VerificationMeta('senha');
  @override
  late final GeneratedColumn<String> senha = GeneratedColumn<String>(
      'senha', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tipoSanguineoMeta =
      const VerificationMeta('tipoSanguineo');
  @override
  late final GeneratedColumn<String> tipoSanguineo = GeneratedColumn<String>(
      'tipo_sanguineo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataNascimentoMeta =
      const VerificationMeta('dataNascimento');
  @override
  late final GeneratedColumn<DateTime> dataNascimento =
      GeneratedColumn<DateTime>('data_nascimento', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, nome, email, senha, tipoSanguineo, dataNascimento];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usuarios';
  @override
  VerificationContext validateIntegrity(Insertable<Usuario> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('senha')) {
      context.handle(
          _senhaMeta, senha.isAcceptableOrUnknown(data['senha']!, _senhaMeta));
    } else if (isInserting) {
      context.missing(_senhaMeta);
    }
    if (data.containsKey('tipo_sanguineo')) {
      context.handle(
          _tipoSanguineoMeta,
          tipoSanguineo.isAcceptableOrUnknown(
              data['tipo_sanguineo']!, _tipoSanguineoMeta));
    }
    if (data.containsKey('data_nascimento')) {
      context.handle(
          _dataNascimentoMeta,
          dataNascimento.isAcceptableOrUnknown(
              data['data_nascimento']!, _dataNascimentoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Usuario map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Usuario(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      senha: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}senha'])!,
      tipoSanguineo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tipo_sanguineo']),
      dataNascimento: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_nascimento']),
    );
  }

  @override
  $UsuariosTable createAlias(String alias) {
    return $UsuariosTable(attachedDatabase, alias);
  }
}

class Usuario extends DataClass implements Insertable<Usuario> {
  final int id;
  final String nome;
  final String email;
  final String senha;
  final String? tipoSanguineo;
  final DateTime? dataNascimento;
  const Usuario(
      {required this.id,
      required this.nome,
      required this.email,
      required this.senha,
      this.tipoSanguineo,
      this.dataNascimento});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['email'] = Variable<String>(email);
    map['senha'] = Variable<String>(senha);
    if (!nullToAbsent || tipoSanguineo != null) {
      map['tipo_sanguineo'] = Variable<String>(tipoSanguineo);
    }
    if (!nullToAbsent || dataNascimento != null) {
      map['data_nascimento'] = Variable<DateTime>(dataNascimento);
    }
    return map;
  }

  UsuariosCompanion toCompanion(bool nullToAbsent) {
    return UsuariosCompanion(
      id: Value(id),
      nome: Value(nome),
      email: Value(email),
      senha: Value(senha),
      tipoSanguineo: tipoSanguineo == null && nullToAbsent
          ? const Value.absent()
          : Value(tipoSanguineo),
      dataNascimento: dataNascimento == null && nullToAbsent
          ? const Value.absent()
          : Value(dataNascimento),
    );
  }

  factory Usuario.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Usuario(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      email: serializer.fromJson<String>(json['email']),
      senha: serializer.fromJson<String>(json['senha']),
      tipoSanguineo: serializer.fromJson<String?>(json['tipoSanguineo']),
      dataNascimento: serializer.fromJson<DateTime?>(json['dataNascimento']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'email': serializer.toJson<String>(email),
      'senha': serializer.toJson<String>(senha),
      'tipoSanguineo': serializer.toJson<String?>(tipoSanguineo),
      'dataNascimento': serializer.toJson<DateTime?>(dataNascimento),
    };
  }

  Usuario copyWith(
          {int? id,
          String? nome,
          String? email,
          String? senha,
          Value<String?> tipoSanguineo = const Value.absent(),
          Value<DateTime?> dataNascimento = const Value.absent()}) =>
      Usuario(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        email: email ?? this.email,
        senha: senha ?? this.senha,
        tipoSanguineo:
            tipoSanguineo.present ? tipoSanguineo.value : this.tipoSanguineo,
        dataNascimento:
            dataNascimento.present ? dataNascimento.value : this.dataNascimento,
      );
  Usuario copyWithCompanion(UsuariosCompanion data) {
    return Usuario(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      email: data.email.present ? data.email.value : this.email,
      senha: data.senha.present ? data.senha.value : this.senha,
      tipoSanguineo: data.tipoSanguineo.present
          ? data.tipoSanguineo.value
          : this.tipoSanguineo,
      dataNascimento: data.dataNascimento.present
          ? data.dataNascimento.value
          : this.dataNascimento,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Usuario(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senha: $senha, ')
          ..write('tipoSanguineo: $tipoSanguineo, ')
          ..write('dataNascimento: $dataNascimento')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nome, email, senha, tipoSanguineo, dataNascimento);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Usuario &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.email == this.email &&
          other.senha == this.senha &&
          other.tipoSanguineo == this.tipoSanguineo &&
          other.dataNascimento == this.dataNascimento);
}

class UsuariosCompanion extends UpdateCompanion<Usuario> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> email;
  final Value<String> senha;
  final Value<String?> tipoSanguineo;
  final Value<DateTime?> dataNascimento;
  const UsuariosCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.email = const Value.absent(),
    this.senha = const Value.absent(),
    this.tipoSanguineo = const Value.absent(),
    this.dataNascimento = const Value.absent(),
  });
  UsuariosCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String email,
    required String senha,
    this.tipoSanguineo = const Value.absent(),
    this.dataNascimento = const Value.absent(),
  })  : nome = Value(nome),
        email = Value(email),
        senha = Value(senha);
  static Insertable<Usuario> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? email,
    Expression<String>? senha,
    Expression<String>? tipoSanguineo,
    Expression<DateTime>? dataNascimento,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (email != null) 'email': email,
      if (senha != null) 'senha': senha,
      if (tipoSanguineo != null) 'tipo_sanguineo': tipoSanguineo,
      if (dataNascimento != null) 'data_nascimento': dataNascimento,
    });
  }

  UsuariosCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<String>? email,
      Value<String>? senha,
      Value<String?>? tipoSanguineo,
      Value<DateTime?>? dataNascimento}) {
    return UsuariosCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      tipoSanguineo: tipoSanguineo ?? this.tipoSanguineo,
      dataNascimento: dataNascimento ?? this.dataNascimento,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (senha.present) {
      map['senha'] = Variable<String>(senha.value);
    }
    if (tipoSanguineo.present) {
      map['tipo_sanguineo'] = Variable<String>(tipoSanguineo.value);
    }
    if (dataNascimento.present) {
      map['data_nascimento'] = Variable<DateTime>(dataNascimento.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsuariosCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('email: $email, ')
          ..write('senha: $senha, ')
          ..write('tipoSanguineo: $tipoSanguineo, ')
          ..write('dataNascimento: $dataNascimento')
          ..write(')'))
        .toString();
  }
}

class $VacinasTable extends Vacinas with TableInfo<$VacinasTable, Vacina> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VacinasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoriaMeta =
      const VerificationMeta('categoria');
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
      'categoria', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descricaoMeta =
      const VerificationMeta('descricao');
  @override
  late final GeneratedColumn<String> descricao = GeneratedColumn<String>(
      'descricao', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, nome, categoria, descricao];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vacinas';
  @override
  VerificationContext validateIntegrity(Insertable<Vacina> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(_categoriaMeta,
          categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta));
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('descricao')) {
      context.handle(_descricaoMeta,
          descricao.isAcceptableOrUnknown(data['descricao']!, _descricaoMeta));
    } else if (isInserting) {
      context.missing(_descricaoMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Vacina map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Vacina(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      categoria: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria'])!,
      descricao: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}descricao'])!,
    );
  }

  @override
  $VacinasTable createAlias(String alias) {
    return $VacinasTable(attachedDatabase, alias);
  }
}

class Vacina extends DataClass implements Insertable<Vacina> {
  final int id;
  final String nome;
  final String categoria;
  final String descricao;
  const Vacina(
      {required this.id,
      required this.nome,
      required this.categoria,
      required this.descricao});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(nome);
    map['categoria'] = Variable<String>(categoria);
    map['descricao'] = Variable<String>(descricao);
    return map;
  }

  VacinasCompanion toCompanion(bool nullToAbsent) {
    return VacinasCompanion(
      id: Value(id),
      nome: Value(nome),
      categoria: Value(categoria),
      descricao: Value(descricao),
    );
  }

  factory Vacina.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Vacina(
      id: serializer.fromJson<int>(json['id']),
      nome: serializer.fromJson<String>(json['nome']),
      categoria: serializer.fromJson<String>(json['categoria']),
      descricao: serializer.fromJson<String>(json['descricao']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(nome),
      'categoria': serializer.toJson<String>(categoria),
      'descricao': serializer.toJson<String>(descricao),
    };
  }

  Vacina copyWith(
          {int? id, String? nome, String? categoria, String? descricao}) =>
      Vacina(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        categoria: categoria ?? this.categoria,
        descricao: descricao ?? this.descricao,
      );
  Vacina copyWithCompanion(VacinasCompanion data) {
    return Vacina(
      id: data.id.present ? data.id.value : this.id,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      descricao: data.descricao.present ? data.descricao.value : this.descricao,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Vacina(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nome, categoria, descricao);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Vacina &&
          other.id == this.id &&
          other.nome == this.nome &&
          other.categoria == this.categoria &&
          other.descricao == this.descricao);
}

class VacinasCompanion extends UpdateCompanion<Vacina> {
  final Value<int> id;
  final Value<String> nome;
  final Value<String> categoria;
  final Value<String> descricao;
  const VacinasCompanion({
    this.id = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoria = const Value.absent(),
    this.descricao = const Value.absent(),
  });
  VacinasCompanion.insert({
    this.id = const Value.absent(),
    required String nome,
    required String categoria,
    required String descricao,
  })  : nome = Value(nome),
        categoria = Value(categoria),
        descricao = Value(descricao);
  static Insertable<Vacina> custom({
    Expression<int>? id,
    Expression<String>? nome,
    Expression<String>? categoria,
    Expression<String>? descricao,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nome != null) 'nome': nome,
      if (categoria != null) 'categoria': categoria,
      if (descricao != null) 'descricao': descricao,
    });
  }

  VacinasCompanion copyWith(
      {Value<int>? id,
      Value<String>? nome,
      Value<String>? categoria,
      Value<String>? descricao}) {
    return VacinasCompanion(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (descricao.present) {
      map['descricao'] = Variable<String>(descricao.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VacinasCompanion(')
          ..write('id: $id, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('descricao: $descricao')
          ..write(')'))
        .toString();
  }
}

class $AgendasTable extends Agendas with TableInfo<$AgendasTable, Agenda> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AgendasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES usuarios (id)'));
  static const VerificationMeta _vacinaIdMeta =
      const VerificationMeta('vacinaId');
  @override
  late final GeneratedColumn<int> vacinaId = GeneratedColumn<int>(
      'vacina_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES vacinas (id)'));
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
      'dose', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loteMeta = const VerificationMeta('lote');
  @override
  late final GeneratedColumn<String> lote = GeneratedColumn<String>(
      'lote', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fabricanteMeta =
      const VerificationMeta('fabricante');
  @override
  late final GeneratedColumn<String> fabricante = GeneratedColumn<String>(
      'fabricante', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dataAplicacaoMeta =
      const VerificationMeta('dataAplicacao');
  @override
  late final GeneratedColumn<DateTime> dataAplicacao =
      GeneratedColumn<DateTime>('data_aplicacao', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _localMeta = const VerificationMeta('local');
  @override
  late final GeneratedColumn<String> local = GeneratedColumn<String>(
      'local', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _proximaDoseMeta =
      const VerificationMeta('proximaDose');
  @override
  late final GeneratedColumn<DateTime> proximaDose = GeneratedColumn<DateTime>(
      'proxima_dose', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        usuarioId,
        vacinaId,
        dose,
        lote,
        fabricante,
        dataAplicacao,
        local,
        proximaDose
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'agendas';
  @override
  VerificationContext validateIntegrity(Insertable<Agenda> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('vacina_id')) {
      context.handle(_vacinaIdMeta,
          vacinaId.isAcceptableOrUnknown(data['vacina_id']!, _vacinaIdMeta));
    } else if (isInserting) {
      context.missing(_vacinaIdMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose']!, _doseMeta));
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('lote')) {
      context.handle(
          _loteMeta, lote.isAcceptableOrUnknown(data['lote']!, _loteMeta));
    }
    if (data.containsKey('fabricante')) {
      context.handle(
          _fabricanteMeta,
          fabricante.isAcceptableOrUnknown(
              data['fabricante']!, _fabricanteMeta));
    }
    if (data.containsKey('data_aplicacao')) {
      context.handle(
          _dataAplicacaoMeta,
          dataAplicacao.isAcceptableOrUnknown(
              data['data_aplicacao']!, _dataAplicacaoMeta));
    } else if (isInserting) {
      context.missing(_dataAplicacaoMeta);
    }
    if (data.containsKey('local')) {
      context.handle(
          _localMeta, local.isAcceptableOrUnknown(data['local']!, _localMeta));
    }
    if (data.containsKey('proxima_dose')) {
      context.handle(
          _proximaDoseMeta,
          proximaDose.isAcceptableOrUnknown(
              data['proxima_dose']!, _proximaDoseMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Agenda map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Agenda(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usuario_id'])!,
      vacinaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}vacina_id'])!,
      dose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dose'])!,
      lote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lote']),
      fabricante: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fabricante']),
      dataAplicacao: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}data_aplicacao'])!,
      local: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local']),
      proximaDose: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}proxima_dose']),
    );
  }

  @override
  $AgendasTable createAlias(String alias) {
    return $AgendasTable(attachedDatabase, alias);
  }
}

class Agenda extends DataClass implements Insertable<Agenda> {
  final int id;
  final int usuarioId;
  final int vacinaId;
  final String dose;
  final String? lote;
  final String? fabricante;
  final DateTime dataAplicacao;
  final String? local;
  final DateTime? proximaDose;
  const Agenda(
      {required this.id,
      required this.usuarioId,
      required this.vacinaId,
      required this.dose,
      this.lote,
      this.fabricante,
      required this.dataAplicacao,
      this.local,
      this.proximaDose});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['vacina_id'] = Variable<int>(vacinaId);
    map['dose'] = Variable<String>(dose);
    if (!nullToAbsent || lote != null) {
      map['lote'] = Variable<String>(lote);
    }
    if (!nullToAbsent || fabricante != null) {
      map['fabricante'] = Variable<String>(fabricante);
    }
    map['data_aplicacao'] = Variable<DateTime>(dataAplicacao);
    if (!nullToAbsent || local != null) {
      map['local'] = Variable<String>(local);
    }
    if (!nullToAbsent || proximaDose != null) {
      map['proxima_dose'] = Variable<DateTime>(proximaDose);
    }
    return map;
  }

  AgendasCompanion toCompanion(bool nullToAbsent) {
    return AgendasCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      vacinaId: Value(vacinaId),
      dose: Value(dose),
      lote: lote == null && nullToAbsent ? const Value.absent() : Value(lote),
      fabricante: fabricante == null && nullToAbsent
          ? const Value.absent()
          : Value(fabricante),
      dataAplicacao: Value(dataAplicacao),
      local:
          local == null && nullToAbsent ? const Value.absent() : Value(local),
      proximaDose: proximaDose == null && nullToAbsent
          ? const Value.absent()
          : Value(proximaDose),
    );
  }

  factory Agenda.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Agenda(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      vacinaId: serializer.fromJson<int>(json['vacinaId']),
      dose: serializer.fromJson<String>(json['dose']),
      lote: serializer.fromJson<String?>(json['lote']),
      fabricante: serializer.fromJson<String?>(json['fabricante']),
      dataAplicacao: serializer.fromJson<DateTime>(json['dataAplicacao']),
      local: serializer.fromJson<String?>(json['local']),
      proximaDose: serializer.fromJson<DateTime?>(json['proximaDose']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'vacinaId': serializer.toJson<int>(vacinaId),
      'dose': serializer.toJson<String>(dose),
      'lote': serializer.toJson<String?>(lote),
      'fabricante': serializer.toJson<String?>(fabricante),
      'dataAplicacao': serializer.toJson<DateTime>(dataAplicacao),
      'local': serializer.toJson<String?>(local),
      'proximaDose': serializer.toJson<DateTime?>(proximaDose),
    };
  }

  Agenda copyWith(
          {int? id,
          int? usuarioId,
          int? vacinaId,
          String? dose,
          Value<String?> lote = const Value.absent(),
          Value<String?> fabricante = const Value.absent(),
          DateTime? dataAplicacao,
          Value<String?> local = const Value.absent(),
          Value<DateTime?> proximaDose = const Value.absent()}) =>
      Agenda(
        id: id ?? this.id,
        usuarioId: usuarioId ?? this.usuarioId,
        vacinaId: vacinaId ?? this.vacinaId,
        dose: dose ?? this.dose,
        lote: lote.present ? lote.value : this.lote,
        fabricante: fabricante.present ? fabricante.value : this.fabricante,
        dataAplicacao: dataAplicacao ?? this.dataAplicacao,
        local: local.present ? local.value : this.local,
        proximaDose: proximaDose.present ? proximaDose.value : this.proximaDose,
      );
  Agenda copyWithCompanion(AgendasCompanion data) {
    return Agenda(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      vacinaId: data.vacinaId.present ? data.vacinaId.value : this.vacinaId,
      dose: data.dose.present ? data.dose.value : this.dose,
      lote: data.lote.present ? data.lote.value : this.lote,
      fabricante:
          data.fabricante.present ? data.fabricante.value : this.fabricante,
      dataAplicacao: data.dataAplicacao.present
          ? data.dataAplicacao.value
          : this.dataAplicacao,
      local: data.local.present ? data.local.value : this.local,
      proximaDose:
          data.proximaDose.present ? data.proximaDose.value : this.proximaDose,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Agenda(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('vacinaId: $vacinaId, ')
          ..write('dose: $dose, ')
          ..write('lote: $lote, ')
          ..write('fabricante: $fabricante, ')
          ..write('dataAplicacao: $dataAplicacao, ')
          ..write('local: $local, ')
          ..write('proximaDose: $proximaDose')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, usuarioId, vacinaId, dose, lote,
      fabricante, dataAplicacao, local, proximaDose);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Agenda &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.vacinaId == this.vacinaId &&
          other.dose == this.dose &&
          other.lote == this.lote &&
          other.fabricante == this.fabricante &&
          other.dataAplicacao == this.dataAplicacao &&
          other.local == this.local &&
          other.proximaDose == this.proximaDose);
}

class AgendasCompanion extends UpdateCompanion<Agenda> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<int> vacinaId;
  final Value<String> dose;
  final Value<String?> lote;
  final Value<String?> fabricante;
  final Value<DateTime> dataAplicacao;
  final Value<String?> local;
  final Value<DateTime?> proximaDose;
  const AgendasCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.vacinaId = const Value.absent(),
    this.dose = const Value.absent(),
    this.lote = const Value.absent(),
    this.fabricante = const Value.absent(),
    this.dataAplicacao = const Value.absent(),
    this.local = const Value.absent(),
    this.proximaDose = const Value.absent(),
  });
  AgendasCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required int vacinaId,
    required String dose,
    this.lote = const Value.absent(),
    this.fabricante = const Value.absent(),
    required DateTime dataAplicacao,
    this.local = const Value.absent(),
    this.proximaDose = const Value.absent(),
  })  : usuarioId = Value(usuarioId),
        vacinaId = Value(vacinaId),
        dose = Value(dose),
        dataAplicacao = Value(dataAplicacao);
  static Insertable<Agenda> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<int>? vacinaId,
    Expression<String>? dose,
    Expression<String>? lote,
    Expression<String>? fabricante,
    Expression<DateTime>? dataAplicacao,
    Expression<String>? local,
    Expression<DateTime>? proximaDose,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (vacinaId != null) 'vacina_id': vacinaId,
      if (dose != null) 'dose': dose,
      if (lote != null) 'lote': lote,
      if (fabricante != null) 'fabricante': fabricante,
      if (dataAplicacao != null) 'data_aplicacao': dataAplicacao,
      if (local != null) 'local': local,
      if (proximaDose != null) 'proxima_dose': proximaDose,
    });
  }

  AgendasCompanion copyWith(
      {Value<int>? id,
      Value<int>? usuarioId,
      Value<int>? vacinaId,
      Value<String>? dose,
      Value<String?>? lote,
      Value<String?>? fabricante,
      Value<DateTime>? dataAplicacao,
      Value<String?>? local,
      Value<DateTime?>? proximaDose}) {
    return AgendasCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      vacinaId: vacinaId ?? this.vacinaId,
      dose: dose ?? this.dose,
      lote: lote ?? this.lote,
      fabricante: fabricante ?? this.fabricante,
      dataAplicacao: dataAplicacao ?? this.dataAplicacao,
      local: local ?? this.local,
      proximaDose: proximaDose ?? this.proximaDose,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (vacinaId.present) {
      map['vacina_id'] = Variable<int>(vacinaId.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (lote.present) {
      map['lote'] = Variable<String>(lote.value);
    }
    if (fabricante.present) {
      map['fabricante'] = Variable<String>(fabricante.value);
    }
    if (dataAplicacao.present) {
      map['data_aplicacao'] = Variable<DateTime>(dataAplicacao.value);
    }
    if (local.present) {
      map['local'] = Variable<String>(local.value);
    }
    if (proximaDose.present) {
      map['proxima_dose'] = Variable<DateTime>(proximaDose.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AgendasCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('vacinaId: $vacinaId, ')
          ..write('dose: $dose, ')
          ..write('lote: $lote, ')
          ..write('fabricante: $fabricante, ')
          ..write('dataAplicacao: $dataAplicacao, ')
          ..write('local: $local, ')
          ..write('proximaDose: $proximaDose')
          ..write(')'))
        .toString();
  }
}

class $AlergiasTable extends Alergias with TableInfo<$AlergiasTable, Alergia> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlergiasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _usuarioIdMeta =
      const VerificationMeta('usuarioId');
  @override
  late final GeneratedColumn<int> usuarioId = GeneratedColumn<int>(
      'usuario_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES usuarios (id)'));
  static const VerificationMeta _nomeMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> nome = GeneratedColumn<String>(
      'nome', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoriaMeta =
      const VerificationMeta('categoria');
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
      'categoria', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gravidadeMeta =
      const VerificationMeta('gravidade');
  @override
  late final GeneratedColumn<String> gravidade = GeneratedColumn<String>(
      'gravidade', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, usuarioId, nome, categoria, gravidade];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alergias';
  @override
  VerificationContext validateIntegrity(Insertable<Alergia> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('usuario_id')) {
      context.handle(_usuarioIdMeta,
          usuarioId.isAcceptableOrUnknown(data['usuario_id']!, _usuarioIdMeta));
    } else if (isInserting) {
      context.missing(_usuarioIdMeta);
    }
    if (data.containsKey('nome')) {
      context.handle(
          _nomeMeta, nome.isAcceptableOrUnknown(data['nome']!, _nomeMeta));
    } else if (isInserting) {
      context.missing(_nomeMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(_categoriaMeta,
          categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta));
    } else if (isInserting) {
      context.missing(_categoriaMeta);
    }
    if (data.containsKey('gravidade')) {
      context.handle(_gravidadeMeta,
          gravidade.isAcceptableOrUnknown(data['gravidade']!, _gravidadeMeta));
    } else if (isInserting) {
      context.missing(_gravidadeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alergia map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alergia(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      usuarioId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}usuario_id'])!,
      nome: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}nome'])!,
      categoria: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}categoria'])!,
      gravidade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}gravidade'])!,
    );
  }

  @override
  $AlergiasTable createAlias(String alias) {
    return $AlergiasTable(attachedDatabase, alias);
  }
}

class Alergia extends DataClass implements Insertable<Alergia> {
  final int id;
  final int usuarioId;
  final String nome;
  final String categoria;
  final String gravidade;
  const Alergia(
      {required this.id,
      required this.usuarioId,
      required this.nome,
      required this.categoria,
      required this.gravidade});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['usuario_id'] = Variable<int>(usuarioId);
    map['nome'] = Variable<String>(nome);
    map['categoria'] = Variable<String>(categoria);
    map['gravidade'] = Variable<String>(gravidade);
    return map;
  }

  AlergiasCompanion toCompanion(bool nullToAbsent) {
    return AlergiasCompanion(
      id: Value(id),
      usuarioId: Value(usuarioId),
      nome: Value(nome),
      categoria: Value(categoria),
      gravidade: Value(gravidade),
    );
  }

  factory Alergia.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alergia(
      id: serializer.fromJson<int>(json['id']),
      usuarioId: serializer.fromJson<int>(json['usuarioId']),
      nome: serializer.fromJson<String>(json['nome']),
      categoria: serializer.fromJson<String>(json['categoria']),
      gravidade: serializer.fromJson<String>(json['gravidade']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'usuarioId': serializer.toJson<int>(usuarioId),
      'nome': serializer.toJson<String>(nome),
      'categoria': serializer.toJson<String>(categoria),
      'gravidade': serializer.toJson<String>(gravidade),
    };
  }

  Alergia copyWith(
          {int? id,
          int? usuarioId,
          String? nome,
          String? categoria,
          String? gravidade}) =>
      Alergia(
        id: id ?? this.id,
        usuarioId: usuarioId ?? this.usuarioId,
        nome: nome ?? this.nome,
        categoria: categoria ?? this.categoria,
        gravidade: gravidade ?? this.gravidade,
      );
  Alergia copyWithCompanion(AlergiasCompanion data) {
    return Alergia(
      id: data.id.present ? data.id.value : this.id,
      usuarioId: data.usuarioId.present ? data.usuarioId.value : this.usuarioId,
      nome: data.nome.present ? data.nome.value : this.nome,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      gravidade: data.gravidade.present ? data.gravidade.value : this.gravidade,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alergia(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('gravidade: $gravidade')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, usuarioId, nome, categoria, gravidade);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alergia &&
          other.id == this.id &&
          other.usuarioId == this.usuarioId &&
          other.nome == this.nome &&
          other.categoria == this.categoria &&
          other.gravidade == this.gravidade);
}

class AlergiasCompanion extends UpdateCompanion<Alergia> {
  final Value<int> id;
  final Value<int> usuarioId;
  final Value<String> nome;
  final Value<String> categoria;
  final Value<String> gravidade;
  const AlergiasCompanion({
    this.id = const Value.absent(),
    this.usuarioId = const Value.absent(),
    this.nome = const Value.absent(),
    this.categoria = const Value.absent(),
    this.gravidade = const Value.absent(),
  });
  AlergiasCompanion.insert({
    this.id = const Value.absent(),
    required int usuarioId,
    required String nome,
    required String categoria,
    required String gravidade,
  })  : usuarioId = Value(usuarioId),
        nome = Value(nome),
        categoria = Value(categoria),
        gravidade = Value(gravidade);
  static Insertable<Alergia> custom({
    Expression<int>? id,
    Expression<int>? usuarioId,
    Expression<String>? nome,
    Expression<String>? categoria,
    Expression<String>? gravidade,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (usuarioId != null) 'usuario_id': usuarioId,
      if (nome != null) 'nome': nome,
      if (categoria != null) 'categoria': categoria,
      if (gravidade != null) 'gravidade': gravidade,
    });
  }

  AlergiasCompanion copyWith(
      {Value<int>? id,
      Value<int>? usuarioId,
      Value<String>? nome,
      Value<String>? categoria,
      Value<String>? gravidade}) {
    return AlergiasCompanion(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      nome: nome ?? this.nome,
      categoria: categoria ?? this.categoria,
      gravidade: gravidade ?? this.gravidade,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (usuarioId.present) {
      map['usuario_id'] = Variable<int>(usuarioId.value);
    }
    if (nome.present) {
      map['nome'] = Variable<String>(nome.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (gravidade.present) {
      map['gravidade'] = Variable<String>(gravidade.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlergiasCompanion(')
          ..write('id: $id, ')
          ..write('usuarioId: $usuarioId, ')
          ..write('nome: $nome, ')
          ..write('categoria: $categoria, ')
          ..write('gravidade: $gravidade')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsuariosTable usuarios = $UsuariosTable(this);
  late final $VacinasTable vacinas = $VacinasTable(this);
  late final $AgendasTable agendas = $AgendasTable(this);
  late final $AlergiasTable alergias = $AlergiasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [usuarios, vacinas, agendas, alergias];
}

typedef $$UsuariosTableCreateCompanionBuilder = UsuariosCompanion Function({
  Value<int> id,
  required String nome,
  required String email,
  required String senha,
  Value<String?> tipoSanguineo,
  Value<DateTime?> dataNascimento,
});
typedef $$UsuariosTableUpdateCompanionBuilder = UsuariosCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String> email,
  Value<String> senha,
  Value<String?> tipoSanguineo,
  Value<DateTime?> dataNascimento,
});

final class $$UsuariosTableReferences
    extends BaseReferences<_$AppDatabase, $UsuariosTable, Usuario> {
  $$UsuariosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AgendasTable, List<Agenda>> _agendasRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.agendas,
          aliasName:
              $_aliasNameGenerator(db.usuarios.id, db.agendas.usuarioId));

  $$AgendasTableProcessedTableManager get agendasRefs {
    final manager = $$AgendasTableTableManager($_db, $_db.agendas)
        .filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_agendasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$AlergiasTable, List<Alergia>> _alergiasRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.alergias,
          aliasName:
              $_aliasNameGenerator(db.usuarios.id, db.alergias.usuarioId));

  $$AlergiasTableProcessedTableManager get alergiasRefs {
    final manager = $$AlergiasTableTableManager($_db, $_db.alergias)
        .filter((f) => f.usuarioId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_alergiasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsuariosTableFilterComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senha => $composableBuilder(
      column: $table.senha, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tipoSanguineo => $composableBuilder(
      column: $table.tipoSanguineo, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => ColumnFilters(column));

  Expression<bool> agendasRefs(
      Expression<bool> Function($$AgendasTableFilterComposer f) f) {
    final $$AgendasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendas,
        getReferencedColumn: (t) => t.usuarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendasTableFilterComposer(
              $db: $db,
              $table: $db.agendas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> alergiasRefs(
      Expression<bool> Function($$AlergiasTableFilterComposer f) f) {
    final $$AlergiasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alergias,
        getReferencedColumn: (t) => t.usuarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlergiasTableFilterComposer(
              $db: $db,
              $table: $db.alergias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsuariosTableOrderingComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senha => $composableBuilder(
      column: $table.senha, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tipoSanguineo => $composableBuilder(
      column: $table.tipoSanguineo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento,
      builder: (column) => ColumnOrderings(column));
}

class $$UsuariosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsuariosTable> {
  $$UsuariosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get senha =>
      $composableBuilder(column: $table.senha, builder: (column) => column);

  GeneratedColumn<String> get tipoSanguineo => $composableBuilder(
      column: $table.tipoSanguineo, builder: (column) => column);

  GeneratedColumn<DateTime> get dataNascimento => $composableBuilder(
      column: $table.dataNascimento, builder: (column) => column);

  Expression<T> agendasRefs<T extends Object>(
      Expression<T> Function($$AgendasTableAnnotationComposer a) f) {
    final $$AgendasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendas,
        getReferencedColumn: (t) => t.usuarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendasTableAnnotationComposer(
              $db: $db,
              $table: $db.agendas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> alergiasRefs<T extends Object>(
      Expression<T> Function($$AlergiasTableAnnotationComposer a) f) {
    final $$AlergiasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alergias,
        getReferencedColumn: (t) => t.usuarioId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlergiasTableAnnotationComposer(
              $db: $db,
              $table: $db.alergias,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsuariosTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsuariosTable,
    Usuario,
    $$UsuariosTableFilterComposer,
    $$UsuariosTableOrderingComposer,
    $$UsuariosTableAnnotationComposer,
    $$UsuariosTableCreateCompanionBuilder,
    $$UsuariosTableUpdateCompanionBuilder,
    (Usuario, $$UsuariosTableReferences),
    Usuario,
    PrefetchHooks Function({bool agendasRefs, bool alergiasRefs})> {
  $$UsuariosTableTableManager(_$AppDatabase db, $UsuariosTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsuariosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsuariosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsuariosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> senha = const Value.absent(),
            Value<String?> tipoSanguineo = const Value.absent(),
            Value<DateTime?> dataNascimento = const Value.absent(),
          }) =>
              UsuariosCompanion(
            id: id,
            nome: nome,
            email: email,
            senha: senha,
            tipoSanguineo: tipoSanguineo,
            dataNascimento: dataNascimento,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            required String email,
            required String senha,
            Value<String?> tipoSanguineo = const Value.absent(),
            Value<DateTime?> dataNascimento = const Value.absent(),
          }) =>
              UsuariosCompanion.insert(
            id: id,
            nome: nome,
            email: email,
            senha: senha,
            tipoSanguineo: tipoSanguineo,
            dataNascimento: dataNascimento,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsuariosTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({agendasRefs = false, alergiasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (agendasRefs) db.agendas,
                if (alergiasRefs) db.alergias
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (agendasRefs)
                    await $_getPrefetchedData<Usuario, $UsuariosTable, Agenda>(
                        currentTable: table,
                        referencedTable:
                            $$UsuariosTableReferences._agendasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsuariosTableReferences(db, table, p0)
                                .agendasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.usuarioId == item.id),
                        typedResults: items),
                  if (alergiasRefs)
                    await $_getPrefetchedData<Usuario, $UsuariosTable, Alergia>(
                        currentTable: table,
                        referencedTable:
                            $$UsuariosTableReferences._alergiasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsuariosTableReferences(db, table, p0)
                                .alergiasRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.usuarioId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsuariosTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsuariosTable,
    Usuario,
    $$UsuariosTableFilterComposer,
    $$UsuariosTableOrderingComposer,
    $$UsuariosTableAnnotationComposer,
    $$UsuariosTableCreateCompanionBuilder,
    $$UsuariosTableUpdateCompanionBuilder,
    (Usuario, $$UsuariosTableReferences),
    Usuario,
    PrefetchHooks Function({bool agendasRefs, bool alergiasRefs})>;
typedef $$VacinasTableCreateCompanionBuilder = VacinasCompanion Function({
  Value<int> id,
  required String nome,
  required String categoria,
  required String descricao,
});
typedef $$VacinasTableUpdateCompanionBuilder = VacinasCompanion Function({
  Value<int> id,
  Value<String> nome,
  Value<String> categoria,
  Value<String> descricao,
});

final class $$VacinasTableReferences
    extends BaseReferences<_$AppDatabase, $VacinasTable, Vacina> {
  $$VacinasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AgendasTable, List<Agenda>> _agendasRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.agendas,
          aliasName: $_aliasNameGenerator(db.vacinas.id, db.agendas.vacinaId));

  $$AgendasTableProcessedTableManager get agendasRefs {
    final manager = $$AgendasTableTableManager($_db, $_db.agendas)
        .filter((f) => f.vacinaId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_agendasRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$VacinasTableFilterComposer
    extends Composer<_$AppDatabase, $VacinasTable> {
  $$VacinasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnFilters(column));

  Expression<bool> agendasRefs(
      Expression<bool> Function($$AgendasTableFilterComposer f) f) {
    final $$AgendasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendas,
        getReferencedColumn: (t) => t.vacinaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendasTableFilterComposer(
              $db: $db,
              $table: $db.agendas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VacinasTableOrderingComposer
    extends Composer<_$AppDatabase, $VacinasTable> {
  $$VacinasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get descricao => $composableBuilder(
      column: $table.descricao, builder: (column) => ColumnOrderings(column));
}

class $$VacinasTableAnnotationComposer
    extends Composer<_$AppDatabase, $VacinasTable> {
  $$VacinasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get descricao =>
      $composableBuilder(column: $table.descricao, builder: (column) => column);

  Expression<T> agendasRefs<T extends Object>(
      Expression<T> Function($$AgendasTableAnnotationComposer a) f) {
    final $$AgendasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.agendas,
        getReferencedColumn: (t) => t.vacinaId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AgendasTableAnnotationComposer(
              $db: $db,
              $table: $db.agendas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$VacinasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VacinasTable,
    Vacina,
    $$VacinasTableFilterComposer,
    $$VacinasTableOrderingComposer,
    $$VacinasTableAnnotationComposer,
    $$VacinasTableCreateCompanionBuilder,
    $$VacinasTableUpdateCompanionBuilder,
    (Vacina, $$VacinasTableReferences),
    Vacina,
    PrefetchHooks Function({bool agendasRefs})> {
  $$VacinasTableTableManager(_$AppDatabase db, $VacinasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VacinasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VacinasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VacinasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> categoria = const Value.absent(),
            Value<String> descricao = const Value.absent(),
          }) =>
              VacinasCompanion(
            id: id,
            nome: nome,
            categoria: categoria,
            descricao: descricao,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String nome,
            required String categoria,
            required String descricao,
          }) =>
              VacinasCompanion.insert(
            id: id,
            nome: nome,
            categoria: categoria,
            descricao: descricao,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$VacinasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({agendasRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (agendasRefs) db.agendas],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (agendasRefs)
                    await $_getPrefetchedData<Vacina, $VacinasTable, Agenda>(
                        currentTable: table,
                        referencedTable:
                            $$VacinasTableReferences._agendasRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$VacinasTableReferences(db, table, p0).agendasRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.vacinaId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$VacinasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VacinasTable,
    Vacina,
    $$VacinasTableFilterComposer,
    $$VacinasTableOrderingComposer,
    $$VacinasTableAnnotationComposer,
    $$VacinasTableCreateCompanionBuilder,
    $$VacinasTableUpdateCompanionBuilder,
    (Vacina, $$VacinasTableReferences),
    Vacina,
    PrefetchHooks Function({bool agendasRefs})>;
typedef $$AgendasTableCreateCompanionBuilder = AgendasCompanion Function({
  Value<int> id,
  required int usuarioId,
  required int vacinaId,
  required String dose,
  Value<String?> lote,
  Value<String?> fabricante,
  required DateTime dataAplicacao,
  Value<String?> local,
  Value<DateTime?> proximaDose,
});
typedef $$AgendasTableUpdateCompanionBuilder = AgendasCompanion Function({
  Value<int> id,
  Value<int> usuarioId,
  Value<int> vacinaId,
  Value<String> dose,
  Value<String?> lote,
  Value<String?> fabricante,
  Value<DateTime> dataAplicacao,
  Value<String?> local,
  Value<DateTime?> proximaDose,
});

final class $$AgendasTableReferences
    extends BaseReferences<_$AppDatabase, $AgendasTable, Agenda> {
  $$AgendasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) => db.usuarios
      .createAlias($_aliasNameGenerator(db.agendas.usuarioId, db.usuarios.id));

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager($_db, $_db.usuarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $VacinasTable _vacinaIdTable(_$AppDatabase db) => db.vacinas
      .createAlias($_aliasNameGenerator(db.agendas.vacinaId, db.vacinas.id));

  $$VacinasTableProcessedTableManager get vacinaId {
    final $_column = $_itemColumn<int>('vacina_id')!;

    final manager = $$VacinasTableTableManager($_db, $_db.vacinas)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_vacinaIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AgendasTableFilterComposer
    extends Composer<_$AppDatabase, $AgendasTable> {
  $$AgendasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lote => $composableBuilder(
      column: $table.lote, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fabricante => $composableBuilder(
      column: $table.fabricante, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dataAplicacao => $composableBuilder(
      column: $table.dataAplicacao, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get local => $composableBuilder(
      column: $table.local, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get proximaDose => $composableBuilder(
      column: $table.proximaDose, builder: (column) => ColumnFilters(column));

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableFilterComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VacinasTableFilterComposer get vacinaId {
    final $$VacinasTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vacinaId,
        referencedTable: $db.vacinas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VacinasTableFilterComposer(
              $db: $db,
              $table: $db.vacinas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AgendasTableOrderingComposer
    extends Composer<_$AppDatabase, $AgendasTable> {
  $$AgendasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lote => $composableBuilder(
      column: $table.lote, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fabricante => $composableBuilder(
      column: $table.fabricante, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dataAplicacao => $composableBuilder(
      column: $table.dataAplicacao,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get local => $composableBuilder(
      column: $table.local, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get proximaDose => $composableBuilder(
      column: $table.proximaDose, builder: (column) => ColumnOrderings(column));

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableOrderingComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VacinasTableOrderingComposer get vacinaId {
    final $$VacinasTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vacinaId,
        referencedTable: $db.vacinas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VacinasTableOrderingComposer(
              $db: $db,
              $table: $db.vacinas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AgendasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AgendasTable> {
  $$AgendasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get lote =>
      $composableBuilder(column: $table.lote, builder: (column) => column);

  GeneratedColumn<String> get fabricante => $composableBuilder(
      column: $table.fabricante, builder: (column) => column);

  GeneratedColumn<DateTime> get dataAplicacao => $composableBuilder(
      column: $table.dataAplicacao, builder: (column) => column);

  GeneratedColumn<String> get local =>
      $composableBuilder(column: $table.local, builder: (column) => column);

  GeneratedColumn<DateTime> get proximaDose => $composableBuilder(
      column: $table.proximaDose, builder: (column) => column);

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableAnnotationComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$VacinasTableAnnotationComposer get vacinaId {
    final $$VacinasTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.vacinaId,
        referencedTable: $db.vacinas,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$VacinasTableAnnotationComposer(
              $db: $db,
              $table: $db.vacinas,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AgendasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AgendasTable,
    Agenda,
    $$AgendasTableFilterComposer,
    $$AgendasTableOrderingComposer,
    $$AgendasTableAnnotationComposer,
    $$AgendasTableCreateCompanionBuilder,
    $$AgendasTableUpdateCompanionBuilder,
    (Agenda, $$AgendasTableReferences),
    Agenda,
    PrefetchHooks Function({bool usuarioId, bool vacinaId})> {
  $$AgendasTableTableManager(_$AppDatabase db, $AgendasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AgendasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AgendasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AgendasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> usuarioId = const Value.absent(),
            Value<int> vacinaId = const Value.absent(),
            Value<String> dose = const Value.absent(),
            Value<String?> lote = const Value.absent(),
            Value<String?> fabricante = const Value.absent(),
            Value<DateTime> dataAplicacao = const Value.absent(),
            Value<String?> local = const Value.absent(),
            Value<DateTime?> proximaDose = const Value.absent(),
          }) =>
              AgendasCompanion(
            id: id,
            usuarioId: usuarioId,
            vacinaId: vacinaId,
            dose: dose,
            lote: lote,
            fabricante: fabricante,
            dataAplicacao: dataAplicacao,
            local: local,
            proximaDose: proximaDose,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int usuarioId,
            required int vacinaId,
            required String dose,
            Value<String?> lote = const Value.absent(),
            Value<String?> fabricante = const Value.absent(),
            required DateTime dataAplicacao,
            Value<String?> local = const Value.absent(),
            Value<DateTime?> proximaDose = const Value.absent(),
          }) =>
              AgendasCompanion.insert(
            id: id,
            usuarioId: usuarioId,
            vacinaId: vacinaId,
            dose: dose,
            lote: lote,
            fabricante: fabricante,
            dataAplicacao: dataAplicacao,
            local: local,
            proximaDose: proximaDose,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AgendasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({usuarioId = false, vacinaId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (usuarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.usuarioId,
                    referencedTable:
                        $$AgendasTableReferences._usuarioIdTable(db),
                    referencedColumn:
                        $$AgendasTableReferences._usuarioIdTable(db).id,
                  ) as T;
                }
                if (vacinaId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.vacinaId,
                    referencedTable:
                        $$AgendasTableReferences._vacinaIdTable(db),
                    referencedColumn:
                        $$AgendasTableReferences._vacinaIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AgendasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AgendasTable,
    Agenda,
    $$AgendasTableFilterComposer,
    $$AgendasTableOrderingComposer,
    $$AgendasTableAnnotationComposer,
    $$AgendasTableCreateCompanionBuilder,
    $$AgendasTableUpdateCompanionBuilder,
    (Agenda, $$AgendasTableReferences),
    Agenda,
    PrefetchHooks Function({bool usuarioId, bool vacinaId})>;
typedef $$AlergiasTableCreateCompanionBuilder = AlergiasCompanion Function({
  Value<int> id,
  required int usuarioId,
  required String nome,
  required String categoria,
  required String gravidade,
});
typedef $$AlergiasTableUpdateCompanionBuilder = AlergiasCompanion Function({
  Value<int> id,
  Value<int> usuarioId,
  Value<String> nome,
  Value<String> categoria,
  Value<String> gravidade,
});

final class $$AlergiasTableReferences
    extends BaseReferences<_$AppDatabase, $AlergiasTable, Alergia> {
  $$AlergiasTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsuariosTable _usuarioIdTable(_$AppDatabase db) => db.usuarios
      .createAlias($_aliasNameGenerator(db.alergias.usuarioId, db.usuarios.id));

  $$UsuariosTableProcessedTableManager get usuarioId {
    final $_column = $_itemColumn<int>('usuario_id')!;

    final manager = $$UsuariosTableTableManager($_db, $_db.usuarios)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_usuarioIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AlergiasTableFilterComposer
    extends Composer<_$AppDatabase, $AlergiasTable> {
  $$AlergiasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gravidade => $composableBuilder(
      column: $table.gravidade, builder: (column) => ColumnFilters(column));

  $$UsuariosTableFilterComposer get usuarioId {
    final $$UsuariosTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableFilterComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlergiasTableOrderingComposer
    extends Composer<_$AppDatabase, $AlergiasTable> {
  $$AlergiasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nome => $composableBuilder(
      column: $table.nome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoria => $composableBuilder(
      column: $table.categoria, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gravidade => $composableBuilder(
      column: $table.gravidade, builder: (column) => ColumnOrderings(column));

  $$UsuariosTableOrderingComposer get usuarioId {
    final $$UsuariosTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableOrderingComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlergiasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlergiasTable> {
  $$AlergiasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nome =>
      $composableBuilder(column: $table.nome, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get gravidade =>
      $composableBuilder(column: $table.gravidade, builder: (column) => column);

  $$UsuariosTableAnnotationComposer get usuarioId {
    final $$UsuariosTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.usuarioId,
        referencedTable: $db.usuarios,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsuariosTableAnnotationComposer(
              $db: $db,
              $table: $db.usuarios,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlergiasTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlergiasTable,
    Alergia,
    $$AlergiasTableFilterComposer,
    $$AlergiasTableOrderingComposer,
    $$AlergiasTableAnnotationComposer,
    $$AlergiasTableCreateCompanionBuilder,
    $$AlergiasTableUpdateCompanionBuilder,
    (Alergia, $$AlergiasTableReferences),
    Alergia,
    PrefetchHooks Function({bool usuarioId})> {
  $$AlergiasTableTableManager(_$AppDatabase db, $AlergiasTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlergiasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlergiasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlergiasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> usuarioId = const Value.absent(),
            Value<String> nome = const Value.absent(),
            Value<String> categoria = const Value.absent(),
            Value<String> gravidade = const Value.absent(),
          }) =>
              AlergiasCompanion(
            id: id,
            usuarioId: usuarioId,
            nome: nome,
            categoria: categoria,
            gravidade: gravidade,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int usuarioId,
            required String nome,
            required String categoria,
            required String gravidade,
          }) =>
              AlergiasCompanion.insert(
            id: id,
            usuarioId: usuarioId,
            nome: nome,
            categoria: categoria,
            gravidade: gravidade,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$AlergiasTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({usuarioId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (usuarioId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.usuarioId,
                    referencedTable:
                        $$AlergiasTableReferences._usuarioIdTable(db),
                    referencedColumn:
                        $$AlergiasTableReferences._usuarioIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AlergiasTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlergiasTable,
    Alergia,
    $$AlergiasTableFilterComposer,
    $$AlergiasTableOrderingComposer,
    $$AlergiasTableAnnotationComposer,
    $$AlergiasTableCreateCompanionBuilder,
    $$AlergiasTableUpdateCompanionBuilder,
    (Alergia, $$AlergiasTableReferences),
    Alergia,
    PrefetchHooks Function({bool usuarioId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsuariosTableTableManager get usuarios =>
      $$UsuariosTableTableManager(_db, _db.usuarios);
  $$VacinasTableTableManager get vacinas =>
      $$VacinasTableTableManager(_db, _db.vacinas);
  $$AgendasTableTableManager get agendas =>
      $$AgendasTableTableManager(_db, _db.agendas);
  $$AlergiasTableTableManager get alergias =>
      $$AlergiasTableTableManager(_db, _db.alergias);
}
