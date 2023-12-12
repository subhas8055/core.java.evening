// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'framework_database.dart';

// ignore_for_file: type=lint
class ApplicationMetaData extends DataClass
    implements Insertable<ApplicationMetaData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String appId;
  final String appName;
  final String description;
  final String version;
  final String installationDate;
  final String appClassName;
  const ApplicationMetaData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.appId,
      required this.appName,
      required this.description,
      required this.version,
      required this.installationDate,
      required this.appClassName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['app_id'] = Variable<String>(appId);
    map['app_name'] = Variable<String>(appName);
    map['description'] = Variable<String>(description);
    map['version'] = Variable<String>(version);
    map['installation_date'] = Variable<String>(installationDate);
    map['app_class_name'] = Variable<String>(appClassName);
    return map;
  }

  ApplicationMetaCompanion toCompanion(bool nullToAbsent) {
    return ApplicationMetaCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      appId: Value(appId),
      appName: Value(appName),
      description: Value(description),
      version: Value(version),
      installationDate: Value(installationDate),
      appClassName: Value(appClassName),
    );
  }

  factory ApplicationMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApplicationMetaData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      appId: serializer.fromJson<String>(json['appId']),
      appName: serializer.fromJson<String>(json['appName']),
      description: serializer.fromJson<String>(json['description']),
      version: serializer.fromJson<String>(json['version']),
      installationDate: serializer.fromJson<String>(json['installationDate']),
      appClassName: serializer.fromJson<String>(json['appClassName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'appId': serializer.toJson<String>(appId),
      'appName': serializer.toJson<String>(appName),
      'description': serializer.toJson<String>(description),
      'version': serializer.toJson<String>(version),
      'installationDate': serializer.toJson<String>(installationDate),
      'appClassName': serializer.toJson<String>(appClassName),
    };
  }

  ApplicationMetaData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? appId,
          String? appName,
          String? description,
          String? version,
          String? installationDate,
          String? appClassName}) =>
      ApplicationMetaData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        appId: appId ?? this.appId,
        appName: appName ?? this.appName,
        description: description ?? this.description,
        version: version ?? this.version,
        installationDate: installationDate ?? this.installationDate,
        appClassName: appClassName ?? this.appClassName,
      );
  @override
  String toString() {
    return (StringBuffer('ApplicationMetaData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appId: $appId, ')
          ..write('appName: $appName, ')
          ..write('description: $description, ')
          ..write('version: $version, ')
          ..write('installationDate: $installationDate, ')
          ..write('appClassName: $appClassName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lid, timestamp, objectStatus, syncStatus,
      appId, appName, description, version, installationDate, appClassName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApplicationMetaData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.appId == this.appId &&
          other.appName == this.appName &&
          other.description == this.description &&
          other.version == this.version &&
          other.installationDate == this.installationDate &&
          other.appClassName == this.appClassName);
}

class ApplicationMetaCompanion extends UpdateCompanion<ApplicationMetaData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> appId;
  final Value<String> appName;
  final Value<String> description;
  final Value<String> version;
  final Value<String> installationDate;
  final Value<String> appClassName;
  const ApplicationMetaCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.appId = const Value.absent(),
    this.appName = const Value.absent(),
    this.description = const Value.absent(),
    this.version = const Value.absent(),
    this.installationDate = const Value.absent(),
    this.appClassName = const Value.absent(),
  });
  ApplicationMetaCompanion.insert({
    required String lid,
    required int timestamp,
    required int objectStatus,
    required int syncStatus,
    required String appId,
    required String appName,
    required String description,
    required String version,
    required String installationDate,
    required String appClassName,
  })  : lid = Value(lid),
        timestamp = Value(timestamp),
        objectStatus = Value(objectStatus),
        syncStatus = Value(syncStatus),
        appId = Value(appId),
        appName = Value(appName),
        description = Value(description),
        version = Value(version),
        installationDate = Value(installationDate),
        appClassName = Value(appClassName);
  static Insertable<ApplicationMetaData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? appId,
    Expression<String>? appName,
    Expression<String>? description,
    Expression<String>? version,
    Expression<String>? installationDate,
    Expression<String>? appClassName,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (appId != null) 'app_id': appId,
      if (appName != null) 'app_name': appName,
      if (description != null) 'description': description,
      if (version != null) 'version': version,
      if (installationDate != null) 'installation_date': installationDate,
      if (appClassName != null) 'app_class_name': appClassName,
    });
  }

  ApplicationMetaCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? appId,
      Value<String>? appName,
      Value<String>? description,
      Value<String>? version,
      Value<String>? installationDate,
      Value<String>? appClassName}) {
    return ApplicationMetaCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      appId: appId ?? this.appId,
      appName: appName ?? this.appName,
      description: description ?? this.description,
      version: version ?? this.version,
      installationDate: installationDate ?? this.installationDate,
      appClassName: appClassName ?? this.appClassName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (version.present) {
      map['version'] = Variable<String>(version.value);
    }
    if (installationDate.present) {
      map['installation_date'] = Variable<String>(installationDate.value);
    }
    if (appClassName.present) {
      map['app_class_name'] = Variable<String>(appClassName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApplicationMetaCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appId: $appId, ')
          ..write('appName: $appName, ')
          ..write('description: $description, ')
          ..write('version: $version, ')
          ..write('installationDate: $installationDate, ')
          ..write('appClassName: $appClassName')
          ..write(')'))
        .toString();
  }
}

class $ApplicationMetaTable extends ApplicationMeta
    with TableInfo<$ApplicationMetaTable, ApplicationMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApplicationMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
      'app_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appNameMeta =
      const VerificationMeta('appName');
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
      'app_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<String> version = GeneratedColumn<String>(
      'version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _installationDateMeta =
      const VerificationMeta('installationDate');
  @override
  late final GeneratedColumn<String> installationDate = GeneratedColumn<String>(
      'installation_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appClassNameMeta =
      const VerificationMeta('appClassName');
  @override
  late final GeneratedColumn<String> appClassName = GeneratedColumn<String>(
      'app_class_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        appId,
        appName,
        description,
        version,
        installationDate,
        appClassName
      ];
  @override
  String get aliasedName => _alias ?? 'application_meta';
  @override
  String get actualTableName => 'application_meta';
  @override
  VerificationContext validateIntegrity(
      Insertable<ApplicationMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    } else if (isInserting) {
      context.missing(_lidMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    } else if (isInserting) {
      context.missing(_objectStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
          _appIdMeta, appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta));
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(_appNameMeta,
          appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta));
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('installation_date')) {
      context.handle(
          _installationDateMeta,
          installationDate.isAcceptableOrUnknown(
              data['installation_date']!, _installationDateMeta));
    } else if (isInserting) {
      context.missing(_installationDateMeta);
    }
    if (data.containsKey('app_class_name')) {
      context.handle(
          _appClassNameMeta,
          appClassName.isAcceptableOrUnknown(
              data['app_class_name']!, _appClassNameMeta));
    } else if (isInserting) {
      context.missing(_appClassNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  ApplicationMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApplicationMetaData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      appId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_id'])!,
      appName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version'])!,
      installationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}installation_date'])!,
      appClassName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_class_name'])!,
    );
  }

  @override
  $ApplicationMetaTable createAlias(String alias) {
    return $ApplicationMetaTable(attachedDatabase, alias);
  }
}

class StructureMetaData extends DataClass
    implements Insertable<StructureMetaData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String appName;
  final String beName;
  final String structureName;
  final String description;
  final String className;
  final String isHeader;
  const StructureMetaData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.appName,
      required this.beName,
      required this.structureName,
      required this.description,
      required this.className,
      required this.isHeader});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['app_name'] = Variable<String>(appName);
    map['be_name'] = Variable<String>(beName);
    map['structure_name'] = Variable<String>(structureName);
    map['description'] = Variable<String>(description);
    map['class_name'] = Variable<String>(className);
    map['is_header'] = Variable<String>(isHeader);
    return map;
  }

  StructureMetaCompanion toCompanion(bool nullToAbsent) {
    return StructureMetaCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      appName: Value(appName),
      beName: Value(beName),
      structureName: Value(structureName),
      description: Value(description),
      className: Value(className),
      isHeader: Value(isHeader),
    );
  }

  factory StructureMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StructureMetaData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      appName: serializer.fromJson<String>(json['appName']),
      beName: serializer.fromJson<String>(json['beName']),
      structureName: serializer.fromJson<String>(json['structureName']),
      description: serializer.fromJson<String>(json['description']),
      className: serializer.fromJson<String>(json['className']),
      isHeader: serializer.fromJson<String>(json['isHeader']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'appName': serializer.toJson<String>(appName),
      'beName': serializer.toJson<String>(beName),
      'structureName': serializer.toJson<String>(structureName),
      'description': serializer.toJson<String>(description),
      'className': serializer.toJson<String>(className),
      'isHeader': serializer.toJson<String>(isHeader),
    };
  }

  StructureMetaData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? appName,
          String? beName,
          String? structureName,
          String? description,
          String? className,
          String? isHeader}) =>
      StructureMetaData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        appName: appName ?? this.appName,
        beName: beName ?? this.beName,
        structureName: structureName ?? this.structureName,
        description: description ?? this.description,
        className: className ?? this.className,
        isHeader: isHeader ?? this.isHeader,
      );
  @override
  String toString() {
    return (StringBuffer('StructureMetaData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appName: $appName, ')
          ..write('beName: $beName, ')
          ..write('structureName: $structureName, ')
          ..write('description: $description, ')
          ..write('className: $className, ')
          ..write('isHeader: $isHeader')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lid, timestamp, objectStatus, syncStatus,
      appName, beName, structureName, description, className, isHeader);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StructureMetaData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.appName == this.appName &&
          other.beName == this.beName &&
          other.structureName == this.structureName &&
          other.description == this.description &&
          other.className == this.className &&
          other.isHeader == this.isHeader);
}

class StructureMetaCompanion extends UpdateCompanion<StructureMetaData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> appName;
  final Value<String> beName;
  final Value<String> structureName;
  final Value<String> description;
  final Value<String> className;
  final Value<String> isHeader;
  const StructureMetaCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.appName = const Value.absent(),
    this.beName = const Value.absent(),
    this.structureName = const Value.absent(),
    this.description = const Value.absent(),
    this.className = const Value.absent(),
    this.isHeader = const Value.absent(),
  });
  StructureMetaCompanion.insert({
    required String lid,
    required int timestamp,
    required int objectStatus,
    required int syncStatus,
    required String appName,
    required String beName,
    required String structureName,
    required String description,
    required String className,
    required String isHeader,
  })  : lid = Value(lid),
        timestamp = Value(timestamp),
        objectStatus = Value(objectStatus),
        syncStatus = Value(syncStatus),
        appName = Value(appName),
        beName = Value(beName),
        structureName = Value(structureName),
        description = Value(description),
        className = Value(className),
        isHeader = Value(isHeader);
  static Insertable<StructureMetaData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? appName,
    Expression<String>? beName,
    Expression<String>? structureName,
    Expression<String>? description,
    Expression<String>? className,
    Expression<String>? isHeader,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (appName != null) 'app_name': appName,
      if (beName != null) 'be_name': beName,
      if (structureName != null) 'structure_name': structureName,
      if (description != null) 'description': description,
      if (className != null) 'class_name': className,
      if (isHeader != null) 'is_header': isHeader,
    });
  }

  StructureMetaCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? appName,
      Value<String>? beName,
      Value<String>? structureName,
      Value<String>? description,
      Value<String>? className,
      Value<String>? isHeader}) {
    return StructureMetaCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      appName: appName ?? this.appName,
      beName: beName ?? this.beName,
      structureName: structureName ?? this.structureName,
      description: description ?? this.description,
      className: className ?? this.className,
      isHeader: isHeader ?? this.isHeader,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (beName.present) {
      map['be_name'] = Variable<String>(beName.value);
    }
    if (structureName.present) {
      map['structure_name'] = Variable<String>(structureName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (className.present) {
      map['class_name'] = Variable<String>(className.value);
    }
    if (isHeader.present) {
      map['is_header'] = Variable<String>(isHeader.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StructureMetaCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appName: $appName, ')
          ..write('beName: $beName, ')
          ..write('structureName: $structureName, ')
          ..write('description: $description, ')
          ..write('className: $className, ')
          ..write('isHeader: $isHeader')
          ..write(')'))
        .toString();
  }
}

class $StructureMetaTable extends StructureMeta
    with TableInfo<$StructureMetaTable, StructureMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StructureMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _appNameMeta =
      const VerificationMeta('appName');
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
      'app_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beNameMeta = const VerificationMeta('beName');
  @override
  late final GeneratedColumn<String> beName = GeneratedColumn<String>(
      'be_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _structureNameMeta =
      const VerificationMeta('structureName');
  @override
  late final GeneratedColumn<String> structureName = GeneratedColumn<String>(
      'structure_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _classNameMeta =
      const VerificationMeta('className');
  @override
  late final GeneratedColumn<String> className = GeneratedColumn<String>(
      'class_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isHeaderMeta =
      const VerificationMeta('isHeader');
  @override
  late final GeneratedColumn<String> isHeader = GeneratedColumn<String>(
      'is_header', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        appName,
        beName,
        structureName,
        description,
        className,
        isHeader
      ];
  @override
  String get aliasedName => _alias ?? 'structure_meta';
  @override
  String get actualTableName => 'structure_meta';
  @override
  VerificationContext validateIntegrity(Insertable<StructureMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    } else if (isInserting) {
      context.missing(_lidMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    } else if (isInserting) {
      context.missing(_objectStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(_appNameMeta,
          appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta));
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('be_name')) {
      context.handle(_beNameMeta,
          beName.isAcceptableOrUnknown(data['be_name']!, _beNameMeta));
    } else if (isInserting) {
      context.missing(_beNameMeta);
    }
    if (data.containsKey('structure_name')) {
      context.handle(
          _structureNameMeta,
          structureName.isAcceptableOrUnknown(
              data['structure_name']!, _structureNameMeta));
    } else if (isInserting) {
      context.missing(_structureNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('class_name')) {
      context.handle(_classNameMeta,
          className.isAcceptableOrUnknown(data['class_name']!, _classNameMeta));
    } else if (isInserting) {
      context.missing(_classNameMeta);
    }
    if (data.containsKey('is_header')) {
      context.handle(_isHeaderMeta,
          isHeader.isAcceptableOrUnknown(data['is_header']!, _isHeaderMeta));
    } else if (isInserting) {
      context.missing(_isHeaderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  StructureMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StructureMetaData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      appName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_name'])!,
      beName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_name'])!,
      structureName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}structure_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      className: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}class_name'])!,
      isHeader: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}is_header'])!,
    );
  }

  @override
  $StructureMetaTable createAlias(String alias) {
    return $StructureMetaTable(attachedDatabase, alias);
  }
}

class BusinessEntityMetaData extends DataClass
    implements Insertable<BusinessEntityMetaData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String appName;
  final String beName;
  final String description;
  final String addFunction;
  final String modifyFunction;
  final String deleteFunction;
  final String notification;
  final String attachments;
  final String conflictRules;
  final String save;
  const BusinessEntityMetaData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.appName,
      required this.beName,
      required this.description,
      required this.addFunction,
      required this.modifyFunction,
      required this.deleteFunction,
      required this.notification,
      required this.attachments,
      required this.conflictRules,
      required this.save});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['app_name'] = Variable<String>(appName);
    map['be_name'] = Variable<String>(beName);
    map['description'] = Variable<String>(description);
    map['add_function'] = Variable<String>(addFunction);
    map['modify_function'] = Variable<String>(modifyFunction);
    map['delete_function'] = Variable<String>(deleteFunction);
    map['notification'] = Variable<String>(notification);
    map['attachments'] = Variable<String>(attachments);
    map['conflict_rules'] = Variable<String>(conflictRules);
    map['save'] = Variable<String>(save);
    return map;
  }

  BusinessEntityMetaCompanion toCompanion(bool nullToAbsent) {
    return BusinessEntityMetaCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      appName: Value(appName),
      beName: Value(beName),
      description: Value(description),
      addFunction: Value(addFunction),
      modifyFunction: Value(modifyFunction),
      deleteFunction: Value(deleteFunction),
      notification: Value(notification),
      attachments: Value(attachments),
      conflictRules: Value(conflictRules),
      save: Value(save),
    );
  }

  factory BusinessEntityMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessEntityMetaData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      appName: serializer.fromJson<String>(json['appName']),
      beName: serializer.fromJson<String>(json['beName']),
      description: serializer.fromJson<String>(json['description']),
      addFunction: serializer.fromJson<String>(json['addFunction']),
      modifyFunction: serializer.fromJson<String>(json['modifyFunction']),
      deleteFunction: serializer.fromJson<String>(json['deleteFunction']),
      notification: serializer.fromJson<String>(json['notification']),
      attachments: serializer.fromJson<String>(json['attachments']),
      conflictRules: serializer.fromJson<String>(json['conflictRules']),
      save: serializer.fromJson<String>(json['save']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'appName': serializer.toJson<String>(appName),
      'beName': serializer.toJson<String>(beName),
      'description': serializer.toJson<String>(description),
      'addFunction': serializer.toJson<String>(addFunction),
      'modifyFunction': serializer.toJson<String>(modifyFunction),
      'deleteFunction': serializer.toJson<String>(deleteFunction),
      'notification': serializer.toJson<String>(notification),
      'attachments': serializer.toJson<String>(attachments),
      'conflictRules': serializer.toJson<String>(conflictRules),
      'save': serializer.toJson<String>(save),
    };
  }

  BusinessEntityMetaData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? appName,
          String? beName,
          String? description,
          String? addFunction,
          String? modifyFunction,
          String? deleteFunction,
          String? notification,
          String? attachments,
          String? conflictRules,
          String? save}) =>
      BusinessEntityMetaData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        appName: appName ?? this.appName,
        beName: beName ?? this.beName,
        description: description ?? this.description,
        addFunction: addFunction ?? this.addFunction,
        modifyFunction: modifyFunction ?? this.modifyFunction,
        deleteFunction: deleteFunction ?? this.deleteFunction,
        notification: notification ?? this.notification,
        attachments: attachments ?? this.attachments,
        conflictRules: conflictRules ?? this.conflictRules,
        save: save ?? this.save,
      );
  @override
  String toString() {
    return (StringBuffer('BusinessEntityMetaData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appName: $appName, ')
          ..write('beName: $beName, ')
          ..write('description: $description, ')
          ..write('addFunction: $addFunction, ')
          ..write('modifyFunction: $modifyFunction, ')
          ..write('deleteFunction: $deleteFunction, ')
          ..write('notification: $notification, ')
          ..write('attachments: $attachments, ')
          ..write('conflictRules: $conflictRules, ')
          ..write('save: $save')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid,
      timestamp,
      objectStatus,
      syncStatus,
      appName,
      beName,
      description,
      addFunction,
      modifyFunction,
      deleteFunction,
      notification,
      attachments,
      conflictRules,
      save);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessEntityMetaData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.appName == this.appName &&
          other.beName == this.beName &&
          other.description == this.description &&
          other.addFunction == this.addFunction &&
          other.modifyFunction == this.modifyFunction &&
          other.deleteFunction == this.deleteFunction &&
          other.notification == this.notification &&
          other.attachments == this.attachments &&
          other.conflictRules == this.conflictRules &&
          other.save == this.save);
}

