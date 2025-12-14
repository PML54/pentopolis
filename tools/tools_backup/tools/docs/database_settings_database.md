# database/settings_database.dart

**Module:** database

## Fonctions

### getSetting

Table pour stocker les paramètres de l'application
Récupère une valeur de paramètre


```dart
Future<String?> getSetting(String key) async {
```

### setSetting

Définit une valeur de paramètre


```dart
Future<void> setSetting(String key, String value) async {
```

### into

```dart
await into(settings).insertOnConflictUpdate( SettingsCompanion.insert( key: key, value: value, ), );
```

### deleteSetting

Supprime un paramètre


```dart
Future<void> deleteSetting(String key) async {
```

### clearAllSettings

Supprime tous les paramètres


```dart
Future<void> clearAllSettings() async {
```

### delete

```dart
await delete(settings).go();
```

### LazyDatabase

```dart
return LazyDatabase(() async {
```

### NativeDatabase

```dart
return NativeDatabase(file);
```

