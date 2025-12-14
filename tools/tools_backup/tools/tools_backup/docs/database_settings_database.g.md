# database/settings_database.g.dart

**Module:** database

## Fonctions

### validateIntegrity

```dart
VerificationContext validateIntegrity( Insertable<Setting> instance, {
```

### map

```dart
Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
```

### Setting

```dart
return Setting( key: attachedDatabase.typeMapping.read( DriftSqlType.string, data['${effectivePrefix}key'],
```

### Setting

```dart
const Setting({required this.key, required this.value});
```

### toColumns

```dart
Map<String, Expression> toColumns(bool nullToAbsent) {
```

### toCompanion

```dart
SettingsCompanion toCompanion(bool nullToAbsent) {
```

### SettingsCompanion

```dart
return SettingsCompanion(key: Value(key), value: Value(value));
```

### Setting

```dart
return Setting( key: serializer.fromJson<String>(json['key']), value: serializer.fromJson<String>(json['value']), );
```

### toJson

```dart
Map<String, dynamic> toJson({ValueSerializer? serializer}) {
```

### copyWith

```dart
Setting copyWith({String? key, String? value}) =>
```

### copyWithCompanion

```dart
Setting copyWithCompanion(SettingsCompanion data) {
```

### Setting

```dart
return Setting( key: data.key.present ? data.key.value : this.key, value: data.value.present ? data.value.value : this.value, );
```

### toString

```dart
String toString() {
```

### SettingsCompanion

```dart
const SettingsCompanion({
```

### custom

```dart
static Insertable<Setting> custom({
```

### RawValuesInsertable

```dart
return RawValuesInsertable({
```

### copyWith

```dart
SettingsCompanion copyWith({
```

### SettingsCompanion

```dart
return SettingsCompanion( key: key ?? this.key, value: value ?? this.value, rowid: rowid ?? this.rowid, );
```

### toColumns

```dart
Map<String, Expression> toColumns(bool nullToAbsent) {
```

### toString

```dart
String toString() {
```

### DriftDatabaseOptions

```dart
const DriftDatabaseOptions(storeDateTimeAsText: true);
```

### Function

```dart
SettingsCompanion Function({
```

### Function

```dart
SettingsCompanion Function({
```

### Function

```dart
PrefetchHooks Function() > {
```

### Function

```dart
PrefetchHooks Function() >;
```

