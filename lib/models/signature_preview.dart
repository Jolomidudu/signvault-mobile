enum SignatureStatus { active, archived }

class SignaturePreview {
  const SignaturePreview({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.updatedLabel,
    required this.preview,
  });

  final String id;
  final String name;
  final String category;
  final SignatureStatus status;
  final String updatedLabel;
  final String preview;
}
