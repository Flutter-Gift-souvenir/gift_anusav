import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/artisan_model.dart';

class ArtisanScreen extends StatelessWidget {
  final String artisanId;

  const ArtisanScreen({Key? key, required this.artisanId}) : super(key: key);

  Future<Artisan> _loadArtisanData() async {
    final String response = await rootBundle.loadString('assets/mock/artisans.json');
    final List<dynamic> data = json.decode(response);
    
    final artisanMap = data.firstWhere(
      (item) => item['id'] == artisanId, 
      orElse: () => data.first
    );
    
    return Artisan.fromJson(artisanMap);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Artisan>(
      future: _loadArtisanData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFDFBF7),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF8B4513))),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error loading artisan: ${snapshot.error}')),
          );
        }

        final artisan = snapshot.data!;

        return Scaffold(
          backgroundColor: const Color(0xFFFDFBF7),
          body: CustomScrollView(
            slivers: [
              // Hero Image AppBar
              SliverAppBar(
                expandedHeight: 350.0,
                pinned: true,
                backgroundColor: const Color(0xFF8B4513),
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: artisan.photoUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              
              // Content Body
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  artisan.name,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF4A3B32),
                                  ),
                                ),
                                const Gap(8),
                                if (artisan.isVerified)
                                  const Icon(Icons.verified, color: Color(0xFFC17F59), size: 24),
                              ],
                            ),
                          ),
                          IconButton(
                            style: IconButton.styleFrom(backgroundColor: const Color(0xFFF2E8DF)),
                            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF8B4513)),
                            onPressed: () {},
                          )
                        ],
                      ),
                      const Gap(4),
                      Text(
                        artisan.specialty,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF8B4513)),
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18, color: Colors.grey),
                          const Gap(4),
                          Text(artisan.location, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                      const Gap(24),
                      
                      // Stats
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(Icons.star, artisan.rating.toString(), 'Rating', Colors.amber),
                            _buildDivider(),
                            _buildStatItem(Icons.inventory_2_outlined, artisan.productCount.toString(), 'Items', Colors.grey),
                            _buildDivider(),
                            _buildStatItem(Icons.history, '${artisan.yearsOfExperience}y', 'Experience', Colors.grey),
                          ],
                        ),
                      ),
                      const Gap(32),
                      
                      // Story
                      const Text("The Story Behind the Maker", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                      const Gap(12),
                      Text(artisan.story, style: const TextStyle(fontSize: 15, height: 1.6, color: Color(0xFF6B5D54))),
                      const Gap(32),

                      // Skills
                      const Text("Crafting Skills", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                      const Gap(12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: artisan.skills.map((skill) {
                          return Chip(
                            label: Text(skill),
                            labelStyle: const TextStyle(color: Color(0xFF8B4513), fontSize: 12),
                            backgroundColor: const Color(0xFFF2E8DF),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          );
                        }).toList(),
                      ),
                      const Gap(40),

                      // --- NEW: Artisan Products Section ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Crafted Items", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                          TextButton(
                            onPressed: () {}, 
                            child: const Text("View All", style: TextStyle(color: Color(0xFF8B4513))),
                          )
                        ],
                      ),
                      const Gap(12),
                      SizedBox(
                        height: 220,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildProductCard("Silk Scarf", "\$45.00", "https://images.unsplash.com/photo-1606293926075-69a00dbfde81?w=400"),
                            _buildProductCard("Ceramic Bowl", "\$32.00", "https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=400"),
                            _buildProductCard("Woven Basket", "\$28.00", "https://images.unsplash.com/photo-1590727263595-15104d5da470?w=400"),
                          ],
                        ),
                      ),
                      const Gap(40),

                      // --- NEW: Themed Collections Section ---
                      const Text("Featured In Collections", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                      const Gap(16),
                      _buildCollectionCard("Pchum Ben Offerings", "Traditional gifts for ancestors", "https://images.unsplash.com/photo-1601614408160-26463990cbac?w=600"),
                      const Gap(12),
                      _buildCollectionCard("Songkran Heritage Set", "Festive handcrafted pieces", "https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=600"),
                      const Gap(40),

                      // --- NEW: Customer Reviews Section ---
                      const Text("Customer Experiences", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A3B32))),
                      const Gap(16),
                      // Matches "image_04b0e6.png" exactly
                      _buildReviewCard(
                        initials: "JD",
                        name: "Jane Doe",
                        purchasedItem: "Lotus Bowl",
                        reviewText: "The texture on Srey Mao's work is unlike anything I've seen. You can feel the history in every curve of the clay. Truly a masterpiece for my home.",
                        avatarColor: const Color(0xFF475B6B),
                      ),
                      _buildReviewCard(
                        initials: "MK",
                        name: "Mean Kim",
                        purchasedItem: "Clay Vase",
                        reviewText: "Beautifully packaged and the story of the artisan made it such a special gift. Supporting local Cambodian talent through Kado has been wonderful.",
                        avatarColor: const Color(0xFFF2C94C),
                      ),
                      const Gap(40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildStatItem(IconData icon, String value, String label, Color iconColor) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const Gap(4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        const Gap(4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.grey.shade300);
  }

  // Horizontal Product Card
  Widget _buildProductCard(String title, String price, String imageUrl) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const Gap(4),
                Text(price, style: const TextStyle(color: Color(0xFF8B4513), fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // Wide Collection Banner
  Widget _buildCollectionCard(String title, String subtitle, String imageUrl) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: CachedNetworkImageProvider(imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // Review Card based on "image_04b0e6.png"
  Widget _buildReviewCard({
    required String initials,
    required String name,
    required String purchasedItem,
    required String reviewText,
    required Color avatarColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F5F0), // Light beige background matching the image
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 20,
                child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
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
              Row(
                children: List.generate(5, (index) => const Icon(Icons.star, color: Color(0xFFF2C94C), size: 16)),
              ),
            ],
          ),
          const Gap(12),
          Text(
            '"$reviewText"',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Color(0xFF555555),
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}