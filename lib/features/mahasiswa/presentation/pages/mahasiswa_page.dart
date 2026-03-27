import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_lanjutan/core/widgets/widgets.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/data/models/mahasiswa_model.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/presentation/providers/mahasiswa_provider.dart';

class MahasiswaPage extends ConsumerWidget {
  const MahasiswaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mahasiswaState = ref.watch(mahasiswaNotifierProvider);
    final savedMahasiswa = ref.watch(savedMahasiswaProvider); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Mahasiswa'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(mahasiswaNotifierProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ), 
        ],
      ), 
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Section Data Tersimpan di SharedPreferences ---
          _SavedMahasiswaSection(savedMahasiswa: savedMahasiswa, ref: ref),

          // --- Section Title Daftar Mahasiswa ----------------
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Daftar Mahasiswa',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ), 
          ), 

          // --- Mahasiswa List --------------------------------
          Expanded(
            child: mahasiswaState.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: 'Gagal memuat data mahasiswa: $error',
                onRetry: () {
                  ref.read(mahasiswaNotifierProvider.notifier).refresh();
                },
              ), 
              data: (mahasiswaList) => _MahasiswaListWithSave(
                mahasiswaList: mahasiswaList,
                onRefresh: () async {
                  await ref.read(mahasiswaNotifierProvider.notifier).refresh();
                },
              ), 
            ),
          ), 
        ],
      ), 
    );
  }
}

// --- Widget: Section Data SharedPreferences ----------------
class _SavedMahasiswaSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedMahasiswa;
  final WidgetRef ref;

  const _SavedMahasiswaSection({required this.savedMahasiswa, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan tombol hapus semua
          Row(
            children: [
              const Icon(Icons.storage_rounded, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Data Tersimpan di Local Storage',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ), 
              const Spacer(),
              savedMahasiswa.maybeWhen(
                data: (users) => users.isEmpty
                    ? const SizedBox.shrink()
                    : TextButton.icon(
                        onPressed: () async {
                          await ref
                              .read(mahasiswaNotifierProvider.notifier)
                              .clearSavedMahasiswa();
                          ref.invalidate(savedMahasiswaProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Semua data tersimpan dihapus"),
                              ), 
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.delete_sweep_outlined,
                          size: 16,
                          color: Colors.red,
                        ),
                        label: const Text(
                          'Hapus Semua',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ), 
                      ), 
                orElse: () => const SizedBox.shrink(),
              ), 
            ],
          ), 
          const SizedBox(height: 8),

          // Content
          savedMahasiswa.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text(
              'Gagal membaca data tersimpan',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ), 
            data: (users) {
              if (users.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ), 
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ), 
                      const SizedBox(width: 8),
                      Text(
                        'Belum ada data. Tap ikon 💾 untuk menyimpan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ), 
                      ), 
                    ],
                  ), 
                ); 
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ), 
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.blue.shade200,
                    indent: 12,
                    endIndent: 12,
                  ), 
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ), 
                      ), 
                      title: Text(user['name'] ?? '-'),
                      subtitle: Text(
                        'ID: ${user['id']} | ${_formatDate(user['saved_at'] ?? '')}',
                        style: const TextStyle(fontSize: 11),
                      ), 
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 16,
                          color: Colors.red,
                        ), 
                        onPressed: () async {
                          await ref
                              .read(mahasiswaNotifierProvider.notifier)
                              .removeSelectedMahasiswa(user['id'] ?? '');
                          ref.invalidate(savedMahasiswaProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Mahasiswa ${user['name']} dihapus'),
                              ), 
                            );
                          }
                        },
                      ), 
                    ); 
                  }, 
                ), 
              ); 
            }, 
          ), 
        ], 
      ), 
    );
  }

  String _formatDate(String isoString) {
    if (isoString.isEmpty) return '-';
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return isoString;
    }
  }
}

// --- Widget: List Mahasiswa dengan tombol save ----------------
class _MahasiswaListWithSave extends ConsumerWidget {
  final List<MahasiswaModel> mahasiswaList;
  final VoidCallback onRefresh;

  const _MahasiswaListWithSave({Key? key, required this.mahasiswaList, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: mahasiswaList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswaList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(child: Text('${mahasiswa.id}')),
              title: Text(mahasiswa.name, maxLines: 1, overflow: TextOverflow.ellipsis,),
              subtitle: Text(
                '${mahasiswa.email}\n${mahasiswa.body.replaceAll("\n", " ")}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ), 
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.save, size: 18),
                tooltip: 'Simpan mahasiswa ini',
                onPressed: () async {
                  await ref
                      .read(mahasiswaNotifierProvider.notifier)
                      .saveSelectedMahasiswa(mahasiswa);
                  ref.invalidate(savedMahasiswaProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${mahasiswa.name} berhasil disimpan ke local storage',
                        ), 
                      ), 
                    );
                  }
                },
              ), 
            ), 
          ); 
        }, 
      ), 
    ); 
  }
}