class BusinessEntityMetaCompanion
    extends UpdateCompanion<BusinessEntityMetaData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> appName;
  final Value<String> beName;
  final Value<String> description;
  final Value<String> addFunction;
  final Value<String> modifyFunction;
  final Value<String> deleteFunction;
  final Value<String> notification;
  final Value<String> attachments;
  final Value<String> conflictRules;
  final Value<String> save;
  const BusinessEntityMetaCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.appName = const Value.absent(),
    this.beName = const Value.absent(),
    this.description = const Value.absent(),
    this.addFunction = const Value.absent(),
    this.modifyFunction = const Value.absent(),
    this.deleteFunction = const Value.absent(),
    this.notification = const Value.absent(),
    this.attachments = const Value.absent(),
    this.conflictRules = const Value.absent(),
    this.save = const Value.absent(),
  });
  BusinessEntityMetaCompanion.insert({
    required String lid,
    required int timestamp,
    required int objectStatus,
    required int syncStatus,
    required String appName,
    required String beName,
    required String description,
    required String addFunction,
    required String modifyFunction,
    required String deleteFunction,
    required String notification,
    required String attachments,
    required String conflictRules,
    required String save,
  })  : lid = Value(lid),
        timestamp = Value(timestamp),
        objectStatus = Value(objectStatus),
        syncStatus = Value(syncStatus),
        appName = Value(appName),
        beName = Value(beName),
        description = Value(description),
        addFunction = Value(addFunction),
        modifyFunction = Value(modifyFunction),
        deleteFunction = Value(deleteFunction),
        notification = Value(notification),
        attachments = Value(attachments),
        conflictRules = Value(conflictRules),
        save = Value(save);
  static Insertable<BusinessEntityMetaData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? appName,
    Expression<String>? beName,
    Expression<String>? description,
    Expression<String>? addFunction,
    Expression<String>? modifyFunction,
    Expression<String>? deleteFunction,
    Expression<String>? notification,
    Expression<String>? attachments,
    Expression<String>? conflictRules,
    Expression<String>? save,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (appName != null) 'app_name': appName,
      if (beName != null) 'be_name': beName,
      if (description != null) 'description': description,
      if (addFunction != null) 'add_function': addFunction,
      if (modifyFunction != null) 'modify_function': modifyFunction,
      if (deleteFunction != null) 'delete_function': deleteFunction,
      if (notification != null) 'notification': notification,
      if (attachments != null) 'attachments': attachments,
      if (conflictRules != null) 'conflict_rules': conflictRules,
      if (save != null) 'save': save,
    });
  }

  BusinessEntityMetaCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? appName,
      Value<String>? beName,
      Value<String>? description,
      Value<String>? addFunction,
      Value<String>? modifyFunction,
      Value<String>? deleteFunction,
      Value<String>? notification,
      Value<String>? attachments,
      Value<String>? conflictRules,
      Value<String>? save}) {
    return BusinessEntityMetaCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      appName: appName ?? this.appName,
      beName: beName ?? this.beName,
      description: description ?? this.description,
      addFunction: addFunction ?? this.addFunction,
      modifyFunction: modifyFunction ?? this.modifyFunction,
      deleteFunction: deleteFunction ?? this.deleteFunction,
      notification: notification ?? this.notification,
      attachments: attachments ?? this.attachments,
      conflictRules: conflictRules ?? this.conflictRules,
      save: save ?? this.save,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (beName.present) {
      map['be_name'] = Variable<String>(beName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (addFunction.present) {
      map['add_function'] = Variable<String>(addFunction.value);
    }
    if (modifyFunction.present) {
      map['modify_function'] = Variable<String>(modifyFunction.value);
    }
    if (deleteFunction.present) {
      map['delete_function'] = Variable<String>(deleteFunction.value);
    }
    if (notification.present) {
      map['notification'] = Variable<String>(notification.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (conflictRules.present) {
      map['conflict_rules'] = Variable<String>(conflictRules.value);
    }
    if (save.present) {
      map['save'] = Variable<String>(save.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessEntityMetaCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appName: $appName, ')
          ..write('beName: $beName, ')
          ..write('description: $description, ')
          ..write('addFunction: $addFunction, ')
          ..write('modifyFunction: $modifyFunction, ')
          ..write('deleteFunction: $deleteFunction, ')
          ..write('notification: $notification, ')
          ..write('attachments: $attachments, ')
          ..write('conflictRules: $conflictRules, ')
          ..write('save: $save')
          ..write(')'))
        .toString();
  }
}

class $BusinessEntityMetaTable extends BusinessEntityMeta
    with TableInfo<$BusinessEntityMetaTable, BusinessEntityMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessEntityMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _appNameMeta =
      const VerificationMeta('appName');
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
      'app_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beNameMeta = const VerificationMeta('beName');
  @override
  late final GeneratedColumn<String> beName = GeneratedColumn<String>(
      'be_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addFunctionMeta =
      const VerificationMeta('addFunction');
  @override
  late final GeneratedColumn<String> addFunction = GeneratedColumn<String>(
      'add_function', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modifyFunctionMeta =
      const VerificationMeta('modifyFunction');
  @override
  late final GeneratedColumn<String> modifyFunction = GeneratedColumn<String>(
      'modify_function', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deleteFunctionMeta =
      const VerificationMeta('deleteFunction');
  @override
  late final GeneratedColumn<String> deleteFunction = GeneratedColumn<String>(
      'delete_function', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationMeta =
      const VerificationMeta('notification');
  @override
  late final GeneratedColumn<String> notification = GeneratedColumn<String>(
      'notification', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
      'attachments', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conflictRulesMeta =
      const VerificationMeta('conflictRules');
  @override
  late final GeneratedColumn<String> conflictRules = GeneratedColumn<String>(
      'conflict_rules', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saveMeta = const VerificationMeta('save');
  @override
  late final GeneratedColumn<String> save = GeneratedColumn<String>(
      'save', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        appName,
        beName,
        description,
        addFunction,
        modifyFunction,
        deleteFunction,
        notification,
        attachments,
        conflictRules,
        save
      ];
  @override
  String get aliasedName => _alias ?? 'business_entity_meta';
  @override
  String get actualTableName => 'business_entity_meta';
  @override
  VerificationContext validateIntegrity(
      Insertable<BusinessEntityMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    } else if (isInserting) {
      context.missing(_lidMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    } else if (isInserting) {
      context.missing(_objectStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(_appNameMeta,
          appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta));
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('be_name')) {
      context.handle(_beNameMeta,
          beName.isAcceptableOrUnknown(data['be_name']!, _beNameMeta));
    } else if (isInserting) {
      context.missing(_beNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('add_function')) {
      context.handle(
          _addFunctionMeta,
          addFunction.isAcceptableOrUnknown(
              data['add_function']!, _addFunctionMeta));
    } else if (isInserting) {
      context.missing(_addFunctionMeta);
    }
    if (data.containsKey('modify_function')) {
      context.handle(
          _modifyFunctionMeta,
          modifyFunction.isAcceptableOrUnknown(
              data['modify_function']!, _modifyFunctionMeta));
    } else if (isInserting) {
      context.missing(_modifyFunctionMeta);
    }
    if (data.containsKey('delete_function')) {
      context.handle(
          _deleteFunctionMeta,
          deleteFunction.isAcceptableOrUnknown(
              data['delete_function']!, _deleteFunctionMeta));
    } else if (isInserting) {
      context.missing(_deleteFunctionMeta);
    }
    if (data.containsKey('notification')) {
      context.handle(
          _notificationMeta,
          notification.isAcceptableOrUnknown(
              data['notification']!, _notificationMeta));
    } else if (isInserting) {
      context.missing(_notificationMeta);
    }
    if (data.containsKey('attachments')) {
      context.handle(
          _attachmentsMeta,
          attachments.isAcceptableOrUnknown(
              data['attachments']!, _attachmentsMeta));
    } else if (isInserting) {
      context.missing(_attachmentsMeta);
    }
    if (data.containsKey('conflict_rules')) {
      context.handle(
          _conflictRulesMeta,
          conflictRules.isAcceptableOrUnknown(
              data['conflict_rules']!, _conflictRulesMeta));
    } else if (isInserting) {
      context.missing(_conflictRulesMeta);
    }
    if (data.containsKey('save')) {
      context.handle(
          _saveMeta, save.isAcceptableOrUnknown(data['save']!, _saveMeta));
    } else if (isInserting) {
      context.missing(_saveMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  BusinessEntityMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessEntityMetaData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      appName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_name'])!,
      beName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      addFunction: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}add_function'])!,
      modifyFunction: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}modify_function'])!,
      deleteFunction: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}delete_function'])!,
      notification: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notification'])!,
      attachments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachments'])!,
      conflictRules: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}conflict_rules'])!,
      save: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}save'])!,
    );
  }

  @override
  $BusinessEntityMetaTable createAlias(String alias) {
    return $BusinessEntityMetaTable(attachedDatabase, alias);
  }
}

class FieldMetaData extends DataClass implements Insertable<FieldMetaData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String appName;
  final String beName;
  final String structureName;
  final String fieldName;
  final String description;
  final String length;
  final String mandatory;
  final String sqlType;
  final String isGid;
  const FieldMetaData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.appName,
      required this.beName,
      required this.structureName,
      required this.fieldName,
      required this.description,
      required this.length,
      required this.mandatory,
      required this.sqlType,
      required this.isGid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['app_name'] = Variable<String>(appName);
    map['be_name'] = Variable<String>(beName);
    map['structure_name'] = Variable<String>(structureName);
    map['field_name'] = Variable<String>(fieldName);
    map['description'] = Variable<String>(description);
    map['length'] = Variable<String>(length);
    map['mandatory'] = Variable<String>(mandatory);
    map['sql_type'] = Variable<String>(sqlType);
    map['is_gid'] = Variable<String>(isGid);
    return map;
  }

  FieldMetaCompanion toCompanion(bool nullToAbsent) {
    return FieldMetaCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      appName: Value(appName),
      beName: Value(beName),
      structureName: Value(structureName),
      fieldName: Value(fieldName),
      description: Value(description),
      length: Value(length),
      mandatory: Value(mandatory),
      sqlType: Value(sqlType),
      isGid: Value(isGid),
    );
  }

  factory FieldMetaData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FieldMetaData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      appName: serializer.fromJson<String>(json['appName']),
      beName: serializer.fromJson<String>(json['beName']),
      structureName: serializer.fromJson<String>(json['structureName']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      description: serializer.fromJson<String>(json['description']),
      length: serializer.fromJson<String>(json['length']),
      mandatory: serializer.fromJson<String>(json['mandatory']),
      sqlType: serializer.fromJson<String>(json['sqlType']),
      isGid: serializer.fromJson<String>(json['isGid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'appName': serializer.toJson<String>(appName),
      'beName': serializer.toJson<String>(beName),
      'structureName': serializer.toJson<String>(structureName),
      'fieldName': serializer.toJson<String>(fieldName),
      'description': serializer.toJson<String>(description),
      'length': serializer.toJson<String>(length),
      'mandatory': serializer.toJson<String>(mandatory),
      'sqlType': serializer.toJson<String>(sqlType),
      'isGid': serializer.toJson<String>(isGid),
    };
  }

  FieldMetaData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? appName,
          String? beName,
          String? structureName,
          String? fieldName,
          String? description,
          String? length,
          String? mandatory,
          String? sqlType,
          String? isGid}) =>
      FieldMetaData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        appName: appName ?? this.appName,
        beName: beName ?? this.beName,
        structureName: structureName ?? this.structureName,
        fieldName: fieldName ?? this.fieldName,
        description: description ?? this.description,
        length: length ?? this.length,
        mandatory: mandatory ?? this.mandatory,
        sqlType: sqlType ?? this.sqlType,
        isGid: isGid ?? this.isGid,
      );
  @override
  String toString() {
    return (StringBuffer('FieldMetaData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appName: $appName, ')
          ..write('beName: $beName, ')
          ..write('structureName: $structureName, ')
          ..write('fieldName: $fieldName, ')
          ..write('description: $description, ')
          ..write('length: $length, ')
          ..write('mandatory: $mandatory, ')
          ..write('sqlType: $sqlType, ')
          ..write('isGid: $isGid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid,
      timestamp,
      objectStatus,
      syncStatus,
      appName,
      beName,
      structureName,
      fieldName,
      description,
      length,
      mandatory,
      sqlType,
      isGid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FieldMetaData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.appName == this.appName &&
          other.beName == this.beName &&
          other.structureName == this.structureName &&
          other.fieldName == this.fieldName &&
          other.description == this.description &&
          other.length == this.length &&
          other.mandatory == this.mandatory &&
          other.sqlType == this.sqlType &&
          other.isGid == this.isGid);
}

class FieldMetaCompanion extends UpdateCompanion<FieldMetaData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> appName;
  final Value<String> beName;
  final Value<String> structureName;
  final Value<String> fieldName;
  final Value<String> description;
  final Value<String> length;
  final Value<String> mandatory;
  final Value<String> sqlType;
  final Value<String> isGid;
  const FieldMetaCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.appName = const Value.absent(),
    this.beName = const Value.absent(),
    this.structureName = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.description = const Value.absent(),
    this.length = const Value.absent(),
    this.mandatory = const Value.absent(),
    this.sqlType = const Value.absent(),
    this.isGid = const Value.absent(),
  });
  FieldMetaCompanion.insert({
    required String lid,
    required int timestamp,
    required int objectStatus,
    required int syncStatus,
    required String appName,
    required String beName,
    required String structureName,
    required String fieldName,
    required String description,
    required String length,
    required String mandatory,
    required String sqlType,
    required String isGid,
  })  : lid = Value(lid),
        timestamp = Value(timestamp),
        objectStatus = Value(objectStatus),
        syncStatus = Value(syncStatus),
        appName = Value(appName),
        beName = Value(beName),
        structureName = Value(structureName),
        fieldName = Value(fieldName),
        description = Value(description),
        length = Value(length),
        mandatory = Value(mandatory),
        sqlType = Value(sqlType),
        isGid = Value(isGid);
  static Insertable<FieldMetaData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? appName,
    Expression<String>? beName,
    Expression<String>? structureName,
    Expression<String>? fieldName,
    Expression<String>? description,
    Expression<String>? length,
    Expression<String>? mandatory,
    Expression<String>? sqlType,
    Expression<String>? isGid,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (appName != null) 'app_name': appName,
      if (beName != null) 'be_name': beName,
      if (structureName != null) 'structure_name': structureName,
      if (fieldName != null) 'field_name': fieldName,
      if (description != null) 'description': description,
      if (length != null) 'length': length,
      if (mandatory != null) 'mandatory': mandatory,
      if (sqlType != null) 'sql_type': sqlType,
      if (isGid != null) 'is_gid': isGid,
    });
  }

  FieldMetaCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? appName,
      Value<String>? beName,
      Value<String>? structureName,
      Value<String>? fieldName,
      Value<String>? description,
      Value<String>? length,
      Value<String>? mandatory,
      Value<String>? sqlType,
      Value<String>? isGid}) {
    return FieldMetaCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      appName: appName ?? this.appName,
      beName: beName ?? this.beName,
      structureName: structureName ?? this.structureName,
      fieldName: fieldName ?? this.fieldName,
      description: description ?? this.description,
      length: length ?? this.length,
      mandatory: mandatory ?? this.mandatory,
      sqlType: sqlType ?? this.sqlType,
      isGid: isGid ?? this.isGid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (beName.present) {
      map['be_name'] = Variable<String>(beName.value);
    }
    if (structureName.present) {
      map['structure_name'] = Variable<String>(structureName.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (length.present) {
      map['length'] = Variable<String>(length.value);
    }
    if (mandatory.present) {
      map['mandatory'] = Variable<String>(mandatory.value);
    }
    if (sqlType.present) {
      map['sql_type'] = Variable<String>(sqlType.value);
    }
    if (isGid.present) {
      map['is_gid'] = Variable<String>(isGid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FieldMetaCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('appName: $appName, ')
          ..write('beName: $beName, ')
          ..write('structureName: $structureName, ')
          ..write('fieldName: $fieldName, ')
          ..write('description: $description, ')
          ..write('length: $length, ')
          ..write('mandatory: $mandatory, ')
          ..write('sqlType: $sqlType, ')
          ..write('isGid: $isGid')
          ..write(')'))
        .toString();
  }
}

class $FieldMetaTable extends FieldMeta
    with TableInfo<$FieldMetaTable, FieldMetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FieldMetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _appNameMeta =
      const VerificationMeta('appName');
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
      'app_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beNameMeta = const VerificationMeta('beName');
  @override
  late final GeneratedColumn<String> beName = GeneratedColumn<String>(
      'be_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _structureNameMeta =
      const VerificationMeta('structureName');
  @override
  late final GeneratedColumn<String> structureName = GeneratedColumn<String>(
      'structure_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldNameMeta =
      const VerificationMeta('fieldName');
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
      'field_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lengthMeta = const VerificationMeta('length');
  @override
  late final GeneratedColumn<String> length = GeneratedColumn<String>(
      'length', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mandatoryMeta =
      const VerificationMeta('mandatory');
  @override
  late final GeneratedColumn<String> mandatory = GeneratedColumn<String>(
      'mandatory', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sqlTypeMeta =
      const VerificationMeta('sqlType');
  @override
  late final GeneratedColumn<String> sqlType = GeneratedColumn<String>(
      'sql_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isGidMeta = const VerificationMeta('isGid');
  @override
  late final GeneratedColumn<String> isGid = GeneratedColumn<String>(
      'is_gid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        appName,
        beName,
        structureName,
        fieldName,
        description,
        length,
        mandatory,
        sqlType,
        isGid
      ];
  @override
  String get aliasedName => _alias ?? 'field_meta';
  @override
  String get actualTableName => 'field_meta';
  @override
  VerificationContext validateIntegrity(Insertable<FieldMetaData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    } else if (isInserting) {
      context.missing(_lidMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    } else if (isInserting) {
      context.missing(_objectStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(_appNameMeta,
          appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta));
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('be_name')) {
      context.handle(_beNameMeta,
          beName.isAcceptableOrUnknown(data['be_name']!, _beNameMeta));
    } else if (isInserting) {
      context.missing(_beNameMeta);
    }
    if (data.containsKey('structure_name')) {
      context.handle(
          _structureNameMeta,
          structureName.isAcceptableOrUnknown(
              data['structure_name']!, _structureNameMeta));
    } else if (isInserting) {
      context.missing(_structureNameMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(_fieldNameMeta,
          fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta));
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('length')) {
      context.handle(_lengthMeta,
          length.isAcceptableOrUnknown(data['length']!, _lengthMeta));
    } else if (isInserting) {
      context.missing(_lengthMeta);
    }
    if (data.containsKey('mandatory')) {
      context.handle(_mandatoryMeta,
          mandatory.isAcceptableOrUnknown(data['mandatory']!, _mandatoryMeta));
    } else if (isInserting) {
      context.missing(_mandatoryMeta);
    }
    if (data.containsKey('sql_type')) {
      context.handle(_sqlTypeMeta,
          sqlType.isAcceptableOrUnknown(data['sql_type']!, _sqlTypeMeta));
    } else if (isInserting) {
      context.missing(_sqlTypeMeta);
    }
    if (data.containsKey('is_gid')) {
      context.handle(
          _isGidMeta, isGid.isAcceptableOrUnknown(data['is_gid']!, _isGidMeta));
    } else if (isInserting) {
      context.missing(_isGidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  FieldMetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FieldMetaData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      appName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_name'])!,
      beName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_name'])!,
      structureName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}structure_name'])!,
      fieldName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      length: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}length'])!,
      mandatory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mandatory'])!,
      sqlType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sql_type'])!,
      isGid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}is_gid'])!,
    );
  }

  @override
  $FieldMetaTable createAlias(String alias) {
    return $FieldMetaTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String fieldName;
  final String fieldValue;
  const Setting(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.fieldName,
      required this.fieldValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['field_name'] = Variable<String>(fieldName);
    map['field_value'] = Variable<String>(fieldValue);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      fieldName: Value(fieldName),
      fieldValue: Value(fieldValue),
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      fieldValue: serializer.fromJson<String>(json['fieldValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'fieldName': serializer.toJson<String>(fieldName),
      'fieldValue': serializer.toJson<String>(fieldValue),
    };
  }

  Setting copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? fieldName,
          String? fieldValue}) =>
      Setting(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        fieldName: fieldName ?? this.fieldName,
        fieldValue: fieldValue ?? this.fieldValue,
      );
  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('fieldName: $fieldName, ')
          ..write('fieldValue: $fieldValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid, timestamp, objectStatus, syncStatus, fieldName, fieldValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.fieldName == this.fieldName &&
          other.fieldValue == this.fieldValue);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> fieldName;
  final Value<String> fieldValue;
  const SettingsCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.fieldValue = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String lid,
    required int timestamp,
    required int objectStatus,
    required int syncStatus,
    required String fieldName,
    required String fieldValue,
  })  : lid = Value(lid),
        timestamp = Value(timestamp),
        objectStatus = Value(objectStatus),
        syncStatus = Value(syncStatus),
        fieldName = Value(fieldName),
        fieldValue = Value(fieldValue);
  static Insertable<Setting> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? fieldName,
    Expression<String>? fieldValue,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (fieldName != null) 'field_name': fieldName,
      if (fieldValue != null) 'field_value': fieldValue,
    });
  }

  SettingsCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? fieldName,
      Value<String>? fieldValue}) {
    return SettingsCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      fieldName: fieldName ?? this.fieldName,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (fieldValue.present) {
      map['field_value'] = Variable<String>(fieldValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('fieldName: $fieldName, ')
          ..write('fieldValue: $fieldValue')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fieldNameMeta =
      const VerificationMeta('fieldName');
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
      'field_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldValueMeta =
      const VerificationMeta('fieldValue');
  @override
  late final GeneratedColumn<String> fieldValue = GeneratedColumn<String>(
      'field_value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [lid, timestamp, objectStatus, syncStatus, fieldName, fieldValue];
  @override
  String get aliasedName => _alias ?? 'settings';
  @override
  String get actualTableName => 'settings';
  @override
  VerificationContext validateIntegrity(Insertable<Setting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    } else if (isInserting) {
      context.missing(_lidMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    } else if (isInserting) {
      context.missing(_objectStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(_fieldNameMeta,
          fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta));
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('field_value')) {
      context.handle(
          _fieldValueMeta,
          fieldValue.isAcceptableOrUnknown(
              data['field_value']!, _fieldValueMeta));
    } else if (isInserting) {
      context.missing(_fieldValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      fieldName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_name'])!,
      fieldValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_value'])!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class FrameworkSetting extends DataClass
    implements Insertable<FrameworkSetting> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String fieldName;
  final String fieldValue;
  const FrameworkSetting(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.fieldName,
      required this.fieldValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['field_name'] = Variable<String>(fieldName);
    map['field_value'] = Variable<String>(fieldValue);
    return map;
  }

  FrameworkSettingsCompanion toCompanion(bool nullToAbsent) {
    return FrameworkSettingsCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      fieldName: Value(fieldName),
      fieldValue: Value(fieldValue),
    );
  }

  factory FrameworkSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FrameworkSetting(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      fieldName: serializer.fromJson<String>(json['fieldName']),
      fieldValue: serializer.fromJson<String>(json['fieldValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'fieldName': serializer.toJson<String>(fieldName),
      'fieldValue': serializer.toJson<String>(fieldValue),
    };
  }

  FrameworkSetting copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? fieldName,
          String? fieldValue}) =>
      FrameworkSetting(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        fieldName: fieldName ?? this.fieldName,
        fieldValue: fieldValue ?? this.fieldValue,
      );
  @override
  String toString() {
    return (StringBuffer('FrameworkSetting(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('fieldName: $fieldName, ')
          ..write('fieldValue: $fieldValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid, timestamp, objectStatus, syncStatus, fieldName, fieldValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FrameworkSetting &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.fieldName == this.fieldName &&
          other.fieldValue == this.fieldValue);
}

class FrameworkSettingsCompanion extends UpdateCompanion<FrameworkSetting> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> fieldName;
  final Value<String> fieldValue;
  const FrameworkSettingsCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.fieldName = const Value.absent(),
    this.fieldValue = const Value.absent(),
  });
  FrameworkSettingsCompanion.insert({
    required String lid,
    required int timestamp,
    required int objectStatus,
    required int syncStatus,
    required String fieldName,
    required String fieldValue,
  })  : lid = Value(lid),
        timestamp = Value(timestamp),
        objectStatus = Value(objectStatus),
        syncStatus = Value(syncStatus),
        fieldName = Value(fieldName),
        fieldValue = Value(fieldValue);
  static Insertable<FrameworkSetting> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? fieldName,
    Expression<String>? fieldValue,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (fieldName != null) 'field_name': fieldName,
      if (fieldValue != null) 'field_value': fieldValue,
    });
  }

  FrameworkSettingsCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? fieldName,
      Value<String>? fieldValue}) {
    return FrameworkSettingsCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      fieldName: fieldName ?? this.fieldName,
      fieldValue: fieldValue ?? this.fieldValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (fieldName.present) {
      map['field_name'] = Variable<String>(fieldName.value);
    }
    if (fieldValue.present) {
      map['field_value'] = Variable<String>(fieldValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FrameworkSettingsCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('fieldName: $fieldName, ')
          ..write('fieldValue: $fieldValue')
          ..write(')'))
        .toString();
  }
}

