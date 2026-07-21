import 'models.dart';

class MockData {
  MockData._();

  static const List<RecentDocument> recentDocuments = [
    RecentDocument('Service_Agreement_V4.pdf', 'Processed'),
    RecentDocument('NDA_Partner_Final.docx', 'Flagged'),
    RecentDocument('Vendor_Policy_2024.pdf', 'Archived'),
  ];

  static const List<TrendingRisk> trendingRisks = [
    TrendingRisk(
      badge: 'HIGH RISK',
      title: 'New SaaS Compliance Changes in EU',
      description:
          'Article 14 adjustments may affect how your user data is stored.',
    ),
    TrendingRisk(
      badge: 'UPDATE',
      title: 'Freelance Contract Loophole Found',
      description:
          'Arbitration clauses in major platforms are being challenged in court.',
    ),
  ];

  static const List<TrendingRisk> highRiskAlertsDark = [
    TrendingRisk(
      badge: 'CRITICAL',
      title: 'New EU Data Privacy Shift (Q4)',
      description: 'Update clauses for sub-processors required by Nov 15.',
    ),
    TrendingRisk(
      badge: 'MODERATE',
      title: 'IP Protection in AI Assets',
      description:
          'Revised standard for copyright of machine-gen assets.',
    ),
  ];

  static const List<ChatMessage> chatThread = [
    ChatMessage(
      fromBot: true,
      text: 'Greetings. I have analyzed the "Service Termination" section. '
          'Clause 12.4 contains an ambiguous "at-will" definition that may '
          'bypass local labor laws.',
    ),
    ChatMessage(
      fromBot: false,
      text: "Can you highlight the specific phrases that constitute the "
          "'Grey Area' in that clause?",
    ),
    ChatMessage(
      fromBot: true,
      text: 'Certainly. The phrases are highlighted below:',
    ),
  ];

  static const List<EmergencyService> emergencyServices = [
    EmergencyService(
      id: '001-505',
      title: 'National Emergency',
      description:
          'Unified helpline for all immediate emergencies including police, '
          'ambulance, and fire services.',
      number: '112',
    ),
    EmergencyService(
      id: '109-INFO',
      title: 'Women Helpline',
      description:
          'Specialized support for women in distress, domestic safety, and '
          'immediate legal assistance.',
      number: '1091',
    ),
    EmergencyService(
      id: '108-CYB',
      title: 'Cyber Crime',
      description:
          'Reporting portal and assistance for financial fraud, identity '
          'theft, and online harassment.',
      number: '1930',
    ),
    EmergencyService(
      id: '108-KID',
      title: 'Child Helpline',
      description:
          '24-hour outreach service for children in need of care and '
          'protection.',
      number: '1098',
    ),
    EmergencyService(
      id: 'DEF-HAZ',
      title: 'Disaster Response',
      description:
          'Coordination for natural disasters, floods, earthquakes, and '
          'civil defense alerts.',
      number: '1078',
    ),
    EmergencyService(
      id: 'ESL-LEX',
      title: 'Legal Aid',
      description:
          'Free legal services and advice for marginalized sections of '
          'society and urgent counsel.',
      number: '1516',
    ),
  ];

  static const List<String> indianStates = [
    'Delhi',
    'Kerala',
    'Maharashtra',
    'Karnataka',
    'Tamil Nadu',
    'Uttar Pradesh',
    'West Bengal',
    'Gujarat',
  ];
}
