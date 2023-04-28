part of 'fake_face_bloc.dart';

abstract class FakeFaceEvent extends Equatable {
  const FakeFaceEvent();
}

class LoadFakeFace extends FakeFaceEvent {
  final BuildContext context;

  const LoadFakeFace({required this.context,});

  @override
  List<Object?> get props => [context];

}