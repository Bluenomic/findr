import 'package:flutter/material.dart';
import 'app_widgets.dart';
import 'detail_page.dart';
import 'sample_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCity = 'Balikpapan';
  String _searchQuery = '';
  String _filter = 'Semua';
  final TextEditingController _searchController = TextEditingController();

  static const List<String> _cities = [
    'Balikpapan',
    'Samarinda',
    'Jakarta',
    'Surabaya',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = sampleItems.where((item) {
      final matchCity = item.city.toLowerCase() == _selectedCity.toLowerCase();
      final matchFilter = _filter == 'Semua' ||
          (_filter == 'Ditemukan' && item.found) ||
          (_filter == 'Hilang' && !item.found);
      final query = _searchQuery.trim().toLowerCase();
      final matchQuery = query.isEmpty ||
          '${item.title} ${item.description} ${item.location}'
              .toLowerCase()
              .contains(query);
      return matchCity && matchFilter && matchQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Expanded(
                      child: Text(
                        'findr',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.green,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.badgeBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'RUANG TEMU',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Filter & Search Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // City Dropdown
                    PopupMenuButton<String>(
                      initialValue: _selectedCity,
                      onSelected: (String city) {
                        setState(() {
                          _selectedCity = city;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      itemBuilder: (BuildContext context) {
                        return _cities.map((String city) {
                          final isSelected = city == _selectedCity;
                          return PopupMenuItem<String>(
                            value: city,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  city,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.green
                                        : AppColors.ink,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.green,
                                    size: 18,
                                  ),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                'Lokasi: $_selectedCity',
                                style: const TextStyle(
                                  color: AppColors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_drop_down_rounded,
                              color: AppColors.green,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Search Field
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cari barang atau lokasi…',
                        hintStyle: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 15,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.muted,
                          size: 24,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFE2E7DE)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFFE2E7DE)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: AppColors.green,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Filter Chips (Semua, Hilang, Ditemukan)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Semua', 'Hilang', 'Ditemukan'].map((label) {
                          final isSelected = _filter == label;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              selected: isSelected,
                              label: Text(label),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.ink,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                              selectedColor: AppColors.green,
                              backgroundColor: Colors.white,
                              checkmarkColor: Colors.white,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.green
                                    : const Color(0xFFE0E5DC),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onSelected: (val) {
                                setState(() {
                                  _filter = label;
                                });
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              const Divider(color: AppColors.divider, height: 1),
              const SizedBox(height: 16),

              // Section Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temukan di $_selectedCity',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Barang hilang dan ditemukan di kotamu',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Grid / List of Feed Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: filteredItems.isEmpty
                    ? AppPanel(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.search_off_rounded,
                              size: 40,
                              color: AppColors.green,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Belum ada yang cocok',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Belum ada barang yang cocok di $_selectedCity. Coba kata kunci, filter, atau kota lain.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildFeedRows(context, filteredItems),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedRows(BuildContext context, List<Item> items) {
    final List<Widget> rowWidgets = [];
    for (int i = 0; i < items.length; i += 2) {
      final firstItem = items[i];
      final hasSecond = i + 1 < items.length;
      final secondItem = hasSecond ? items[i + 1] : null;

      rowWidgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ItemFeedCard(
                  item: firstItem,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          item: firstItem,
                          isOwn: false,
                          origin: 'home',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: secondItem != null
                    ? ItemFeedCard(
                        item: secondItem,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                item: secondItem,
                                isOwn: false,
                                origin: 'home',
                              ),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rowWidgets);
  }
}
