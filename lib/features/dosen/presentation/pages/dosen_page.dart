import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_lanjutan/core/widgets/widgets.dart';
import 'package:riverpod_lanjutan/features/dosen/data/models/dosen_model.dart';
import 'package:riverpod_lanjutan/features/dosen/presentation/providers/dosen_provider.dart';

class DosenPage extends ConsumerWidget {
  const DosenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dosenState = ref.watch(dosenNotifierProvider);
    final savedUsers = ref.watch(savedUsersProvider); // CHANGED

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Dosen'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => ref.read(dosenNotifierProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ), // IconButton
        ],
      ), // AppBar
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Section Data Tersimpan di SharedPreferences ---
          _SavedUserSection(savedUsers: savedUsers, ref: ref),

          // --- Section Title Daftar Dosen ----------------
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Daftar Dosen',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ), // Text
          ), // Padding

          // --- Dosen List --------------------------------
          Expanded(
            child: dosenState.when(
              loading: () => const LoadingWidget(),
              error: (error, stack) => CustomErrorWidget(
                message: 'Gagal memuat data dosen: $error.toString()',
                onRetry: () {
                  ref.read(dosenNotifierProvider.notifier).refresh();
                },
              ), // CustomErrorWidget
              data: (dosenList) => _DosenListWithSave(
                dosenList: dosenList,
                onRefresh: () => ref.read(dosenNotifierProvider.notifier).refresh(),
              ), // _DosenListWithSave
            ),
          ), // Expanded
        ],
      ), // Column
    ); // Scaffold
  }
}

// --- Widget: Section Data SharedPreferences ----------------
class _SavedUserSection extends ConsumerWidget {
  final AsyncValue<List<Map<String, String>>> savedUsers;
  final WidgetRef ref;

  const _SavedUserSection({required this.savedUsers, required this.ref});

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
              ), // Text
              const Spacer(),
              savedUsers.maybeWhen(
                data: (users) => users.isEmpty
                    ? const SizedBox.shrink()
                    : TextButton.icon(
                        onPressed: () async {
                          await ref
                              .read(dosenNotifierProvider.notifier)
                              .clearSavedUsers();
                          ref.invalidate(savedUsersProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Semua data tersimpan dihapus"),
                              ), // SnackBar
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.delete_sweep_outlined,
                          size: 16,
                          color: Colors.red,
                        ), // Icon
                        label: const Text(
                          'Hapus Semua',
                          style: TextStyle(fontSize: 12, color: Colors.red),
                        ), // Text
                      ), // TextButton.icon
                orElse: () => const SizedBox.shrink(),
              ), // Row
            ],
          ), // Row
          const SizedBox(height: 8),

          // Content
          savedUsers.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const Text(
              'Gagal membaca data tersimpan',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ), // Text
            data: (users) {
              if (users.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ), // BoxDecoration
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey.shade600,
                      ), // Icon
                      const SizedBox(width: 8),
                      Text(
                        'Belum ada data. Tap ikon 💾 untuk menyimpan.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ), // TextStyle
                      ), // Text
                    ],
                  ), // Row
                ); // Container
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ), // BoxDecoration
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: Colors.green.shade200,
                    indent: 12,
                    endIndent: 12,
                  ), // Divider
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.green.shade100,
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ), // Text
                      ), // CircleAvatar
                      title: Text(user['username'] ?? '-'),
                      subtitle: Text(
                        'ID: ${user['user_id']} | ${_formatDate(user['saved_at'] ?? '')}',
                        style: const TextStyle(fontSize: 11),
                      ), // Text
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 16,
                          color: Colors.red,
                        ), // Icon
                        onPressed: () async {
                          await ref
                              .read(dosenNotifierProvider.notifier)
                              .removeSelectedDosen(user['user_id'] ?? '');
                          ref.invalidate(savedUsersProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('User ${user['username']} dihapus'),
                              ), // SnackBar
                            );
                          }
                        },
                      ), // IconButton
                    ); // ListTile
                  }, // itemBuilder
                ), // ListView.separated
              ); // Container
            }, // data
          ), // savedUsers.when
        ], // Column
      ), // Padding
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

// --- Widget: List Dosen dengan tombol save ----------------
class _DosenListWithSave extends ConsumerWidget {
  final List<DosenModel> dosenList;
  final VoidCallback onRefresh;

  const _DosenListWithSave({Key? key, required this.dosenList, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: dosenList.length,
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemBuilder: (context, index) {
          final dosen = dosenList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(child: Text('${dosen.id}')),
              title: Text(dosen.name),
              subtitle: Text(
                '${dosen.username} - ${dosen.email}\n${dosen.address.city}',
              ), // Text
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.save, size: 18),
                tooltip: 'Simpan user ini',
                onPressed: () async {
                  await ref
                      .read(dosenNotifierProvider.notifier)
                      .saveSelectedDosen(dosen);
                  ref.invalidate(savedUsersProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${dosen.username} berhasil disimpan ke local storage',
                        ), // Text
                      ), // SnackBar
                    );
                  }
                },
              ), // IconButton
            ), // ListTile
          ); // Card
        }, // itemBuilder
      ), // ListView.builder
    ); // RefreshIndicator
  }
}
