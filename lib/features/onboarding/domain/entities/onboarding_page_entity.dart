class OnboardingPageEntity {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPageEntity({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

const kOnboardingPages = [
  OnboardingPageEntity(
    imagePath: 'assets/images/onboarding_1.png',
    title: 'Simple et intuitif',
    description:
        'Dolor sit amet, consectetur adipiscing elit. '
        'Pharetra sit lorem praesent eu ac nec dignissim. '
        'At eget nisl ultrices integer.',
  ),
  OnboardingPageEntity(
    imagePath: 'assets/images/onboarding_2.png',
    title: 'Familiale à souhait',
    description:
        'Dolor sit amet, consectetur adipiscing elit. '
        'Pharetra sit lorem praesent eu ac nec dignissim. '
        'At eget nisl ultrices integer.',
  ),
  OnboardingPageEntity(
    imagePath: 'assets/images/onboarding_3.png',
    title: 'Il faut sauver la terre',
    description:
        'Dolor sit amet, consectetur adipiscing elit. '
        'Pharetra sit lorem praesent eu ac nec dignissim. '
        'At eget nisl ultrices integer.',
  ),
];