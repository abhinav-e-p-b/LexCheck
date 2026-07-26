import 'models.dart';

class MockData {
  MockData._();

  // ─── Home screen data ──────────────────────────────────────────────────────

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

  // ─── LexChat screen data ───────────────────────────────────────────────────

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

  // ─── Resources screen data ─────────────────────────────────────────────────

  /// All Indian legal / emergency resources.
  static const List<EmergencyService> emergencyServices = [
    // ── Emergency ────────────────────────────────────────────────────────────
    EmergencyService(
      id: 'EMG-001',
      title: 'National Emergency Helpline',
      category: 'Emergency',
      description:
          'Unified pan-India helpline that connects callers to police, '
          'ambulance and fire services in a single call. Available 24×7.',
      number: '112',
      website: 'https://www.112.gov.in',
      keywords: [
        'emergency', 'police', 'ambulance', 'fire', '112', 'urgent', 'help',
      ],
      emergencyGuidance:
          '1. Stay calm and speak clearly.\n'
          '2. State your exact location first.\n'
          '3. Describe the nature of the emergency.\n'
          '4. Keep the line open until dispatcher says to disconnect.\n'
          '5. Follow all instructions given by the dispatcher.',
      whenToUse:
          'Call 112 when there is an immediate threat to life or safety, '
          'including accidents, fire outbreaks, medical emergencies or '
          'crimes in progress.',
    ),
    EmergencyService(
      id: 'EMG-002',
      title: 'Police Control Room',
      category: 'Emergency',
      description:
          'Direct line to the local police control room for reporting '
          'crimes, filing complaints, or requesting immediate police presence.',
      number: '100',
      keywords: [
        'police', 'crime', 'theft', 'robbery', 'fir', 'complaint', '100',
      ],
      emergencyGuidance:
          '1. Clearly state that you need police assistance.\n'
          '2. Give your full address with landmark.\n'
          '3. Describe the incident briefly.\n'
          '4. Note the PCR van number when it arrives.\n'
          '5. Insist on getting an acknowledgement number for your complaint.',
      whenToUse:
          'Call 100 for crimes such as theft, assault, eve-teasing, '
          'robbery, or whenever you need immediate police intervention.',
    ),
    EmergencyService(
      id: 'EMG-003',
      title: 'Ambulance Service',
      category: 'Emergency',
      description:
          'National ambulance helpline for medical emergencies. '
          'Connects to the nearest government and private ambulance services.',
      number: '108',
      keywords: [
        'ambulance', 'medical', 'hospital', 'accident', 'injury', '108',
      ],
      emergencyGuidance:
          '1. Confirm the patient\'s breathing and pulse.\n'
          '2. Give the exact location including nearest landmark.\n'
          '3. Describe the condition (e.g., unconscious, bleeding).\n'
          '4. Do not move the patient unless there is immediate danger.\n'
          '5. Stay on the line for further instructions.',
      whenToUse:
          'Call 108 for any medical emergency including accidents, '
          'heart attacks, strokes, poisoning, or childbirth complications.',
    ),

    // ── Women Safety ─────────────────────────────────────────────────────────
    EmergencyService(
      id: 'WOM-001',
      title: 'Women Helpline (National)',
      category: 'Women Safety',
      description:
          'Round-the-clock helpline for women in distress. Provides '
          'immediate assistance, crisis intervention, and legal guidance '
          'for violence, harassment and sexual crimes.',
      number: '1091',
      website: 'https://www.ncw.nic.in',
      keywords: [
        'women', 'harassment', 'sexual assault', 'domestic violence',
        'abuse', '1091', 'ncw',
      ],
      emergencyGuidance:
          '1. Move to a safe location if possible before calling.\n'
          '2. State your name and current location.\n'
          '3. Describe the nature of the threat or violence.\n'
          '4. Ask for a Mahila Police vehicle if needed.\n'
          '5. Request shelter or medical assistance if required.',
      whenToUse:
          'Call 1091 if you are facing domestic violence, sexual '
          'harassment, stalking, acid attack threats, or any other '
          'gender-based violence.',
    ),
    EmergencyService(
      id: 'WOM-002',
      title: 'Nirbhaya Helpline',
      category: 'Women Safety',
      description:
          'Dedicated helpline for women facing sexual violence and '
          'harassment. Operated by the Ministry of Women & Child Development.',
      number: '181',
      keywords: [
        'nirbhaya', 'sexual violence', 'rape', 'women safety', '181',
        'helpline',
      ],
      emergencyGuidance:
          '1. Find a safe space before calling.\n'
          '2. Provide your location and describe the incident.\n'
          '3. Counsellors will guide you through legal steps.\n'
          '4. Medical aid and shelter can be arranged.',
      whenToUse:
          'Use 181 after any incident of sexual assault, or if you feel '
          'threatened and need immediate safety guidance and counselling.',
    ),
    EmergencyService(
      id: 'WOM-003',
      title: 'One Stop Centre (Sakhi)',
      category: 'Women Safety',
      description:
          'Government-run integrated support centres for women affected '
          'by violence. Offers medical aid, legal support, police assistance '
          'and temporary shelter under one roof.',
      number: '7827170170',
      website: 'https://wcd.nic.in/schemes/one-stop-centre-scheme',
      keywords: [
        'sakhi', 'one stop centre', 'shelter', 'women refuge',
        'domestic violence', 'legal aid women',
      ],
      emergencyGuidance:
          '1. Contact the OSC for immediate shelter needs.\n'
          '2. Medical examination can be arranged at the centre.\n'
          '3. Legal counsellors can help file FIR.\n'
          '4. Psycho-social support is available on site.',
      whenToUse:
          'Reach out to Sakhi if you need a safe place to stay, '
          'legal help, or medical assistance after experiencing '
          'any form of violence.',
    ),

    // ── Child Protection ──────────────────────────────────────────────────────
    EmergencyService(
      id: 'CHD-001',
      title: 'Childline India',
      category: 'Child Protection',
      description:
          '24-hour national helpline for children in distress, abuse, '
          'exploitation or those in need of care and protection. '
          'Free of cost, available in multiple languages.',
      number: '1098',
      website: 'https://www.childlineindia.org',
      keywords: [
        'child', 'childline', 'abuse', 'trafficking', 'missing child',
        '1098', 'minor', 'protection',
      ],
      emergencyGuidance:
          '1. Call 1098 – the call is free from any phone.\n'
          '2. Give the child\'s location and condition.\n'
          '3. Childline teams will be dispatched to help.\n'
          '4. Do NOT try to intervene in dangerous situations alone.',
      whenToUse:
          'Call 1098 when you find a child who is lost, abandoned, '
          'suffering abuse, bonded labour, trafficking or is in any form '
          'of distress.',
    ),
    EmergencyService(
      id: 'CHD-002',
      title: 'NCPCR Helpline',
      category: 'Child Protection',
      description:
          'National Commission for Protection of Child Rights helpline '
          'for reporting violations of child rights including educational '
          'rights, child labour and institutional abuse.',
      number: '1800-11-8036',
      website: 'https://ncpcr.gov.in',
      address: 'NCPCR, 5th Floor, Chanderlok Building, Janpath, New Delhi 110001',
      keywords: [
        'ncpcr', 'child rights', 'child labour', 'school rights',
        'educational rights', 'child commission',
      ],
      emergencyGuidance:
          '1. Document evidence of the violation if safe to do so.\n'
          '2. Note the child\'s details and location.\n'
          '3. File a complaint via the helpline or online portal.\n'
          '4. Follow up with your complaint number.',
      whenToUse:
          'Contact NCPCR when you observe child labour, denial of '
          'education, abuse in institutions, or any systematic violation '
          'of children\'s rights.',
    ),

    // ── Cyber Crime ──────────────────────────────────────────────────────────
    EmergencyService(
      id: 'CYB-001',
      title: 'Cyber Crime Helpline',
      category: 'Cyber Crime',
      description:
          'National helpline to report financial fraud, online scams, '
          'identity theft, online harassment and cyberbullying. '
          'Complaints are forwarded to the state cyber-crime police.',
      number: '1930',
      website: 'https://cybercrime.gov.in',
      keywords: [
        'cyber', 'fraud', 'scam', 'upi fraud', 'online harassment',
        'identity theft', '1930', 'cyberbullying', 'phishing',
      ],
      emergencyGuidance:
          '1. Do NOT transfer any more money after realising fraud.\n'
          '2. Call 1930 immediately – early reporting freezes funds.\n'
          '3. Keep all transaction IDs, screenshots and messages.\n'
          '4. File a detailed complaint on cybercrime.gov.in.\n'
          '5. Contact your bank to block compromised accounts/cards.',
      whenToUse:
          'Report on 1930 if you have been a victim of online financial '
          'fraud, received extortion/morphed image threats, experienced '
          'hacking, or faced cyberbullying.',
    ),
    EmergencyService(
      id: 'CYB-002',
      title: 'National Cyber Crime Portal',
      category: 'Cyber Crime',
      description:
          'Official government portal for lodging cyber crime complaints '
          'online. Handles cases related to cyber fraud, women and '
          'children related cybercrimes with anonymity options.',
      number: '1930',
      website: 'https://cybercrime.gov.in',
      keywords: [
        'cyber portal', 'online complaint', 'cyber crime report',
        'fraud complaint', 'online fir',
      ],
      emergencyGuidance:
          '1. Visit cybercrime.gov.in from a trusted device.\n'
          '2. Choose the correct category of offence.\n'
          '3. Upload all supporting evidence (screenshots, bank statements).\n'
          '4. Note your complaint reference number.\n'
          '5. Complaints are forwarded to state police within 24 hours.',
      whenToUse:
          'Use the portal when you need to file a formal online complaint '
          'with evidence, or if the crime does not require immediate response.',
    ),

    // ── Legal Aid ────────────────────────────────────────────────────────────
    EmergencyService(
      id: 'LEG-001',
      title: 'National Legal Services Authority',
      category: 'Legal Aid',
      description:
          'Free legal aid and services for economically weaker sections, '
          'SC/ST, women, children, persons with disabilities and victims '
          'of disasters or trafficking.',
      number: '15100',
      website: 'https://nalsa.gov.in',
      address: '12/11, Jam Nagar House, Shahjahan Road, New Delhi 110011',
      keywords: [
        'nalsa', 'legal aid', 'free lawyer', 'legal assistance',
        'lok adalat', 'legal services', '15100',
      ],
      emergencyGuidance:
          '1. Call 15100 to find your nearest Legal Services Authority.\n'
          '2. Carry identity proof and income documents if available.\n'
          '3. Explain your legal issue to the duty lawyer.\n'
          '4. Free representation in courts is provided if eligible.',
      whenToUse:
          'Contact NALSA if you cannot afford a lawyer, need someone to '
          'represent you in court, require help with bail proceedings, '
          'or need guidance on filing cases.',
    ),
    EmergencyService(
      id: 'LEG-002',
      title: 'District Legal Services Authority',
      category: 'Legal Aid',
      description:
          'Local authority in every district providing free legal '
          'services, Lok Adalats for out-of-court settlements, and '
          'pre-litigation mediation.',
      number: '15100',
      keywords: [
        'dlsa', 'district legal', 'lok adalat', 'mediation',
        'free legal', 'settlement',
      ],
      emergencyGuidance:
          '1. Locate your District Court complex.\n'
          '2. Visit the DLSA office during working hours (10AM–5PM).\n'
          '3. Fill the application form for legal aid.\n'
          '4. A panel lawyer will be assigned within 7 days.',
      whenToUse:
          'Approach DLSA for motor accident claims, labour disputes, '
          'matrimonial issues, land disputes, or any civil/criminal '
          'matter where you need free representation.',
    ),

    // ── Consumer Rights ──────────────────────────────────────────────────────
    EmergencyService(
      id: 'CON-001',
      title: 'National Consumer Helpline',
      category: 'Consumer Rights',
      description:
          'Government helpline for consumer grievances against defective '
          'products, deficient services, unfair trade practices, '
          'e-commerce fraud and overcharging.',
      number: '1800-11-4000',
      website: 'https://consumerhelpline.gov.in',
      keywords: [
        'consumer', 'fraud', 'product defect', 'refund', 'e-commerce',
        'overcharging', 'consumer forum', 'ncf',
      ],
      emergencyGuidance:
          '1. Gather all purchase receipts, bills and communication records.\n'
          '2. Call 1800-11-4000 or register on consumerhelpline.gov.in.\n'
          '3. Provide the company name, product details and grievance.\n'
          '4. Note your docket number for follow-up.\n'
          '5. Escalate to Consumer Forum if unresolved in 30 days.',
      whenToUse:
          'Contact NCH for product defects, service failures, online '
          'shopping fraud, banking grievances, or unfair trade practices '
          'by any business.',
    ),
    EmergencyService(
      id: 'CON-002',
      title: 'Consumer Forum (NCDRC)',
      category: 'Consumer Rights',
      description:
          'National Consumer Disputes Redressal Commission for consumer '
          'complaints above ₹2 crore. State and District commissions '
          'handle smaller disputes.',
      number: '1800-11-4000',
      website: 'https://ncdrc.nic.in',
      address: 'Upbhokta Nyay Bhawan, F-Block, GPO Complex, INA, New Delhi 110023',
      keywords: [
        'ncdrc', 'consumer court', 'consumer commission', 'consumer dispute',
        'compensation', 'consumer case',
      ],
      emergencyGuidance:
          '1. Attempt resolution with the company first (30-day notice).\n'
          '2. Identify which commission has jurisdiction based on claim amount.\n'
          '3. File a complaint with documents and ₹100–₹5000 court fee.\n'
          '4. Hearings are typically completed in 90–150 days.',
      whenToUse:
          'File a complaint with the Consumer Commission if negotiations '
          'with the company fail and you seek compensation for deficient '
          'services or defective products.',
    ),

    // ── Mental Health ────────────────────────────────────────────────────────
    EmergencyService(
      id: 'MNT-001',
      title: 'iCall Mental Health Helpline',
      category: 'Mental Health',
      description:
          'Free and confidential psychosocial support helpline run by '
          'Tata Institute of Social Sciences (TISS). Provides counselling '
          'for stress, anxiety, trauma and crisis situations.',
      number: '9152987821',
      website: 'https://icallhelpline.org',
      keywords: [
        'mental health', 'counselling', 'suicide', 'depression', 'anxiety',
        'stress', 'tiss', 'icall', 'therapy',
      ],
      emergencyGuidance:
          '1. Call during working hours (Mon–Sat, 8AM–10PM).\n'
          '2. All conversations are completely confidential.\n'
          '3. Say you are in crisis – a senior counsellor will assist.\n'
          '4. For immediate suicide risk call 112 for emergency response.',
      whenToUse:
          'Call iCall when experiencing severe stress, depression, '
          'suicidal thoughts, trauma, relationship crises, or when you '
          'need someone to talk to confidentially.',
    ),
    EmergencyService(
      id: 'MNT-002',
      title: 'Vandrevala Foundation 24x7',
      category: 'Mental Health',
      description:
          'Round-the-clock free mental health helpline for crisis '
          'intervention, suicide prevention and emotional support. '
          'Available in multiple languages.',
      number: '1860-2662-345',
      website: 'https://www.vandrevalafoundation.com',
      keywords: [
        'mental health 24x7', 'suicide prevention', 'crisis', 'emotional support',
        'vandrevala', 'helpline',
      ],
      emergencyGuidance:
          '1. Call anytime – available all 24 hours, 7 days.\n'
          '2. Tell the counsellor if you have suicidal thoughts for escalation.\n'
          '3. Request referral to a psychiatrist if required.\n'
          '4. Regular follow-up calls can be scheduled.',
      whenToUse:
          'Call this helpline at any hour – especially during night-time '
          'crises, panic attacks, or when you feel you cannot cope.',
    ),
    EmergencyService(
      id: 'MNT-003',
      title: 'NIMHANS Mental Health Helpline',
      category: 'Mental Health',
      description:
          'National Institute of Mental Health and Neurosciences helpline '
          'offering expert guidance on mental health conditions, treatment '
          'options and referrals to specialists.',
      number: '080-46110007',
      website: 'https://nimhans.ac.in',
      address: 'NIMHANS, Hosur Road, Bangalore 560029',
      keywords: [
        'nimhans', 'mental health expert', 'psychiatry', 'referral',
        'psychiatric emergency', 'bangalore',
      ],
      emergencyGuidance:
          '1. Call the helpline to speak with a trained mental health professional.\n'
          '2. Describe your symptoms and duration.\n'
          '3. Request nearest treatment centre referral.\n'
          '4. NIMHANS offers subsidised outpatient care.',
      whenToUse:
          'Contact NIMHANS when you need expert psychiatric guidance, '
          'diagnosis support, or a referral to a trusted mental health '
          'professional.',
    ),

    // ── Disaster Management ──────────────────────────────────────────────────
    EmergencyService(
      id: 'DIS-001',
      title: 'NDMA Disaster Helpline',
      category: 'Disaster Management',
      description:
          'National Disaster Management Authority helpline for natural '
          'disasters including floods, earthquakes, cyclones, landslides '
          'and industrial accidents.',
      number: '1078',
      website: 'https://ndma.gov.in',
      address: 'NDMA Bhawan, A-1, Safdarjung Enclave, New Delhi 110029',
      keywords: [
        'disaster', 'flood', 'earthquake', 'cyclone', 'landslide',
        'ndma', '1078', 'relief',
      ],
      emergencyGuidance:
          '1. Move to higher ground immediately in flood situations.\n'
          '2. Stay away from damaged structures after earthquakes.\n'
          '3. Call 1078 to report your location for rescue.\n'
          '4. Stay tuned to All India Radio for official evacuation orders.\n'
          '5. Do not spread unverified information.',
      whenToUse:
          'Call 1078 if you are trapped in or affected by a natural '
          'disaster and need rescue, relief supplies or evacuation guidance.',
    ),
    EmergencyService(
      id: 'DIS-002',
      title: 'Fire Emergency Services',
      category: 'Disaster Management',
      description:
          'National fire emergency number for reporting fires in '
          'residential, commercial or industrial premises. '
          'Also handles gas leaks and hazardous material incidents.',
      number: '101',
      keywords: [
        'fire', '101', 'gas leak', 'fire brigade', 'blaze', 'hazardous',
        'explosion',
      ],
      emergencyGuidance:
          '1. Alert all occupants and evacuate immediately.\n'
          '2. Call 101 from a safe distance.\n'
          '3. Provide the exact address and type of fire.\n'
          '4. Do NOT use lifts during a fire evacuation.\n'
          '5. Use wet cloth over nose/mouth in smoky environments.',
      whenToUse:
          'Call 101 for any fire emergency, gas leak, chemical spill, '
          'or situation requiring fire brigade intervention.',
    ),

    // ── Road Safety ──────────────────────────────────────────────────────────
    EmergencyService(
      id: 'ROD-001',
      title: 'Road Accident Emergency',
      category: 'Road Safety',
      description:
          'National Highway Authority of India helpline for road accidents '
          'on national highways. Dispatches ambulances, cranes and '
          'traffic police.',
      number: '1033',
      website: 'https://nhai.gov.in',
      keywords: [
        'road accident', 'highway', 'nhai', '1033', 'traffic', 'crash',
        'vehicle breakdown',
      ],
      emergencyGuidance:
          '1. Ensure your own safety first – move away from traffic.\n'
          '2. Call 1033 and state the highway number and kilometre marker.\n'
          '3. Do not move injured persons unless they are in immediate danger.\n'
          '4. Turn on hazard lights and set up warning triangles.\n'
          '5. Note the registration numbers of vehicles involved.',
      whenToUse:
          'Call 1033 for road accidents on national highways, vehicle '
          'breakdowns, or to report reckless driving that is causing danger.',
    ),
    EmergencyService(
      id: 'ROD-002',
      title: 'Traffic Police Helpline',
      category: 'Road Safety',
      description:
          'City traffic police helpline for reporting traffic violations, '
          'accidents, signal failures, road blockages and requesting '
          'traffic management assistance.',
      number: '103',
      keywords: [
        'traffic', 'traffic police', '103', 'signal', 'road block',
        'violation', 'challan',
      ],
      emergencyGuidance:
          '1. Note the location, time and nature of the incident.\n'
          '2. Photograph evidence if it is safe to do so.\n'
          '3. Report to 103 with the vehicle registration number if relevant.\n'
          '4. For accidents with injuries, also call 108 ambulance.',
      whenToUse:
          'Call 103 to report dangerous driving, accidents within city '
          'limits, broken traffic signals or for directions during '
          'major congestion events.',
    ),
  ];

  // ─── Emergency checklist items ─────────────────────────────────────────────

  static const List<String> lightChecklistItems = [
    'State your exact location clearly to the dispatcher.',
    'Keep the phone line open and do not disconnect.',
    'Identify immediate hazards around you.',
    'Maintain visual line-of-sight to the nearest exit.',
  ];

  static const List<String> darkChecklistItems = [
    'Contacted primary emergency services (112).',
    'Shared current geo-location with a trusted contact.',
    'Secured physical perimeter and enabled low-power mode.',
    'Documented incident details with timestamps.',
  ];

  // ─── Resource categories ───────────────────────────────────────────────────

  static const List<String> resourceCategories = [
    'Emergency',
    'Women Safety',
    'Child Protection',
    'Cyber Crime',
    'Legal Aid',
    'Consumer Rights',
    'Mental Health',
    'Disaster Management',
    'Road Safety',
  ];

  // ─── Onboarding data ──────────────────────────────────────────────────────

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
