part of 'fake_face_bloc.dart';

abstract class FakeFaceEvent extends Equatable {
  const FakeFaceEvent();
}

class LoadFakeFace extends FakeFaceEvent {
  final String? gender;
  final int minimumAge;
  final int maximumAge;
  final bool? random;
  final BuildContext context;

  const LoadFakeFace({this.gender, required this.minimumAge, required this.maximumAge, this.random = true, required this.context,});

  @override
  List<Object?> get props => [gender, minimumAge, maximumAge, random, context];

}