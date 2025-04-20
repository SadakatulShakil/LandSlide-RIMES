import 'package:flutter/material.dart';

@immutable
class ModelLocation {
  final int id;
  final String district;
  final String upazila;
  final String location;

  ModelLocation(this.id, this.district, this.upazila, this.location);

  @override
  String toString() {
    return '$location';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelLocation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          district == other.district &&
          upazila == other.upazila &&
          location == other.location;

  @override
  int get hashCode =>
      id.hashCode ^ district.hashCode ^ upazila.hashCode ^ location.hashCode;
}