import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import '../../theme/app_colors.dart';
import 'booking_cache.dart'; // Handles local caching for your /booking page tracker

class BookingScreen extends StatefulWidget {
  final String productId;

  const BookingScreen({
    super.key,
    required this.productId,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Customization States
  bool _includeGiftWrap = false;
  bool _includeGreetingCard = false;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _recipientController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));

  // Pure Frontend Mock Data List
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Handwoven Golden Silk Lotus Scarf',
      category: 'Textiles',
      isAvailable: true,
      description: 'Inspired by the lotus flowers of the Tonle Sap lake, this scarf is hand-woven by women from the Siem Reap province.',
      price: 120.00,
      imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=600',
      rating: 4.8,
      reviewCount: 24,
      artisanName: 'Sopheak Vuthy',
      artisanId: 'artisan_01',
      origin: 'Siem Reap Province',
      tags: ['Silk', 'Scarves', 'Traditional'],
      images: ['https://images.unsplash.com/photo-1544816155-12df9643f363?q=80&w=600'],
    ),
    Product(
      id: '2',
      name: 'Cambodian Silver Plated Bracelet',
      category: 'Jewelry',
      isAvailable: true,
      description: 'Crafted carefully in the historical silver-smithing village of Kampong Luong.',
      price: 45.00,
      imageUrl: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600',
      rating: 4.9,
      reviewCount: 18,
      artisanName: 'Chantha Piseth',
      artisanId: 'artisan_02',
      origin: 'Kandal Province',
      tags: ['Silver', 'Jewelry', 'Handcarved'],
      images: ['https://images.unsplash.com/photo-1611591437281-460bfbe1220a?q=80&w=600'],
    ),
    Product(
      id: '3',
      name: 'Premium Cotton Krama Scarf',
      category: 'Textiles',
      isAvailable: true,
      description: 'The iconic traditional Cambodian gingham scarf woven with love.',
      price: 15.00,
      imageUrl: 'https://images.unsplash.com/photo-1520635360276-79f3dbd809f6?q=80&w=600',
      rating: 4.7,
      reviewCount: 32,
      artisanName: 'Srey Mom',
      artisanId: 'artisan_03',
      origin: 'Takeo Province',
      tags: ['Cotton', 'Krama', 'Everyday'],
      images: ['https://images.unsplash.com/photo-1520635360276-79f3dbd809f6?q=80&w=600'],
    ),
    Product(
      id: '4',
      name: 'Handmade Kampot Ceramic Teaset',
      category: 'Ceramics',
      isAvailable: true,
      description: 'An elegant clay teaset sculpted carefully using the iconic rich, iron-dense clay.',
      price: 65.00,
      imageUrl: 'https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600',
      rating: 4.9,
      reviewCount: 12,
      artisanName: 'Kosal Sopheap',
      artisanId: 'artisan_04',
      origin: 'Kampot Province',
      tags: ['Clay', 'Ceramics', 'Kitchen'],
      images: ['https://images.unsplash.com/photo-1576092768241-dec231879fc3?q=80&w=600'],
    ),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = isDark ? AppColors.grey900 : AppColors.grey100;

    final product = _mockProducts.firstWhere(
      (p) => p.id == widget.productId || 
             widget.productId.toLowerCase().contains(p.id.toLowerCase()) ||
             p.name.toLowerCase().contains(widget.productId.toLowerCase()),
      orElse: () {
        int index = int.tryParse(widget.productId) ?? 1;
        if (index > 0 && index <= _mockProducts.length) {
          return _mockProducts[index - 1];
        }
        return _mockProducts.first;
      },
    );

    double addonTotal = 0.0;
    if (_includeGiftWrap) addonTotal += 5.0;
    if (_includeGreetingCard) addonTotal += 2.5;
    double finalTotal = product.price + addonTotal;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Customize Kado',
          style: theme.textTheme.titleLarge?.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Summary Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(4),
                                Text(
                                  'by ${product.artisanName}',
                                  style: theme.textTheme.bodySmall?.copyWith(color: textSecondary),
                                ),
                                const Gap(4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(24),

                    // Recipient Input
                    Text(
                      'Who is this gift for?',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    TextFormField(
                      controller: _recipientController,
                      decoration: InputDecoration(
                        hintText: "Recipient's Name",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                    ),
                    const Gap(24),

                    // Delivery Date Picker
                    Text(
                      'Desired Delivery Date',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.dividerColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
                                const Gap(12),
                                Text(
                                  "${_selectedDate.toLocal()}".split(' ')[0],
                                  style: theme.textTheme.bodyLarge?.copyWith(color: textPrimary),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    const Gap(24),

                    // Customization Add-ons
                    Text(
                      'Gift Customization Options',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    CheckboxListTile(
                      title: const Text('Premium Traditional Wrapping'),
                      subtitle: const Text('+\$5.00'),
                      secondary: const Icon(Icons.card_giftcard, color: AppColors.gold),
                      value: _includeGiftWrap,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _includeGiftWrap = val ?? false),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    CheckboxListTile(
                      title: const Text('Handwritten Greeting Card'),
                      subtitle: const Text('+\$2.50'),
                      secondary: const Icon(Icons.rate_review_outlined, color: AppColors.gold),
                      value: _includeGreetingCard,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _includeGreetingCard = val ?? false),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    const Gap(24),

                    // Gift Letter Message Box
                    Text(
                      'Personal Message / Special Requests',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Gap(8),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Write a warm letter text or special instructions for the artisan...",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Summary Control Dock
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Price', style: TextStyle(color: textSecondary, fontSize: 14)),
                          Text(
                            '\$${finalTotal.toStringAsFixed(2)}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext ctx) => AlertDialog(
                                title: const Row(
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.green),
                                    Gap(8),
                                    Text('Kado Confirmed!'),
                                  ],
                                ),
                                content: const Text('Your customization settings have been mocked locally. When we hook up Supabase next week, this transaction will insert live records directly into the backend database tables!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // 1. Log order items cache into the notifier state background layer
                                      bookedItemsNotifier.value = [
                                        ...bookedItemsNotifier.value,
                                        {
                                          'id': product.id,
                                          'name': product.name,
                                          'price': finalTotal,
                                          'imageUrl': product.imageUrl,
                                          'recipient': _recipientController.text,
                                          'date': "${_selectedDate.toLocal()}".split(' ')[0],
                                          'status': _includeGiftWrap ? 'Gift Being Wrapped' : 'Order Processing',
                                          'progress': 0.75,
                                        }
                                      ];

                                      // 2. Dismiss the success dialog popup window
                                      Navigator.of(ctx).pop();
                                      
                                      // 3. 🎯 Redirects user back to Gifts view page tab layout
                                      context.go('/gifts');
                                    },
                                    child: const Text(
                                      'Awesome',
                                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text(
                          'Confirm Customization',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}