class $FrameworkSettingsTable extends FrameworkSettings
    with TableInfo<$FrameworkSettingsTable, FrameworkSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FrameworkSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fieldNameMeta =
      const VerificationMeta('fieldName');
  @override
  late final GeneratedColumn<String> fieldName = GeneratedColumn<String>(
      'field_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldValueMeta =
      const VerificationMeta('fieldValue');
  @override
  late final GeneratedColumn<String> fieldValue = GeneratedColumn<String>(
      'field_value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [lid, timestamp, objectStatus, syncStatus, fieldName, fieldValue];
  @override
  String get aliasedName => _alias ?? 'framework_settings';
  @override
  String get actualTableName => 'framework_settings';
  @override
  VerificationContext validateIntegrity(Insertable<FrameworkSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    } else if (isInserting) {
      context.missing(_lidMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    } else if (isInserting) {
      context.missing(_objectStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('field_name')) {
      context.handle(_fieldNameMeta,
          fieldName.isAcceptableOrUnknown(data['field_name']!, _fieldNameMeta));
    } else if (isInserting) {
      context.missing(_fieldNameMeta);
    }
    if (data.containsKey('field_value')) {
      context.handle(
          _fieldValueMeta,
          fieldValue.isAcceptableOrUnknown(
              data['field_value']!, _fieldValueMeta));
    } else if (isInserting) {
      context.missing(_fieldValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  FrameworkSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FrameworkSetting(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      fieldName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_name'])!,
      fieldValue: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}field_value'])!,
    );
  }

  @override
  $FrameworkSettingsTable createAlias(String alias) {
    return $FrameworkSettingsTable(attachedDatabase, alias);
  }
}

class MobileUserSetting extends DataClass
    implements Insertable<MobileUserSetting> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String keyName;
  final String description;
  final String defaultField;
  final String current;
  final String mandatory;
  final String secure;
  const MobileUserSetting(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.keyName,
      required this.description,
      required this.defaultField,
      required this.current,
      required this.mandatory,
      required this.secure});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['key_name'] = Variable<String>(keyName);
    map['description'] = Variable<String>(description);
    map['default_field'] = Variable<String>(defaultField);
    map['current'] = Variable<String>(current);
    map['mandatory'] = Variable<String>(mandatory);
    map['secure'] = Variable<String>(secure);
    return map;
  }

  MobileUserSettingsCompanion toCompanion(bool nullToAbsent) {
    return MobileUserSettingsCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      keyName: Value(keyName),
      description: Value(description),
      defaultField: Value(defaultField),
      current: Value(current),
      mandatory: Value(mandatory),
      secure: Value(secure),
    );
  }

  factory MobileUserSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MobileUserSetting(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      keyName: serializer.fromJson<String>(json['keyName']),
      description: serializer.fromJson<String>(json['description']),
      defaultField: serializer.fromJson<String>(json['defaultField']),
      current: serializer.fromJson<String>(json['current']),
      mandatory: serializer.fromJson<String>(json['mandatory']),
      secure: serializer.fromJson<String>(json['secure']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'keyName': serializer.toJson<String>(keyName),
      'description': serializer.toJson<String>(description),
      'defaultField': serializer.toJson<String>(defaultField),
      'current': serializer.toJson<String>(current),
      'mandatory': serializer.toJson<String>(mandatory),
      'secure': serializer.toJson<String>(secure),
    };
  }

  MobileUserSetting copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? keyName,
          String? description,
          String? defaultField,
          String? current,
          String? mandatory,
          String? secure}) =>
      MobileUserSetting(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        keyName: keyName ?? this.keyName,
        description: description ?? this.description,
        defaultField: defaultField ?? this.defaultField,
        current: current ?? this.current,
        mandatory: mandatory ?? this.mandatory,
        secure: secure ?? this.secure,
      );
  @override
  String toString() {
    return (StringBuffer('MobileUserSetting(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('keyName: $keyName, ')
          ..write('description: $description, ')
          ..write('defaultField: $defaultField, ')
          ..write('current: $current, ')
          ..write('mandatory: $mandatory, ')
          ..write('secure: $secure')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lid, timestamp, objectStatus, syncStatus,
      keyName, description, defaultField, current, mandatory, secure);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MobileUserSetting &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.keyName == this.keyName &&
          other.description == this.description &&
          other.defaultField == this.defaultField &&
          other.current == this.current &&
          other.mandatory == this.mandatory &&
          other.secure == this.secure);
}

