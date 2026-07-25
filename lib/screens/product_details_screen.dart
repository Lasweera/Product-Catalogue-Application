import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/favourites_provider.dart';
import '../widgets/product_image.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFavourite = context.select<FavouritesProvider, bool>(
          (favourites) => favourites.isFavourite(product.id),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 320,
            backgroundColor: theme.colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: ProductImage(imageUrl: product.imageUrl),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _FavouriteButton(
                  isFavourite: isFavourite,
                  onTap: () => context
                      .read<FavouritesProvider>()
                      .toggleFavourite(product.id),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(
                    label: Text(product.category),
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    product.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(color: theme.colorScheme.outlineVariant),
                  const SizedBox(height: 20),
                  Text(
                    'Description',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context
                          .read<FavouritesProvider>()
                          .toggleFavourite(product.id),
                      icon: Icon(
                        isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                      ),
                      label: Text(
                        isFavourite
                            ? 'Remove from Favourites'
                            : 'Add to Favourites',
                      ),
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

class _FavouriteButton extends StatelessWidget {
  const _FavouriteButton({required this.isFavourite, required this.onTap});

  final bool isFavourite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            color: isFavourite ? Colors.redAccent : Colors.white,
          ),
        ),
      ),
    );
  }
}