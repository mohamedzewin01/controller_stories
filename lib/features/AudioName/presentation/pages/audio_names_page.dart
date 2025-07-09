

import 'package:controller_stories/features/AudioName/presentation/bloc/AudioName_cubit.dart';
import 'package:controller_stories/features/AudioName/presentation/widgets/utils/audio_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../../core/di/di.dart';
import '../widgets/sliver_app_bar_widget.dart';
import '../widgets/all_names_tab_widget.dart';
import '../widgets/empty_audio_tab_widget.dart';
import '../widgets/add_new_tab_widget.dart';
import '../widgets/floating_action_button_widget.dart';


class AudioNamesPage extends StatefulWidget {
  const AudioNamesPage({super.key});

  @override
  State<AudioNamesPage> createState() => _AudioNamesPageState();
}

class _AudioNamesPageState extends State<AudioNamesPage>
    with TickerProviderStateMixin {
  late AudioNameCubit viewModel;
  late TabController _tabController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String? _currentPlayingId;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    viewModel = getIt.get<AudioNameCubit>();
    _tabController = TabController(length: 3, vsync: this);

    _setupAudioPlayer();
    _loadInitialData();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _currentPlayingId = null;
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchNamesAudio();
      viewModel.nameAudioEmpty();
    });
  }

  Future<void> _playPauseAudio(String audioUrl, String id) async {
    try {
      if (_currentPlayingId == id && _isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          _currentPlayingId = id;
        });
      }
    } catch (e) {
      AudioNavigationUtils.showErrorSnackBar(
        context,
        'خطأ في تشغيل الملف الصوتي: ${e.toString()}',
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: BlocListener<AudioNameCubit, AudioNameState>(
        listener: (context, state) {
          if (state is AddAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(context, 'تم إضافة الاسم بنجاح');
            _loadInitialData();
          } else if (state is EditAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(context, 'تم تحديث الاسم بنجاح');
            _loadInitialData();
          } else if (state is DeleteAudioNameSuccess) {
            AudioNavigationUtils.showSuccessSnackBar(context, 'تم حذف الاسم بنجاح');
            _loadInitialData();
          } else if (state is AddAudioNameFailure ||
              state is EditAudioNameFailure ||
              state is DeleteAudioNameFailure) {
            AudioNavigationUtils.showErrorSnackBar(context, 'حدث خطأ أثناء العملية');
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBarWidget(tabController: _tabController),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                AllNamesTabWidget(
                  audioPlayer: _audioPlayer,
                  currentPlayingId: _currentPlayingId,
                  isPlaying: _isPlaying,
                  duration: _duration,
                  position: _position,
                  onPlayPause: _playPauseAudio,
                ),
                const EmptyAudioTabWidget(),
                AddNewTabWidget(
                  onAudioAdded: () {
                    viewModel.fetchNamesAudio();
                    viewModel.nameAudioEmpty();
                  },
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButtonWidget(
            onPressed: () => _tabController.animateTo(2),
          ),
        ),
      ),
    );
  }

}