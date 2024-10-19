import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:q_flow/model/company.dart';
import 'package:q_flow/model/interview.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  var interviews = [
    Interview(timeOfBooking: '10:30 AM', positionInQueue: 5, companyId: '1'),
    Interview(timeOfBooking: '10:42 AM', positionInQueue: 12, companyId: '1')
  ];

  final company = Company(
      id: '1',
      name: 'ABC Company',
      description:
          'XYZ is a startup company that is specialized in providing tech solutions based on client needs.',
      numEmployees: 200,
      establishedYear: 2015,
      logoUrl: null);
}
