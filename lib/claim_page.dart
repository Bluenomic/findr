import 'package:flutter/material.dart';
import 'app_widgets.dart';
import 'sample_data.dart';

class ClaimPage extends StatefulWidget {
  final Item item;

  const ClaimPage({
    super.key,
    required this.item,
  });

  @override
  State<ClaimPage> createState() => _ClaimPageState();
}

class _ClaimPageState extends State<ClaimPage> {
  final _proofController = TextEditingController();

  @override
  void dispose() {
    _proofController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'Ajukan klaim',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppHeading(
                title: 'Buktikan ini milikmu',
                subtitle: 'Bantu pelapor mengenali pemilik yang tepat.',
              ),
              const SizedBox(height: 18),

              // Item Summary Card
              ItemRowCard(
                item: widget.item,
                onTap: () {},
              ),
              const SizedBox(height: 14),

              // Instruction Panel
              const AppPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hanya kamu yang tahu',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Ceritakan ciri khusus, isi barang, atau detail yang tidak terlihat di foto. Bukti ini ditujukan kepada pembuat laporan.',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Proof Field
              TextField(
                controller: _proofController,
                minLines: 4,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Bukti kepemilikan',
                  labelStyle: const TextStyle(color: AppColors.muted),
                  hintText: 'Contoh: Isi di dalam dompet, tanda khusus…',
                  hintStyle: const TextStyle(color: AppColors.muted, fontSize: 14),
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD6DDD2)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFD6DDD2)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.green, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit Button
              AppPrimaryButton(
                label: 'Kirim klaim',
                onPressed: () async {
                  await showAppNoticeDialog(
                    context: context,
                    message:
                        'Tampilan klaim selesai dicoba. Klaim belum dikirim atau disimpan.',
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
