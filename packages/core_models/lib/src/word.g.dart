// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Word _$WordFromJson(Map<String, dynamic> json) => Word(
      text: json['text'] as String,
      category: $enumDecode(_$WordCategoryEnumMap, json['category']),
      difficulty: $enumDecode(_$WordDifficultyEnumMap, json['difficulty']),
      languageCode: json['languageCode'] as String,
    );

Map<String, dynamic> _$WordToJson(Word instance) => <String, dynamic>{
      'text': instance.text,
      'category': _$WordCategoryEnumMap[instance.category]!,
      'difficulty': _$WordDifficultyEnumMap[instance.difficulty]!,
      'languageCode': instance.languageCode,
    };

const _$WordCategoryEnumMap = {
  WordCategory.movies: 'movies',
  WordCategory.actions: 'actions',
  WordCategory.celebrities: 'celebrities',
  WordCategory.animals: 'animals',
  WordCategory.objects: 'objects',
  WordCategory.sports: 'sports',
  WordCategory.tvShows: 'tvShows',
  WordCategory.books: 'books',
  WordCategory.custom: 'custom',
};

const _$WordDifficultyEnumMap = {
  WordDifficulty.easy: 'easy',
  WordDifficulty.medium: 'medium',
  WordDifficulty.hard: 'hard',
};
