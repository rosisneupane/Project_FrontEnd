  // Example somewhere in your file:
  String getBadgeImage(int score) {
    if (score < 100) {
      return 'assets/badges/one.png'; // replace later
    } else if (score < 500) {
      return 'assets/badges/two.png';
    } else if (score < 1000) {
      return 'assets/badges/three.png';
    } else {
      return 'assets/badges/four.png';
    }
  }

// Get Previous Badge Image
  String getPreviousBadgeImage(int score) {
    if (score < 100) {
      return 'assets/badges/one.png'; // No badge before first
    } else if (score < 500) {
      return 'assets/badges/one.png'; // Previous of two
    } else if (score < 1000) {
      return 'assets/badges/two.png'; // Previous of three
    } else {
      return 'assets/badges/three.png'; // Previous of four
    }
  }

// Get Next Badge Image
  String getNextBadgeImage(int score) {
    if (score < 100) {
      return 'assets/badges/two.png'; // After one is two
    } else if (score < 500) {
      return 'assets/badges/three.png'; // After two is three
    } else if (score < 1000) {
      return 'assets/badges/four.png'; // After three is four
    } else {
      return 'assets/badges/four.png'; // No badge after max, stay on four
    }
  }

  double getProgressValue(int score) {
    if (score < 100) {
      return score / 100;
    } else if (score < 500) {
      return (score - 100) / 400;
    } else if (score < 1000) {
      return (score - 500) / 500;
    } else {
      return 1.0;
    }
  }