class MobileUserSettingsCompanion extends UpdateCompanion<MobileUserSetting> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> keyName;
  final Value<String> description;
  final Value<String> defaultField;
  final Value<String> current;
  final Value<String> mandatory;
  final Value<String> secure;
  const MobileUserSettingsCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.keyName = const Value.absent(),
    this.description = const Value.absent(),
    this.defaultField = const Value.absent(),
    this.current = const Value.absent(),
    this.mandatory = const Value.absent(),
    this.secure = const Value.absent(),
  });
  MobileUserSettingsCompanion.insert({
    required String lid,
    required int timestamp,
    required int objectStatus,
    required int syncStatus,
    required String keyName,
    required String description,
    required String defaultField,
    required String current,
    required String mandatory,
    required String secure,
  })  : lid = Value(lid),
        timestamp = Value(timestamp),
        objectStatus = Value(objectStatus),
        syncStatus = Value(syncStatus),
        keyName = Value(keyName),
        description = Value(description),
        defaultField = Value(defaultField),
        current = Value(current),
        mandatory = Value(mandatory),
        secure = Value(secure);
  static Insertable<MobileUserSetting> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? keyName,
    Expression<String>? description,
    Expression<String>? defaultField,
    Expression<String>? current,
    Expression<String>? mandatory,
    Expression<String>? secure,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (keyName != null) 'key_name': keyName,
      if (description != null) 'description': description,
      if (defaultField != null) 'default_field': defaultField,
      if (current != null) 'current': current,
      if (mandatory != null) 'mandatory': mandatory,
      if (secure != null) 'secure': secure,
    });
  }

  MobileUserSettingsCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? keyName,
      Value<String>? description,
      Value<String>? defaultField,
      Value<String>? current,
      Value<String>? mandatory,
      Value<String>? secure}) {
    return MobileUserSettingsCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      keyName: keyName ?? this.keyName,
      description: description ?? this.description,
      defaultField: defaultField ?? this.defaultField,
      current: current ?? this.current,
      mandatory: mandatory ?? this.mandatory,
      secure: secure ?? this.secure,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (keyName.present) {
      map['key_name'] = Variable<String>(keyName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (defaultField.present) {
      map['default_field'] = Variable<String>(defaultField.value);
    }
    if (current.present) {
      map['current'] = Variable<String>(current.value);
    }
    if (mandatory.present) {
      map['mandatory'] = Variable<String>(mandatory.value);
    }
    if (secure.present) {
      map['secure'] = Variable<String>(secure.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MobileUserSettingsCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('keyName: $keyName, ')
          ..write('description: $description, ')
          ..write('defaultField: $defaultField, ')
          ..write('current: $current, ')
          ..write('mandatory: $mandatory, ')
          ..write('secure: $secure')
          ..write(')'))
        .toString();
  }
}

class $MobileUserSettingsTable extends MobileUserSettings
    with TableInfo<$MobileUserSettingsTable, MobileUserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MobileUserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _keyNameMeta =
      const VerificationMeta('keyName');
  @override
  late final GeneratedColumn<String> keyName = GeneratedColumn<String>(
      'key_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _defaultFieldMeta =
      const VerificationMeta('defaultField');
  @override
  late final GeneratedColumn<String> defaultField = GeneratedColumn<String>(
      'default_field', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentMeta =
      const VerificationMeta('current');
  @override
  late final GeneratedColumn<String> current = GeneratedColumn<String>(
      'current', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mandatoryMeta =
      const VerificationMeta('mandatory');
  @override
  late final GeneratedColumn<String> mandatory = GeneratedColumn<String>(
      'mandatory', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _secureMeta = const VerificationMeta('secure');
  @override
  late final GeneratedColumn<String> secure = GeneratedColumn<String>(
      'secure', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        keyName,
        description,
        defaultField,
        current,
        mandatory,
        secure
      ];
  @override
  String get aliasedName => _alias ?? 'mobile_user_settings';
  @override
  String get actualTableName => 'mobile_user_settings';
  @override
  VerificationContext validateIntegrity(Insertable<MobileUserSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    } else if (isInserting) {
      context.missing(_lidMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    } else if (isInserting) {
      context.missing(_objectStatusMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    } else if (isInserting) {
      context.missing(_syncStatusMeta);
    }
    if (data.containsKey('key_name')) {
      context.handle(_keyNameMeta,
          keyName.isAcceptableOrUnknown(data['key_name']!, _keyNameMeta));
    } else if (isInserting) {
      context.missing(_keyNameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('default_field')) {
      context.handle(
          _defaultFieldMeta,
          defaultField.isAcceptableOrUnknown(
              data['default_field']!, _defaultFieldMeta));
    } else if (isInserting) {
      context.missing(_defaultFieldMeta);
    }
    if (data.containsKey('current')) {
      context.handle(_currentMeta,
          current.isAcceptableOrUnknown(data['current']!, _currentMeta));
    } else if (isInserting) {
      context.missing(_currentMeta);
    }
    if (data.containsKey('mandatory')) {
      context.handle(_mandatoryMeta,
          mandatory.isAcceptableOrUnknown(data['mandatory']!, _mandatoryMeta));
    } else if (isInserting) {
      context.missing(_mandatoryMeta);
    }
    if (data.containsKey('secure')) {
      context.handle(_secureMeta,
          secure.isAcceptableOrUnknown(data['secure']!, _secureMeta));
    } else if (isInserting) {
      context.missing(_secureMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  MobileUserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MobileUserSetting(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      keyName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key_name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      defaultField: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}default_field'])!,
      current: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current'])!,
      mandatory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mandatory'])!,
      secure: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}secure'])!,
    );
  }

  @override
  $MobileUserSettingsTable createAlias(String alias) {
    return $MobileUserSettingsTable(attachedDatabase, alias);
  }
}

class InfoMessageData extends DataClass implements Insertable<InfoMessageData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String type;
  final String subtype;
  final String category;
  final String message;
  final String bename;
  final String belid;
  final Uint8List messagedetails;
  const InfoMessageData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.type,
      required this.subtype,
      required this.category,
      required this.message,
      required this.bename,
      required this.belid,
      required this.messagedetails});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['type'] = Variable<String>(type);
    map['subtype'] = Variable<String>(subtype);
    map['category'] = Variable<String>(category);
    map['message'] = Variable<String>(message);
    map['bename'] = Variable<String>(bename);
    map['belid'] = Variable<String>(belid);
    map['messagedetails'] = Variable<Uint8List>(messagedetails);
    return map;
  }

  InfoMessageCompanion toCompanion(bool nullToAbsent) {
    return InfoMessageCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      type: Value(type),
      subtype: Value(subtype),
      category: Value(category),
      message: Value(message),
      bename: Value(bename),
      belid: Value(belid),
      messagedetails: Value(messagedetails),
    );
  }

  factory InfoMessageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InfoMessageData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      type: serializer.fromJson<String>(json['type']),
      subtype: serializer.fromJson<String>(json['subtype']),
      category: serializer.fromJson<String>(json['category']),
      message: serializer.fromJson<String>(json['message']),
      bename: serializer.fromJson<String>(json['bename']),
      belid: serializer.fromJson<String>(json['belid']),
      messagedetails: serializer.fromJson<Uint8List>(json['messagedetails']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'type': serializer.toJson<String>(type),
      'subtype': serializer.toJson<String>(subtype),
      'category': serializer.toJson<String>(category),
      'message': serializer.toJson<String>(message),
      'bename': serializer.toJson<String>(bename),
      'belid': serializer.toJson<String>(belid),
      'messagedetails': serializer.toJson<Uint8List>(messagedetails),
    };
  }

  InfoMessageData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? type,
          String? subtype,
          String? category,
          String? message,
          String? bename,
          String? belid,
          Uint8List? messagedetails}) =>
      InfoMessageData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        type: type ?? this.type,
        subtype: subtype ?? this.subtype,
        category: category ?? this.category,
        message: message ?? this.message,
        bename: bename ?? this.bename,
        belid: belid ?? this.belid,
        messagedetails: messagedetails ?? this.messagedetails,
      );
  @override
  String toString() {
    return (StringBuffer('InfoMessageData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('type: $type, ')
          ..write('subtype: $subtype, ')
          ..write('category: $category, ')
          ..write('message: $message, ')
          ..write('bename: $bename, ')
          ..write('belid: $belid, ')
          ..write('messagedetails: $messagedetails')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid,
      timestamp,
      objectStatus,
      syncStatus,
      type,
      subtype,
      category,
      message,
      bename,
      belid,
      $driftBlobEquality.hash(messagedetails));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InfoMessageData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.type == this.type &&
          other.subtype == this.subtype &&
          other.category == this.category &&
          other.message == this.message &&
          other.bename == this.bename &&
          other.belid == this.belid &&
          $driftBlobEquality.equals(other.messagedetails, this.messagedetails));
}

class InfoMessageCompanion extends UpdateCompanion<InfoMessageData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> type;
  final Value<String> subtype;
  final Value<String> category;
  final Value<String> message;
  final Value<String> bename;
  final Value<String> belid;
  final Value<Uint8List> messagedetails;
  const InfoMessageCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.type = const Value.absent(),
    this.subtype = const Value.absent(),
    this.category = const Value.absent(),
    this.message = const Value.absent(),
    this.bename = const Value.absent(),
    this.belid = const Value.absent(),
    this.messagedetails = const Value.absent(),
  });
  InfoMessageCompanion.insert({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String type,
    required String subtype,
    required String category,
    required String message,
    required String bename,
    required String belid,
    required Uint8List messagedetails,
  })  : type = Value(type),
        subtype = Value(subtype),
        category = Value(category),
        message = Value(message),
        bename = Value(bename),
        belid = Value(belid),
        messagedetails = Value(messagedetails);
  static Insertable<InfoMessageData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? type,
    Expression<String>? subtype,
    Expression<String>? category,
    Expression<String>? message,
    Expression<String>? bename,
    Expression<String>? belid,
    Expression<Uint8List>? messagedetails,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (type != null) 'type': type,
      if (subtype != null) 'subtype': subtype,
      if (category != null) 'category': category,
      if (message != null) 'message': message,
      if (bename != null) 'bename': bename,
      if (belid != null) 'belid': belid,
      if (messagedetails != null) 'messagedetails': messagedetails,
    });
  }

  InfoMessageCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? type,
      Value<String>? subtype,
      Value<String>? category,
      Value<String>? message,
      Value<String>? bename,
      Value<String>? belid,
      Value<Uint8List>? messagedetails}) {
    return InfoMessageCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      type: type ?? this.type,
      subtype: subtype ?? this.subtype,
      category: category ?? this.category,
      message: message ?? this.message,
      bename: bename ?? this.bename,
      belid: belid ?? this.belid,
      messagedetails: messagedetails ?? this.messagedetails,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (subtype.present) {
      map['subtype'] = Variable<String>(subtype.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (bename.present) {
      map['bename'] = Variable<String>(bename.value);
    }
    if (belid.present) {
      map['belid'] = Variable<String>(belid.value);
    }
    if (messagedetails.present) {
      map['messagedetails'] = Variable<Uint8List>(messagedetails.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InfoMessageCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('type: $type, ')
          ..write('subtype: $subtype, ')
          ..write('category: $category, ')
          ..write('message: $message, ')
          ..write('bename: $bename, ')
          ..write('belid: $belid, ')
          ..write('messagedetails: $messagedetails')
          ..write(')'))
        .toString();
  }
}

class $InfoMessageTable extends InfoMessage
    with TableInfo<$InfoMessageTable, InfoMessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InfoMessageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant("${FrameworkHelper.getUUID()}"));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().millisecondsSinceEpoch));
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(ObjectStatus.global.index));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(SyncStatus.none.index));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subtypeMeta =
      const VerificationMeta('subtype');
  @override
  late final GeneratedColumn<String> subtype = GeneratedColumn<String>(
      'subtype', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _benameMeta = const VerificationMeta('bename');
  @override
  late final GeneratedColumn<String> bename = GeneratedColumn<String>(
      'bename', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _belidMeta = const VerificationMeta('belid');
  @override
  late final GeneratedColumn<String> belid = GeneratedColumn<String>(
      'belid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messagedetailsMeta =
      const VerificationMeta('messagedetails');
  @override
  late final GeneratedColumn<Uint8List> messagedetails =
      GeneratedColumn<Uint8List>('messagedetails', aliasedName, false,
          type: DriftSqlType.blob, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        type,
        subtype,
        category,
        message,
        bename,
        belid,
        messagedetails
      ];
  @override
  String get aliasedName => _alias ?? 'info_message';
  @override
  String get actualTableName => 'info_message';
  @override
  VerificationContext validateIntegrity(Insertable<InfoMessageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('subtype')) {
      context.handle(_subtypeMeta,
          subtype.isAcceptableOrUnknown(data['subtype']!, _subtypeMeta));
    } else if (isInserting) {
      context.missing(_subtypeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('bename')) {
      context.handle(_benameMeta,
          bename.isAcceptableOrUnknown(data['bename']!, _benameMeta));
    } else if (isInserting) {
      context.missing(_benameMeta);
    }
    if (data.containsKey('belid')) {
      context.handle(
          _belidMeta, belid.isAcceptableOrUnknown(data['belid']!, _belidMeta));
    } else if (isInserting) {
      context.missing(_belidMeta);
    }
    if (data.containsKey('messagedetails')) {
      context.handle(
          _messagedetailsMeta,
          messagedetails.isAcceptableOrUnknown(
              data['messagedetails']!, _messagedetailsMeta));
    } else if (isInserting) {
      context.missing(_messagedetailsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  InfoMessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InfoMessageData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      subtype: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subtype'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      bename: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bename'])!,
      belid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}belid'])!,
      messagedetails: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}messagedetails'])!,
    );
  }

  @override
  $InfoMessageTable createAlias(String alias) {
    return $InfoMessageTable(attachedDatabase, alias);
  }
}

