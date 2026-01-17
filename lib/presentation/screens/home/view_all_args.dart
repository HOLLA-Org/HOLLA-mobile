import 'package:holla/models/hotel_model.dart';

class ViewAllArgs {
  final String title;
  final List<HotelModel> hotels;

  ViewAllArgs({required this.title, required this.hotels});
}
