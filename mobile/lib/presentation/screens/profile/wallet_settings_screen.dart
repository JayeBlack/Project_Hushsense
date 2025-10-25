import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';

class WalletSettingsScreen extends ConsumerWidget {
  const WalletSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppConstants.textPrimary),
        ),
        title: const Text(
          'Wallet Settings',
          style: TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Funnel Sans',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage your HUSH wallet, connect accounts, and view blockchain details.',
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontFamily: 'Funnel Sans',
              ),
            ),
            const SizedBox(height: AppConstants.paddingXL),
            _buildWalletCard(),
            const SizedBox(height: AppConstants.paddingL),
            ListTile(
              leading: const Icon(Icons.key, color: AppConstants.primaryTeal),
              title: const Text('Export Private Key', style: TextStyle(fontFamily: 'Funnel Sans')),
              subtitle: const Text('Backup your wallet key securely', style: TextStyle(fontFamily: 'Funnel Sans')),
              onTap: () {
                // TODO: Export private key
              },
            ),
            ListTile(
              leading: const Icon(Icons.link, color: AppConstants.primaryTeal),
              title: const Text('Connect External Wallet', style: TextStyle(fontFamily: 'Funnel Sans')),
              subtitle: const Text('Link MetaMask, Ledger, or other', style: TextStyle(fontFamily: 'Funnel Sans')),
              onTap: () {
                // TODO: Connect external wallet
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: AppConstants.primaryTeal),
              title: const Text('Wallet Security', style: TextStyle(fontFamily: 'Funnel Sans')),
              subtitle: const Text('Set up PIN, biometrics, or 2FA', style: TextStyle(fontFamily: 'Funnel Sans')),
              onTap: () {
                // TODO: Wallet security settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.history, color: AppConstants.primaryTeal),
              title: const Text('Transaction History', style: TextStyle(fontFamily: 'Funnel Sans')),
              subtitle: const Text('See all blockchain transactions', style: TextStyle(fontFamily: 'Funnel Sans')),
              onTap: () {
                // TODO: Show transaction history
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryTeal,
            AppConstants.primaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryTeal.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Wallet Balance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Funnel Sans',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppConstants.accentGold,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Connected',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Funnel Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingL),
          const Text(
            '2,847',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Funnel Sans',
            ),
          ),
          Text(
            '\$HUSH Tokens',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
              fontFamily: 'Funnel Sans',
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Text(
            '≈ \$142.35 USD',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.7),
              fontFamily: 'Funnel Sans',
            ),
          ),
        ],
      ),
    );
  }
}