class OutObjectData extends DataClass implements Insertable<OutObjectData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String functionName;
  final String beName;
  final String beHeaderLid;
  final String requestType;
  final String syncType;
  final String conversationId;
  final String messageJson;
  final String companyNameSpace;
  final String sendStatus;
  final String fieldOutObjectStatus;
  final bool isAdminServices;
  const OutObjectData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.functionName,
      required this.beName,
      required this.beHeaderLid,
      required this.requestType,
      required this.syncType,
      required this.conversationId,
      required this.messageJson,
      required this.companyNameSpace,
      required this.sendStatus,
      required this.fieldOutObjectStatus,
      required this.isAdminServices});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['function_name'] = Variable<String>(functionName);
    map['be_name'] = Variable<String>(beName);
    map['be_header_lid'] = Variable<String>(beHeaderLid);
    map['request_type'] = Variable<String>(requestType);
    map['sync_type'] = Variable<String>(syncType);
    map['conversation_id'] = Variable<String>(conversationId);
    map['message_json'] = Variable<String>(messageJson);
    map['company_name_space'] = Variable<String>(companyNameSpace);
    map['send_status'] = Variable<String>(sendStatus);
    map['field_out_object_status'] = Variable<String>(fieldOutObjectStatus);
    map['is_admin_services'] = Variable<bool>(isAdminServices);
    return map;
  }

  OutObjectCompanion toCompanion(bool nullToAbsent) {
    return OutObjectCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      functionName: Value(functionName),
      beName: Value(beName),
      beHeaderLid: Value(beHeaderLid),
      requestType: Value(requestType),
      syncType: Value(syncType),
      conversationId: Value(conversationId),
      messageJson: Value(messageJson),
      companyNameSpace: Value(companyNameSpace),
      sendStatus: Value(sendStatus),
      fieldOutObjectStatus: Value(fieldOutObjectStatus),
      isAdminServices: Value(isAdminServices),
    );
  }

  factory OutObjectData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutObjectData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      functionName: serializer.fromJson<String>(json['functionName']),
      beName: serializer.fromJson<String>(json['beName']),
      beHeaderLid: serializer.fromJson<String>(json['beHeaderLid']),
      requestType: serializer.fromJson<String>(json['requestType']),
      syncType: serializer.fromJson<String>(json['syncType']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      messageJson: serializer.fromJson<String>(json['messageJson']),
      companyNameSpace: serializer.fromJson<String>(json['companyNameSpace']),
      sendStatus: serializer.fromJson<String>(json['sendStatus']),
      fieldOutObjectStatus:
          serializer.fromJson<String>(json['fieldOutObjectStatus']),
      isAdminServices: serializer.fromJson<bool>(json['isAdminServices']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'functionName': serializer.toJson<String>(functionName),
      'beName': serializer.toJson<String>(beName),
      'beHeaderLid': serializer.toJson<String>(beHeaderLid),
      'requestType': serializer.toJson<String>(requestType),
      'syncType': serializer.toJson<String>(syncType),
      'conversationId': serializer.toJson<String>(conversationId),
      'messageJson': serializer.toJson<String>(messageJson),
      'companyNameSpace': serializer.toJson<String>(companyNameSpace),
      'sendStatus': serializer.toJson<String>(sendStatus),
      'fieldOutObjectStatus': serializer.toJson<String>(fieldOutObjectStatus),
      'isAdminServices': serializer.toJson<bool>(isAdminServices),
    };
  }

  OutObjectData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? functionName,
          String? beName,
          String? beHeaderLid,
          String? requestType,
          String? syncType,
          String? conversationId,
          String? messageJson,
          String? companyNameSpace,
          String? sendStatus,
          String? fieldOutObjectStatus,
          bool? isAdminServices}) =>
      OutObjectData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        functionName: functionName ?? this.functionName,
        beName: beName ?? this.beName,
        beHeaderLid: beHeaderLid ?? this.beHeaderLid,
        requestType: requestType ?? this.requestType,
        syncType: syncType ?? this.syncType,
        conversationId: conversationId ?? this.conversationId,
        messageJson: messageJson ?? this.messageJson,
        companyNameSpace: companyNameSpace ?? this.companyNameSpace,
        sendStatus: sendStatus ?? this.sendStatus,
        fieldOutObjectStatus: fieldOutObjectStatus ?? this.fieldOutObjectStatus,
        isAdminServices: isAdminServices ?? this.isAdminServices,
      );
  @override
  String toString() {
    return (StringBuffer('OutObjectData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('functionName: $functionName, ')
          ..write('beName: $beName, ')
          ..write('beHeaderLid: $beHeaderLid, ')
          ..write('requestType: $requestType, ')
          ..write('syncType: $syncType, ')
          ..write('conversationId: $conversationId, ')
          ..write('messageJson: $messageJson, ')
          ..write('companyNameSpace: $companyNameSpace, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('fieldOutObjectStatus: $fieldOutObjectStatus, ')
          ..write('isAdminServices: $isAdminServices')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid,
      timestamp,
      objectStatus,
      syncStatus,
      functionName,
      beName,
      beHeaderLid,
      requestType,
      syncType,
      conversationId,
      messageJson,
      companyNameSpace,
      sendStatus,
      fieldOutObjectStatus,
      isAdminServices);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutObjectData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.functionName == this.functionName &&
          other.beName == this.beName &&
          other.beHeaderLid == this.beHeaderLid &&
          other.requestType == this.requestType &&
          other.syncType == this.syncType &&
          other.conversationId == this.conversationId &&
          other.messageJson == this.messageJson &&
          other.companyNameSpace == this.companyNameSpace &&
          other.sendStatus == this.sendStatus &&
          other.fieldOutObjectStatus == this.fieldOutObjectStatus &&
          other.isAdminServices == this.isAdminServices);
}

class OutObjectCompanion extends UpdateCompanion<OutObjectData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> functionName;
  final Value<String> beName;
  final Value<String> beHeaderLid;
  final Value<String> requestType;
  final Value<String> syncType;
  final Value<String> conversationId;
  final Value<String> messageJson;
  final Value<String> companyNameSpace;
  final Value<String> sendStatus;
  final Value<String> fieldOutObjectStatus;
  final Value<bool> isAdminServices;
  const OutObjectCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.functionName = const Value.absent(),
    this.beName = const Value.absent(),
    this.beHeaderLid = const Value.absent(),
    this.requestType = const Value.absent(),
    this.syncType = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.messageJson = const Value.absent(),
    this.companyNameSpace = const Value.absent(),
    this.sendStatus = const Value.absent(),
    this.fieldOutObjectStatus = const Value.absent(),
    this.isAdminServices = const Value.absent(),
  });
  OutObjectCompanion.insert({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String functionName,
    required String beName,
    required String beHeaderLid,
    required String requestType,
    required String syncType,
    required String conversationId,
    required String messageJson,
    required String companyNameSpace,
    required String sendStatus,
    required String fieldOutObjectStatus,
    required bool isAdminServices,
  })  : functionName = Value(functionName),
        beName = Value(beName),
        beHeaderLid = Value(beHeaderLid),
        requestType = Value(requestType),
        syncType = Value(syncType),
        conversationId = Value(conversationId),
        messageJson = Value(messageJson),
        companyNameSpace = Value(companyNameSpace),
        sendStatus = Value(sendStatus),
        fieldOutObjectStatus = Value(fieldOutObjectStatus),
        isAdminServices = Value(isAdminServices);
  static Insertable<OutObjectData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? functionName,
    Expression<String>? beName,
    Expression<String>? beHeaderLid,
    Expression<String>? requestType,
    Expression<String>? syncType,
    Expression<String>? conversationId,
    Expression<String>? messageJson,
    Expression<String>? companyNameSpace,
    Expression<String>? sendStatus,
    Expression<String>? fieldOutObjectStatus,
    Expression<bool>? isAdminServices,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (functionName != null) 'function_name': functionName,
      if (beName != null) 'be_name': beName,
      if (beHeaderLid != null) 'be_header_lid': beHeaderLid,
      if (requestType != null) 'request_type': requestType,
      if (syncType != null) 'sync_type': syncType,
      if (conversationId != null) 'conversation_id': conversationId,
      if (messageJson != null) 'message_json': messageJson,
      if (companyNameSpace != null) 'company_name_space': companyNameSpace,
      if (sendStatus != null) 'send_status': sendStatus,
      if (fieldOutObjectStatus != null)
        'field_out_object_status': fieldOutObjectStatus,
      if (isAdminServices != null) 'is_admin_services': isAdminServices,
    });
  }

  OutObjectCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? functionName,
      Value<String>? beName,
      Value<String>? beHeaderLid,
      Value<String>? requestType,
      Value<String>? syncType,
      Value<String>? conversationId,
      Value<String>? messageJson,
      Value<String>? companyNameSpace,
      Value<String>? sendStatus,
      Value<String>? fieldOutObjectStatus,
      Value<bool>? isAdminServices}) {
    return OutObjectCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      functionName: functionName ?? this.functionName,
      beName: beName ?? this.beName,
      beHeaderLid: beHeaderLid ?? this.beHeaderLid,
      requestType: requestType ?? this.requestType,
      syncType: syncType ?? this.syncType,
      conversationId: conversationId ?? this.conversationId,
      messageJson: messageJson ?? this.messageJson,
      companyNameSpace: companyNameSpace ?? this.companyNameSpace,
      sendStatus: sendStatus ?? this.sendStatus,
      fieldOutObjectStatus: fieldOutObjectStatus ?? this.fieldOutObjectStatus,
      isAdminServices: isAdminServices ?? this.isAdminServices,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (functionName.present) {
      map['function_name'] = Variable<String>(functionName.value);
    }
    if (beName.present) {
      map['be_name'] = Variable<String>(beName.value);
    }
    if (beHeaderLid.present) {
      map['be_header_lid'] = Variable<String>(beHeaderLid.value);
    }
    if (requestType.present) {
      map['request_type'] = Variable<String>(requestType.value);
    }
    if (syncType.present) {
      map['sync_type'] = Variable<String>(syncType.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (messageJson.present) {
      map['message_json'] = Variable<String>(messageJson.value);
    }
    if (companyNameSpace.present) {
      map['company_name_space'] = Variable<String>(companyNameSpace.value);
    }
    if (sendStatus.present) {
      map['send_status'] = Variable<String>(sendStatus.value);
    }
    if (fieldOutObjectStatus.present) {
      map['field_out_object_status'] =
          Variable<String>(fieldOutObjectStatus.value);
    }
    if (isAdminServices.present) {
      map['is_admin_services'] = Variable<bool>(isAdminServices.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutObjectCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('functionName: $functionName, ')
          ..write('beName: $beName, ')
          ..write('beHeaderLid: $beHeaderLid, ')
          ..write('requestType: $requestType, ')
          ..write('syncType: $syncType, ')
          ..write('conversationId: $conversationId, ')
          ..write('messageJson: $messageJson, ')
          ..write('companyNameSpace: $companyNameSpace, ')
          ..write('sendStatus: $sendStatus, ')
          ..write('fieldOutObjectStatus: $fieldOutObjectStatus, ')
          ..write('isAdminServices: $isAdminServices')
          ..write(')'))
        .toString();
  }
}

class $OutObjectTable extends OutObject
    with TableInfo<$OutObjectTable, OutObjectData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutObjectTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => "${FrameworkHelper.getUUID()}");
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecondsSinceEpoch);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => ObjectStatus.global.index);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => SyncStatus.none.index);
  static const VerificationMeta _functionNameMeta =
      const VerificationMeta('functionName');
  @override
  late final GeneratedColumn<String> functionName = GeneratedColumn<String>(
      'function_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beNameMeta = const VerificationMeta('beName');
  @override
  late final GeneratedColumn<String> beName = GeneratedColumn<String>(
      'be_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beHeaderLidMeta =
      const VerificationMeta('beHeaderLid');
  @override
  late final GeneratedColumn<String> beHeaderLid = GeneratedColumn<String>(
      'be_header_lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requestTypeMeta =
      const VerificationMeta('requestType');
  @override
  late final GeneratedColumn<String> requestType = GeneratedColumn<String>(
      'request_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncTypeMeta =
      const VerificationMeta('syncType');
  @override
  late final GeneratedColumn<String> syncType = GeneratedColumn<String>(
      'sync_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageJsonMeta =
      const VerificationMeta('messageJson');
  @override
  late final GeneratedColumn<String> messageJson = GeneratedColumn<String>(
      'message_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _companyNameSpaceMeta =
      const VerificationMeta('companyNameSpace');
  @override
  late final GeneratedColumn<String> companyNameSpace = GeneratedColumn<String>(
      'company_name_space', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sendStatusMeta =
      const VerificationMeta('sendStatus');
  @override
  late final GeneratedColumn<String> sendStatus = GeneratedColumn<String>(
      'send_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fieldOutObjectStatusMeta =
      const VerificationMeta('fieldOutObjectStatus');
  @override
  late final GeneratedColumn<String> fieldOutObjectStatus =
      GeneratedColumn<String>('field_out_object_status', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isAdminServicesMeta =
      const VerificationMeta('isAdminServices');
  @override
  late final GeneratedColumn<bool> isAdminServices =
      GeneratedColumn<bool>('is_admin_services', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_admin_services" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        functionName,
        beName,
        beHeaderLid,
        requestType,
        syncType,
        conversationId,
        messageJson,
        companyNameSpace,
        sendStatus,
        fieldOutObjectStatus,
        isAdminServices
      ];
  @override
  String get aliasedName => _alias ?? 'out_object';
  @override
  String get actualTableName => 'out_object';
  @override
  VerificationContext validateIntegrity(Insertable<OutObjectData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('function_name')) {
      context.handle(
          _functionNameMeta,
          functionName.isAcceptableOrUnknown(
              data['function_name']!, _functionNameMeta));
    } else if (isInserting) {
      context.missing(_functionNameMeta);
    }
    if (data.containsKey('be_name')) {
      context.handle(_beNameMeta,
          beName.isAcceptableOrUnknown(data['be_name']!, _beNameMeta));
    } else if (isInserting) {
      context.missing(_beNameMeta);
    }
    if (data.containsKey('be_header_lid')) {
      context.handle(
          _beHeaderLidMeta,
          beHeaderLid.isAcceptableOrUnknown(
              data['be_header_lid']!, _beHeaderLidMeta));
    } else if (isInserting) {
      context.missing(_beHeaderLidMeta);
    }
    if (data.containsKey('request_type')) {
      context.handle(
          _requestTypeMeta,
          requestType.isAcceptableOrUnknown(
              data['request_type']!, _requestTypeMeta));
    } else if (isInserting) {
      context.missing(_requestTypeMeta);
    }
    if (data.containsKey('sync_type')) {
      context.handle(_syncTypeMeta,
          syncType.isAcceptableOrUnknown(data['sync_type']!, _syncTypeMeta));
    } else if (isInserting) {
      context.missing(_syncTypeMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('message_json')) {
      context.handle(
          _messageJsonMeta,
          messageJson.isAcceptableOrUnknown(
              data['message_json']!, _messageJsonMeta));
    } else if (isInserting) {
      context.missing(_messageJsonMeta);
    }
    if (data.containsKey('company_name_space')) {
      context.handle(
          _companyNameSpaceMeta,
          companyNameSpace.isAcceptableOrUnknown(
              data['company_name_space']!, _companyNameSpaceMeta));
    } else if (isInserting) {
      context.missing(_companyNameSpaceMeta);
    }
    if (data.containsKey('send_status')) {
      context.handle(
          _sendStatusMeta,
          sendStatus.isAcceptableOrUnknown(
              data['send_status']!, _sendStatusMeta));
    } else if (isInserting) {
      context.missing(_sendStatusMeta);
    }
    if (data.containsKey('field_out_object_status')) {
      context.handle(
          _fieldOutObjectStatusMeta,
          fieldOutObjectStatus.isAcceptableOrUnknown(
              data['field_out_object_status']!, _fieldOutObjectStatusMeta));
    } else if (isInserting) {
      context.missing(_fieldOutObjectStatusMeta);
    }
    if (data.containsKey('is_admin_services')) {
      context.handle(
          _isAdminServicesMeta,
          isAdminServices.isAcceptableOrUnknown(
              data['is_admin_services']!, _isAdminServicesMeta));
    } else if (isInserting) {
      context.missing(_isAdminServicesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  OutObjectData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutObjectData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      functionName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}function_name'])!,
      beName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_name'])!,
      beHeaderLid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_header_lid'])!,
      requestType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}request_type'])!,
      syncType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sync_type'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      messageJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_json'])!,
      companyNameSpace: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}company_name_space'])!,
      sendStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}send_status'])!,
      fieldOutObjectStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_out_object_status'])!,
      isAdminServices: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_admin_services'])!,
    );
  }

  @override
  $OutObjectTable createAlias(String alias) {
    return $OutObjectTable(attachedDatabase, alias);
  }
}

class ConflictBEData extends DataClass implements Insertable<ConflictBEData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String beName;
  final String beHeaderLid;
  final String data;
  const ConflictBEData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.beName,
      required this.beHeaderLid,
      required this.data});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['be_name'] = Variable<String>(beName);
    map['be_header_lid'] = Variable<String>(beHeaderLid);
    map['data'] = Variable<String>(data);
    return map;
  }

  ConflictBECompanion toCompanion(bool nullToAbsent) {
    return ConflictBECompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      beName: Value(beName),
      beHeaderLid: Value(beHeaderLid),
      data: Value(data),
    );
  }

  factory ConflictBEData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConflictBEData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      beName: serializer.fromJson<String>(json['beName']),
      beHeaderLid: serializer.fromJson<String>(json['beHeaderLid']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'beName': serializer.toJson<String>(beName),
      'beHeaderLid': serializer.toJson<String>(beHeaderLid),
      'data': serializer.toJson<String>(data),
    };
  }

  ConflictBEData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? beName,
          String? beHeaderLid,
          String? data}) =>
      ConflictBEData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        beName: beName ?? this.beName,
        beHeaderLid: beHeaderLid ?? this.beHeaderLid,
        data: data ?? this.data,
      );
  @override
  String toString() {
    return (StringBuffer('ConflictBEData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('beName: $beName, ')
          ..write('beHeaderLid: $beHeaderLid, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid, timestamp, objectStatus, syncStatus, beName, beHeaderLid, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConflictBEData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.beName == this.beName &&
          other.beHeaderLid == this.beHeaderLid &&
          other.data == this.data);
}

class ConflictBECompanion extends UpdateCompanion<ConflictBEData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> beName;
  final Value<String> beHeaderLid;
  final Value<String> data;
  const ConflictBECompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.beName = const Value.absent(),
    this.beHeaderLid = const Value.absent(),
    this.data = const Value.absent(),
  });
  ConflictBECompanion.insert({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String beName,
    required String beHeaderLid,
    required String data,
  })  : beName = Value(beName),
        beHeaderLid = Value(beHeaderLid),
        data = Value(data);
  static Insertable<ConflictBEData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? beName,
    Expression<String>? beHeaderLid,
    Expression<String>? data,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (beName != null) 'be_name': beName,
      if (beHeaderLid != null) 'be_header_lid': beHeaderLid,
      if (data != null) 'data': data,
    });
  }

  ConflictBECompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? beName,
      Value<String>? beHeaderLid,
      Value<String>? data}) {
    return ConflictBECompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      beName: beName ?? this.beName,
      beHeaderLid: beHeaderLid ?? this.beHeaderLid,
      data: data ?? this.data,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (beName.present) {
      map['be_name'] = Variable<String>(beName.value);
    }
    if (beHeaderLid.present) {
      map['be_header_lid'] = Variable<String>(beHeaderLid.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConflictBECompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('beName: $beName, ')
          ..write('beHeaderLid: $beHeaderLid, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }
}

class $ConflictBETable extends ConflictBE
    with TableInfo<$ConflictBETable, ConflictBEData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConflictBETable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant("${FrameworkHelper.getUUID()}"));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().millisecondsSinceEpoch));
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(ObjectStatus.global.index));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(SyncStatus.none.index));
  static const VerificationMeta _beNameMeta = const VerificationMeta('beName');
  @override
  late final GeneratedColumn<String> beName = GeneratedColumn<String>(
      'be_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beHeaderLidMeta =
      const VerificationMeta('beHeaderLid');
  @override
  late final GeneratedColumn<String> beHeaderLid = GeneratedColumn<String>(
      'be_header_lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [lid, timestamp, objectStatus, syncStatus, beName, beHeaderLid, data];
  @override
  String get aliasedName => _alias ?? 'conflict_b_e';
  @override
  String get actualTableName => 'conflict_b_e';
  @override
  VerificationContext validateIntegrity(Insertable<ConflictBEData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('be_name')) {
      context.handle(_beNameMeta,
          beName.isAcceptableOrUnknown(data['be_name']!, _beNameMeta));
    } else if (isInserting) {
      context.missing(_beNameMeta);
    }
    if (data.containsKey('be_header_lid')) {
      context.handle(
          _beHeaderLidMeta,
          beHeaderLid.isAcceptableOrUnknown(
              data['be_header_lid']!, _beHeaderLidMeta));
    } else if (isInserting) {
      context.missing(_beHeaderLidMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  ConflictBEData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConflictBEData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      beName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_name'])!,
      beHeaderLid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_header_lid'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
    );
  }

  @override
  $ConflictBETable createAlias(String alias) {
    return $ConflictBETable(attachedDatabase, alias);
  }
}

class InObjectData extends DataClass implements Insertable<InObjectData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String conversationId;
  final int subtype;
  final int type;
  final String appId;
  final String serverId;
  final String appName;
  final String requestType;
  final String jsonData;
  final String beLid;
  const InObjectData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.conversationId,
      required this.subtype,
      required this.type,
      required this.appId,
      required this.serverId,
      required this.appName,
      required this.requestType,
      required this.jsonData,
      required this.beLid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['conversation_id'] = Variable<String>(conversationId);
    map['subtype'] = Variable<int>(subtype);
    map['type'] = Variable<int>(type);
    map['app_id'] = Variable<String>(appId);
    map['server_id'] = Variable<String>(serverId);
    map['app_name'] = Variable<String>(appName);
    map['request_type'] = Variable<String>(requestType);
    map['json_data'] = Variable<String>(jsonData);
    map['be_lid'] = Variable<String>(beLid);
    return map;
  }

  InObjectCompanion toCompanion(bool nullToAbsent) {
    return InObjectCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      conversationId: Value(conversationId),
      subtype: Value(subtype),
      type: Value(type),
      appId: Value(appId),
      serverId: Value(serverId),
      appName: Value(appName),
      requestType: Value(requestType),
      jsonData: Value(jsonData),
      beLid: Value(beLid),
    );
  }

  factory InObjectData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InObjectData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      subtype: serializer.fromJson<int>(json['subtype']),
      type: serializer.fromJson<int>(json['type']),
      appId: serializer.fromJson<String>(json['appId']),
      serverId: serializer.fromJson<String>(json['serverId']),
      appName: serializer.fromJson<String>(json['appName']),
      requestType: serializer.fromJson<String>(json['requestType']),
      jsonData: serializer.fromJson<String>(json['jsonData']),
      beLid: serializer.fromJson<String>(json['beLid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'conversationId': serializer.toJson<String>(conversationId),
      'subtype': serializer.toJson<int>(subtype),
      'type': serializer.toJson<int>(type),
      'appId': serializer.toJson<String>(appId),
      'serverId': serializer.toJson<String>(serverId),
      'appName': serializer.toJson<String>(appName),
      'requestType': serializer.toJson<String>(requestType),
      'jsonData': serializer.toJson<String>(jsonData),
      'beLid': serializer.toJson<String>(beLid),
    };
  }

  InObjectData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? conversationId,
          int? subtype,
          int? type,
          String? appId,
          String? serverId,
          String? appName,
          String? requestType,
          String? jsonData,
          String? beLid}) =>
      InObjectData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        conversationId: conversationId ?? this.conversationId,
        subtype: subtype ?? this.subtype,
        type: type ?? this.type,
        appId: appId ?? this.appId,
        serverId: serverId ?? this.serverId,
        appName: appName ?? this.appName,
        requestType: requestType ?? this.requestType,
        jsonData: jsonData ?? this.jsonData,
        beLid: beLid ?? this.beLid,
      );
  @override
  String toString() {
    return (StringBuffer('InObjectData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('conversationId: $conversationId, ')
          ..write('subtype: $subtype, ')
          ..write('type: $type, ')
          ..write('appId: $appId, ')
          ..write('serverId: $serverId, ')
          ..write('appName: $appName, ')
          ..write('requestType: $requestType, ')
          ..write('jsonData: $jsonData, ')
          ..write('beLid: $beLid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      lid,
      timestamp,
      objectStatus,
      syncStatus,
      conversationId,
      subtype,
      type,
      appId,
      serverId,
      appName,
      requestType,
      jsonData,
      beLid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InObjectData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.conversationId == this.conversationId &&
          other.subtype == this.subtype &&
          other.type == this.type &&
          other.appId == this.appId &&
          other.serverId == this.serverId &&
          other.appName == this.appName &&
          other.requestType == this.requestType &&
          other.jsonData == this.jsonData &&
          other.beLid == this.beLid);
}

class InObjectCompanion extends UpdateCompanion<InObjectData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> conversationId;
  final Value<int> subtype;
  final Value<int> type;
  final Value<String> appId;
  final Value<String> serverId;
  final Value<String> appName;
  final Value<String> requestType;
  final Value<String> jsonData;
  final Value<String> beLid;
  const InObjectCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.subtype = const Value.absent(),
    this.type = const Value.absent(),
    this.appId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.appName = const Value.absent(),
    this.requestType = const Value.absent(),
    this.jsonData = const Value.absent(),
    this.beLid = const Value.absent(),
  });
  InObjectCompanion.insert({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String conversationId,
    required int subtype,
    required int type,
    required String appId,
    required String serverId,
    required String appName,
    required String requestType,
    required String jsonData,
    required String beLid,
  })  : conversationId = Value(conversationId),
        subtype = Value(subtype),
        type = Value(type),
        appId = Value(appId),
        serverId = Value(serverId),
        appName = Value(appName),
        requestType = Value(requestType),
        jsonData = Value(jsonData),
        beLid = Value(beLid);
  static Insertable<InObjectData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? conversationId,
    Expression<int>? subtype,
    Expression<int>? type,
    Expression<String>? appId,
    Expression<String>? serverId,
    Expression<String>? appName,
    Expression<String>? requestType,
    Expression<String>? jsonData,
    Expression<String>? beLid,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (conversationId != null) 'conversation_id': conversationId,
      if (subtype != null) 'subtype': subtype,
      if (type != null) 'type': type,
      if (appId != null) 'app_id': appId,
      if (serverId != null) 'server_id': serverId,
      if (appName != null) 'app_name': appName,
      if (requestType != null) 'request_type': requestType,
      if (jsonData != null) 'json_data': jsonData,
      if (beLid != null) 'be_lid': beLid,
    });
  }

  InObjectCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? conversationId,
      Value<int>? subtype,
      Value<int>? type,
      Value<String>? appId,
      Value<String>? serverId,
      Value<String>? appName,
      Value<String>? requestType,
      Value<String>? jsonData,
      Value<String>? beLid}) {
    return InObjectCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      conversationId: conversationId ?? this.conversationId,
      subtype: subtype ?? this.subtype,
      type: type ?? this.type,
      appId: appId ?? this.appId,
      serverId: serverId ?? this.serverId,
      appName: appName ?? this.appName,
      requestType: requestType ?? this.requestType,
      jsonData: jsonData ?? this.jsonData,
      beLid: beLid ?? this.beLid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (subtype.present) {
      map['subtype'] = Variable<int>(subtype.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (appId.present) {
      map['app_id'] = Variable<String>(appId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (appName.present) {
      map['app_name'] = Variable<String>(appName.value);
    }
    if (requestType.present) {
      map['request_type'] = Variable<String>(requestType.value);
    }
    if (jsonData.present) {
      map['json_data'] = Variable<String>(jsonData.value);
    }
    if (beLid.present) {
      map['be_lid'] = Variable<String>(beLid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InObjectCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('conversationId: $conversationId, ')
          ..write('subtype: $subtype, ')
          ..write('type: $type, ')
          ..write('appId: $appId, ')
          ..write('serverId: $serverId, ')
          ..write('appName: $appName, ')
          ..write('requestType: $requestType, ')
          ..write('jsonData: $jsonData, ')
          ..write('beLid: $beLid')
          ..write(')'))
        .toString();
  }
}

class $InObjectTable extends InObject
    with TableInfo<$InObjectTable, InObjectData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InObjectTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant("${FrameworkHelper.getUUID()}"));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().millisecondsSinceEpoch));
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(ObjectStatus.global.index));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(SyncStatus.none.index));
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subtypeMeta =
      const VerificationMeta('subtype');
  @override
  late final GeneratedColumn<int> subtype = GeneratedColumn<int>(
      'subtype', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
      'type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _appIdMeta = const VerificationMeta('appId');
  @override
  late final GeneratedColumn<String> appId = GeneratedColumn<String>(
      'app_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _appNameMeta =
      const VerificationMeta('appName');
  @override
  late final GeneratedColumn<String> appName = GeneratedColumn<String>(
      'app_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _requestTypeMeta =
      const VerificationMeta('requestType');
  @override
  late final GeneratedColumn<String> requestType = GeneratedColumn<String>(
      'request_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _jsonDataMeta =
      const VerificationMeta('jsonData');
  @override
  late final GeneratedColumn<String> jsonData = GeneratedColumn<String>(
      'json_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beLidMeta = const VerificationMeta('beLid');
  @override
  late final GeneratedColumn<String> beLid = GeneratedColumn<String>(
      'be_lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        conversationId,
        subtype,
        type,
        appId,
        serverId,
        appName,
        requestType,
        jsonData,
        beLid
      ];
  @override
  String get aliasedName => _alias ?? 'in_object';
  @override
  String get actualTableName => 'in_object';
  @override
  VerificationContext validateIntegrity(Insertable<InObjectData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('subtype')) {
      context.handle(_subtypeMeta,
          subtype.isAcceptableOrUnknown(data['subtype']!, _subtypeMeta));
    } else if (isInserting) {
      context.missing(_subtypeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('app_id')) {
      context.handle(
          _appIdMeta, appId.isAcceptableOrUnknown(data['app_id']!, _appIdMeta));
    } else if (isInserting) {
      context.missing(_appIdMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('app_name')) {
      context.handle(_appNameMeta,
          appName.isAcceptableOrUnknown(data['app_name']!, _appNameMeta));
    } else if (isInserting) {
      context.missing(_appNameMeta);
    }
    if (data.containsKey('request_type')) {
      context.handle(
          _requestTypeMeta,
          requestType.isAcceptableOrUnknown(
              data['request_type']!, _requestTypeMeta));
    } else if (isInserting) {
      context.missing(_requestTypeMeta);
    }
    if (data.containsKey('json_data')) {
      context.handle(_jsonDataMeta,
          jsonData.isAcceptableOrUnknown(data['json_data']!, _jsonDataMeta));
    } else if (isInserting) {
      context.missing(_jsonDataMeta);
    }
    if (data.containsKey('be_lid')) {
      context.handle(
          _beLidMeta, beLid.isAcceptableOrUnknown(data['be_lid']!, _beLidMeta));
    } else if (isInserting) {
      context.missing(_beLidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid, conversationId};
  @override
  InObjectData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InObjectData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      subtype: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}subtype'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!,
      appId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id'])!,
      appName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}app_name'])!,
      requestType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}request_type'])!,
      jsonData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_data'])!,
      beLid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_lid'])!,
    );
  }

  @override
  $InObjectTable createAlias(String alias) {
    return $InObjectTable(attachedDatabase, alias);
  }
}

class SentItem extends DataClass implements Insertable<SentItem> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String beName;
  final String beHeaderLid;
  final String conversationId;
  final String entryDate;
  final String attachmentFlag;
  const SentItem(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.beName,
      required this.beHeaderLid,
      required this.conversationId,
      required this.entryDate,
      required this.attachmentFlag});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['be_name'] = Variable<String>(beName);
    map['be_header_lid'] = Variable<String>(beHeaderLid);
    map['conversation_id'] = Variable<String>(conversationId);
    map['entry_date'] = Variable<String>(entryDate);
    map['attachment_flag'] = Variable<String>(attachmentFlag);
    return map;
  }

  SentItemsCompanion toCompanion(bool nullToAbsent) {
    return SentItemsCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      beName: Value(beName),
      beHeaderLid: Value(beHeaderLid),
      conversationId: Value(conversationId),
      entryDate: Value(entryDate),
      attachmentFlag: Value(attachmentFlag),
    );
  }

  factory SentItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SentItem(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      beName: serializer.fromJson<String>(json['beName']),
      beHeaderLid: serializer.fromJson<String>(json['beHeaderLid']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      entryDate: serializer.fromJson<String>(json['entryDate']),
      attachmentFlag: serializer.fromJson<String>(json['attachmentFlag']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'beName': serializer.toJson<String>(beName),
      'beHeaderLid': serializer.toJson<String>(beHeaderLid),
      'conversationId': serializer.toJson<String>(conversationId),
      'entryDate': serializer.toJson<String>(entryDate),
      'attachmentFlag': serializer.toJson<String>(attachmentFlag),
    };
  }

  SentItem copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? beName,
          String? beHeaderLid,
          String? conversationId,
          String? entryDate,
          String? attachmentFlag}) =>
      SentItem(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        beName: beName ?? this.beName,
        beHeaderLid: beHeaderLid ?? this.beHeaderLid,
        conversationId: conversationId ?? this.conversationId,
        entryDate: entryDate ?? this.entryDate,
        attachmentFlag: attachmentFlag ?? this.attachmentFlag,
      );
  @override
  String toString() {
    return (StringBuffer('SentItem(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('beName: $beName, ')
          ..write('beHeaderLid: $beHeaderLid, ')
          ..write('conversationId: $conversationId, ')
          ..write('entryDate: $entryDate, ')
          ..write('attachmentFlag: $attachmentFlag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lid, timestamp, objectStatus, syncStatus,
      beName, beHeaderLid, conversationId, entryDate, attachmentFlag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SentItem &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.beName == this.beName &&
          other.beHeaderLid == this.beHeaderLid &&
          other.conversationId == this.conversationId &&
          other.entryDate == this.entryDate &&
          other.attachmentFlag == this.attachmentFlag);
}

class SentItemsCompanion extends UpdateCompanion<SentItem> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> beName;
  final Value<String> beHeaderLid;
  final Value<String> conversationId;
  final Value<String> entryDate;
  final Value<String> attachmentFlag;
  const SentItemsCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.beName = const Value.absent(),
    this.beHeaderLid = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.attachmentFlag = const Value.absent(),
  });
  SentItemsCompanion.insert({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String beName,
    required String beHeaderLid,
    required String conversationId,
    required String entryDate,
    required String attachmentFlag,
  })  : beName = Value(beName),
        beHeaderLid = Value(beHeaderLid),
        conversationId = Value(conversationId),
        entryDate = Value(entryDate),
        attachmentFlag = Value(attachmentFlag);
  static Insertable<SentItem> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? beName,
    Expression<String>? beHeaderLid,
    Expression<String>? conversationId,
    Expression<String>? entryDate,
    Expression<String>? attachmentFlag,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (beName != null) 'be_name': beName,
      if (beHeaderLid != null) 'be_header_lid': beHeaderLid,
      if (conversationId != null) 'conversation_id': conversationId,
      if (entryDate != null) 'entry_date': entryDate,
      if (attachmentFlag != null) 'attachment_flag': attachmentFlag,
    });
  }

  SentItemsCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? beName,
      Value<String>? beHeaderLid,
      Value<String>? conversationId,
      Value<String>? entryDate,
      Value<String>? attachmentFlag}) {
    return SentItemsCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      beName: beName ?? this.beName,
      beHeaderLid: beHeaderLid ?? this.beHeaderLid,
      conversationId: conversationId ?? this.conversationId,
      entryDate: entryDate ?? this.entryDate,
      attachmentFlag: attachmentFlag ?? this.attachmentFlag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (beName.present) {
      map['be_name'] = Variable<String>(beName.value);
    }
    if (beHeaderLid.present) {
      map['be_header_lid'] = Variable<String>(beHeaderLid.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<String>(entryDate.value);
    }
    if (attachmentFlag.present) {
      map['attachment_flag'] = Variable<String>(attachmentFlag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SentItemsCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('beName: $beName, ')
          ..write('beHeaderLid: $beHeaderLid, ')
          ..write('conversationId: $conversationId, ')
          ..write('entryDate: $entryDate, ')
          ..write('attachmentFlag: $attachmentFlag')
          ..write(')'))
        .toString();
  }
}

class $SentItemsTable extends SentItems
    with TableInfo<$SentItemsTable, SentItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SentItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => "${FrameworkHelper.getUUID()}");
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecondsSinceEpoch);
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => ObjectStatus.global.index);
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      clientDefault: () => SyncStatus.none.index);
  static const VerificationMeta _beNameMeta = const VerificationMeta('beName');
  @override
  late final GeneratedColumn<String> beName = GeneratedColumn<String>(
      'be_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beHeaderLidMeta =
      const VerificationMeta('beHeaderLid');
  @override
  late final GeneratedColumn<String> beHeaderLid = GeneratedColumn<String>(
      'be_header_lid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entryDateMeta =
      const VerificationMeta('entryDate');
  @override
  late final GeneratedColumn<String> entryDate = GeneratedColumn<String>(
      'entry_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attachmentFlagMeta =
      const VerificationMeta('attachmentFlag');
  @override
  late final GeneratedColumn<String> attachmentFlag = GeneratedColumn<String>(
      'attachment_flag', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        beName,
        beHeaderLid,
        conversationId,
        entryDate,
        attachmentFlag
      ];
  @override
  String get aliasedName => _alias ?? 'sent_items';
  @override
  String get actualTableName => 'sent_items';
  @override
  VerificationContext validateIntegrity(Insertable<SentItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('be_name')) {
      context.handle(_beNameMeta,
          beName.isAcceptableOrUnknown(data['be_name']!, _beNameMeta));
    } else if (isInserting) {
      context.missing(_beNameMeta);
    }
    if (data.containsKey('be_header_lid')) {
      context.handle(
          _beHeaderLidMeta,
          beHeaderLid.isAcceptableOrUnknown(
              data['be_header_lid']!, _beHeaderLidMeta));
    } else if (isInserting) {
      context.missing(_beHeaderLidMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(_entryDateMeta,
          entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta));
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('attachment_flag')) {
      context.handle(
          _attachmentFlagMeta,
          attachmentFlag.isAcceptableOrUnknown(
              data['attachment_flag']!, _attachmentFlagMeta));
    } else if (isInserting) {
      context.missing(_attachmentFlagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  SentItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SentItem(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      beName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_name'])!,
      beHeaderLid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_header_lid'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      entryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entry_date'])!,
      attachmentFlag: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}attachment_flag'])!,
    );
  }

  @override
  $SentItemsTable createAlias(String alias) {
    return $SentItemsTable(attachedDatabase, alias);
  }
}

