import 'dart:io';

import 'package:ai_face_generator/blocs/fake_face/fake_face_bloc.dart';
import 'package:ai_face_generator/models/fake_face_model.dart';
import 'package:download/download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _loading = true;
  final FakeFaceBloc _fakeFaceBloc = FakeFaceBloc();
  FakeFace _fakeFace = FakeFace();
  late Uint8List _image;

  int _minimumAge = 20, _maximumAge = 50;

  int _selectedIndex = 2;

  Future _downloadImage() async {
    if (_loading) return;
    Directory? appDir;
    final stream = Stream.fromIterable(_image);
    if (kIsWeb) {
      await download(stream, _fakeFace.filename!);
      return;
    } else if (Platform.isAndroid) {
      appDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getDownloadsDirectory();
    }
    String pathName = appDir?.path ?? "";
    String destinationPath = "$pathName${Platform.isWindows ? "\\" : "/"}${_fakeFace.filename}";
    await download(stream, destinationPath);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'The image has been downloaded successfully to $destinationPath',
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    _fakeFaceBloc.add(LoadFakeFace(minimumAge: _minimumAge, maximumAge: _maximumAge, context: context));
    super.initState();
  }

  @override
  void dispose() {
    _fakeFaceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Face Generator'),
      ),
      body: BlocConsumer<FakeFaceBloc, FakeFaceState>(
        bloc: _fakeFaceBloc,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > constraints.maxHeight) {
                  return Row(
                    children: [
                      imageBuild(),
                      const SizedBox(width: 20.0,),
                      filterView(),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      imageBuild(),
                      filterView(),
                    ],
                  );
                }
              },
            ),
          );
        },
        listener: (context, state) {
          if(state is FakeFaceLoadingState) {
            setState(() {
              _loading = true;
            });
          } else if (state is FakeFaceLoadedState) {
            setState(() {
              _fakeFace = state.fakeFace;
              _image = state.uIntImage;
              _loading = false;
            });
          } else if (state is FakeFaceErrorState) {
            setState(() {
              _loading = false;
            });
          } else {
            setState(() {
              _loading = false;
            });
          }
        },
      ),
    );
  }

  Widget imageBuild() {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          color: Theme.of(context).hoverColor,
          child: _loading
              ? LottieBuilder.asset(
            'assets/lottie_animations/face_load.json',
          ) : Stack(
            children: [
              Image.memory(
                _image,
                fit: BoxFit.contain,
              ),
              Visibility(
                visible: !_loading,
                child: Positioned(
                  left: 10,
                 bottom: 10,
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: 'AGE\n',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                        children: [
                          TextSpan(
                            text: _fakeFace.age.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                            ),
                          ),
                        ]
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 55.0,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                        border: Border.all(
                          color: const ColorScheme.dark().surfaceTint,
                        ),
                        color: _selectedIndex == 0 ? const ColorScheme.dark().primary.withOpacity(0.4) : Colors.transparent,
                      ),
                      child: const Icon(
                        Icons.male,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const ColorScheme.dark().surfaceTint,
                        ),
                        color: _selectedIndex == 1 ? const ColorScheme.dark().primary.withOpacity(0.4) : Colors.transparent,
                      ),
                      child: const Icon(
                        Icons.female,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                        border: Border.all(
                          color: const ColorScheme.dark().surfaceTint,
                        ),
                        color: _selectedIndex == 2 ? const ColorScheme.dark().primary.withOpacity(0.4) : Colors.transparent,
                      ),
                      child: const Icon(
                        Icons.shuffle,
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Age Range',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    '$_minimumAge - $_maximumAge years',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
                child: RangeSlider(
                  min: 0,
                  max: 100,
                  values: RangeValues(_minimumAge.toDouble(), _maximumAge.toDouble()),
                  onChanged: (value) {
                    if(value.start.floor() <= 76 && value.end.floor() >= 9) {
                      setState(() {
                        _minimumAge = value.start.floor();
                        _maximumAge = value.end.floor();
                      });
                    }
                  },
                  onChangeStart: (value) {
                    HapticFeedback.vibrate();
                  },
                  onChangeEnd: (value) {
                    HapticFeedback.vibrate();
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _loading ? null : () {
                    if(_selectedIndex == 0) {
                      _fakeFaceBloc.add(LoadFakeFace(gender: 'male', minimumAge: _minimumAge, maximumAge: _maximumAge, random: false, context: context));
                    } else if(_selectedIndex == 1) {
                      _fakeFaceBloc.add(LoadFakeFace(gender: 'female', minimumAge: _minimumAge, maximumAge: _maximumAge, random: false, context: context));
                    } else if(_selectedIndex == 2) {
                      _fakeFaceBloc.add(LoadFakeFace(minimumAge: _minimumAge, maximumAge: _maximumAge, context: context));
                    } else {
                      _fakeFaceBloc.add(LoadFakeFace(minimumAge: _minimumAge, maximumAge: _maximumAge, context: context));
                    }
                  },
                  child: const Text(
                    'GENERATE',
                  ),
                ),
              ),
              const SizedBox(width: 20.0,),
              ElevatedButton(
                onPressed: _loading ? null : () {
                  _downloadImage();
                },
                child: const Icon(
                  Icons.download,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
