import 'package:flutter/material.dart';
import 'dart:convert';

class AppSettings {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final List<String> bannerLinks;
  final List<double> availableVersions;
  final double lastVersion;
  final Map<String, dynamic> admobConfigs;
  final bool updateIsAvailable;
  final String updateDescriptionText;
  final String updateLink;
  final String updateImageLink;
  final SupportLinks supportLinks;

  AppSettings({
    required this.lightTheme,
    required this.darkTheme,
    required this.bannerLinks,
    required this.availableVersions,
    required this.lastVersion,
    required this.admobConfigs,
    required this.updateIsAvailable,
    required this.updateDescriptionText,
    required this.updateLink,
    required this.updateImageLink,
    required this.supportLinks,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    try {
      return AppSettings(
        lightTheme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Color(int.parse(
                json['theme']?['lightThemeBackgroundColor']?.replaceFirst('#', '0xFF') ?? '0xFFFFFFFF')),
            onPrimary: Color(int.parse(
                json['theme']?['lightThemeFontColor']?.replaceFirst('#', '0xFF') ?? '0xFF000000')),
            secondary: Color(int.parse(
                json['theme']?['lightThemeButtonColor']?.replaceFirst('#', '0xFF') ?? '0xFF007BFF')),
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: Color(int.parse(
                json['theme']?['darkThemeBackgroundColor']?.replaceFirst('#', '0xFF') ?? '0xFF000000')),
            onPrimary: Color(int.parse(
                json['theme']?['darkThemeFontColor']?.replaceFirst('#', '0xFF') ?? '0xFFFFFFFF')),
            secondary: Color(int.parse(
                json['theme']?['darkThemeButtonColor']?.replaceFirst('#', '0xFF') ?? '0xFF6C757D')),
          ),
        ),
        bannerLinks: List<String>.from(json['bannerLinks'] ?? []),
        availableVersions: List<double>.from(
            (json['availableVersions'] ?? []).map((v) => (v as num).toDouble())),
        lastVersion: double.tryParse(json['lastVersion']?.toString() ?? '0.0') ?? 0.0,
        admobConfigs: Map<String, dynamic>.from(json['admobConfigs'] ?? {}),
        updateIsAvailable: json['updateIsAvailable'] ?? false,
        updateDescriptionText: json['updateDescriptionText'] ?? '',
        updateLink: json['updateLink'] ?? '',
        updateImageLink: json['updateImageLink'] ?? '',
        supportLinks: json['SupportLinks'] is String
            ? SupportLinks.fromJson(jsonDecode(json['SupportLinks']))
            : SupportLinks.fromJson(json['SupportLinks'] ?? {}),
      );
    } catch (e) {
      print('Error parsing AppSettings from JSON: $e');
      rethrow;
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'theme': {
        'lightThemeBackgroundColor': '#${lightTheme.colorScheme.primary.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        'darkThemeBackgroundColor': '#${darkTheme.colorScheme.primary.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        'lightThemeButtonColor': '#${lightTheme.colorScheme.secondary.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        'darkThemeButtonColor': '#${darkTheme.colorScheme.secondary.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        'lightThemeFontColor': '#${lightTheme.colorScheme.onPrimary.value.toRadixString(16).padLeft(8, '0').substring(2)}',
        'darkThemeFontColor': '#${darkTheme.colorScheme.onPrimary.value.toRadixString(16).padLeft(8, '0').substring(2)}',
      },
      'bannerLinks': bannerLinks,
      'availableVersions': availableVersions,
      'lastVersion': lastVersion,
      'admobConfigs': admobConfigs,
      'updateIsAvailable': updateIsAvailable,
      'updateDescriptionText': updateDescriptionText,
      'updateLink': updateLink,
      'updateImageLink': updateImageLink,
      'SupportLinks': supportLinks.toJson(),
    };
  }
}

class SupportLinks {
  final List<String> subscriptionSupportLinks;
  final List<String> xBaseLink;
  final String chatSupprotLink;

  SupportLinks({
    required this.subscriptionSupportLinks,
    required this.xBaseLink,
    required this.chatSupprotLink,
  });

  factory SupportLinks.fromJson(Map<String, dynamic> json) {
    return SupportLinks(
      subscriptionSupportLinks: List<String>.from(json['subscriptionSupportLinks'] ?? []),
      xBaseLink: List<String>.from(json['xBaseLink']) ?? [],
      chatSupprotLink: json['chatSupprotLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriptionSupportLinks': subscriptionSupportLinks,
      'xBaseLink': xBaseLink,
      'chatSupprotLink': chatSupprotLink,
    };
  }
}
