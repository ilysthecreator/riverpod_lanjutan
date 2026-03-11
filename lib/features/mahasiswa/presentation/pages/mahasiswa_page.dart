import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_lanjutan/core/widgets/widgets.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/presentation/widgets/mahasiswa_widget.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {
              ref.invalidate(mahasiswaNotifierProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: mahasiswaState.when(
        loading: () => const LoadingWidget(),
        error: (error, stack) => CustomErrorWidget(
          message: 'Gagal memuat data mahasiswa: ${error.toString()}',
          onRetry: () {
            ref.read(mahasiswaNotifierProvider.notifier).refresh();
          },
        ),
        data: (mahasiswaList) {
          return MahasiswaListView(
            mahasiswaList: mahasiswaList,
            onRefresh: () async {
              ref.invalidate(mahasiswaNotifierProvider);
            },
          );
        },
      ),
    );
  }
}
