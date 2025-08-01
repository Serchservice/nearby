import 'package:flutter/material.dart';

class CategorySection {
  final String title;
  final String type;
  final String description;
  final List<Color> colors;

  CategorySection({required this.title, required this.type, this.description = "", this.colors = const []});

  factory CategorySection.fromJson(Map<String, dynamic> json) {
    return CategorySection(
      title: json["title"] ?? "",
      type: json["type"] ?? "",
      description: json["description"] ?? "",
      colors: json["colors"] ?? [],
    );
  }

  factory CategorySection.fromJsonWithColorStrings(Map<String, dynamic> json) {
    var colors = (json["colors"] as List<dynamic>?)?.map((color) {
      int value = int.parse("0xff${color.toString().substring(1)}");
      return Color(value);
    }).toList() ?? [];

    return CategorySection(
      title: json["title"] ?? "",
      type: json["type"] ?? "",
      description: json["description"] ?? "",
      colors: colors,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "type": type,
      "description": description,
      "colors": colors
    };
  }

  factory CategorySection.empty() {
    return CategorySection(title: "", type: "");
  }
}

class Category {
  final String title;
  final List<CategorySection> sections;

  Category({required this.sections, required this.title});

  static List<CategorySection> services = [
    CategorySection(
      title: "Electrician",
      type: "electrician",
      description: "Electricians",
      colors: [Color(0xFF001F3F), Color(0xFF003366)], // Dark Blue Gradient
    ),
    CategorySection(
      title: "Hair Salon",
      type: "hair_salon",
      description: "Hair salons",
      colors: [Color(0xFF002B36), Color(0xFF004D60)], // Teal Blue Gradient
    ),
    CategorySection(
      title: "Makeup Artist",
      type: "makeup_artist",
      description: "Makeup artists",
      colors: [Color(0xFF004225), Color(0xFF006633)], // Forest Green Gradient
    ),
    CategorySection(
      title: "Plumber",
      type: "plumber",
      description: "Plumbers",
      colors: [Color(0xFF101820), Color(0xFF2C394B)], // Navy Black Gradient
    ),
    CategorySection(
      title: "Car Repair",
      type: "car_repair",
      description: "Mechanics",
      colors: [Color(0xFF0B0C10), Color(0xFF1F2833)], // Charcoal Black Gradient
    ),
  ];

  static List<CategorySection> suggestions = [
    CategorySection(
      title: "School",
      type: "school",
      description: "Schools",
      colors: [Color(0xFF002244), Color(0xFF003366)], // Sapphire Blue Gradient
    ),
    CategorySection(
      title: "ATM",
      type: "atm",
      description: "Atm stands",
      colors: [Color(0xFF101820), Color(0xFF2C394B)], // Navy Black Gradient
    ),
    CategorySection(
      title: "Restaurant",
      type: "restaurant",
      description: "Restaurants",
      colors: [Color(0xFF004225), Color(0xFF006633)], // Forest Green Gradient
    ),
    CategorySection(
      title: "Hotel",
      type: "hotel",
      description: "Hotels",
      colors: [Color(0xFF1C2833), Color(0xFF566573)], // Steel Blue Gradient
    ),
    CategorySection(
      title: "Church",
      type: "church",
      description: "Churches",
      colors: [Color(0xFF001F3F), Color(0xFF004080)], // Royal Blue Gradient
    ),
  ];

  static List<CategorySection> emergencies = [
    CategorySection(
      title: "Police",
      type: "police",
      description: "Police stations",
      colors: [Color(0xFF0A0A0A), Color(0xFF202020)], // Deep Black Gradient
    ),
    CategorySection(
      title: "Fire Station",
      type: "fire_station",
      description: "Fire stations",
      colors: [Color(0xFF101820), Color(0xFF2C394B)], // Midnight Blue Gradient
    ),
    CategorySection(
      title: "Hospital",
      type: "hospital",
      description: "Hospitals",
      colors: [Color(0xFF0B3D91), Color(0xFF002147)], // Medical Blue Gradient
    ),
    CategorySection(
      title: "Pharmacy",
      type: "pharmacy",
      description: "Pharmacies",
      colors: [Color(0xFF004225), Color(0xFF006633)], // Emerald Green Gradient
    ),
  ];

