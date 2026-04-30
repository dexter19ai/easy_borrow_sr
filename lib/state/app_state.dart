import 'package:flutter/material.dart';

import '../models/borrow_request.dart';
import '../models/equipment.dart';
import '../models/resident_user.dart';

class AppState {
  static final List<Equipment> inventory = [
    Equipment(
      id: '1',
      name: 'Plastic Chairs',
      category: 'Furniture',
      description: 'Comfortable seating for community meetings and events.',
      icon: Icons.chair_outlined,
      quantityAvailable: 120,
    ),
    Equipment(
      id: '2',
      name: 'Folding Tables',
      category: 'Furniture',
      description: 'Portable tables suitable for food booths and registration.',
      icon: Icons.table_restaurant_outlined,
      quantityAvailable: 28,
    ),
    Equipment(
      id: '3',
      name: 'Long Tables',
      category: 'Furniture',
      description: 'Extra-long tables for seminars, exhibits, and gatherings.',
      icon: Icons.view_week_outlined,
      quantityAvailable: 18,
    ),
    Equipment(
      id: '4',
      name: 'Tents / Canopies',
      category: 'Event Equipment',
      description: 'Weather-ready tent shelters for outdoor barangay events.',
      icon: Icons.holiday_village_outlined,
      quantityAvailable: 8,
    ),
    Equipment(
      id: '5',
      name: 'Sound System',
      category: 'Event Equipment',
      description: 'Speakers, microphones, and amplifier for announcements.',
      icon: Icons.speaker_group_outlined,
      quantityAvailable: 4,
    ),
    Equipment(
      id: '6',
      name: 'Extension Cords',
      category: 'Event Equipment',
      description: 'Heavy-duty extension cords for temporary power setup.',
      icon: Icons.cable_outlined,
      quantityAvailable: 16,
    ),
    Equipment(
      id: '7',
      name: 'Basketball',
      category: 'Sports Equipment',
      description: 'Standard basketballs for games and practice sessions.',
      icon: Icons.sports_basketball_outlined,
      quantityAvailable: 12,
    ),
    Equipment(
      id: '8',
      name: 'Volleyball',
      category: 'Sports Equipment',
      description: 'Outdoor/indoor volleyballs for tournaments and training.',
      icon: Icons.sports_volleyball_outlined,
      quantityAvailable: 10,
    ),
    Equipment(
      id: '9',
      name: 'Badminton Rackets (Set)',
      category: 'Sports Equipment',
      description: 'Racket sets for friendly matches and youth activities.',
      icon: Icons.sports_tennis_outlined,
      quantityAvailable: 9,
    ),
    Equipment(
      id: '10',
      name: 'Shuttlecocks',
      category: 'Sports Equipment',
      description: 'Shuttlecock tubes for badminton community events.',
      icon: Icons.sports_outlined,
      quantityAvailable: 20,
    ),
    Equipment(
      id: '11',
      name: 'Table Tennis Set',
      category: 'Sports Equipment',
      description: 'Complete set with paddles and balls for table tennis.',
      icon: Icons.sports_score_outlined,
      quantityAvailable: 6,
    ),
    Equipment(
      id: '12',
      name: 'Football (Soccer Ball)',
      category: 'Sports Equipment',
      description: 'Durable soccer balls for youth and adult leagues.',
      icon: Icons.sports_soccer_outlined,
      quantityAvailable: 8,
    ),
    Equipment(
      id: '13',
      name: 'Whistle',
      category: 'Sports Equipment',
      description: 'Referee whistle for officiating barangay games.',
      icon: Icons.record_voice_over_outlined,
      quantityAvailable: 14,
    ),
    Equipment(
      id: '14',
      name: 'Scoreboard (Manual)',
      category: 'Sports Equipment',
      description: 'Flip scoreboard for volleyball, basketball, and more.',
      icon: Icons.scoreboard_outlined,
      quantityAvailable: 5,
    ),
  ];

  static final List<BorrowRequest> myRequests = [];
  static final List<ResidentUser> residents = [
    ResidentUser(
      fullName: 'Juan Dela Cruz',
      address: 'Purok 3, San Ramon',
      contactNumber: '0917-000-0001',
      username: 'resident',
      password: 'Resident123',
    ),
  ];

  static ResidentUser? currentResident;

  static List<BorrowRequest> requestsForCurrentResident() {
    final ResidentUser? resident = currentResident;
    if (resident == null) {
      return <BorrowRequest>[];
    }

    return myRequests
        .where((request) => request.residentUsername == resident.username)
        .toList();
  }

  static int totalItemsAvailable() {
    return inventory.fold<int>(
      0,
      (sum, item) => sum + item.quantityAvailable,
    );
  }

  static int activeBorrowedItemsCount() {
    return requestsForCurrentResident()
        .where((request) => request.status == BorrowStatus.borrowed)
        .fold<int>(0, (sum, request) => sum + request.quantity);
  }

  static int returnedItemsCount() {
    return requestsForCurrentResident()
        .where((request) => request.status == BorrowStatus.returned)
        .fold<int>(0, (sum, request) => sum + request.quantity);
  }

  static String? registerResident({
    required String fullName,
    required String address,
    required String contactNumber,
    required String username,
    required String password,
  }) {
    final bool usernameExists = residents.any(
      (resident) => resident.username.toLowerCase() == username.toLowerCase(),
    );

    if (usernameExists) {
      return 'Username is already taken. Please use a different one.';
    }

    residents.add(
      ResidentUser(
        fullName: fullName,
        address: address,
        contactNumber: contactNumber,
        username: username,
        password: password,
      ),
    );

    return null;
  }

  static String? login({
    required String username,
    required String password,
  }) {
    ResidentUser? resident;
    for (final ResidentUser user in residents) {
      if (user.username == username) {
        resident = user;
        break;
      }
    }

    if (resident == null || resident.password != password) {
      return 'Invalid username or password. Please try again.';
    }

    currentResident = resident;
    return null;
  }

  static void logout() {
    currentResident = null;
  }

  static String? updateProfile({
    required String fullName,
    required String address,
    required String contactNumber,
  }) {
    final ResidentUser? resident = currentResident;
    if (resident == null) {
      return 'No active resident profile found.';
    }

    resident.fullName = fullName;
    resident.address = address;
    resident.contactNumber = contactNumber;
    return null;
  }
}
