import 'package:equatable/equatable.dart';

// ─── Events ──────────────────────────────────────────────────────────────────

abstract class ArEvent extends Equatable {
  const ArEvent();
  @override
  List<Object?> get props => [];
}

/// Inisialisasi AR session
class ArInitialize extends ArEvent {
  const ArInitialize();
}

/// Load model 3D berdasarkan ID bangun
class ArLoadModel extends ArEvent {
  const ArLoadModel({required this.shapeId, required this.shapeName});
  final String shapeId;
  final String shapeName;
  @override
  List<Object?> get props => [shapeId, shapeName];
}

/// Event dari Unity → Flutter (message handler)
class ArUnityMessage extends ArEvent {
  const ArUnityMessage({required this.gameObject, required this.methodName, required this.message});
  final String gameObject;
  final String methodName;
  final String message;
  @override
  List<Object?> get props => [gameObject, methodName, message];
}

class ArDispose extends ArEvent {
  const ArDispose();
}

class ArToggleInfo extends ArEvent {
  const ArToggleInfo();
}

// ─── States ───────────────────────────────────────────────────────────────────

abstract class ArState extends Equatable {
  const ArState();
  @override
  List<Object?> get props => [];
}

class ArInitial extends ArState {
  const ArInitial();
}

class ArInitializing extends ArState {
  const ArInitializing();
}

class ArReady extends ArState {
  const ArReady({
    required this.isModelLoaded,
    this.loadedShapeId,
    this.loadedShapeName,
    this.isInfoVisible = false,
  });

  final bool isModelLoaded;
  final String? loadedShapeId;
  final String? loadedShapeName;
  final bool isInfoVisible;

  ArReady copyWith({
    bool? isModelLoaded,
    String? loadedShapeId,
    String? loadedShapeName,
    bool? isInfoVisible,
  }) {
    return ArReady(
      isModelLoaded: isModelLoaded ?? this.isModelLoaded,
      loadedShapeId: loadedShapeId ?? this.loadedShapeId,
      loadedShapeName: loadedShapeName ?? this.loadedShapeName,
      isInfoVisible: isInfoVisible ?? this.isInfoVisible,
    );
  }

  @override
  List<Object?> get props =>
      [isModelLoaded, loadedShapeId, loadedShapeName, isInfoVisible];
}

class ArLoadingModel extends ArState {
  const ArLoadingModel({required this.shapeId});
  final String shapeId;
  @override
  List<Object?> get props => [shapeId];
}

class ArError extends ArState {
  const ArError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
