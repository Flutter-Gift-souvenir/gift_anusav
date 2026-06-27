import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../models/product_model.dart';
import '../../theme/app_colors.dart';
import '../../data/supabase_repository.dart';

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

  // Real product loaded from Supabase
  Product? _product;
  bool _isLoadingProduct = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    final p = await SupabaseRepository.getProductById(widget.productId);
    if (!mounted) return;
    setState(() {
      _product = p;
      _isLoadingProduct = false;
    });
  }

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

    // Show spinner while the product loads from Supabase
    if (_isLoadingProduct) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_product == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(child: Text('Product not found')),
      );
    }
    final product = _product!;

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
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
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
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;
                          try {
                            // Save the booking to Supabase
                            await SupabaseRepository.createBooking(
                              productId: product.id,
                              productName: product.name,
                              productImageUrl: product.imageUrl,
                              price: finalTotal,
                              recipient: _recipientController.text,
                              note: _noteController.text,
                              deliveryDate:
                                  "${_selectedDate.toLocal()}".split(' ')[0],
                              giftWrap: _includeGiftWrap,
                              greetingCard: _includeGreetingCard,
                              status: _includeGiftWrap
                                  ? 'Gift Being Wrapped'
                                  : 'Order Processing',
                            );

                            if (!context.mounted) return;
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
                                content: const Text(
                                    'Your order has been saved. You can track it in My Orders.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      context.go('/booking'); // My Orders tab
                                    },
                                    child: const Text(
                                      'Awesome',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary),
                                    ),
                                  )
                                ],
                              ),
                            );
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString().contains('logged in')
                                      ? 'Please log in to place an order.'
                                      : 'Could not place order. Please try again.',
                                ),
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