  static List<Category> categories = [
    Category(
      sections: [
        CategorySection(title: "Car Dealer", type: "car_dealer"),
        CategorySection(title: "Car Rental", type: "car_rental"),
        CategorySection(title: "Car Repair", type: "car_repair"),
        CategorySection(title: "Car Wash", type: "car_wash"),
        CategorySection(title: "Electric Vehicle Charging Station", type: "electric_vehicle_charging_station"),
        CategorySection(title: "Gas Station", type: "gas_station"),
        CategorySection(title: "Parking", type: "parking"),
        CategorySection(title: "Rest Stop", type: "rest_stop"),
      ],
      title: "Automotive",
    ),
    Category(
      sections: [
        CategorySection(title: "Corporate Office", type: "corporate_office"),
        CategorySection(title: "Farm", type: "farm"),
        CategorySection(title: "Ranch", type: "ranch"),
      ],
      title: "Business",
    ),
    Category(
      sections: [
        CategorySection(title: "Art Gallery", type: "art_gallery"),
        CategorySection(title: "Art Studio", type: "art_studio"),
        CategorySection(title: "Auditorium", type: "auditorium"),
        CategorySection(title: "Cultural Landmark", type: "cultural_landmark"),
        CategorySection(title: "Historical Place", type: "historical_place"),
        CategorySection(title: "Monument", type: "monument"),
        CategorySection(title: "Museum", type: "museum"),
        CategorySection(title: "Performing Arts Theater", type: "performing_arts_theater"),
        CategorySection(title: "Sculpture", type: "sculpture"),
      ],
      title: "Culture",
    ),
    Category(
      sections: [
        CategorySection(title: "Library", type: "library"),
        CategorySection(title: "Preschool", type: "preschool"),
        CategorySection(title: "Primary School", type: "primary_school"),
        CategorySection(title: "Secondary School", type: "secondary_school"),
        CategorySection(title: "University", type: "university"),
        CategorySection(title: "School", type: "school"),
      ],
      title: "Education",
    ),
    Category(
      sections: [
        CategorySection(title: "Adventure Sports Center", type: "adventure_sports_center"),
        CategorySection(title: "Amphitheatre", type: "amphitheatre"),
        CategorySection(title: "Amusement Center", type: "amusement_center"),
        CategorySection(title: "Amusement Park", type: "amusement_park"),
        CategorySection(title: "Aquarium", type: "aquarium"),
        CategorySection(title: "Banquet Hall", type: "banquet_hall"),
        CategorySection(title: "Barbecue Area", type: "barbecue_area"),
        CategorySection(title: "Botanical Garden", type: "botanical_garden"),
        CategorySection(title: "Bowling Alley", type: "bowling_alley"),
        CategorySection(title: "Casino", type: "casino"),
        CategorySection(title: "Children's Camp", type: "childrens_camp"),
        CategorySection(title: "Comedy Club", type: "comedy_club"),
        CategorySection(title: "Community Center", type: "community_center"),
        CategorySection(title: "Concert Hall", type: "concert_hall"),
        CategorySection(title: "Convention Center", type: "convention_center"),
        CategorySection(title: "Cultural Center", type: "cultural_center"),
        CategorySection(title: "Cycling Park", type: "cycling_park"),
        CategorySection(title: "Dance Hall", type: "dance_hall"),
        CategorySection(title: "Dog Park", type: "dog_park"),
        CategorySection(title: "Activity Venue", type: "activity_venue"),
        CategorySection(title: "Ferris Wheel", type: "ferris_wheel"),
        CategorySection(title: "Garden", type: "garden"),
        CategorySection(title: "Hiking Area", type: "hiking_area"),
        CategorySection(title: "Historical Landmark", type: "historical_landmark"),
        CategorySection(title: "Internet Cafe", type: "internet_cafe"),
        CategorySection(title: "Karaoke", type: "karaoke"),
        CategorySection(title: "Marina", type: "marina"),
        CategorySection(title: "Movie Rental", type: "movie_rental"),
        CategorySection(title: "Movie Theater", type: "movie_theater"),
        CategorySection(title: "National Park", type: "national_park"),
        CategorySection(title: "Night Club", type: "night_club"),
        CategorySection(title: "Observation Deck", type: "observation_deck"),
        CategorySection(title: "Off-Road Area", type: "off_roading_area"),
        CategorySection(title: "Opera House", type: "opera_house"),
        CategorySection(title: "Park", type: "park"),
        CategorySection(title: "Philharmonic Hall", type: "philharmonic_hall"),
        CategorySection(title: "Picnic Ground", type: "picnic_ground"),
        CategorySection(title: "Planetarium", type: "planetarium"),
        CategorySection(title: "Plaza", type: "plaza"),
        CategorySection(title: "Roller Coaster", type: "roller_coaster"),
        CategorySection(title: "Skateboard Park", type: "skateboard_park"),
        CategorySection(title: "State Park", type: "state_park"),
        CategorySection(title: "Tourist Attraction", type: "tourist_attraction"),
        CategorySection(title: "Video Arcade", type: "video_arcade"),
        CategorySection(title: "Visitor Center", type: "visitor_center"),
        CategorySection(title: "Water Park", type: "water_park"),
        CategorySection(title: "Wedding Venue", type: "wedding_venue"),
        CategorySection(title: "Wildlife Park", type: "wildlife_park"),
        CategorySection(title: "Wildlife Refuge", type: "wildlife_refuge"),
        CategorySection(title: "Zoo", type: "zoo"),
      ],
      title: "Education and Recreation",
    ),
    Category(
      sections: [
        CategorySection(title: "Public Bath", type: "public_bath"),
        CategorySection(title: "Public Bathroom", type: "public_bathroom"),
        CategorySection(title: "Stable", type: "stable"),
      ],
      title: "Facilities",
    ),
    Category(
      sections: [
        CategorySection(title: "Accounting", type: "accounting"),
        CategorySection(title: "ATM", type: "atm"),
        CategorySection(title: "Bank", type: "bank"),
      ],
      title: "Finance",
    ),
    Category(
      sections: [
        CategorySection(title: "Acai Shop", type: "acai_shop"),
        CategorySection(title: "Afghani Restaurant", type: "afghani_restaurant"),
        CategorySection(title: "African Restaurant", type: "african_restaurant"),
        CategorySection(title: "American Restaurant", type: "american_restaurant"),
        CategorySection(title: "Asian Restaurant", type: "asian_restaurant"),
        CategorySection(title: "Bagel Shop", type: "bagel_shop"),
        CategorySection(title: "Bakery", type: "bakery"),
        CategorySection(title: "Bar", type: "bar"),
        CategorySection(title: "Bar and Grill", type: "bar_and_grill"),
        CategorySection(title: "Barbecue Restaurant", type: "barbecue_restaurant"),
        CategorySection(title: "Brazilian Restaurant", type: "brazilian_restaurant"),
        CategorySection(title: "Breakfast Restaurant", type: "breakfast_restaurant"),
        CategorySection(title: "Brunch Restaurant", type: "brunch_restaurant"),
        CategorySection(title: "Buffet Restaurant", type: "buffet_restaurant"),
        CategorySection(title: "Cafe", type: "cafe"),
        CategorySection(title: "Cafeteria", type: "cafeteria"),
        CategorySection(title: "Candy Store", type: "candy_store"),
        CategorySection(title: "Cat Cafe", type: "cat_cafe"),
        CategorySection(title: "Chinese Restaurant", type: "chinese_restaurant"),
        CategorySection(title: "Chocolate Factory", type: "chocolate_factory"),
        CategorySection(title: "Chocolate Shop", type: "chocolate_shop"),
        CategorySection(title: "Coffee Shop", type: "coffee_shop"),
        CategorySection(title: "Confectionery", type: "confectionery"),
        CategorySection(title: "Deli", type: "deli"),
        CategorySection(title: "Dessert Restaurant", type: "dessert_restaurant"),
        CategorySection(title: "Dessert Shop", type: "dessert_shop"),
        CategorySection(title: "Diner", type: "diner"),
        CategorySection(title: "Dog Cafe", type: "dog_cafe"),
        CategorySection(title: "Donut Shop", type: "donut_shop"),
        CategorySection(title: "Fast Food Restaurant", type: "fast_food_restaurant"),
        CategorySection(title: "Fine Dining Restaurant", type: "fine_dining_restaurant"),
        CategorySection(title: "Food Court", type: "food_court"),
        CategorySection(title: "French Restaurant", type: "french_restaurant"),
        CategorySection(title: "Greek Restaurant", type: "greek_restaurant"),
        CategorySection(title: "Hamburger Restaurant", type: "hamburger_restaurant"),
        CategorySection(title: "Ice Cream Shop", type: "ice_cream_shop"),
        CategorySection(title: "Indian Restaurant", type: "indian_restaurant"),
        CategorySection(title: "Indonesian Restaurant", type: "indonesian_restaurant"),
        CategorySection(title: "Italian Restaurant", type: "italian_restaurant"),
        CategorySection(title: "Japanese Restaurant", type: "japanese_restaurant"),
        CategorySection(title: "Juice Shop", type: "juice_shop"),
        CategorySection(title: "Korean Restaurant", type: "korean_restaurant"),
        CategorySection(title: "Lebanese Restaurant", type: "lebanese_restaurant"),
        CategorySection(title: "Meal Delivery", type: "meal_delivery"),
        CategorySection(title: "Meal Takeaway", type: "meal_takeaway"),
        CategorySection(title: "Mediterranean Restaurant", type: "mediterranean_restaurant"),
        CategorySection(title: "Mexican Restaurant", type: "mexican_restaurant"),
        CategorySection(title: "Middle Eastern Restaurant", type: "middle_eastern_restaurant"),
        CategorySection(title: "Pizza Restaurant", type: "pizza_restaurant"),
        CategorySection(title: "Pub", type: "pub"),
        CategorySection(title: "Ramen Restaurant", type: "ramen_restaurant"),
        CategorySection(title: "Restaurant", type: "restaurant"),
        CategorySection(title: "Sandwich Shop", type: "sandwich_shop"),
        CategorySection(title: "Seafood Restaurant", type: "seafood_restaurant"),
        CategorySection(title: "Spanish Restaurant", type: "spanish_restaurant"),
        CategorySection(title: "Steak House", type: "steak_house"),
        CategorySection(title: "Sushi Restaurant", type: "sushi_restaurant"),
        CategorySection(title: "Tea House", type: "tea_house"),
        CategorySection(title: "Thai Restaurant", type: "thai_restaurant"),
        CategorySection(title: "Turkish Restaurant", type: "turkish_restaurant"),
        CategorySection(title: "Vegan Restaurant", type: "vegan_restaurant"),
        CategorySection(title: "Vegetarian Restaurant", type: "vegetarian_restaurant"),
        CategorySection(title: "Vietnamese Restaurant", type: "vietnamese_restaurant"),
        CategorySection(title: "Wine Bar", type: "wine_bar"),
      ],
      title: "Food and Drink",
    ),
    Category(
      sections: [
        CategorySection(title: "Administrative Area Level 1", type: "administrative_area_level_1"),
        CategorySection(title: "Administrative Area Level 2", type: "administrative_area_level_2"),
        CategorySection(title: "Country", type: "country"),
        CategorySection(title: "Locality", type: "locality"),
        CategorySection(title: "Postal Code", type: "postal_code"),
        CategorySection(title: "School District", type: "school_district"),
      ],
      title: "Geographical Areas",
    ),
    Category(
      sections: [
        CategorySection(title: "City Hall", type: "city_hall"),
        CategorySection(title: "Government Office", type: "government_office"),
        CategorySection(title: "Court House", type: "courthouse"),
        CategorySection(title: "Local Government Office", type: "local_government_office"),
        CategorySection(title: "Embassy", type: "embassy"),
        CategorySection(title: "Police", type: "police"),
        CategorySection(title: "Fire Station", type: "fire_station"),
        CategorySection(title: "Post Office", type: "post_office"),
      ],
      title: "Government",
    ),
    Category(
      sections: [
        CategorySection(title: "Chiropractor", type: "chiropractor"),
        CategorySection(title: "Dental Clinic", type: "dental_clinic"),
        CategorySection(title: "Dentist", type: "dentist"),
        CategorySection(title: "Doctor", type: "doctor"),
        CategorySection(title: "Drugstore", type: "drugstore"),
        CategorySection(title: "Hospital", type: "hospital"),
        CategorySection(title: "Massage", type: "massage"),
        CategorySection(title: "Medical Lab", type: "medical_lab"),
        CategorySection(title: "Pharmacy", type: "pharmacy"),
        CategorySection(title: "Physiotherapist", type: "physiotherapist"),
        CategorySection(title: "Sauna", type: "sauna"),
        CategorySection(title: "Skin Care Clinic", type: "skin_care_clinic"),
        CategorySection(title: "Spa", type: "spa"),
        CategorySection(title: "Tanning Studio", type: "tanning_studio"),
        CategorySection(title: "Wellness Center", type: "wellness_center"),
        CategorySection(title: "Yoga Studio", type: "yoga_studio"),
      ],
      title: "Health and Wellness",
    ),
    Category(
      sections: [
        CategorySection(title: "Apartment Building", type: "apartment_building"),
        CategorySection(title: "Apartment Complex", type: "apartment_complex"),
        CategorySection(title: "Condominium Complex", type: "condominium_complex"),
        CategorySection(title: "Housing Complex", type: "housing_complex"),
      ],
      title: "Housing",
    ),
    Category(
      sections: [
        CategorySection(title: "Bed and Breakfast", type: "bed_and_breakfast"),
        CategorySection(title: "Budget Japanese Inn", type: "budget_japanese_inn"),
        CategorySection(title: "Campground", type: "campground"),
        CategorySection(title: "Camping Cabin", type: "camping_cabin"),
        CategorySection(title: "Cottage", type: "cottage"),
        CategorySection(title: "Extended Stay Hotel", type: "extended_stay_hotel"),
        CategorySection(title: "Farmstay", type: "farmstay"),
        CategorySection(title: "Guest House", type: "guest_house"),
        CategorySection(title: "Hostel", type: "hostel"),
        CategorySection(title: "Hotel", type: "hotel"),
        CategorySection(title: "Inn", type: "inn"),
        CategorySection(title: "Japanese Inn", type: "japanese_inn"),
        CategorySection(title: "Lodging", type: "lodging"),
        CategorySection(title: "Mobile Home Park", type: "mobile_home_park"),
        CategorySection(title: "Motel", type: "motel"),
        CategorySection(title: "Private Guest Room", type: "private_guest_room"),
        CategorySection(title: "Resort Hotel", type: "resort_hotel"),
        CategorySection(title: "RV Park", type: "rv_park"),
      ],
      title: "Lodging",
    ),
    Category(
      sections: [
        CategorySection(title: "Beach", type: "beach"),
      ],
      title: "Natural Features",
    ),
    Category(
      sections: [
        CategorySection(title: "Church", type: "church"),
        CategorySection(title: "Hindu", type: "hindu"),
        CategorySection(title: "Mosque", type: "mosque"),
        CategorySection(title: "Synagogue", type: "synagogue"),
      ],
      title: "Places of Worship",
    ),
    Category(
      sections: [
        CategorySection(title: "Astrologer", type: "astrologer"),
        CategorySection(title: "Barber Shop", type: "barber_shop"),
        CategorySection(title: "Beautician", type: "beautician"),
        CategorySection(title: "Beauty Salon", type: "beauty_salon"),
        CategorySection(title: "Body Art Service", type: "body_art_service"),
        CategorySection(title: "Catering Service", type: "catering_service"),
        CategorySection(title: "Cemetery", type: "cemetery"),
        CategorySection(title: "Child Care Agency", type: "child_care_agency"),
        CategorySection(title: "Consultant", type: "consultant"),
        CategorySection(title: "Courier Service", type: "courier_service"),
        CategorySection(title: "Electrician", type: "electrician"),
        CategorySection(title: "Florist", type: "florist"),
        CategorySection(title: "Food Delivery", type: "food_delivery"),
        CategorySection(title: "Foot Care", type: "foot_care"),
        CategorySection(title: "Funeral Home", type: "funeral_home"),
        CategorySection(title: "Hair Care", type: "hair_care"),
        CategorySection(title: "Hair Salon", type: "hair_salon"),
        CategorySection(title: "Insurance Agency", type: "insurance_agency"),
        CategorySection(title: "Laundry", type: "laundry"),
        CategorySection(title: "Lawyer", type: "lawyer"),
        CategorySection(title: "Locksmith", type: "locksmith"),
        CategorySection(title: "Makeup Artist", type: "makeup_artist"),
        CategorySection(title: "Moving Company", type: "moving_company"),
        CategorySection(title: "Nail Salon", type: "nail_salon"),
        CategorySection(title: "Painter", type: "painter"),
        CategorySection(title: "Plumber", type: "plumber"),
        CategorySection(title: "Psychic", type: "psychic"),
        CategorySection(title: "Real Estate Agency", type: "real_estate_agency"),
        CategorySection(title: "Roofing Contractor", type: "roofing_contractor"),
        CategorySection(title: "Storage", type: "storage"),
        CategorySection(title: "Summer Camp Organizer", type: "summer_camp_organizer"),
        CategorySection(title: "Tailor", type: "tailor"),
        CategorySection(title: "Telecommunications Service Provider", type: "telecommunications_service_provider"),
        CategorySection(title: "Tour Agency", type: "tour_agency"),
        CategorySection(title: "Tourist Information Center", type: "tourist_information_center"),
        CategorySection(title: "Travel Agency", type: "travel_agency"),
        CategorySection(title: "Veterinary Care", type: "veterinary_care"),
      ],
      title: "Services",
    ),
    Category(
      sections: [
        CategorySection(title: "Asian Grocery Store", type: "asian_grocery_store"),
        CategorySection(title: "Auto Parts Store", type: "auto_parts_store"),
        CategorySection(title: "Bicycle Store", type: "bicycle_store"),
        CategorySection(title: "Book Store", type: "book_store"),
        CategorySection(title: "Butcher Shop", type: "butcher_shop"),
        CategorySection(title: "Cell Phone Store", type: "cell_phone_store"),
        CategorySection(title: "Clothing Store", type: "clothing_store"),
        CategorySection(title: "Convenience Store", type: "convenience_store"),
        CategorySection(title: "Department Store", type: "department_store"),
        CategorySection(title: "Discount Store", type: "discount_store"),
        CategorySection(title: "Electronics Store", type: "electronics_store"),
        CategorySection(title: "Food Store", type: "food_store"),
        CategorySection(title: "Furniture Store", type: "furniture_store"),
        CategorySection(title: "Gift Shop", type: "gift_shop"),
        CategorySection(title: "Grocery Store", type: "grocery_store"),
        CategorySection(title: "Hardware Store", type: "hardware_store"),
        CategorySection(title: "Home Goods Store", type: "home_goods_store"),
        CategorySection(title: "Home Improvement Store", type: "home_improvement_store"),
        CategorySection(title: "Jewelry Store", type: "jewelry_store"),
        CategorySection(title: "Liquor Store", type: "liquor_store"),
        CategorySection(title: "Market", type: "market"),
        CategorySection(title: "Pet Store", type: "pet_store"),
        CategorySection(title: "Shoe Store", type: "shoe_store"),
        CategorySection(title: "Shopping Mall", type: "shopping_mall"),
        CategorySection(title: "Sporting Goods Store", type: "sporting_goods_store"),
        CategorySection(title: "Store", type: "store"),
        CategorySection(title: "Supermarket", type: "supermarket"),
        CategorySection(title: "Warehouse Store", type: "warehouse_store"),
        CategorySection(title: "Wholesaler", type: "wholesaler"),
      ],
      title: "Shopping",
    ),
    Category(
      sections: [
        CategorySection(title: "Arena", type: "arena"),
        CategorySection(title: "Athletic Field", type: "athletic_field"),
        CategorySection(title: "Fishing Charter", type: "fishing_charter"),
        CategorySection(title: "Fishing Pond", type: "fishing_pond"),
        CategorySection(title: "Fitness Center", type: "fitness_center"),
        CategorySection(title: "Golf Course", type: "golf_course"),
        CategorySection(title: "Gym", type: "gym"),
        CategorySection(title: "Ice Skating Rink", type: "ice_skating_rink"),
        CategorySection(title: "Playground", type: "playground"),
        CategorySection(title: "Ski Resort", type: "ski_resort"),
        CategorySection(title: "Sports Activity Location", type: "sports_activity_location"),
        CategorySection(title: "Sports Club", type: "sports_club"),
        CategorySection(title: "Sports Coaching", type: "sports_coaching"),
        CategorySection(title: "Sports Complex", type: "sports_complex"),
        CategorySection(title: "Stadium", type: "stadium"),
        CategorySection(title: "Swimming Pool", type: "swimming_pool"),
      ],
      title: "Sports",
    ),
    Category(
      sections: [
        CategorySection(title: "Airport", type: "airport"),
        CategorySection(title: "Airstrip", type: "airstrip"),
        CategorySection(title: "Bus Station", type: "bus_station"),
        CategorySection(title: "Bus Stop", type: "bus_stop"),
        CategorySection(title: "Ferry Terminal", type: "ferry_terminal"),
        CategorySection(title: "Heliport", type: "heliport"),
        CategorySection(title: "International Airport", type: "international_airport"),
        CategorySection(title: "Light Rail Station", type: "light_rail_station"),
        CategorySection(title: "Park and Ride", type: "park_and_ride"),
        CategorySection(title: "Subway Station", type: "subway_station"),
        CategorySection(title: "Taxi Stand", type: "taxi_stand"),
        CategorySection(title: "Train Station", type: "train_station"),
        CategorySection(title: "Transit Depot", type: "transit_depot"),
        CategorySection(title: "Transit Station", type: "transit_station"),
        CategorySection(title: "Truck Stop", type: "truck_stop"),
      ],
      title: "Transportation",
    ),
  ];
}