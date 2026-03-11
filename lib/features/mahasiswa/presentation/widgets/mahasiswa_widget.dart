import 'package:flutter/material.dart';
import 'package:riverpod_lanjutan/core/constants/constants.dart';
import 'package:riverpod_lanjutan/features/mahasiswa/data/models/mahasiswa_model.dart';

class ModernMahasiswaCard extends StatefulWidget {
  final MahasiswaModel mahasiswa;
  final VoidCallback? onTap;

  const ModernMahasiswaCard({
    Key? key,
    required this.mahasiswa,
    this.onTap,
  }) : super(key: key);

  @override
  State<ModernMahasiswaCard> createState() => _ModernMahasiswaCardState();
}

class _ModernMahasiswaCardState extends State<ModernMahasiswaCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom gradient to differentiate from dosen
    final gradientColors = [Colors.teal, Colors.teal[300]!];

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, gradientColors[0].withOpacity(0.06)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: gradientColors[0].withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Avatar Area
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: gradientColors,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.mahasiswa.nama.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Details Area
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.mahasiswa.nama,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.mahasiswa.isAktif
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.mahasiswa.isAktif ? 'Aktif' : 'Non-Aktif',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: widget.mahasiswa.isAktif
                                    ? Colors.green[800]
                                    : Colors.red[800],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.numbers_outlined,
                        'NIM: ${widget.mahasiswa.nim}',
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: _buildInfoRow(
                              Icons.school_outlined,
                              widget.mahasiswa.jurusan,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  size: 14, color: Colors.orange[400]),
                              const SizedBox(width: 4),
                              Text(
                                widget.mahasiswa.ipk.toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class MahasiswaListView extends StatelessWidget {
  final List<MahasiswaModel> mahasiswaList;
  final Future<void> Function() onRefresh;

  const MahasiswaListView({
    super.key,
    required this.mahasiswaList,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        itemCount: mahasiswaList.length,
        itemBuilder: (context, index) {
          final mahasiswa = mahasiswaList[index];
          return ModernMahasiswaCard(mahasiswa: mahasiswa);
        },
      ),
    );
  }
}
