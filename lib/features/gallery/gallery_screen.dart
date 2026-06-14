import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class GalleryScreen extends StatefulWidget {
  final String artisanId;
  const GalleryScreen({super.key, required this.artisanId});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int selectedTabIndex = 0;

  final List<String> tabs = const [
    'Photos',
    'Videos',
  ];

  List<Map<String, String>> photos = [];
  List<Map<String, String>> videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGallery();
  }

  Future<void> _loadGallery() async {
    try {
      final loadedPhotos = await MockRepository.getGalleryByArtisanAndType(widget.artisanId, 'photo');
      final loadedVideos = await MockRepository.getGalleryByArtisanAndType(widget.artisanId, 'video');

      if (!mounted) return;

      setState(() {
        photos = loadedPhotos.map((e) => Map<String, String>.from({
              'title': e['title'] ?? '',
              'subtitle': e['subtitle'] ?? '',
              'image': e['image'] ?? e['thumbnail'] ?? '',
            })).toList();

        videos = loadedVideos.map((e) => Map<String, String>.from({
          'title': e['title'] ?? '',
          'subtitle': e['subtitle'] ?? '',
          'thumbnail': e['thumbnail'] ?? e['image'] ?? '',
          'duration': e['duration'] ?? '',
          'videoUrl': e['videoUrl'] ?? '',
        })).toList();

        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> openVideoUrl(String? videoUrl) async {
    if (videoUrl == null || videoUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video URL is not available')),
      );
      return;
    }

    final uri = Uri.parse(videoUrl.trim());

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open video')),
      );
    }
  }

  void openPhotoViewer(Map<String, String> photo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PhotoViewer(photo: photo),
      ),
    );
  }

  void showVideoPreview(Map<String, String> video) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const Gap(18),
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: video['thumbnail']!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),
              Text(
                video['title']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2B2118),
                ),
              ),
              const Gap(8),
              Text(
                'Video player can be connected later. This is frontend preview mode.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              const Gap(18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    openVideoUrl(video['videoUrl']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text(
                    'Watch Video',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFDFBF7),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Material(
      color: isDark ? const Color(0xFF121212) : const Color(0xFFFDFBF7),
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTopHeader(context),
                    const Gap(20),
                    buildHeroCard(context),
                    const Gap(20),
                    buildTabs(context),
                    const Gap(16),
                    Text(
                      selectedTabIndex == 0
                          ? 'Atelier Photos'
                          : 'Making Process Videos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF2B2118),
                      ),
                    ),
                    const Gap(6),
                    Text(
                      selectedTabIndex == 0
                          ? 'Explore moments from the artisan workshop.'
                          : 'Watch short previews about handmade production.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const Gap(16),
                  ],
                ),
              ),
            ),

            if (selectedTabIndex == 0)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final photo = photos[index];
                      return buildPhotoCard(context, photo, index);
                    },
                    childCount: photos.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.78,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final video = videos[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: buildVideoCard(context, video),
                      );
                    },
                    childCount: videos.length,
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: Gap(40)),
          ],
        ),
      ),
    );
  }

  Widget buildTopHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/artisan/${widget.artisanId}');
            }
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? Colors.grey.shade800 : const Color(0xFFE8DFD5),
              ),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 17,
              color: isDark ? Colors.white : const Color(0xFF2B2118),
            ),
          ),
        ),
        const Gap(14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Photos & Videos',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF2B2118),
                ),
              ),
              const Gap(2),
              Text(
                'Artisan ID: ${widget.artisanId}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF8B4513),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.photo_library_outlined,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget buildHeroCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String heroImage = photos.isNotEmpty
        ? (photos.first['image'] ?? '')
        : videos.isNotEmpty
            ? (videos.first['thumbnail'] ?? '')
            : 'https://images.unsplash.com/photo-1506806732259-39c2d0268443?w=1200';

    return Container(
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.22 : 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: heroImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
              ),
              errorWidget: (context, url, error) => Container(
                color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.78),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2C94C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'BEHIND THE ATELIER',
                      style: TextStyle(
                        color: Color(0xFF8B4513),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    'Discover the craft behind every gift',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '${photos.length} photos • ${videos.length} videos',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.82),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabs(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : const Color(0xFFE8DFD5),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedTabIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedTabIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF8B4513) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      index == 0
                          ? Icons.grid_view_rounded
                          : Icons.play_circle_outline_rounded,
                      size: 17,
                      color: selected
                          ? Colors.white
                          : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                    ),
                    const Gap(6),
                    Text(
                      tabs[index],
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : (isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget buildPhotoCard(BuildContext context, Map<String, String> photo, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => openPhotoViewer(photo),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : const Color(0xFFE8DFD5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.16 : 0.035),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: photo['image']!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                ),
                errorWidget: (context, url, error) => Container(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported_outlined),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.72),
                    ],
                    stops: const [0.45, 1.0],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.38),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.zoom_out_map_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      photo['title']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const Gap(3),
                    Text(
                      photo['subtitle']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 11,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildVideoCard(BuildContext context, Map<String, String> video) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => showVideoPreview(video),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : const Color(0xFFE8DFD5),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.16 : 0.035),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: video['thumbnail']!,
                    width: 110,
                    height: 92,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 110,
                      height: 92,
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 110,
                      height: 92,
                      color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.45),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF2B2118),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    video['subtitle']!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: Color(0xFF8B4513),
                      ),
                      const Gap(5),
                      Text(
                        video['duration']!,
                        style: const TextStyle(
                          color: Color(0xFF8B4513),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

class _PhotoViewer extends StatelessWidget {
  final Map<String, String> photo;

  const _PhotoViewer({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: CachedNetworkImage(
                imageUrl: photo['image']!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(4),
                        Text(
                          photo['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          photo['subtitle']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.72),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
