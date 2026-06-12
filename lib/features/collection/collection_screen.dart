import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/app_scaffold.dart';

import '../../theme/app_colors.dart';

class CollectionScreen extends StatelessWidget {
  final String collectionId;

  const CollectionScreen({Key? key, required this.collectionId}) : super(key: key);

  Future<Map<String, dynamic>> _loadScreenData() async {
    final String collectionString = await rootBundle.loadString('assets/mock/collections.json');
    final List<dynamic> collectionList = json.decode(collectionString);
    final collectionData = collectionList.firstWhere(
      (item) => item['id'] == collectionId, 
      orElse: () => collectionList.first
    );

    final String productString = await rootBundle.loadString('assets/mock/items.json');
    final List<dynamic> productList = json.decode(productString);
    
    final List<dynamic> collectionProducts = productList
        .where((product) => (collectionData['productIds'] as List).contains(product['id']))
        .toList();

    return {
      'collection': collectionData,
      'products': collectionProducts,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<Map<String, dynamic>>(
      future: _loadScreenData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppScaffold(
            currentIndex: 1, 
            body: Center(child: CircularProgressIndicator(color: Color(0xFF8B4513))),
          );
        }

        if (snapshot.hasError) {
          return AppScaffold(
            currentIndex: 1,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final collection = snapshot.data!['collection'];
        final products = snapshot.data!['products'] as List<dynamic>;

        return AppScaffold(
          currentIndex: 1,
          body: Container(
            color: isDark ? AppColors.backgroundDark : const Color(0xFFFDFBF7),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.0,
                  pinned: true,
                  backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFF4A3B32),
                  iconTheme: const IconThemeData(color: Colors.white),
                  actions: [
                    IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () {}),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      collection['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                    ),
                    centerTitle: true,
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: collection['coverImageUrl'],
                          fit: BoxFit.cover,
                        ),
                        Container(color: Colors.black.withOpacity(0.4)),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2C94C).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            collection['occasion'].toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF8B4513), 
                              fontWeight: FontWeight.bold, 
                              fontSize: 12, 
                              letterSpacing: 1.2
                            ),
                          ),
                        ),
                        const Gap(16),
                        Text(
                          collection['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15, 
                            color: isDark ? AppColors.textSecondaryDark : const Color(0xFF555555), 
                            height: 1.6
                          ),
                        ),
                        const Gap(32),
                        Divider(color: isDark ? AppColors.grey800 : const Color(0xFFE0D8D0)),
                        const Gap(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${products.length} Exclusive Items",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 16, 
                                color: isDark ? AppColors.textPrimaryDark : const Color(0xFF4A3B32)
                              ),
                            ),
                            const Icon(Icons.tune, color: Color(0xFF8B4513)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,        
                      mainAxisSpacing: 16.0,       
                      crossAxisSpacing: 16.0,      
                      childAspectRatio: 0.75,      
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return _buildGridProductCard(context, product);
                      },
                      childCount: products.length,
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: Gap(40)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridProductCard(BuildContext context, Map<String, dynamic> product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.black.withOpacity(0.2) : AppColors.black.withOpacity(0.04), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: product['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: CircleAvatar(
                    backgroundColor: isDark ? AppColors.grey800 : Colors.white,
                    radius: 14,
                    child: Icon(Icons.favorite_border, size: 16, color: isDark ? AppColors.grey400 : Colors.grey),
                  ),
                )
              ],
            ),
          ),
     
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'], 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 13, 
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF333333)
                  ), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis
                ),
                const Gap(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${product['price'].toStringAsFixed(2)}", 
                      style: const TextStyle(color: Color(0xFF8B4513), fontWeight: FontWeight.bold, fontSize: 14)
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513), 
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: const Icon(Icons.shopping_cart, color: Colors.white, size: 12),
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
}