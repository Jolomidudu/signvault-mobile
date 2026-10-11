import '../models/signature_preview.dart';

const mockUserName = 'Alex Morgan';

const mockSignatures = <SignaturePreview>[
  SignaturePreview(
    id: 'professional',
    name: 'Professional',
    category: 'Work',
    status: SignatureStatus.active,
    updatedLabel: 'Updated today',
    preview: 'Alex Morgan',
  ),
  SignaturePreview(
    id: 'personal',
    name: 'Personal',
    category: 'Personal',
    status: SignatureStatus.active,
    updatedLabel: 'Updated Oct 8',
    preview: 'Alex M.',
  ),
  SignaturePreview(
    id: 'business',
    name: 'Business',
    category: 'Business',
    status: SignatureStatus.active,
    updatedLabel: 'Updated Oct 4',
    preview: 'A. Morgan',
  ),
  SignaturePreview(
    id: 'initials',
    name: 'Initials',
    category: 'Personal',
    status: SignatureStatus.archived,
    updatedLabel: 'Updated Sep 28',
    preview: 'AM',
  ),
];

class ActivityPreview {
  const ActivityPreview({
    required this.title,
    required this.detail,
    required this.when,
    required this.icon,
  });
  final String title;
  final String detail;
  final String when;
  final String icon;
}

const mockActivity = <ActivityPreview>[
  ActivityPreview(
    title: 'Professional signature created',
    detail: 'Added to your vault',
    when: 'Today, 9:42 AM',
    icon: 'create',
  ),
  ActivityPreview(
    title: 'Personal signature updated',
    detail: 'Version 2 saved',
    when: 'Oct 8, 4:18 PM',
    icon: 'edit',
  ),
  ActivityPreview(
    title: 'Business signature copied',
    detail: 'Copied to clipboard',
    when: 'Oct 4, 11:06 AM',
    icon: 'copy',
  ),
];
