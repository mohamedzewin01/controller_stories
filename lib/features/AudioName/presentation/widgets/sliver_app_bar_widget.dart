// lib/features/AudioName/presentation/widgets/sliver_app_bar_widget.dart
import 'package:controller_stories/core/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SliverAppBarWidget extends StatelessWidget {
  final TabController tabController;

  const SliverAppBarWidget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 130,
      floating: false,
      pinned: true,
      backgroundColor: ColorManager.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors:  [
                ColorManager.primaryColor,
                ColorManager.primaryColor.withOpacity(0.9),
                ColorManager.primaryColor,

              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          // child: SafeArea(
          //   child: Column(
          //     children: [
          //       const SizedBox(height: 60),
          //       const Text(
          //         'إدارة الأسماء الصوتية',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(height: 20),
          //       // const StatisticsCardsWidget(),
          //     ],
          //   ),
          // ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          margin: const EdgeInsets.all(8),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: tabController,
            // labelColor: Colors.indigo[600],
            unselectedLabelColor: Colors.grey[600],
            // indicator: BoxDecoration(
            //   borderRadius: BorderRadius.circular(25),
            //   color: Colors.indigo[50],
            // ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(icon: Icon(Icons.library_music), text: 'الكل'),
              // Tab(icon: Icon(Icons.music_off), text: 'بدون صوت'),
              Tab(icon: Icon(Icons.add_circle), text: 'إضافة'),
            ],
          ),
        ),
      ),
    );
  }
}