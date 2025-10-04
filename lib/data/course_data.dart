class CourseData {
  final List<Map<String, dynamic>> courseData = [
    {
      "courseName": "Introduction To Computer Science",
      "courseCode": "DCIT 101",
      'courseDescription':
          "This course introduces the concept of Computer Science",
      "courseCreditHours": 3,
      "courseGPT": [4, 5, 3.5, 3],
      "courseGrades": ['B', "A", 'B+', 'A'],
    },
    {
      "courseName": "Programming Fundamentals",
      "courseCode": "DCIT 102",
      'courseDescription': "Introduction to programming concepts and logic",
      "courseCreditHours": 3,
      "courseGPT": [4.2, 4.8, 4.0, 4.5],
      "courseGrades": ['A', 'A-', 'B+', 'A'],
    },
  ];

  final List<Map<String, dynamic>> courseSlides = [
    {
      'slideTitle': 'Computer Security Basics',
      'pointsEarned': 20,
      'difficultyLevel': 'easy',
      'courseField': 'science',
      'rightAnswers': 1,
      'questionsReview': "The questions were great",
      'completeTime': 30, //in minutes
      'courseId': 1,
      'slideId': 1,
      'slideUploadTime': '2025-08-22',
      'solutionStatus': 'pending',
      'scores': 85.5,
      'questions': [
        {
          'query': 'What is the primary goal of computer security?',
          'isCorrect': true,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 1,
          'options': [
            {
              'option': 'Confidentiality, Integrity, and Availability',
              'optionId': 1,
            },
            {'option': 'High performance and speed', 'optionId': 2},
            {'option': 'User interface design', 'optionId': 3},
            {'option': 'Data compression', 'optionId': 4},
          ],
        },
        {
          'query': 'Which of these is NOT a type of malware?',
          'isCorrect': true,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 4,
          'options': [
            {'option': 'Virus', 'optionId': 1},
            {'option': 'Worm', 'optionId': 2},
            {'option': 'Trojan', 'optionId': 3},
            {'option': 'Firewall', 'optionId': 4},
          ],
        },
      ],
    },
    {
      'slideTitle': 'Object-Oriented Programming',
      'pointsEarned': 20,
      'courseField': 'science',
      'difficultyLevel': 'easy',
      'rightAnswers': 1,
      'questionsReview': "The questions were great",
      'completeTime': 10, //in minutes
      'courseId': 2,
      'slideId': 2,
      'slideUploadTime': '2025-08-23',
      'solutionStatus': 'completed',
      'scores': 92.0,
      'questions': [
        {
          'query': 'What are the four pillars of OOP?',

          'answer': 1,
          'options': [
            {
              'option': 'Variables, Functions, Loops, Conditionals',
              'isCorrect': true,
              'reasonForCorrect':
                  'Transmission Control Protocol/Internet Protocol',
              'optionId': 1,
            },
            {
              'option': 'Encapsulation, Inheritance, Polymorphism, Abstraction',
              'optionId': 2,
            },
            {'option': 'Classes, Objects, Methods, Properties', 'optionId': 3},
            {'option': 'Public, Private, Protected, Default', 'optionId': 4},
          ],
        },
        {
          'query': 'What are the four pillars of OOP?',
          'isCorrect': false,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 2,
          'options': [
            {
              'option': 'Variables, Functions, Loops, Conditionals',
              'optionId': 1,
            },
            {
              'option': 'Encapsulation, Inheritance, Polymorphism, Abstraction',
              'optionId': 2,
            },
            {'option': 'Classes, Objects, Methods, Properties', 'optionId': 3},
            {'option': 'Public, Private, Protected, Default', 'optionId': 4},
          ],
        },
        {
          'query': 'What are the four pillars of OOP?',
          'isCorrect': false,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 3,
          'options': [
            {
              'option': 'Variables, Functions, Loops, Conditionals',
              'optionId': 1,
            },
            {
              'option': 'Encapsulation, Inheritance, Polymorphism, Abstraction',
              'optionId': 2,
            },
            {'option': 'Classes, Objects, Methods, Properties', 'optionId': 3},
            {'option': 'Public, Private, Protected, Default', 'optionId': 4},
          ],
        },
        {
          'query': 'What are the four pillars of OOP?',
          'answer': 1,
          'options': [
            {
              'option': 'Variables, Functions, Loops, Conditionals',
              'optionId': 1,
            },
            {
              'option': 'Encapsulation, Inheritance, Polymorphism, Abstraction',
              'isCorrect': true,
              'reasonForCorrect':
                  'Transmission Control Protocol/Internet Protocol',
              'optionId': 2,
            },
            {'option': 'Classes, Objects, Methods, Properties', 'optionId': 3},
            {'option': 'Public, Private, Protected, Default', 'optionId': 4},
          ],
        },
        {
          'query': 'What are the four pillars of OOP?',
          'answer': 3,
          'options': [
            {
              'option': 'Variables, Functions, Loops, Conditionals',
              'optionId': 1,
            },
            {
              'option': 'Encapsulation, Inheritance, Polymorphism, Abstraction',
              'optionId': 3,
              'isCorrect': true,
              'reasonForCorrect':
                  'Transmission Control Protocol/Internet Protocol',
            },
            {'option': 'Classes, Objects, Methods, Properties', 'optionId': 3},
            {'option': 'Public, Private, Protected, Default', 'optionId': 4},
          ],
        },
        {
          'query': 'What are the four pillars of OOP?',
          'answer': 4,
          'options': [
            {
              'option': 'Variables, Functions, Loops, Conditionals',
              'optionId': 1,
            },
            {
              'option': 'Encapsulation, Inheritance, Polymorphism, Abstraction',
              'optionId': 4,
              'isCorrect': true,
              'reasonForCorrect':
                  'Transmission Control Protocol/Internet Protocol',
            },
            {'option': 'Classes, Objects, Methods, Properties', 'optionId': 3},
            {'option': 'Public, Private, Protected, Default', 'optionId': 4},
          ],
        },
        {
          'query': 'What do you think about the computer networking?',
          'answer': 3,
          'options': [
            {
              'option': 'Variables, Functions, Loops, Conditionals',
              'optionId': 1,
            },
            {
              'option': 'Encapsulation, Inheritance, Polymorphism, Abstraction',
              'optionId': 2,
            },
            {
              'option': 'Classes, Objects, Methods, Properties',
              'optionId': 3,
              'isCorrect': true,
              'reasonForCorrect':
                  'Transmission Control Protocol/Internet Protocol',
              'reasonForIncorrect':
                  'Transmission Check Protocol/Internet Protocol',
            },
            {'option': 'Public, Private, Protected, Default', 'optionId': 4},
          ],
        },
      ],
    },
    {
      'slideTitle': 'Data Structures',
      'pointsEarned': 20,
      'courseField': 'science',
      'difficultyLevel': 'intermediate',
      'rightAnswers': 1,
      'questionsReview': "The questions were great",
      'completeTime': 20, //in minutes
      'courseId': 3,
      'slideId': 3,
      'slideUploadTime': '2025-08-24',
      'solutionStatus': 'progress',
      'scores': 78.5,
      'questions': [
        {
          'query':
              'What is the time complexity of accessing an element in an array by index?',
          'isCorrect': true,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 3,
          'options': [
            {'option': 'O(n)', 'optionId': 1},
            {'option': 'O(log n)', 'optionId': 2},
            {'option': 'O(1)', 'optionId': 3},
            {'option': 'O(n²)', 'optionId': 4},
          ],
        },
      ],
    },
    {
      'slideTitle': 'Networking Fundamentals',
      'pointsEarned': 20,
      'courseField': 'computing',
      'difficultyLevel': 'intermediate',
      'rightAnswers': 1,
      'questionsReview': "The questions were great",
      'completeTime': 15, //in minutes
      'slideId': 4,
      'courseId': 4,
      'slideUploadTime': '2025-08-25',
      'solutionStatus': 'pending',
      'scores': 0.0,
      'questions': [
        {
          'query': 'What does TCP/IP stand for?',
          'isCorrect': true,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 1,
          'options': [
            {
              'option': 'Transmission Control Protocol/Internet Protocol',
              'optionId': 1,
            },
            {
              'option': 'Transmission Check Protocol/Internet Protocol',
              'optionId': 2,
            },
            {
              'option': 'Transfer Control Protocol/Internet Protocol',
              'optionId': 3,
            },
            {
              'option': 'Transmission Control Process/Internet Process',
              'optionId': 4,
            },
          ],
        },
      ],
    },
    {
      'slideTitle': 'Networking Fundamentals',
      'pointsEarned': 20,
      'courseField': 'computing',
      'difficultyLevel': 'intermediate',
      'rightAnswers': 1,
      'questionsReview': "The questions were great",
      'completeTime': 15, //in minutes
      'slideId': 4,
      'courseId': 4,
      'slideUploadTime': '2025-08-25',
      'solutionStatus': 'pending',
      'scores': 0.0,
      'questions': [
        {
          'query': 'What does TCP/IP stand for?',
          'isCorrect': true,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 1,
          'options': [
            {
              'option': 'Transmission Control Protocol/Internet Protocol',
              'optionId': 1,
            },
            {
              'option': 'Transmission Check Protocol/Internet Protocol',
              'optionId': 2,
            },
            {
              'option': 'Transfer Control Protocol/Internet Protocol',
              'optionId': 3,
            },
            {
              'option': 'Transmission Control Process/Internet Process',
              'optionId': 4,
            },
          ],
        },
      ],
    },
    {
      'slideTitle': 'Networking Fundamentals',
      'pointsEarned': 20,
      'courseField': 'computing',
      'difficultyLevel': 'intermediate',
      'rightAnswers': 1,
      'questionsReview': "The questions were great",
      'completeTime': 15, //in minutes
      'slideId': 4,
      'courseId': 4,
      'slideUploadTime': '2025-08-25',
      'solutionStatus': 'pending',
      'scores': 0.0,
      'questions': [
        {
          'query': 'What does TCP/IP stand for?',
          'isCorrect': true,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'answer': 1,
          'options': [
            {
              'option': 'Transmission Control Protocol/Internet Protocol',
              'optionId': 1,
            },
            {
              'option': 'Transmission Check Protocol/Internet Protocol',
              'optionId': 2,
            },
            {
              'option': 'Transfer Control Protocol/Internet Protocol',
              'optionId': 3,
            },
            {
              'option': 'Transmission Control Process/Internet Process',
              'optionId': 4,
            },
          ],
        },
      ],
    },
    {
      'slideTitle': 'Networking Fundamentals',
      'pointsEarned': 20,
      'courseField': 'computing',
      'difficultyLevel': 'intermediate',
      'rightAnswers': 1,
      'questionsReview': "The questions were great",
      'completeTime': 15, //in minutes
      'slideId': 4,
      'courseId': 4,
      'slideUploadTime': '2025-08-25',
      'solutionStatus': 'pending',
      'scores': 0.0,
      'questions': [
        {
          'query': 'What does TCP/IP stand for?',
          'answer': 1,
          'isCorrect': true,
          'reasonForCorrect': 'Transmission Control Protocol/Internet Protocol',
          'reasonForIncorrect': 'Transmission Check Protocol/Internet Protocol',
          'options': [
            {
              'option': 'Transmission Control Protocol/Internet Protocol',
              'optionId': 1,
            },
            {
              'option': 'Transmission Check Protocol/Internet Protocol',
              'optionId': 2,
            },
            {
              'option': 'Transfer Control Protocol/Internet Protocol',
              'optionId': 3,
            },
            {
              'option': 'Transmission Control Process/Internet Process',
              'optionId': 4,
            },
          ],
        },
      ],
    },
  ];

  // Get slides by status
  List<Map<String, dynamic>> getSlidesByStatus(String status) {
    return courseSlides
        .where((slide) => slide['solutionStatus'] == status)
        .toList();
  }

  // Get slides by course field
  List<Map<String, dynamic>> getSlidesByField(String field) {
    return courseSlides
        .where((slide) => slide['courseField'] == field)
        .toList();
  }

  // Get average score across all slides
  double getAverageScore() {
    if (courseSlides.isEmpty) return 0.0;
    double total = 0;
    int count = 0;
    for (var slide in courseSlides) {
      if (slide['scores'] != null) {
        total += (slide['scores'] as num).toDouble();
        count++;
      }
    }
    return count > 0 ? total / count : 0.0;
  }
}
