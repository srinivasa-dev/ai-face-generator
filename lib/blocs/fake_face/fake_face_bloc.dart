import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ai_face_generator/models/fake_face_model.dart';
import 'package:ai_face_generator/services/fake_face_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


part 'fake_face_event.dart';
part 'fake_face_state.dart';

class FakeFaceBloc extends Bloc<FakeFaceEvent, FakeFaceState> {
  FakeFaceBloc() : super(FakeFaceInitial()) {
    on<FakeFaceEvent>((event, emit) async {
      if(event is LoadFakeFace) {
        emit(FakeFaceLoadingState());
        try {
          var fakeFaceResponse = await FakeFaceService().getFace(gender: event.gender, minimumAge: event.minimumAge, maximumAge: event.maximumAge, random: event.random).timeout(const Duration(seconds: 10));
          var data = json.decode(fakeFaceResponse.body);

          if(fakeFaceResponse.statusCode == 200) {
            FakeFace fakeFace = FakeFace.fromJson(data);
            Uint8List uIntImage = await readBytes(Uri.parse(fakeFace.imageUrl!));
            emit(FakeFaceLoadedState(fakeFace: fakeFace, uIntImage: uIntImage));
          } else {
            ScaffoldMessenger.of(event.context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Oops Something went wrong!',
                ),
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
            emit(FakeFaceErrorState(error: fakeFaceResponse.statusCode.toString()));
          }
        } on TimeoutException catch (_) {
          ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(
              content: Text(
                'Connection Timeout!\nPlease try again later!',
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
          emit(FakeFaceErrorState(error: 'Timeout Exception'));
        } on SocketException catch (_) {
          ScaffoldMessenger.of(event.context).showSnackBar(
            const SnackBar(
              content: Text(
                'Oops Something went wrong!\nPlease try again later!',
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
          emit(FakeFaceErrorState(error: 'Socket Exception'));
        }
      }
    });
  }
}
