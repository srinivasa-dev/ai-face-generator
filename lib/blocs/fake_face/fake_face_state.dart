// ignore_for_file: must_be_immutable

part of 'fake_face_bloc.dart';

abstract class FakeFaceState extends Equatable {
  const FakeFaceState();
}

class FakeFaceInitial extends FakeFaceState {
  @override
  List<Object> get props => [];
}

class FakeFaceLoadingState extends FakeFaceState {
  @override
  List<Object> get props => [];
}

class FakeFaceLoadedState extends FakeFaceState {

  FakeFace fakeFace;
  Uint8List uIntImage;
  FakeFaceLoadedState({required this.fakeFace, required this.uIntImage});

  @override
  List<Object?> get props => [fakeFace, uIntImage];

}

class FakeFaceErrorState extends FakeFaceState {

  String error;
  FakeFaceErrorState({required this.error});

  @override
  List<Object?> get props => [error];

}
