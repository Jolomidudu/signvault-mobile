import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_widgets.dart';
import '../../mock/mock_data.dart';
import '../../models/signature_preview.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.appState, required this.child});
  final AppState appState;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selected = location.endsWith('vault')
        ? 1
        : location.endsWith('activity')
        ? 2
        : location.endsWith('profile')
        ? 3
        : 0;
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selected,
        onDestinationSelected: (index) => context.go(
          ['/app/home', '/app/vault', '/app/activity', '/app/profile'][index],
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.draw_outlined),
            selectedIcon: Icon(Icons.draw_rounded),
            label: 'Vault',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
    children: [
      const SignVaultWordmark(compact: true),
      const SizedBox(height: 30),
      Text(
        'Good morning,',
        style: AppTypography.body.copyWith(color: AppColors.muted),
      ),
      const SizedBox(height: 3),
      const Text(mockUserName, style: AppTypography.heading),
      const SizedBox(height: 24),
      Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Signature Vault',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '${mockSignatures.length} of 25 signatures',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.76)),
            ),
            const SizedBox(height: 17),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 0.16,
                minHeight: 6,
                backgroundColor: Color(0xFF41695C),
                color: Color(0xFFD4B779),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      PrimaryButton(
        label: 'Create Signature',
        icon: Icons.add,
        onPressed: () => context.go('/signatures/new'),
      ),
      const SizedBox(height: 30),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Recent Signatures', style: AppTypography.heading),
          TextButton(
            onPressed: () => context.go('/app/vault'),
            child: const Text('View all'),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ...mockSignatures
          .take(3)
          .map(
            (signature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SignatureCard(signature: signature),
            ),
          ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _QuickAction(
              icon: Icons.draw_outlined,
              label: 'Open Vault',
              onTap: () => context.go('/app/vault'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickAction(
              icon: Icons.history_rounded,
              label: 'Activity',
              onTap: () => context.go('/app/activity'),
            ),
          ),
        ],
      ),
    ],
  );
}

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _search = TextEditingController();
  bool _showArchived = true;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signatures = mockSignatures.where((signature) {
      final matchesText = '${signature.name} ${signature.category}'
          .toLowerCase()
          .contains(_search.text.toLowerCase());
      return matchesText &&
          (_showArchived || signature.status == SignatureStatus.active);
    }).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
      children: [
        const Text('Signature Vault', style: AppTypography.title),
        const SizedBox(height: 6),
        Text(
          '${mockSignatures.length} of 25 signatures',
          style: AppTypography.body.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Search signatures',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show archived'),
          value: _showArchived,
          onChanged: (value) => setState(() => _showArchived = value),
        ),
        const SizedBox(height: 8),
        if (signatures.isEmpty)
          const EmptyState(
            title: 'No signatures found',
            message: 'Try another search or create a new signature.',
          )
        else
          ...signatures.map(
            (signature) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SignatureCard(signature: signature),
            ),
          ),
        const SizedBox(height: 10),
        PrimaryButton(
          label: 'Create Signature',
          icon: Icons.add,
          onPressed: () => context.go('/signatures/new'),
        ),
      ],
    );
  }
}

class SignatureCard extends StatelessWidget {
  const SignatureCard({super.key, required this.signature});
  final SignaturePreview signature;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: [
        Container(
          width: 72,
          height: 58,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F6F3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            signature.preview,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'cursive',
              fontSize: 16,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signature.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${signature.category} · ${signature.updatedLabel}',
                style: AppTypography.caption.copyWith(color: AppColors.muted),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: signature.status == SignatureStatus.active
                ? const Color(0xFFE6F1EA)
                : const Color(0xFFF0F1EF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            signature.status == SignatureStatus.active ? 'Active' : 'Archived',
            style: TextStyle(
              fontSize: 11,
              color: signature.status == SignatureStatus.active
                  ? AppColors.success
                  : AppColors.muted,
            ),
          ),
        ),
      ],
    ),
  );
}

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Activity', style: AppTypography.title),
      const SizedBox(height: 6),
      Text(
        'Recent changes in your signature vault',
        style: AppTypography.body.copyWith(color: AppColors.muted),
      ),
      const SizedBox(height: 22),
      ...mockActivity.map(
        (item) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE7F0EA),
                child: Icon(
                  Icons.draw_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.detail,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      item.when,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.muted,
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
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.appState});
  final AppState appState;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text('Profile', style: AppTypography.title),
      const SizedBox(height: 22),
      Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Color(0xFFE7F0EA),
              child: Text(
                'AM',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mockUserName,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'alex.morgan@example.com',
                  style: TextStyle(color: AppColors.muted),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      for (final entry in const [
        (Icons.person_outline, 'Personal Information'),
        (Icons.security_outlined, 'Security'),
        (Icons.privacy_tip_outlined, 'Privacy'),
        (Icons.settings_outlined, 'Settings'),
        (Icons.help_outline, 'Help'),
      ])
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(entry.$1, color: AppColors.muted),
          title: Text(entry.$2),
          trailing: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.muted,
          ),
          onTap: () {},
        ),
      const SizedBox(height: 12),
      SecondaryButton(label: 'Sign Out', onPressed: appState.signOut),
    ],
  );
}

class CreateSignatureScreen extends StatelessWidget {
  const CreateSignatureScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create Signature')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: const Color(0xFFE5EFE9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.draw_outlined,
                size: 42,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Signature Designer', style: AppTypography.heading),
            const SizedBox(height: 8),
            Text(
              'The Signature Designer is coming in the next mobile phase.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 22),
            SecondaryButton(
              label: 'Back to Vault',
              onPressed: () => context.go('/app/vault'),
            ),
          ],
        ),
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
    child: Column(
      children: [
        const Icon(Icons.draw_outlined, size: 48, color: AppColors.primary),
        const SizedBox(height: 12),
        Text(title, style: AppTypography.heading),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.body.copyWith(color: AppColors.muted),
        ),
      ],
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(AppRadius.sm),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 7),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    ),
  );
}
