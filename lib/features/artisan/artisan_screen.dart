import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_scaffold.dart';

class ArtisanScreen extends StatelessWidget {
  final String artisanId;

  const ArtisanScreen({Key? key, required this.artisanId}) : super(key: key);

  Future<Map<String, dynamic>> _loadScreenData() async {
    final String artisanString = await rootBundle.loadString('assets/mock/artisans.json');
    final List<dynamic> artisanList = json.decode(artisanString);
    final artisanData = artisanList.firstWhere(
      (item) => item['id'] == artisanId, 
      orElse: () => artisanList.first
    );

    final String productString = await rootBundle.loadString('assets/mock/items.json');
    final List<dynamic> productList = json.decode(productString);
    
    final List<dynamic> artisanProducts = productList
        .where((product) => (artisanData['productIds'] as List).contains(product['id']))
        .toList();

    return {
      'artisan': artisanData,
      'products': artisanProducts,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadScreenData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppScaffold(
            currentIndex: 4,
            body: Center(child: CircularProgressIndicator(color: Color(0xFF8B4513))),
          );
        }

        if (snapshot.hasError) {
          return AppScaffold(
            currentIndex: 4,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final artisan = snapshot.data!['artisan'];
        final products = snapshot.data!['products'] as List<dynamic>;

        final String masterTitle = artisan['masterTitle'] ?? artisan['specialty'];
        final String totalSales = artisan['totalSales'] ?? "${artisan['productCount'] * 15}+";

        return AppScaffold(
          currentIndex: 4,
          body: Container(
            color: const Color(0xFFFDFBF7),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 450.0,
                  pinned: false,
                  backgroundColor: const Color(0xFF4A3B32),
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white), onPressed: () {}),
                    const Gap(8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: artisan['photoUrl'],
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                              stops: const [0.5, 1.0],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 24,
                          right: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2C94C),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.verified, size: 14, color: Color(0xFF8B4513)),
                                    const Gap(4),
                                    Text(
                                      masterTitle.toUpperCase(),
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8B4513)),
                                    ),
                                  ],
                                ),
                              ),
                              const Gap(8),
                              Text(
                                artisan['name'],
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const Gap(16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF8B4513),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      icon: const Icon(Icons.person_add_alt_1, size: 18),
                                      label: const Text("Follow", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const Gap(12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: BorderSide(color: Colors.white.withOpacity(0.5)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        backgroundColor: Colors.white.withOpacity(0.1),
                                      ),
                                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                                      label: const Text("Chat", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn('GIFTS', totalSales),
                            _buildDivider(),
                            _buildStatColumn('YEARS', artisan['yearsOfExperience'].toString()),
                            _buildDivider(),
                            _buildRatingColumn('RATING', artisan['rating'].toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(width: 24, height: 2, color: const Color(0xFF8B4513)),
                                const Gap(8),
                                const Text("Meet the Maker", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                              ],
                            ),
                            const Gap(16),
                            Text(
                              artisan['story'],
                              style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF555555)),
                            ),
                            const Gap(40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Signature Collection", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                                TextButton(
                                  onPressed: () {}, 
                                  child: const Text("View All", style: TextStyle(color: Color(0xFF8B4513), fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                            const Gap(12),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 260,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _buildNewProductCard(
                              product['name'], 
                              "\$${product['price'].toStringAsFixed(2)}", 
                              "${(product['price'] * 4100).toInt()} KHR",
                              product['imageUrl']
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Inside the Atelier", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                            const Gap(16),
                            _buildGalleryGrid(),
                            const Gap(40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Artisan Stories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                                Row(
                                  children: [
                                    Text(artisan['rating'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8B4513))),
                                    const Icon(Icons.star, color: Color(0xFFF2C94C), size: 16),
                                  ],
                                )
                              ],
                            ),
                            const Gap(16),
                            _buildReviewCard(
                              initials: "JD", name: "Jane Doe", purchasedItem: "Lotus Bowl",
                              reviewText: "The texture on Srey Mao's work is unlike anything I've seen. You can feel the history in every curve of the clay. Truly a masterpiece for my home.",
                              avatarColor: const Color(0xFF475B6B),
                            ),
                            _buildReviewCard(
                              initials: "MK", name: "Mean Kim", purchasedItem: "Clay Vase",
                              reviewText: "Beautifully packaged and the story of the artisan made it such a special gift. Supporting local Cambodian talent through Kado has been wonderful.",
                              avatarColor: const Color(0xFFF2C94C),
                            ),
                            const Gap(40),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.2)),
        const Gap(4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B4513))),
      ],
    );
  }

  Widget _buildRatingColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1.2)),
        const Gap(4),
        Row(
          children: [
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B4513))),
            const Gap(2),
            const Icon(Icons.star, size: 16, color: Color(0xFFF2C94C)),
          ],
        )
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
  }

  Widget _buildNewProductCard(String title, String usdPrice, String khrPrice, String imageUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned(
                top: 8, right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 14,
                  child: Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF333333)), maxLines: 2, overflow: TextOverflow.ellipsis),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(usdPrice, style: const TextStyle(color: Color(0xFF8B4513), fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(khrPrice, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.shopping_cart, color: Colors.white, size: 14),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return Column(
      children: [
        _buildGalleryImage("https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=600", "Earth Preparation", 200, double.infinity),
        const Gap(12),
        Row(
          children: [
            Expanded(child: _buildGalleryImage("https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=400", "", 140, double.infinity)),
            const Gap(12),
            Expanded(child: _buildGalleryImage("https://images.unsplash.com/photo-1578321272176-b7bbc0679853?w=400", "", 140, double.infinity)),
          ],
        )
      ],
    );
  }

  Widget _buildGalleryImage(String url, String overlayText, double height, double width) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: CachedNetworkImageProvider(url),
          fit: BoxFit.cover,
        ),
      ),
      child: overlayText.isNotEmpty 
        ? Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                stops: const [0.6, 1.0],
              ),
            ),
            child: Text(overlayText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        : null,
    );
  }

  Widget _buildReviewCard({required String initials, required String name, required String purchasedItem, required String reviewText, required Color avatarColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF7F5F0), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: avatarColor, radius: 20, child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333333))),
                    Text('Purchased: $purchasedItem', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Row(children: List.generate(5, (index) => const Icon(Icons.star, color: Color(0xFFF2C94C), size: 16))),
            ],
          ),
          const Gap(12),
          Text('"$reviewText"', style: const TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF555555), height: 1.5, fontSize: 14)),
        ],
      ),
    );
  }
}