class AttachmentQObjectData extends DataClass
    implements Insertable<AttachmentQObjectData> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String uid;
  final String beName;
  final String beHeaderName;
  final String beAttachmentStructName;
  final int priority;
  final int timeStamp;
  const AttachmentQObjectData(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.uid,
      required this.beName,
      required this.beHeaderName,
      required this.beAttachmentStructName,
      required this.priority,
      required this.timeStamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['uid'] = Variable<String>(uid);
    map['be_name'] = Variable<String>(beName);
    map['be_header_name'] = Variable<String>(beHeaderName);
    map['be_attachment_struct_name'] = Variable<String>(beAttachmentStructName);
    map['priority'] = Variable<int>(priority);
    map['time_stamp'] = Variable<int>(timeStamp);
    return map;
  }

  AttachmentQObjectCompanion toCompanion(bool nullToAbsent) {
    return AttachmentQObjectCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      uid: Value(uid),
      beName: Value(beName),
      beHeaderName: Value(beHeaderName),
      beAttachmentStructName: Value(beAttachmentStructName),
      priority: Value(priority),
      timeStamp: Value(timeStamp),
    );
  }

  factory AttachmentQObjectData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttachmentQObjectData(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      uid: serializer.fromJson<String>(json['uid']),
      beName: serializer.fromJson<String>(json['beName']),
      beHeaderName: serializer.fromJson<String>(json['beHeaderName']),
      beAttachmentStructName:
          serializer.fromJson<String>(json['beAttachmentStructName']),
      priority: serializer.fromJson<int>(json['priority']),
      timeStamp: serializer.fromJson<int>(json['timeStamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'uid': serializer.toJson<String>(uid),
      'beName': serializer.toJson<String>(beName),
      'beHeaderName': serializer.toJson<String>(beHeaderName),
      'beAttachmentStructName':
          serializer.toJson<String>(beAttachmentStructName),
      'priority': serializer.toJson<int>(priority),
      'timeStamp': serializer.toJson<int>(timeStamp),
    };
  }

  AttachmentQObjectData copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? uid,
          String? beName,
          String? beHeaderName,
          String? beAttachmentStructName,
          int? priority,
          int? timeStamp}) =>
      AttachmentQObjectData(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        uid: uid ?? this.uid,
        beName: beName ?? this.beName,
        beHeaderName: beHeaderName ?? this.beHeaderName,
        beAttachmentStructName:
            beAttachmentStructName ?? this.beAttachmentStructName,
        priority: priority ?? this.priority,
        timeStamp: timeStamp ?? this.timeStamp,
      );
  @override
  String toString() {
    return (StringBuffer('AttachmentQObjectData(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('uid: $uid, ')
          ..write('beName: $beName, ')
          ..write('beHeaderName: $beHeaderName, ')
          ..write('beAttachmentStructName: $beAttachmentStructName, ')
          ..write('priority: $priority, ')
          ..write('timeStamp: $timeStamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lid, timestamp, objectStatus, syncStatus, uid,
      beName, beHeaderName, beAttachmentStructName, priority, timeStamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttachmentQObjectData &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.uid == this.uid &&
          other.beName == this.beName &&
          other.beHeaderName == this.beHeaderName &&
          other.beAttachmentStructName == this.beAttachmentStructName &&
          other.priority == this.priority &&
          other.timeStamp == this.timeStamp);
}

class AttachmentQObjectCompanion
    extends UpdateCompanion<AttachmentQObjectData> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> uid;
  final Value<String> beName;
  final Value<String> beHeaderName;
  final Value<String> beAttachmentStructName;
  final Value<int> priority;
  final Value<int> timeStamp;
  const AttachmentQObjectCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.uid = const Value.absent(),
    this.beName = const Value.absent(),
    this.beHeaderName = const Value.absent(),
    this.beAttachmentStructName = const Value.absent(),
    this.priority = const Value.absent(),
    this.timeStamp = const Value.absent(),
  });
  AttachmentQObjectCompanion.insert({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String uid,
    required String beName,
    required String beHeaderName,
    required String beAttachmentStructName,
    required int priority,
    required int timeStamp,
  })  : uid = Value(uid),
        beName = Value(beName),
        beHeaderName = Value(beHeaderName),
        beAttachmentStructName = Value(beAttachmentStructName),
        priority = Value(priority),
        timeStamp = Value(timeStamp);
  static Insertable<AttachmentQObjectData> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? uid,
    Expression<String>? beName,
    Expression<String>? beHeaderName,
    Expression<String>? beAttachmentStructName,
    Expression<int>? priority,
    Expression<int>? timeStamp,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (uid != null) 'uid': uid,
      if (beName != null) 'be_name': beName,
      if (beHeaderName != null) 'be_header_name': beHeaderName,
      if (beAttachmentStructName != null)
        'be_attachment_struct_name': beAttachmentStructName,
      if (priority != null) 'priority': priority,
      if (timeStamp != null) 'time_stamp': timeStamp,
    });
  }

  AttachmentQObjectCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? uid,
      Value<String>? beName,
      Value<String>? beHeaderName,
      Value<String>? beAttachmentStructName,
      Value<int>? priority,
      Value<int>? timeStamp}) {
    return AttachmentQObjectCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      uid: uid ?? this.uid,
      beName: beName ?? this.beName,
      beHeaderName: beHeaderName ?? this.beHeaderName,
      beAttachmentStructName:
          beAttachmentStructName ?? this.beAttachmentStructName,
      priority: priority ?? this.priority,
      timeStamp: timeStamp ?? this.timeStamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (beName.present) {
      map['be_name'] = Variable<String>(beName.value);
    }
    if (beHeaderName.present) {
      map['be_header_name'] = Variable<String>(beHeaderName.value);
    }
    if (beAttachmentStructName.present) {
      map['be_attachment_struct_name'] =
          Variable<String>(beAttachmentStructName.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (timeStamp.present) {
      map['time_stamp'] = Variable<int>(timeStamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttachmentQObjectCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('uid: $uid, ')
          ..write('beName: $beName, ')
          ..write('beHeaderName: $beHeaderName, ')
          ..write('beAttachmentStructName: $beAttachmentStructName, ')
          ..write('priority: $priority, ')
          ..write('timeStamp: $timeStamp')
          ..write(')'))
        .toString();
  }
}

class $AttachmentQObjectTable extends AttachmentQObject
    with TableInfo<$AttachmentQObjectTable, AttachmentQObjectData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttachmentQObjectTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant("${FrameworkHelper.getUUID()}"));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().millisecondsSinceEpoch));
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(ObjectStatus.global.index));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(SyncStatus.none.index));
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
      'uid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beNameMeta = const VerificationMeta('beName');
  @override
  late final GeneratedColumn<String> beName = GeneratedColumn<String>(
      'be_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beHeaderNameMeta =
      const VerificationMeta('beHeaderName');
  @override
  late final GeneratedColumn<String> beHeaderName = GeneratedColumn<String>(
      'be_header_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _beAttachmentStructNameMeta =
      const VerificationMeta('beAttachmentStructName');
  @override
  late final GeneratedColumn<String> beAttachmentStructName =
      GeneratedColumn<String>('be_attachment_struct_name', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _timeStampMeta =
      const VerificationMeta('timeStamp');
  @override
  late final GeneratedColumn<int> timeStamp = GeneratedColumn<int>(
      'time_stamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        uid,
        beName,
        beHeaderName,
        beAttachmentStructName,
        priority,
        timeStamp
      ];
  @override
  String get aliasedName => _alias ?? 'attachment_q_object';
  @override
  String get actualTableName => 'attachment_q_object';
  @override
  VerificationContext validateIntegrity(
      Insertable<AttachmentQObjectData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
          _uidMeta, uid.isAcceptableOrUnknown(data['uid']!, _uidMeta));
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('be_name')) {
      context.handle(_beNameMeta,
          beName.isAcceptableOrUnknown(data['be_name']!, _beNameMeta));
    } else if (isInserting) {
      context.missing(_beNameMeta);
    }
    if (data.containsKey('be_header_name')) {
      context.handle(
          _beHeaderNameMeta,
          beHeaderName.isAcceptableOrUnknown(
              data['be_header_name']!, _beHeaderNameMeta));
    } else if (isInserting) {
      context.missing(_beHeaderNameMeta);
    }
    if (data.containsKey('be_attachment_struct_name')) {
      context.handle(
          _beAttachmentStructNameMeta,
          beAttachmentStructName.isAcceptableOrUnknown(
              data['be_attachment_struct_name']!, _beAttachmentStructNameMeta));
    } else if (isInserting) {
      context.missing(_beAttachmentStructNameMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('time_stamp')) {
      context.handle(_timeStampMeta,
          timeStamp.isAcceptableOrUnknown(data['time_stamp']!, _timeStampMeta));
    } else if (isInserting) {
      context.missing(_timeStampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  AttachmentQObjectData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttachmentQObjectData(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      uid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uid'])!,
      beName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_name'])!,
      beHeaderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}be_header_name'])!,
      beAttachmentStructName: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}be_attachment_struct_name'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      timeStamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}time_stamp'])!,
    );
  }

  @override
  $AttachmentQObjectTable createAlias(String alias) {
    return $AttachmentQObjectTable(attachedDatabase, alias);
  }
}

