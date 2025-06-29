import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silence_score/constants/app_constants.dart';
import 'package:silence_score/models/silence_data.dart';

class StorageService {
  static const String _silenceDataKey = 'silence_data';

  /// Save silence data to local storage
  Future<void> saveSilenceData(SilenceData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_silenceDataKey, jsonString);
  }

  /// Load silence data from local storage
  Future<SilenceData> loadSilenceData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_silenceDataKey);
    
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return SilenceData.fromJson(json);
      } catch (e) {
        // If JSON is corrupted, return default data
        return const SilenceData();
      }
    }
    
    return const SilenceData();
  }

  /// Save decibel threshold setting
  Future<void> saveDecibelThreshold(double threshold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.decibelThresholdKey, threshold);
  }

  /// Load decibel threshold setting
  Future<double> loadDecibelThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(AppConstants.decibelThresholdKey) ?? 
           AppConstants.defaultDecibelThreshold;
  }

  /// Reset all stored data
  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// Update streak based on current date
  Future<SilenceData> updateStreak(SilenceData currentData) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // If no last play date, start streak at 1
    if (currentData.lastPlayDate == null) {
      return currentData.copyWith(
        currentStreak: 1,
        lastPlayDate: today,
      );
    }
    
    final lastPlayDay = DateTime(
      currentData.lastPlayDate!.year,
      currentData.lastPlayDate!.month,
      currentData.lastPlayDate!.day,
    );
    
    // If played today, don't change streak
    if (today.isAtSameMomentAs(lastPlayDay)) {
      return currentData;
    }
    
    // If played yesterday, increment streak
    final yesterday = today.subtract(const Duration(days: 1));
    if (lastPlayDay.isAtSameMomentAs(yesterday)) {
      final newStreak = currentData.currentStreak + 1;
      final newBestStreak = newStreak > currentData.bestStreak 
          ? newStreak 
          : currentData.bestStreak;
      
      return currentData.copyWith(
        currentStreak: newStreak,
        bestStreak: newBestStreak,
        lastPlayDate: today,
      );
    }
    
    // If gap is more than 1 day, reset streak
    return currentData.copyWith(
      currentStreak: 1,
      lastPlayDate: today,
    );
  }
} 