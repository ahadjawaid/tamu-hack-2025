//
//  SampleData.swift
//  HackTAMU25App
//
//  Created by tk on 1/25/25.
//

import SwiftData

@MainActor
class SampleData {
    static let shared = SampleData()
    
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init() {
        modelContainer = initializeModelContainer()
        
        do {
            insertSampleData()
            try context.save()
        } catch {
            fatalError("Could not initalize ModelContainer Data: \(error)")
        }
    }
    
    var profile: Profile = Profile(
       name: "Miss Reveille",
       profileImage: "profile_image"
    )
    
    var topics: [Topic] = [
        // MARK: - Biology (10)
        Topic(
            title: "Cell Structure",
            subtitle: "Basic Components",
            prompt: "Describe the main parts of a cell and their functions. Explore how organelles work together.",
            genre: .rock,
            category: .biology,
            userAdded: true
//            audioURL: "https://brainbeats1.s3.us-east-1.amazonaws.com/0bf3812b-6c62-4261-bc75-69d61f73a049/playlist6.m3u8"
        ),
        Topic(
            title: "Genetics",
            subtitle: "Heredity",
            prompt: "Explain how traits pass from parents to offspring. Include basic Mendelian concepts.",
            genre: .pop,
            category: .biology,
            userAdded: true
        ),
        Topic(
            title: "Photosynthesis",
            subtitle: "Energy Conversion",
            prompt: "Explore how plants convert light into chemical energy. Discuss the role of chlorophyll.",
            genre: .jazz,
            category: .biology,
            userAdded: true
        ),
        Topic(
            title: "Human Respiration",
            subtitle: "Gas Exchange",
            prompt: "Detail how oxygen and carbon dioxide move through the body. Describe lung function.",
            genre: .classical,
            category: .biology
        ),
        Topic(
            title: "Immunology",
            subtitle: "Defense Mechanisms",
            prompt: "Summarize how the immune system identifies and destroys pathogens. Mention key cells involved.",
            genre: .country,
            category: .biology
        ),
        Topic(
            title: "Microbiology",
            subtitle: "Microorganisms",
            prompt: "Explain differences between bacteria, viruses, and fungi. Consider their impact on health.",
            genre: .hiphop,
            category: .biology
        ),
        Topic(
            title: "Evolution",
            subtitle: "Natural Selection",
            prompt: "Outline how species adapt over generations. Discuss Darwin’s key observations.",
            genre: .rock,
            category: .biology
        ),
        Topic(
            title: "Ecology",
            subtitle: "Ecosystems",
            prompt: "Describe food webs and energy flow in ecosystems. Consider the impact of human activity.",
            genre: .pop,
            category: .biology
        ),
        Topic(
            title: "Neurobiology",
            subtitle: "Nervous System",
            prompt: "Examine how neurons transmit signals. Include the role of synapses in communication.",
            genre: .jazz,
            category: .biology
        ),
        Topic(
            title: "Endocrinology",
            subtitle: "Hormonal Regulation",
            prompt: "Discuss how hormones control bodily functions. Focus on feedback loops in the endocrine system.",
            genre: .classical,
            category: .biology
        ),

        // MARK: - Finance (10)
        Topic(
            title: "Budgeting",
            subtitle: "Personal Finance",
            prompt: "Create a basic monthly budget. Identify areas to save and reduce expenses.",
            imageURL: "https://media.discordapp.net/attachments/1331744956271820881/1333009781895729172/budgeting_background.png?ex=6797559a&is=6796041a&hm=66c882bc2425abfd301268415ad7e5a9849e307b25c58992e7e585b0036c1404&=&format=webp&quality=lossless&width=917&height=935",
            genre: .country,
            category: .finance,
            recommended: true
        ),
        Topic(
            title: "Investing Basics",
            subtitle: "Stocks and Bonds",
            prompt: "Compare different investment vehicles. Highlight risk vs. reward factors.",
            imageURL: "https://media.discordapp.net/attachments/1331744956271820881/1333009782373613568/investing_background.png?ex=6797559a&is=6796041a&hm=7291b138c7ddee890637bd7077feca171dbd5a604cda944360433e93c568a458&=&format=webp&quality=lossless&width=917&height=935",
            genre: .hiphop,
            category: .finance,
            recommended: true
        ),
        Topic(
            title: "Retirement Planning",
            subtitle: "Long-term Saving",
            prompt: "Explore strategies for retirement accounts. Focus on compound interest.",
            imageURL: "https://media.discordapp.net/attachments/1331744956271820881/1333009781538947225/retirement_background.png?ex=6797559a&is=6796041a&hm=e789e00a578120c6b35c35fd731473a1f75a1b65f20260a01480b449fd72b71b&=&format=webp&quality=lossless&width=913&height=932",
            genre: .rock,
            category: .finance,
            recommended: true
        ),
        Topic(
            title: "Cryptocurrency",
            subtitle: "Digital Assets",
            prompt: "Explain the basics of blockchain and crypto trading. Consider potential risks.",
            genre: .pop,
            category: .finance
        ),
        Topic(
            title: "Real Estate",
            subtitle: "Property Investment",
            prompt: "Discuss factors for successful real estate investment. Include location and market trends.",
            genre: .jazz,
            category: .finance
        ),
        Topic(
            title: "Credit Scores",
            subtitle: "Financial Health",
            prompt: "Describe how credit scores are calculated. Provide tips to improve credit.",
            genre: .classical,
            category: .finance
        ),
        Topic(
            title: "Taxes",
            subtitle: "Filing & Deductions",
            prompt: "Outline the process of filing taxes. Consider how deductions and credits reduce liability.",
            genre: .country,
            category: .finance
        ),
        Topic(
            title: "Insurance",
            subtitle: "Risk Management",
            prompt: "Review different types of insurance. Emphasize how to choose adequate coverage.",
            genre: .hiphop,
            category: .finance
        ),
        Topic(
            title: "Financial Markets",
            subtitle: "Trading & Exchanges",
            prompt: "Describe how stock markets function. Mention how supply and demand affect prices.",
            genre: .rock,
            category: .finance
        ),
        Topic(
            title: "Emergency Fund",
            subtitle: "Safety Net",
            prompt: "Discuss the purpose of an emergency fund. Calculate ideal savings for unexpected costs.",
            genre: .pop,
            category: .finance
        ),

        // MARK: - Health (10)
        Topic(
            title: "Nutrition",
            subtitle: "Balanced Diet",
            prompt: "Outline essential nutrients for a healthy diet. Highlight examples of balanced meals.",
            genre: .jazz,
            category: .health
        ),
        Topic(
            title: "Mental Health",
            subtitle: "Stress Management",
            prompt: "Identify coping techniques for stress. Consider deep breathing and mindfulness.",
            genre: .classical,
            category: .health
        ),
        Topic(
            title: "Exercise",
            subtitle: "Physical Activity",
            prompt: "Propose a weekly workout routine. Include benefits of strength and cardio training.",
            genre: .country,
            category: .health
        ),
        Topic(
            title: "Sleep Hygiene",
            subtitle: "Rest & Recovery",
            prompt: "Explain how consistent sleep schedules improve health. Offer tips for better sleep.",
            genre: .hiphop,
            category: .health
        ),
        Topic(
            title: "Hydration",
            subtitle: "Daily Water Intake",
            prompt: "Discuss the importance of adequate fluid intake. Include signs of dehydration.",
            genre: .rock,
            category: .health
        ),
        Topic(
            title: "Immunity Boost",
            subtitle: "Healthy Habits",
            prompt: "Provide ways to strengthen the immune system. Focus on diet, exercise, and rest.",
            genre: .pop,
            category: .health
        ),
        Topic(
            title: "Chronic Diseases",
            subtitle: "Prevention",
            prompt: "Examine lifestyle changes to reduce risk of heart disease and diabetes.",
            genre: .jazz,
            category: .health
        ),
        Topic(
            title: "Healthy Aging",
            subtitle: "Longevity",
            prompt: "Review strategies to maintain health in older adults. Discuss diet, exercise, and social engagement.",
            genre: .classical,
            category: .health
        ),
        Topic(
            title: "Body Composition",
            subtitle: "Muscle vs. Fat",
            prompt: "Explore methods to measure body composition. Consider role of nutrition and exercise.",
            genre: .country,
            category: .health
        ),
        Topic(
            title: "Mind-Body Connection",
            subtitle: "Holistic Wellness",
            prompt: "Discuss how mental state can affect physical health. Mention stress-induced illnesses.",
            genre: .hiphop,
            category: .health
        ),

        // MARK: - Business (10)
        Topic(
            title: "Business Plan",
            subtitle: "Start-Up Fundamentals",
            prompt: "Outline key sections of a business plan. Highlight mission, market analysis, and finances.",
            genre: .rock,
            category: .business
        ),
        Topic(
            title: "Marketing Strategies",
            subtitle: "Brand Promotion",
            prompt: "Discuss digital and traditional marketing tactics. Emphasize target audience research.",
            genre: .pop,
            category: .business
        ),
        Topic(
            title: "Leadership Styles",
            subtitle: "Team Management",
            prompt: "Compare autocratic vs. democratic leadership. Explain when each might be effective.",
            genre: .jazz,
            category: .business
        ),
        Topic(
            title: "Customer Service",
            subtitle: "Satisfaction & Retention",
            prompt: "Propose methods to improve customer support. Mention feedback loops and follow-ups.",
            genre: .classical,
            category: .business
        ),
        Topic(
            title: "Product Development",
            subtitle: "Idea to Launch",
            prompt: "Explain steps in creating a new product. Include prototyping and market testing.",
            genre: .country,
            category: .business
        ),
        Topic(
            title: "E-commerce",
            subtitle: "Online Sales",
            prompt: "Explore strategies for launching an online store. Discuss website design and payment options.",
            genre: .hiphop,
            category: .business
        ),
        Topic(
            title: "Negotiation",
            subtitle: "Deal-Making",
            prompt: "Offer tips to negotiate contracts effectively. Consider win-win outcomes and compromise.",
            genre: .rock,
            category: .business
        ),
        Topic(
            title: "Entrepreneurship",
            subtitle: "Startup Growth",
            prompt: "Identify key traits of successful founders. Describe how to handle common obstacles.",
            genre: .pop,
            category: .business
        ),
        Topic(
            title: "Business Ethics",
            subtitle: "Corporate Responsibility",
            prompt: "Explore ethical decision-making in business. Consider transparency and fair practices.",
            genre: .jazz,
            category: .business
        ),
        Topic(
            title: "Financial Planning",
            subtitle: "Cash Flow",
            prompt: "Explain how to manage cash flow in a small business. Include revenue forecasting.",
            genre: .classical,
            category: .business
        ),

        // MARK: - History (10)
        Topic(
            title: "Ancient Egypt",
            subtitle: "Pharaohs & Pyramids",
            prompt: "Explore the social and religious significance of pyramids. Discuss burial practices.",
            genre: .country,
            category: .history
        ),
        Topic(
            title: "Roman Empire",
            subtitle: "Rise & Fall",
            prompt: "Summarize key factors in Rome’s expansion. Examine reasons for eventual decline.",
            genre: .hiphop,
            category: .history
        ),
        Topic(
            title: "Medieval Europe",
            subtitle: "Feudal Society",
            prompt: "Describe the feudal hierarchy. Discuss the roles of lords, vassals, and serfs.",
            genre: .rock,
            category: .history
        ),
        Topic(
            title: "Renaissance",
            subtitle: "Cultural Rebirth",
            prompt: "Highlight major artists and thinkers of the era. Assess their influence on Western culture.",
            genre: .pop,
            category: .history
        ),
        Topic(
            title: "Industrial Revolution",
            subtitle: "Technological Shift",
            prompt: "Examine the impact of steam power on factories. Mention social and economic changes.",
            genre: .jazz,
            category: .history
        ),
        Topic(
            title: "World War I",
            subtitle: "Global Conflict",
            prompt: "Identify the main causes of WWI. Explore the role of alliances and militarism.",
            genre: .classical,
            category: .history
        ),
        Topic(
            title: "World War II",
            subtitle: "Allied vs Axis",
            prompt: "Explain key events leading to WWII. Discuss its major turning points.",
            genre: .country,
            category: .history
        ),
        Topic(
            title: "Cold War",
            subtitle: "Ideological Divide",
            prompt: "Analyze tensions between the US and USSR. Mention the arms race and space race.",
            genre: .hiphop,
            category: .history
        ),
        Topic(
            title: "Civil Rights Movement",
            subtitle: "Social Justice",
            prompt: "Outline major milestones for racial equality in the US. Include key leaders and legislation.",
            genre: .rock,
            category: .history
        ),
        Topic(
            title: "Digital Revolution",
            subtitle: "Internet Age",
            prompt: "Trace the evolution of technology from the late 20th century. Note effects on global communication.",
            genre: .pop,
            category: .history
        ),

        // MARK: - Technology (10)
        Topic(
            title: "Artificial Intelligence",
            subtitle: "Machine Learning",
            prompt: "Discuss applications of AI in daily life. Highlight ethical concerns.",
            genre: .jazz,
            category: .technology
        ),
        Topic(
            title: "Cybersecurity",
            subtitle: "Data Protection",
            prompt: "Explain basic ways to protect information online. Consider encryption and strong passwords.",
            genre: .classical,
            category: .technology
        ),
        Topic(
            title: "Cloud Computing",
            subtitle: "Remote Infrastructure",
            prompt: "Outline how cloud services work. Describe benefits of scalability and cost-efficiency.",
            genre: .country,
            category: .technology
        ),
        Topic(
            title: "Internet of Things",
            subtitle: "Connected Devices",
            prompt: "Explore how IoT devices interact. Mention potential privacy and security risks.",
            genre: .hiphop,
            category: .technology
        ),
        Topic(
            title: "Blockchain",
            subtitle: "Distributed Ledger",
            prompt: "Summarize how blockchain ensures data integrity. Provide an example of its use beyond crypto.",
            genre: .rock,
            category: .technology
        ),
        Topic(
            title: "Mobile App Development",
            subtitle: "Platform Differences",
            prompt: "Compare iOS and Android development. Note common frameworks and tools.",
            genre: .pop,
            category: .technology
        ),
        Topic(
            title: "Quantum Computing",
            subtitle: "Future Tech",
            prompt: "Introduce basics of quantum bits. Consider potential breakthroughs and challenges.",
            genre: .jazz,
            category: .technology
        ),
        Topic(
            title: "Robotics",
            subtitle: "Automation",
            prompt: "Examine how robots perform tasks in manufacturing. Consider benefits for efficiency.",
            genre: .classical,
            category: .technology
        ),
        Topic(
            title: "AR & VR",
            subtitle: "Immersive Tech",
            prompt: "Discuss differences between augmented and virtual reality. Mention real-world applications.",
            genre: .country,
            category: .technology
        ),
        Topic(
            title: "Big Data",
            subtitle: "Analytics",
            prompt: "Describe how large datasets are processed and analyzed. Highlight predictive modeling.",
            genre: .hiphop,
            category: .technology
        ),

        // MARK: - Mathematics (10)
        Topic(
            title: "Algebra Basics",
            subtitle: "Equations & Variables",
            prompt: "Explain how to solve simple linear equations. Demonstrate steps with examples.",
            genre: .rock,
            category: .mathematics
        ),
        Topic(
            title: "Geometry",
            subtitle: "Shapes & Angles",
            prompt: "Outline properties of basic shapes. Explore the relationships of angles in triangles.",
            genre: .pop,
            category: .mathematics
        ),
        Topic(
            title: "Trigonometry",
            subtitle: "Triangles & Circles",
            prompt: "Describe sine, cosine, and tangent. Provide a real-world application.",
            genre: .jazz,
            category: .mathematics
        ),
        Topic(
            title: "Calculus Introduction",
            subtitle: "Limits & Derivatives",
            prompt: "Explain the concept of a limit. Show how derivatives measure change over time.",
            genre: .classical,
            category: .mathematics
        ),
        Topic(
            title: "Probability",
            subtitle: "Chance & Risk",
            prompt: "Discuss how to calculate basic probabilities. Use examples like coin flips or dice rolls.",
            genre: .country,
            category: .mathematics
        ),
        Topic(
            title: "Statistics",
            subtitle: "Data Analysis",
            prompt: "Summarize mean, median, and mode. Highlight differences and usage cases.",
            genre: .hiphop,
            category: .mathematics
        ),
        Topic(
            title: "Number Theory",
            subtitle: "Prime Numbers",
            prompt: "Explain the importance of prime numbers. Mention cryptographic applications.",
            genre: .rock,
            category: .mathematics
        ),
        Topic(
            title: "Discrete Math",
            subtitle: "Combinatorics",
            prompt: "Outline how to count permutations and combinations. Use a small example.",
            genre: .pop,
            category: .mathematics
        ),
        Topic(
            title: "Linear Algebra",
            subtitle: "Matrices & Vectors",
            prompt: "Describe how matrices can represent transformations. Include a 2D transformation example.",
            genre: .jazz,
            category: .mathematics
        ),
        Topic(
            title: "Differential Equations",
            subtitle: "Modeling Change",
            prompt: "Explain the role of differential equations in modeling real-world phenomena.",
            genre: .classical,
            category: .mathematics
        ),

        // MARK: - Art & Design (10)
        Topic(
            title: "Color Theory",
            subtitle: "Hue & Saturation",
            prompt: "Explain how colors interact. Discuss complementary and analogous color schemes.",
            genre: .country,
            category: .artAndDesign
        ),
        Topic(
            title: "Perspective Drawing",
            subtitle: "Depth & Distance",
            prompt: "Describe one-point and two-point perspective techniques. Note how to create 3D illusions.",
            genre: .hiphop,
            category: .artAndDesign
        ),
        Topic(
            title: "Typography",
            subtitle: "Fonts & Layout",
            prompt: "Explore the impact of font choice on design. Include tips for readability.",
            genre: .rock,
            category: .artAndDesign
        ),
        Topic(
            title: "Logo Design",
            subtitle: "Brand Identity",
            prompt: "Discuss principles of an effective logo. Mention simplicity and scalability.",
            genre: .pop,
            category: .artAndDesign
        ),
        Topic(
            title: "Interior Design",
            subtitle: "Space Planning",
            prompt: "Explain how color, furniture, and lighting affect room atmosphere.",
            genre: .jazz,
            category: .artAndDesign
        ),
        Topic(
            title: "Fashion Illustration",
            subtitle: "Design Sketches",
            prompt: "Outline how to create clothing sketches. Consider body proportions and fabric textures.",
            genre: .classical,
            category: .artAndDesign
        ),
        Topic(
            title: "Photography Basics",
            subtitle: "Composition & Lighting",
            prompt: "Discuss rule of thirds and lighting techniques. Provide tips for beginner photographers.",
            genre: .country,
            category: .artAndDesign
        ),
        Topic(
            title: "Graphic Design",
            subtitle: "Visual Communication",
            prompt: "Examine how to combine text and images effectively. Focus on layout balance.",
            genre: .hiphop,
            category: .artAndDesign
        ),
        Topic(
            title: "UI/UX Design",
            subtitle: "User Experience",
            prompt: "Define the difference between UI and UX. Highlight user-centric design principles.",
            genre: .rock,
            category: .artAndDesign
        ),
        Topic(
            title: "Sculpture",
            subtitle: "3D Art",
            prompt: "Explore different sculpture materials. Consider methods like carving, modeling, and casting.",
            genre: .pop,
            category: .artAndDesign
        ),

        // MARK: - Psychology (10)
        Topic(
            title: "Behaviorism",
            subtitle: "Learning Theories",
            prompt: "Summarize classical and operant conditioning. Provide real-life examples.",
            genre: .jazz,
            category: .psychology
        ),
        Topic(
            title: "Cognitive Development",
            subtitle: "Piaget’s Stages",
            prompt: "Describe key cognitive stages from infancy to adolescence. Give typical milestones.",
            genre: .classical,
            category: .psychology
        ),
        Topic(
            title: "Social Psychology",
            subtitle: "Group Dynamics",
            prompt: "Examine how group settings influence behavior. Discuss concepts like conformity.",
            genre: .country,
            category: .psychology
        ),
        Topic(
            title: "Personality Theories",
            subtitle: "Trait vs. Type",
            prompt: "Compare trait-based and type-based personality models. Mention the Big Five.",
            genre: .hiphop,
            category: .psychology
        ),
        Topic(
            title: "Emotions",
            subtitle: "Regulation",
            prompt: "Discuss how people identify and regulate emotions. Include coping strategies.",
            genre: .rock,
            category: .psychology
        ),
        Topic(
            title: "Memory",
            subtitle: "Encoding & Retrieval",
            prompt: "Explain how short-term and long-term memory differ. Highlight techniques to improve recall.",
            genre: .pop,
            category: .psychology
        ),
        Topic(
            title: "Stress and Coping",
            subtitle: "Adaptive Methods",
            prompt: "Explore how stress affects health. Consider healthy coping mechanisms.",
            genre: .jazz,
            category: .psychology
        ),
        Topic(
            title: "Psychological Disorders",
            subtitle: "Diagnosis & Treatment",
            prompt: "Outline how professionals diagnose mental disorders. Mention therapy and medication.",
            genre: .classical,
            category: .psychology
        ),
        Topic(
            title: "Motivation",
            subtitle: "Intrinsic & Extrinsic",
            prompt: "Discuss factors that drive behavior. Provide examples of internal vs. external rewards.",
            genre: .country,
            category: .psychology
        ),
        Topic(
            title: "Positive Psychology",
            subtitle: "Well-Being",
            prompt: "Examine techniques that promote happiness. Emphasize gratitude and resilience.",
            genre: .hiphop,
            category: .psychology
        ),

        // MARK: - Food (10)
        Topic(
            title: "Italian Cuisine",
            subtitle: "Pasta & Sauces",
            prompt: "Explore regional pasta varieties in Italy. Mention classic sauce pairings.",
            genre: .rock,
            category: .food
        ),
        Topic(
            title: "Baking Basics",
            subtitle: "Bread & Pastry",
            prompt: "Describe yeast’s role in bread-making. Provide tips for achieving the perfect rise.",
            genre: .pop,
            category: .food
        ),
        Topic(
            title: "Vegan Cooking",
            subtitle: "Plant-Based Meals",
            prompt: "Suggest protein sources for a vegan diet. Mention tofu, legumes, and nuts.",
            genre: .jazz,
            category: .food
        ),
        Topic(
            title: "Food Safety",
            subtitle: "Kitchen Hygiene",
            prompt: "Outline best practices for handling raw meat. Include proper temperature guidelines.",
            genre: .classical,
            category: .food
        ),
        Topic(
            title: "Spices & Herbs",
            subtitle: "Flavor Profiles",
            prompt: "Explain how to pair spices with dishes. Provide examples of complementary herbs.",
            genre: .country,
            category: .food
        ),
        Topic(
            title: "Grilling Techniques",
            subtitle: "Char & Flavor",
            prompt: "Discuss direct vs. indirect heat methods. Offer tips for juicy meats and veggies.",
            genre: .hiphop,
            category: .food
        ),
        Topic(
            title: "Desserts",
            subtitle: "Sweet Treats",
            prompt: "Introduce basic dessert types like cakes, pies, and custards. Highlight key techniques.",
            genre: .rock,
            category: .food
        ),
        Topic(
            title: "Fermentation",
            subtitle: "Pickles & Kimchi",
            prompt: "Explain the science behind fermentation. Provide examples of foods preserved this way.",
            genre: .pop,
            category: .food
        ),
        Topic(
            title: "Global Street Food",
            subtitle: "Quick Bites",
            prompt: "Explore popular street foods from different cultures. Include tacos, samosas, and dumplings.",
            genre: .jazz,
            category: .food
        ),
        Topic(
            title: "Meal Planning",
            subtitle: "Efficient Prep",
            prompt: "Provide a weekly meal plan strategy. Discuss batch cooking and ingredient reusability.",
            genre: .classical,
            category: .food
        )
    ]

    var topic: Topic {
        topics.first!
    }
    
    private func insertSampleData() {
        for topic in topics {
            context.insert(topic)
        }
    }
}