class SystemCredential extends DataClass
    implements Insertable<SystemCredential> {
  final String lid;
  final int timestamp;
  final int objectStatus;
  final int syncStatus;
  final String name;
  final String portName;
  final String portType;
  final String portDesc;
  final String systemDesc;
  final String userId;
  final String password;
  const SystemCredential(
      {required this.lid,
      required this.timestamp,
      required this.objectStatus,
      required this.syncStatus,
      required this.name,
      required this.portName,
      required this.portType,
      required this.portDesc,
      required this.systemDesc,
      required this.userId,
      required this.password});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['lid'] = Variable<String>(lid);
    map['timestamp'] = Variable<int>(timestamp);
    map['object_status'] = Variable<int>(objectStatus);
    map['sync_status'] = Variable<int>(syncStatus);
    map['name'] = Variable<String>(name);
    map['port_name'] = Variable<String>(portName);
    map['port_type'] = Variable<String>(portType);
    map['port_desc'] = Variable<String>(portDesc);
    map['system_desc'] = Variable<String>(systemDesc);
    map['user_id'] = Variable<String>(userId);
    map['password'] = Variable<String>(password);
    return map;
  }

  SystemCredentialsCompanion toCompanion(bool nullToAbsent) {
    return SystemCredentialsCompanion(
      lid: Value(lid),
      timestamp: Value(timestamp),
      objectStatus: Value(objectStatus),
      syncStatus: Value(syncStatus),
      name: Value(name),
      portName: Value(portName),
      portType: Value(portType),
      portDesc: Value(portDesc),
      systemDesc: Value(systemDesc),
      userId: Value(userId),
      password: Value(password),
    );
  }

  factory SystemCredential.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemCredential(
      lid: serializer.fromJson<String>(json['lid']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      objectStatus: serializer.fromJson<int>(json['objectStatus']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
      name: serializer.fromJson<String>(json['name']),
      portName: serializer.fromJson<String>(json['portName']),
      portType: serializer.fromJson<String>(json['portType']),
      portDesc: serializer.fromJson<String>(json['portDesc']),
      systemDesc: serializer.fromJson<String>(json['systemDesc']),
      userId: serializer.fromJson<String>(json['userId']),
      password: serializer.fromJson<String>(json['password']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'lid': serializer.toJson<String>(lid),
      'timestamp': serializer.toJson<int>(timestamp),
      'objectStatus': serializer.toJson<int>(objectStatus),
      'syncStatus': serializer.toJson<int>(syncStatus),
      'name': serializer.toJson<String>(name),
      'portName': serializer.toJson<String>(portName),
      'portType': serializer.toJson<String>(portType),
      'portDesc': serializer.toJson<String>(portDesc),
      'systemDesc': serializer.toJson<String>(systemDesc),
      'userId': serializer.toJson<String>(userId),
      'password': serializer.toJson<String>(password),
    };
  }

  SystemCredential copyWith(
          {String? lid,
          int? timestamp,
          int? objectStatus,
          int? syncStatus,
          String? name,
          String? portName,
          String? portType,
          String? portDesc,
          String? systemDesc,
          String? userId,
          String? password}) =>
      SystemCredential(
        lid: lid ?? this.lid,
        timestamp: timestamp ?? this.timestamp,
        objectStatus: objectStatus ?? this.objectStatus,
        syncStatus: syncStatus ?? this.syncStatus,
        name: name ?? this.name,
        portName: portName ?? this.portName,
        portType: portType ?? this.portType,
        portDesc: portDesc ?? this.portDesc,
        systemDesc: systemDesc ?? this.systemDesc,
        userId: userId ?? this.userId,
        password: password ?? this.password,
      );
  @override
  String toString() {
    return (StringBuffer('SystemCredential(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('name: $name, ')
          ..write('portName: $portName, ')
          ..write('portType: $portType, ')
          ..write('portDesc: $portDesc, ')
          ..write('systemDesc: $systemDesc, ')
          ..write('userId: $userId, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(lid, timestamp, objectStatus, syncStatus,
      name, portName, portType, portDesc, systemDesc, userId, password);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemCredential &&
          other.lid == this.lid &&
          other.timestamp == this.timestamp &&
          other.objectStatus == this.objectStatus &&
          other.syncStatus == this.syncStatus &&
          other.name == this.name &&
          other.portName == this.portName &&
          other.portType == this.portType &&
          other.portDesc == this.portDesc &&
          other.systemDesc == this.systemDesc &&
          other.userId == this.userId &&
          other.password == this.password);
}

class SystemCredentialsCompanion extends UpdateCompanion<SystemCredential> {
  final Value<String> lid;
  final Value<int> timestamp;
  final Value<int> objectStatus;
  final Value<int> syncStatus;
  final Value<String> name;
  final Value<String> portName;
  final Value<String> portType;
  final Value<String> portDesc;
  final Value<String> systemDesc;
  final Value<String> userId;
  final Value<String> password;
  const SystemCredentialsCompanion({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.name = const Value.absent(),
    this.portName = const Value.absent(),
    this.portType = const Value.absent(),
    this.portDesc = const Value.absent(),
    this.systemDesc = const Value.absent(),
    this.userId = const Value.absent(),
    this.password = const Value.absent(),
  });
  SystemCredentialsCompanion.insert({
    this.lid = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.objectStatus = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String name,
    required String portName,
    required String portType,
    required String portDesc,
    required String systemDesc,
    required String userId,
    required String password,
  })  : name = Value(name),
        portName = Value(portName),
        portType = Value(portType),
        portDesc = Value(portDesc),
        systemDesc = Value(systemDesc),
        userId = Value(userId),
        password = Value(password);
  static Insertable<SystemCredential> custom({
    Expression<String>? lid,
    Expression<int>? timestamp,
    Expression<int>? objectStatus,
    Expression<int>? syncStatus,
    Expression<String>? name,
    Expression<String>? portName,
    Expression<String>? portType,
    Expression<String>? portDesc,
    Expression<String>? systemDesc,
    Expression<String>? userId,
    Expression<String>? password,
  }) {
    return RawValuesInsertable({
      if (lid != null) 'lid': lid,
      if (timestamp != null) 'timestamp': timestamp,
      if (objectStatus != null) 'object_status': objectStatus,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (name != null) 'name': name,
      if (portName != null) 'port_name': portName,
      if (portType != null) 'port_type': portType,
      if (portDesc != null) 'port_desc': portDesc,
      if (systemDesc != null) 'system_desc': systemDesc,
      if (userId != null) 'user_id': userId,
      if (password != null) 'password': password,
    });
  }

  SystemCredentialsCompanion copyWith(
      {Value<String>? lid,
      Value<int>? timestamp,
      Value<int>? objectStatus,
      Value<int>? syncStatus,
      Value<String>? name,
      Value<String>? portName,
      Value<String>? portType,
      Value<String>? portDesc,
      Value<String>? systemDesc,
      Value<String>? userId,
      Value<String>? password}) {
    return SystemCredentialsCompanion(
      lid: lid ?? this.lid,
      timestamp: timestamp ?? this.timestamp,
      objectStatus: objectStatus ?? this.objectStatus,
      syncStatus: syncStatus ?? this.syncStatus,
      name: name ?? this.name,
      portName: portName ?? this.portName,
      portType: portType ?? this.portType,
      portDesc: portDesc ?? this.portDesc,
      systemDesc: systemDesc ?? this.systemDesc,
      userId: userId ?? this.userId,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (lid.present) {
      map['lid'] = Variable<String>(lid.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (objectStatus.present) {
      map['object_status'] = Variable<int>(objectStatus.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (portName.present) {
      map['port_name'] = Variable<String>(portName.value);
    }
    if (portType.present) {
      map['port_type'] = Variable<String>(portType.value);
    }
    if (portDesc.present) {
      map['port_desc'] = Variable<String>(portDesc.value);
    }
    if (systemDesc.present) {
      map['system_desc'] = Variable<String>(systemDesc.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemCredentialsCompanion(')
          ..write('lid: $lid, ')
          ..write('timestamp: $timestamp, ')
          ..write('objectStatus: $objectStatus, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('name: $name, ')
          ..write('portName: $portName, ')
          ..write('portType: $portType, ')
          ..write('portDesc: $portDesc, ')
          ..write('systemDesc: $systemDesc, ')
          ..write('userId: $userId, ')
          ..write('password: $password')
          ..write(')'))
        .toString();
  }
}

class $SystemCredentialsTable extends SystemCredentials
    with TableInfo<$SystemCredentialsTable, SystemCredential> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemCredentialsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _lidMeta = const VerificationMeta('lid');
  @override
  late final GeneratedColumn<String> lid = GeneratedColumn<String>(
      'lid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: Constant("${FrameworkHelper.getUUID()}"));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now().millisecondsSinceEpoch));
  static const VerificationMeta _objectStatusMeta =
      const VerificationMeta('objectStatus');
  @override
  late final GeneratedColumn<int> objectStatus = GeneratedColumn<int>(
      'object_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(ObjectStatus.global.index));
  static const VerificationMeta _syncStatusMeta =
      const VerificationMeta('syncStatus');
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
      'sync_status', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(SyncStatus.none.index));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portNameMeta =
      const VerificationMeta('portName');
  @override
  late final GeneratedColumn<String> portName = GeneratedColumn<String>(
      'port_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portTypeMeta =
      const VerificationMeta('portType');
  @override
  late final GeneratedColumn<String> portType = GeneratedColumn<String>(
      'port_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _portDescMeta =
      const VerificationMeta('portDesc');
  @override
  late final GeneratedColumn<String> portDesc = GeneratedColumn<String>(
      'port_desc', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _systemDescMeta =
      const VerificationMeta('systemDesc');
  @override
  late final GeneratedColumn<String> systemDesc = GeneratedColumn<String>(
      'system_desc', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        lid,
        timestamp,
        objectStatus,
        syncStatus,
        name,
        portName,
        portType,
        portDesc,
        systemDesc,
        userId,
        password
      ];
  @override
  String get aliasedName => _alias ?? 'system_credentials';
  @override
  String get actualTableName => 'system_credentials';
  @override
  VerificationContext validateIntegrity(Insertable<SystemCredential> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('lid')) {
      context.handle(
          _lidMeta, lid.isAcceptableOrUnknown(data['lid']!, _lidMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    if (data.containsKey('object_status')) {
      context.handle(
          _objectStatusMeta,
          objectStatus.isAcceptableOrUnknown(
              data['object_status']!, _objectStatusMeta));
    }
    if (data.containsKey('sync_status')) {
      context.handle(
          _syncStatusMeta,
          syncStatus.isAcceptableOrUnknown(
              data['sync_status']!, _syncStatusMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('port_name')) {
      context.handle(_portNameMeta,
          portName.isAcceptableOrUnknown(data['port_name']!, _portNameMeta));
    } else if (isInserting) {
      context.missing(_portNameMeta);
    }
    if (data.containsKey('port_type')) {
      context.handle(_portTypeMeta,
          portType.isAcceptableOrUnknown(data['port_type']!, _portTypeMeta));
    } else if (isInserting) {
      context.missing(_portTypeMeta);
    }
    if (data.containsKey('port_desc')) {
      context.handle(_portDescMeta,
          portDesc.isAcceptableOrUnknown(data['port_desc']!, _portDescMeta));
    } else if (isInserting) {
      context.missing(_portDescMeta);
    }
    if (data.containsKey('system_desc')) {
      context.handle(
          _systemDescMeta,
          systemDesc.isAcceptableOrUnknown(
              data['system_desc']!, _systemDescMeta));
    } else if (isInserting) {
      context.missing(_systemDescMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {lid};
  @override
  SystemCredential map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemCredential(
      lid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lid'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      objectStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}object_status'])!,
      syncStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sync_status'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      portName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}port_name'])!,
      portType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}port_type'])!,
      portDesc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}port_desc'])!,
      systemDesc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}system_desc'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
    );
  }

  @override
  $SystemCredentialsTable createAlias(String alias) {
    return $SystemCredentialsTable(attachedDatabase, alias);
  }
}

abstract class _$FrameworkDatabase extends GeneratedDatabase {
  _$FrameworkDatabase(QueryExecutor e) : super(e);
  _$FrameworkDatabase.connect(DatabaseConnection c) : super.connect(c);
  late final $ApplicationMetaTable applicationMeta =
      $ApplicationMetaTable(this);
  late final $StructureMetaTable structureMeta = $StructureMetaTable(this);
  late final $BusinessEntityMetaTable businessEntityMeta =
      $BusinessEntityMetaTable(this);
  late final $FieldMetaTable fieldMeta = $FieldMetaTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $FrameworkSettingsTable frameworkSettings =
      $FrameworkSettingsTable(this);
  late final $MobileUserSettingsTable mobileUserSettings =
      $MobileUserSettingsTable(this);
  late final $InfoMessageTable infoMessage = $InfoMessageTable(this);
  late final $OutObjectTable outObject = $OutObjectTable(this);
  late final $ConflictBETable conflictBE = $ConflictBETable(this);
  late final $InObjectTable inObject = $InObjectTable(this);
  late final $SentItemsTable sentItems = $SentItemsTable(this);
  late final $AttachmentQObjectTable attachmentQObject =
      $AttachmentQObjectTable(this);
  late final $SystemCredentialsTable systemCredentials =
      $SystemCredentialsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        applicationMeta,
        structureMeta,
        businessEntityMeta,
        fieldMeta,
        settings,
        frameworkSettings,
        mobileUserSettings,
        infoMessage,
        outObject,
        conflictBE,
        inObject,
        sentItems,
        attachmentQObject,
        systemCredentials
      ];
}
