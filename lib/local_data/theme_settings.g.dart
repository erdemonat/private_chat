// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetThemeSettingsCollection on Isar {
  IsarCollection<ThemeSettings> get themeSettings => this.collection();
}

const ThemeSettingsSchema = CollectionSchema(
  name: r'ThemeSettings',
  id: 815540309993789807,
  properties: {
    r'themeName': PropertySchema(
      id: 0,
      name: r'themeName',
      type: IsarType.string,
    )
  },
  estimateSize: _themeSettingsEstimateSize,
  serialize: _themeSettingsSerialize,
  deserialize: _themeSettingsDeserialize,
  deserializeProp: _themeSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _themeSettingsGetId,
  getLinks: _themeSettingsGetLinks,
  attach: _themeSettingsAttach,
  version: '3.1.0+1',
);

int _themeSettingsEstimateSize(
  ThemeSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.themeName.length * 3;
  return bytesCount;
}

void _themeSettingsSerialize(
  ThemeSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.themeName);
}

ThemeSettings _themeSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ThemeSettings();
  object.id = id;
  object.themeName = reader.readString(offsets[0]);
  return object;
}

P _themeSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _themeSettingsGetId(ThemeSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _themeSettingsGetLinks(ThemeSettings object) {
  return [];
}

void _themeSettingsAttach(
    IsarCollection<dynamic> col, Id id, ThemeSettings object) {
  object.id = id;
}

extension ThemeSettingsQueryWhereSort
    on QueryBuilder<ThemeSettings, ThemeSettings, QWhere> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ThemeSettingsQueryWhere
    on QueryBuilder<ThemeSettings, ThemeSettings, QWhereClause> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ThemeSettingsQueryFilter
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'themeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'themeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'themeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'themeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeName',
        value: '',
      ));
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterFilterCondition>
      themeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'themeName',
        value: '',
      ));
    });
  }
}

extension ThemeSettingsQueryObject
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {}

extension ThemeSettingsQueryLinks
    on QueryBuilder<ThemeSettings, ThemeSettings, QFilterCondition> {}

extension ThemeSettingsQuerySortBy
    on QueryBuilder<ThemeSettings, ThemeSettings, QSortBy> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> sortByThemeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeName', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      sortByThemeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeName', Sort.desc);
    });
  }
}

extension ThemeSettingsQuerySortThenBy
    on QueryBuilder<ThemeSettings, ThemeSettings, QSortThenBy> {
  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy> thenByThemeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeName', Sort.asc);
    });
  }

  QueryBuilder<ThemeSettings, ThemeSettings, QAfterSortBy>
      thenByThemeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeName', Sort.desc);
    });
  }
}

extension ThemeSettingsQueryWhereDistinct
    on QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> {
  QueryBuilder<ThemeSettings, ThemeSettings, QDistinct> distinctByThemeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeName', caseSensitive: caseSensitive);
    });
  }
}

extension ThemeSettingsQueryProperty
    on QueryBuilder<ThemeSettings, ThemeSettings, QQueryProperty> {
  QueryBuilder<ThemeSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ThemeSettings, String, QQueryOperations> themeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeName');
    });
  }
}
